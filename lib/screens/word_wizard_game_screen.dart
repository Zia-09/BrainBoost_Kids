import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/word_wizard_provider.dart';
import '../models/word_item.dart';
import '../widgets/letter_box_widget.dart';
import '../widgets/draggable_letter_widget.dart';
import '../widgets/fun_fact_popup_widget.dart';
import '../app_colors.dart';
import '../services/sound_service.dart';

class WordWizardGameScreen extends StatefulWidget {
  const WordWizardGameScreen({super.key});

  @override
  State<WordWizardGameScreen> createState() => _WordWizardGameScreenState();
}

class _WordWizardGameScreenState extends State<WordWizardGameScreen>
    with WidgetsBindingObserver {
  int? _hoveredIndex;
  int? _wrongMcqIndex;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WordWizardProvider>();
    final word = provider.currentWord;

    if (word == null) {
      return Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: _buildAppBar(context, provider),
      body: Stack(
        children: [
          _buildBackgroundEffect(),
          _buildColorCategoryBackground(word, provider),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  _buildProgressHeader(provider),
                  const SizedBox(height: 20),
                  _buildWordImage(word, provider.isWordComplete),
                  const SizedBox(height: 10),
                  _buildUrduTranslation(word.urduName),
                  const SizedBox(height: 30),
                  if (provider.currentMode != GameMode.mcq)
                    _buildWordSlots(word, provider),
                  if (provider.currentMode == GameMode.mcq &&
                      provider.isWordComplete)
                    _buildWordSlots(word, provider),
                  const SizedBox(height: 30),
                  if (!provider.isWordComplete)
                    provider.currentMode == GameMode.mcq
                        ? _buildMcqOptions(provider)
                        : _buildLetterOptions(provider),
                  if (provider.isWordComplete) _buildSuccessAction(provider),
                  const SizedBox(height: 100), // Space for FunFactPopup
                ],
              ),
            ),
          ),
          if (provider.isWordComplete) _buildConfetti(),
          if (provider.isWordComplete)
            Positioned(
              bottom: 120,
              left: 0,
              right: 0,
              child: FunFactPopupWidget(fact: word.funFact),
            ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    WordWizardProvider provider,
  ) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.close, color: Colors.white, size: 30),
        onPressed: () => context.pop(),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("🔥", style: TextStyle(fontSize: 20)),
          const SizedBox(width: 4),
          Text(
            "${provider.currentStreak}",
            style: GoogleFonts.fredoka(color: Colors.orange, fontSize: 24),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Center(
            child: Text(
              "${provider.totalScore}",
              style: GoogleFonts.fredoka(color: Colors.amber, fontSize: 24),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBackgroundEffect() {
    return Positioned.fill(
      child: Opacity(
        opacity: 0.1,
        child: Lottie.network(
          'https://assets9.lottiefiles.com/packages/lf20_7zskm3p2.json', // Abstract floaty bubbles
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildProgressHeader(WordWizardProvider provider) {
    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value:
                  (provider.currentWordIndex + 1) / provider.roundWords.length,
              minHeight: 12,
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Colors.greenAccent,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          "${provider.currentWordIndex + 1}/${provider.roundWords.length}",
          style: GoogleFonts.fredoka(color: Colors.white70, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildWordImage(WordItem word, bool isComplete) {
    Color? displayColor = _getColorFromName(word.word);

    return Container(
          width: 250,
          height: 250,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: (displayColor ?? Colors.blue).withValues(alpha: 0.3),
                blurRadius: 40,
                spreadRadius: 10,
              ),
              if (isComplete)
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.5),
                  blurRadius: 60,
                  spreadRadius: 20,
                ),
            ],
          ),
          child: ClipOval(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Premium background gradient
                AnimatedContainer(
                  duration: 1.seconds,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        (displayColor ?? Colors.white).withValues(alpha: 0.6),
                        (displayColor ?? Colors.blue).withValues(alpha: 0.1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),

                // Lottie success background
                if (isComplete)
                  Lottie.network(
                    'https://assets5.lottiefiles.com/packages/lf20_tou9at9v.json',
                    width: 250,
                    fit: BoxFit.cover,
                  ),

                // Main Content
                Padding(
                  padding: const EdgeInsets.all(40),
                  child: Hero(
                    tag: 'word_image_${word.id}',
                    child: Image.asset(
                      word.imagePath,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        if (word.category == "Colors" || displayColor != null) {
                          return Container(
                            width: 250,
                            height: 250,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  displayColor ?? Colors.grey,
                                  (displayColor ?? Colors.grey).withValues(
                                    alpha: 0.5,
                                  ),
                                ],
                              ),
                              border: Border.all(color: Colors.white, width: 8),
                              boxShadow: [
                                BoxShadow(
                                  color: (displayColor ?? Colors.grey)
                                      .withValues(alpha: 0.4),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Icon(
                                Icons.palette_rounded,
                                size: 80,
                                color: Colors.white.withValues(alpha: 0.5),
                              ),
                            ),
                          );
                        }
                        return Icon(
                          _getCategoryIcon(word.category),
                          size: 100,
                          color: Colors.white24,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
        .animate(target: isComplete ? 1 : 0)
        .scale(
          begin: const Offset(1, 1),
          end: const Offset(1.1, 1.1),
          duration: 600.ms,
          curve: Curves.elasticOut,
        )
        .shimmer(delay: 600.ms, duration: 1.seconds);
  }

  Widget _buildColorCategoryBackground(
    WordItem word,
    WordWizardProvider provider,
  ) {
    if (provider.currentCategory != "Colors") return const SizedBox.shrink();
    Color? displayColor = _getColorFromName(word.word);
    if (displayColor == null) return const SizedBox.shrink();

    return Positioned.fill(
      child: AnimatedContainer(
        duration: 800.ms,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              displayColor.withValues(alpha: 0.15),
              Colors.transparent,
              displayColor.withValues(alpha: 0.05),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 1.seconds);
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case "Animals":
        return Icons.pets;
      case "Fruits":
        return Icons.apple;
      case "Vegetables":
        return Icons.grass;
      case "Transport":
        return Icons.rocket_launch;
      case "Shapes":
        return Icons.category;
      default:
        return Icons.help_outline;
    }
  }

  Widget _buildUrduTranslation(String urdu) {
    return Text(
      urdu,
      style: GoogleFonts.notoNastaliqUrdu(
        fontSize: 32,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildWordSlots(WordItem word, WordWizardProvider provider) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(word.word.length, (index) {
          bool isMissing = word.missingIndexes.contains(index);
          String? filled = provider.filledLetters[index];
          bool? isCorrect = provider.letterCorrectness[index];

          // If it's a color category and it's MCQ mode, we don't show the slots?
          // No, MCQ mode usually shows the full word after completion or as a prompt.
          // But here MCQ mode replaces the letter options.

          if (!isMissing) {
            return LetterBoxWidget(
              letter: word.word[index].toUpperCase(),
              isMissing: false,
            );
          }

          return DragTarget<String>(
            onWillAcceptWithDetails: (details) {
              if (provider.currentMode == GameMode.mcq) return false;
              setState(() => _hoveredIndex = index);
              return true;
            },
            onLeave: (data) => setState(() => _hoveredIndex = null),
            onAcceptWithDetails: (details) {
              final data = details.data;
              setState(() => _hoveredIndex = null);
              provider.dropLetter(data, index);
              if (provider.letterCorrectness[index] == true) {
                SoundService().playCorrectSound();
              } else if (provider.letterCorrectness[index] == false) {
                SoundService().playWrongSound();
              }
            },
            builder: (context, candidateData, rejectedData) {
              return LetterBoxWidget(
                letter: filled,
                isMissing: true,
                isCorrect: isCorrect,
                isHovered: _hoveredIndex == index,
              );
            },
          );
        }),
      ),
    );
  }

  Widget _buildLetterOptions(WordWizardProvider provider) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Drag to fill!",
              style: GoogleFonts.fredoka(color: Colors.white54, fontSize: 18),
            ),
            IconButton(
                  onPressed: () => provider.useHint(),
                  icon: const Text("💡", style: TextStyle(fontSize: 24)),
                  tooltip: "Get a hint",
                )
                .animate(onPlay: (controller) => controller.repeat())
                .shimmer(duration: 2.seconds),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: provider.availableLetters.map((letter) {
            return DraggableLetterWidget(
              letter: letter,
              color: _getLetterColor(letter),
            ).animate().scale(
              delay: 100.ms * provider.availableLetters.indexOf(letter),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMcqOptions(WordWizardProvider provider) {
    // Safety check for MCQ options
    if (provider.mcqOptions.isEmpty) {
      return const SizedBox(
        height: 100,
        child: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return Column(
      children: [
        Text(
          "Choose the correct word!",
          style: GoogleFonts.fredoka(color: Colors.white54, fontSize: 18),
        ),
        const SizedBox(height: 20),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 2.2,
          ),
          itemCount: provider.mcqOptions.length,
          itemBuilder: (context, index) {
            final option = provider.mcqOptions[index];
            Color? optionColor;
            if (provider.currentCategory == "Colors") {
              optionColor = _getColorFromName(option);
            }

            bool isWrong = _wrongMcqIndex == index;
            bool isCorrect =
                provider.isWordComplete &&
                provider.currentWord?.word.toUpperCase() ==
                    option.toUpperCase();

            return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  child: ElevatedButton(
                    onPressed:
                        (provider.isWordComplete || _wrongMcqIndex != null)
                        ? null
                        : () {
                            try {
                              debugPrint('MCQ option tapped: $option');
                              bool correct = provider.checkMcqAnswer(option);
                              if (correct) {
                                debugPrint('✓ CORRECT MCQ ANSWER');
                                SoundService().playCorrectSound();
                              } else {
                                debugPrint('✗ WRONG MCQ ANSWER');
                                SoundService().playWrongSound();
                                setState(() => _wrongMcqIndex = index);
                                Future.delayed(
                                  const Duration(milliseconds: 1000),
                                  () {
                                    if (mounted) {
                                      setState(() => _wrongMcqIndex = null);
                                    }
                                  },
                                );
                              }
                            } catch (e) {
                              debugPrint(
                                'CRITICAL ERROR checking MCQ answer: $e',
                              );
                              SoundService().playWrongSound();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isCorrect
                          ? Colors.green.withValues(alpha: 0.3)
                          : isWrong
                          ? Colors.red.withValues(alpha: 0.3)
                          : Colors.white.withValues(alpha: 0.08),
                      foregroundColor: isCorrect
                          ? Colors.greenAccent
                          : isWrong
                          ? Colors.redAccent
                          : Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isCorrect
                              ? Colors.greenAccent
                              : isWrong
                              ? Colors.redAccent
                              : Colors.white.withValues(alpha: 0.1),
                          width: (isWrong || isCorrect) ? 2 : 1,
                        ),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (optionColor != null)
                          Container(
                            width: 30,
                            height: 30,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              color: optionColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: optionColor.withValues(alpha: 0.6),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                          ),
                        Expanded(
                          child: Text(
                            option,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.fredoka(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .animate(target: isWrong ? 1 : 0)
                .shake(hz: 8, curve: Curves.easeInOut)
                .scale(
                  begin: const Offset(1, 1),
                  end: const Offset(0.95, 0.95),
                );
          },
        ),
      ],
    );
  }

  Color? _getColorFromName(String name) {
    final upperName = name.toUpperCase();
    if (upperName.contains("RED")) return Colors.red;
    if (upperName.contains("BLUE")) return Colors.blue;
    if (upperName.contains("GREEN")) return Colors.green;
    if (upperName.contains("ORANGE")) return Colors.orange;
    if (upperName.contains("PURPLE")) return Colors.purple;
    if (upperName.contains("YELLOW")) return Colors.yellow;
    if (upperName.contains("PINK")) return Colors.pink;
    if (upperName.contains("BLACK")) return Colors.black;
    if (upperName.contains("WHITE")) return Colors.white;
    if (upperName.contains("BROWN")) return Colors.brown;
    if (upperName.contains("TEAL")) return Colors.teal;
    if (upperName.contains("CYAN")) return Colors.cyan;
    if (upperName.contains("AMBER")) return Colors.amber;
    if (upperName.contains("INDIGO")) return Colors.indigo;
    if (upperName.contains("GREY")) return Colors.grey;
    return null;
  }

  Color _getLetterColor(String letter) {
    final colors = [
      AppColors.optBlue,
      AppColors.optRed,
      AppColors.optOrange,
      AppColors.optCyan,
      Colors.purple,
      Colors.teal,
    ];
    return colors[letter.codeUnitAt(0) % colors.length];
  }

  Widget _buildSuccessAction(WordWizardProvider provider) {
    return Column(
      children: [
        if (provider.wrongAttempts == 0)
          Text(
                "PERFECT! 🌟",
                style: GoogleFonts.fredoka(fontSize: 42, color: Colors.amber),
              )
              .animate()
              .scale(duration: 600.ms, curve: Curves.elasticOut)
              .shimmer(duration: 2.seconds)
        else
          Text(
            "EXCELLENT!",
            style: GoogleFonts.fredoka(fontSize: 36, color: Colors.greenAccent),
          ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
        const SizedBox(height: 20),
        ElevatedButton(
              onPressed: () {
                try {
                  debugPrint(
                    'Button pressed: isRoundComplete=${provider.isRoundComplete}',
                  );
                  if (provider.isRoundComplete) {
                    debugPrint('Navigating to result screen...');
                    context.pushReplacement('/word-wizard/result');
                  } else {
                    debugPrint('Moving to next word...');
                    provider.nextWord();
                  }
                } catch (e) {
                  debugPrint('ERROR in success action button: $e');
                  // Fallback: try to go to result screen
                  try {
                    context.pushReplacement('/word-wizard/result');
                  } catch (e2) {
                    debugPrint('CRITICAL: Could not navigate: $e2');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: $e2'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    provider.isRoundComplete ? "View Results" : "Next Word",
                    style: GoogleFonts.fredoka(fontSize: 22),
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.arrow_forward_rounded, size: 28),
                ],
              ),
            )
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .scale(
              begin: const Offset(1, 1),
              end: const Offset(1.05, 1.05),
              duration: 1.seconds,
            ),
      ],
    );
  }

  Widget _buildConfetti() {
    return Align(
      alignment: Alignment.topCenter,
      child: Lottie.network(
        'https://assets1.lottiefiles.com/packages/lf20_m60f8q6i.json', // Confetti
        repeat: false,
      ),
    );
  }
}
