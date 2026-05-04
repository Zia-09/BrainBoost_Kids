import 'dart:math';
import '../models/word_item.dart';

// ═══════════════════════════════════════════
// ANIMALS — 28 words across all difficulties
// ═══════════════════════════════════════════
final List<WordItem> animalWords = [
  // EASY — 1 missing letter
  WordItem(id:1,  word:"CAT",      missingIndexes:[1],         difficulty:"Easy",   category:"Animals", imagePath:"assets/images/animals/cat.png",       urduName:"بلی",       hint:"Small furry pet",          funFact:"Cats sleep up to 16 hours a day!"),
  WordItem(id:2,  word:"DOG",      missingIndexes:[1],         difficulty:"Easy",   category:"Animals", imagePath:"assets/images/animals/dog.png",       urduName:"کتا",       hint:"Man's best friend",        funFact:"Dogs can smell 100,000 times better than us!"),
  WordItem(id:3,  word:"HEN",      missingIndexes:[1],         difficulty:"Easy",   category:"Animals", imagePath:"assets/images/animals/hen.png",       urduName:"مرغی",      hint:"Gives us eggs",            funFact:"A hen turns her egg 50 times a day!"),
  WordItem(id:4,  word:"COW",      missingIndexes:[1],         difficulty:"Easy",   category:"Animals", imagePath:"assets/images/animals/cow.png",       urduName:"گائے",      hint:"Gives us milk",            funFact:"Cows have best friends and feel sad apart!"),
  WordItem(id:5,  word:"PIG",      missingIndexes:[1],         difficulty:"Easy",   category:"Animals", imagePath:"assets/images/animals/pig.png",       urduName:"سور",       hint:"Pink and round",           funFact:"Pigs are actually very clean animals!"),
  WordItem(id:6,  word:"BEE",      missingIndexes:[1],         difficulty:"Easy",   category:"Animals", imagePath:"assets/images/animals/bee.png",       urduName:"مکھی",      hint:"Makes honey",              funFact:"A bee visits 2 million flowers for 1 jar of honey!"),
  WordItem(id:7,  word:"ANT",      missingIndexes:[1],         difficulty:"Easy",   category:"Animals", imagePath:"assets/images/animals/ant.png",       urduName:"چیونٹی",    hint:"Very tiny insect",         funFact:"Ants can carry 50 times their own body weight!"),
  WordItem(id:8,  word:"OWL",      missingIndexes:[1],         difficulty:"Easy",   category:"Animals", imagePath:"assets/images/animals/owl.png",       urduName:"الو",       hint:"Active at night",          funFact:"Owls can turn their head 270 degrees!"),
  // MEDIUM — 2 missing letters
  WordItem(id:9,  word:"LION",     missingIndexes:[1,3],       difficulty:"Medium", category:"Animals", imagePath:"assets/images/animals/lion.png",      urduName:"شیر",       hint:"King of the jungle",       funFact:"Lions roar can be heard 8 km away!"),
  WordItem(id:10, word:"BEAR",     missingIndexes:[1,3],       difficulty:"Medium", category:"Animals", imagePath:"assets/images/animals/bear.png",      urduName:"ریچھ",      hint:"Big and furry",            funFact:"Bears can run as fast as a horse!"),
  WordItem(id:11, word:"DUCK",     missingIndexes:[1,3],       difficulty:"Medium", category:"Animals", imagePath:"assets/images/animals/duck.png",      urduName:"بطخ",       hint:"Loves water",              funFact:"Ducks sleep with one eye open!"),
  WordItem(id:12, word:"FROG",     missingIndexes:[1,3],       difficulty:"Medium", category:"Animals", imagePath:"assets/images/animals/frog.png",      urduName:"مینڈک",     hint:"Jumps and croaks",         funFact:"Frogs drink water through their skin!"),
  WordItem(id:13, word:"WOLF",     missingIndexes:[1,3],       difficulty:"Medium", category:"Animals", imagePath:"assets/images/animals/wolf.png",      urduName:"بھیڑیا",    hint:"Lives in a pack",          funFact:"Wolves howl to communicate!"),
  WordItem(id:14, word:"CRAB",     missingIndexes:[1,3],       difficulty:"Medium", category:"Animals", imagePath:"assets/images/animals/crab.png",      urduName:"کیکڑا",     hint:"Has claws, lives in sea",  funFact:"Crabs walk sideways!"),
  WordItem(id:15, word:"DEER",     missingIndexes:[0,2],       difficulty:"Medium", category:"Animals", imagePath:"assets/images/animals/deer.png",      urduName:"ہرن",       hint:"Has antlers",              funFact:"Deer can jump 10 feet high!"),
  WordItem(id:16, word:"HAWK",     missingIndexes:[1,3],       difficulty:"Medium", category:"Animals", imagePath:"assets/images/animals/hawk.png",      urduName:"باز",       hint:"Bird of prey",             funFact:"Hawks see 8 times sharper than humans!"),
  // HARD — 3 missing letters
  WordItem(id:17, word:"TIGER",    missingIndexes:[1,3,4],     difficulty:"Hard",   category:"Animals", imagePath:"assets/images/animals/tiger.png",     urduName:"ببر شیر",   hint:"Has stripes",              funFact:"No two tigers have same stripe pattern!"),
  WordItem(id:18, word:"EAGLE",    missingIndexes:[1,3,4],     difficulty:"Hard",   category:"Animals", imagePath:"assets/images/animals/eagle.png",     urduName:"عقاب",      hint:"Bird with sharp eyes",     funFact:"Eagles can spot prey from 3 km away!"),
  WordItem(id:19, word:"SHARK",    missingIndexes:[1,3,4],     difficulty:"Hard",   category:"Animals", imagePath:"assets/images/animals/shark.png",     urduName:"شارک",      hint:"King of the ocean",        funFact:"Sharks have been on Earth 450 million years!"),
  WordItem(id:20, word:"CAMEL",    missingIndexes:[1,3,4],     difficulty:"Hard",   category:"Animals", imagePath:"assets/images/animals/camel.png",     urduName:"اونٹ",      hint:"Desert animal with hump",  funFact:"Camels drink 200 liters of water at once!"),
  WordItem(id:21, word:"HORSE",    missingIndexes:[1,3,4],     difficulty:"Hard",   category:"Animals", imagePath:"assets/images/animals/horse.png",     urduName:"گھوڑا",     hint:"Humans ride this",         funFact:"Horses can sleep standing up!"),
  WordItem(id:22, word:"ZEBRA",    missingIndexes:[1,3,4],     difficulty:"Hard",   category:"Animals", imagePath:"assets/images/animals/zebra.png",     urduName:"زیبرا",     hint:"Black and white stripes",  funFact:"Every zebra has unique stripe pattern!"),
  WordItem(id:23, word:"PANDA",    missingIndexes:[1,3,4],     difficulty:"Hard",   category:"Animals", imagePath:"assets/images/animals/panda.png",     urduName:"پانڈا",     hint:"Black and white bear",     funFact:"Pandas eat bamboo 14 hours a day!"),
  WordItem(id:24, word:"KOALA",    missingIndexes:[1,3,4],     difficulty:"Hard",   category:"Animals", imagePath:"assets/images/animals/koala.png",     urduName:"کوآلا",     hint:"Lives in Australia",       funFact:"Koalas sleep 22 hours a day!"),
  // EXPERT — full scramble all letters
  WordItem(id:25, word:"MONKEY",   missingIndexes:[0,1,2,3,4,5],   difficulty:"Expert", category:"Animals", imagePath:"assets/images/animals/monkey.png",  urduName:"بندر",    hint:"Swings on trees",      funFact:"Monkeys use tools like humans!"),
  WordItem(id:26, word:"RABBIT",   missingIndexes:[0,1,2,3,4,5],   difficulty:"Expert", category:"Animals", imagePath:"assets/images/animals/rabbit.png",  urduName:"خرگوش",   hint:"Has long ears",        funFact:"Rabbits can jump 3 feet high!"),
  WordItem(id:27, word:"PARROT",   missingIndexes:[0,1,2,3,4,5],   difficulty:"Expert", category:"Animals", imagePath:"assets/images/animals/parrot.png",  urduName:"طوطا",    hint:"Copies human speech",  funFact:"Parrots can live up to 80 years!"),
  WordItem(id:28, word:"PENGUIN",  missingIndexes:[0,1,2,3,4,5,6], difficulty:"Expert", category:"Animals", imagePath:"assets/images/animals/penguin.png", urduName:"پینگوئن", hint:"Cannot fly but swims", funFact:"Penguins propose with pebbles!"),
];

// ═══════════════════════════════════════════
// FRUITS — 24 words
// ═══════════════════════════════════════════
final List<WordItem> fruitWords = [
  WordItem(id:29, word:"FIG",        missingIndexes:[1],             difficulty:"Easy",   category:"Fruits", imagePath:"assets/images/fruits/fig.png",        urduName:"انجیر",     hint:"Mentioned in Holy Quran",   funFact:"Figs are one of the oldest fruits on Earth!"),
  WordItem(id:30, word:"PLUM",       missingIndexes:[2],             difficulty:"Easy",   category:"Fruits", imagePath:"assets/images/fruits/plum.png",       urduName:"آلوبخارہ",  hint:"Purple and sweet",          funFact:"Plums are relatives of peaches!"),
  WordItem(id:31, word:"PEAR",       missingIndexes:[1],             difficulty:"Easy",   category:"Fruits", imagePath:"assets/images/fruits/pear.png",       urduName:"ناشپاتی",   hint:"Green and juicy",           funFact:"Pears ripen better off the tree!"),
  WordItem(id:32, word:"LIME",       missingIndexes:[2],             difficulty:"Easy",   category:"Fruits", imagePath:"assets/images/fruits/lime.png",       urduName:"لیموں",     hint:"Sour and green",            funFact:"Lime juice was used to prevent scurvy!"),
  WordItem(id:33, word:"MANGO",      missingIndexes:[1,3],           difficulty:"Medium", category:"Fruits", imagePath:"assets/images/fruits/mango.png",      urduName:"آم",        hint:"King of fruits",            funFact:"Mango is national fruit of Pakistan!"),
  WordItem(id:34, word:"APPLE",      missingIndexes:[1,3],           difficulty:"Medium", category:"Fruits", imagePath:"assets/images/fruits/apple.png",      urduName:"سیب",       hint:"Keeps doctor away",         funFact:"Apples float because they are 25% air!"),
  WordItem(id:35, word:"GRAPE",      missingIndexes:[1,3],           difficulty:"Medium", category:"Fruits", imagePath:"assets/images/fruits/grape.png",      urduName:"انگور",     hint:"Grows in clusters",         funFact:"Grapes grow in clusters of 15 to 300!"),
  WordItem(id:36, word:"PEACH",      missingIndexes:[1,4],           difficulty:"Medium", category:"Fruits", imagePath:"assets/images/fruits/peach.png",      urduName:"آڑو",       hint:"Soft and fuzzy skin",       funFact:"Peaches are 88% water!"),
  WordItem(id:37, word:"BANANA",     missingIndexes:[1,3,5],         difficulty:"Hard",   category:"Fruits", imagePath:"assets/images/fruits/banana.png",     urduName:"کیلا",      hint:"Yellow and curved",         funFact:"Bananas are technically berries!"),
  WordItem(id:38, word:"ORANGE",     missingIndexes:[1,3,5],         difficulty:"Hard",   category:"Fruits", imagePath:"assets/images/fruits/orange.png",     urduName:"نارنگی",    hint:"Round and citrus",          funFact:"Oranges are full of Vitamin C!"),
  WordItem(id:39, word:"CHERRY",     missingIndexes:[1,3,5],         difficulty:"Hard",   category:"Fruits", imagePath:"assets/images/fruits/cherry.png",     urduName:"چیری",      hint:"Tiny red fruit",            funFact:"Cherry tree takes 4-7 years to first fruit!"),
  WordItem(id:40, word:"LYCHEE",     missingIndexes:[1,3,5],         difficulty:"Hard",   category:"Fruits", imagePath:"assets/images/fruits/lychee.png",     urduName:"لیچی",      hint:"White inside pink outside", funFact:"Lychee is queen of fruits in Asia!"),
  WordItem(id:41, word:"PINEAPPLE",  missingIndexes:[0,1,2,3,4,5,6,7,8],   difficulty:"Expert", category:"Fruits", imagePath:"assets/images/fruits/pineapple.png",  urduName:"انناس",  hint:"Crown on top",           funFact:"Pineapple takes 2 years to grow!"),
  WordItem(id:42, word:"WATERMELON", missingIndexes:[0,1,2,3,4,5,6,7,8,9], difficulty:"Expert", category:"Fruits", imagePath:"assets/images/fruits/watermelon.png", urduName:"تربوز", hint:"Green outside red inside", funFact:"Watermelon is 92% water!"),
  WordItem(id:43, word:"STRAWBERRY", missingIndexes:[0,1,2,3,4,5,6,7,8,9], difficulty:"Expert", category:"Fruits", imagePath:"assets/images/fruits/strawberry.png", urduName:"اسٹرابیری", hint:"Red with seeds outside", funFact:"Strawberries have 200 seeds on outside!"),
];

// ═══════════════════════════════════════════
// VEGETABLES — 16 words
// ═══════════════════════════════════════════
final List<WordItem> vegetableWords = [
  WordItem(id:44, word:"PEA",      missingIndexes:[1],             difficulty:"Easy",   category:"Vegetables", imagePath:"assets/images/vegetables/pea.png",       urduName:"مٹر",     hint:"Tiny and green",         funFact:"Peas were first vegetable to be frozen!"),
  WordItem(id:45, word:"CORN",     missingIndexes:[1],             difficulty:"Easy",   category:"Vegetables", imagePath:"assets/images/vegetables/corn.png",      urduName:"مکئی",    hint:"Yellow and crunchy",     funFact:"Corn always has even number of rows!"),
  WordItem(id:46, word:"ONION",    missingIndexes:[1,3],           difficulty:"Medium", category:"Vegetables", imagePath:"assets/images/vegetables/onion.png",     urduName:"پیاز",    hint:"Makes eyes water",       funFact:"Onions grown for over 5000 years!"),
  WordItem(id:47, word:"CARROT",   missingIndexes:[1,3,5],         difficulty:"Hard",   category:"Vegetables", imagePath:"assets/images/vegetables/carrot.png",    urduName:"گاجر",    hint:"Orange and crunchy",     funFact:"Carrots were originally purple!"),
  WordItem(id:48, word:"POTATO",   missingIndexes:[1,3,5],         difficulty:"Hard",   category:"Vegetables", imagePath:"assets/images/vegetables/potato.png",    urduName:"آلو",     hint:"Underground vegetable",  funFact:"Potatoes are 80% water!"),
  WordItem(id:49, word:"SPINACH",  missingIndexes:[0,1,2,3,4,5,6], difficulty:"Expert", category:"Vegetables", imagePath:"assets/images/vegetables/spinach.png",   urduName:"پالک",    hint:"Popeye loves this",      funFact:"Spinach gives you strong muscles!"),
  WordItem(id:50, word:"BROCCOLI", missingIndexes:[0,1,2,3,4,5,6,7], difficulty:"Expert", category:"Vegetables", imagePath:"assets/images/vegetables/broccoli.png", urduName:"بروکولی", hint:"Looks like tiny tree",  funFact:"Broccoli is a flower we eat!"),
];

// ═══════════════════════════════════════════
// TRANSPORT — 16 words
// ═══════════════════════════════════════════
final List<WordItem> transportWords = [
  WordItem(id:51, word:"CAR",         missingIndexes:[1],               difficulty:"Easy",   category:"Transport", imagePath:"assets/images/transport/car.png",        urduName:"گاڑی",        hint:"Has 4 wheels",          funFact:"First car invented in 1885!"),
  WordItem(id:52, word:"BUS",         missingIndexes:[1],               difficulty:"Easy",   category:"Transport", imagePath:"assets/images/transport/bus.png",        urduName:"بس",          hint:"Carries many people",   funFact:"Double decker bus carries 80 people!"),
  WordItem(id:53, word:"BOAT",        missingIndexes:[1,3],             difficulty:"Medium", category:"Transport", imagePath:"assets/images/transport/boat.png",       urduName:"کشتی",        hint:"Floats on water",       funFact:"Boats used for 10,000 years!"),
  WordItem(id:54, word:"TRAIN",       missingIndexes:[1,3],             difficulty:"Medium", category:"Transport", imagePath:"assets/images/transport/train.png",      urduName:"ریل گاڑی",    hint:"Runs on tracks",        funFact:"Fastest train goes 600 km per hour!"),
  WordItem(id:55, word:"PLANE",       missingIndexes:[1,3,4],           difficulty:"Hard",   category:"Transport", imagePath:"assets/images/transport/plane.png",      urduName:"ہوائی جہاز",  hint:"Flies in the sky",      funFact:"Plane travels 900 km per hour!"),
  WordItem(id:56, word:"BICYCLE",     missingIndexes:[0,1,2,3,4,5,6],  difficulty:"Expert", category:"Transport", imagePath:"assets/images/transport/bicycle.png",    urduName:"سائیکل",      hint:"Two wheels no engine",  funFact:"Bicycles are most efficient machines!"),
  WordItem(id:57, word:"HELICOPTER",  missingIndexes:[0,1,2,3,4,5,6,7,8,9], difficulty:"Expert", category:"Transport", imagePath:"assets/images/transport/helicopter.png", urduName:"ہیلی کاپٹر", hint:"Has spinning blades", funFact:"Helicopters can fly backwards!"),
];

// ═══════════════════════════════════════════
// SHAPES — 16 words
// ═══════════════════════════════════════════
final List<WordItem> shapeWords = [
  WordItem(id:58, word:"STAR",      missingIndexes:[1],           difficulty:"Easy",   category:"Shapes", imagePath:"assets/images/shapes/star.png",      urduName:"ستارہ",  hint:"5 pointed shape",       funFact:"Stars in sky are huge balls of fire!"),
  WordItem(id:59, word:"OVAL",      missingIndexes:[2],           difficulty:"Easy",   category:"Shapes", imagePath:"assets/images/shapes/oval.png",      urduName:"بیضوی",  hint:"Like stretched circle",  funFact:"Eggs are oval shaped!"),
  WordItem(id:60, word:"CUBE",      missingIndexes:[1],           difficulty:"Easy",   category:"Shapes", imagePath:"assets/images/shapes/cube.png",      urduName:"مکعب",   hint:"6 equal faces",         funFact:"A dice is a perfect cube!"),
  WordItem(id:61, word:"CONE",      missingIndexes:[2],           difficulty:"Easy",   category:"Shapes", imagePath:"assets/images/shapes/cone.png",      urduName:"مخروط",  hint:"Ice cream shape",       funFact:"Volcanoes are cone shaped!"),
  WordItem(id:62, word:"CIRCLE",    missingIndexes:[1,4],         difficulty:"Medium", category:"Shapes", imagePath:"assets/images/shapes/circle.png",    urduName:"دائرہ",  hint:"No corners at all",     funFact:"Circle has infinite lines of symmetry!"),
  WordItem(id:63, word:"SQUARE",    missingIndexes:[1,4],         difficulty:"Medium", category:"Shapes", imagePath:"assets/images/shapes/square.png",    urduName:"مربع",   hint:"4 perfectly equal sides", funFact:"Square is strongest 2D shape!"),
  WordItem(id:64, word:"DIAMOND",   missingIndexes:[1,3,5],       difficulty:"Hard",   category:"Shapes", imagePath:"assets/images/shapes/diamond.png",   urduName:"ہیرا",   hint:"Like a square rotated", funFact:"Diamond is hardest natural material!"),
  WordItem(id:65, word:"TRIANGLE",  missingIndexes:[0,1,2,3,4,5,6,7], difficulty:"Expert", category:"Shapes", imagePath:"assets/images/shapes/triangle.png", urduName:"مثلث", hint:"3 sides 3 corners",   funFact:"Triangle is strongest shape in nature!"),
];

// ═══════════════════════════════════════════
// COLORS — 12 words
// ═══════════════════════════════════════════
final List<WordItem> colorWords = [
  WordItem(id:66, word:"RED",     missingIndexes:[1],           difficulty:"Easy",   category:"Colors", imagePath:"assets/images/colors/red.png",     urduName:"سرخ",    hint:"Color of fire",          funFact:"Red is first color babies can see!"),
  WordItem(id:67, word:"BLUE",    missingIndexes:[2],           difficulty:"Easy",   category:"Colors", imagePath:"assets/images/colors/blue.png",    urduName:"نیلا",   hint:"Color of sky",           funFact:"Blue is worlds most popular color!"),
  WordItem(id:68, word:"GREEN",   missingIndexes:[1,3],         difficulty:"Medium", category:"Colors", imagePath:"assets/images/colors/green.png",   urduName:"سبز",    hint:"Color of grass",         funFact:"Green is easiest color for eyes to see!"),
  WordItem(id:69, word:"ORANGE",  missingIndexes:[1,3,5],       difficulty:"Hard",   category:"Colors", imagePath:"assets/images/colors/orange.png",  urduName:"نارنجی", hint:"Mix of red and yellow",  funFact:"Orange was named after the fruit!"),
  WordItem(id:70, word:"PURPLE",  missingIndexes:[1,3,5],       difficulty:"Hard",   category:"Colors", imagePath:"assets/images/colors/purple.png",  urduName:"جامنی",  hint:"Mix of red and blue",    funFact:"Purple was once most expensive color!"),
  WordItem(id:71, word:"YELLOW",  missingIndexes:[0,1,2,3,4,5], difficulty:"Expert", category:"Colors", imagePath:"assets/images/colors/yellow.png", urduName:"پیلا",   hint:"Color of sun",           funFact:"Yellow is most visible color from far!"),
];

// ═══════════════════════════════════════════
// ALL CATEGORIES MAP
// ═══════════════════════════════════════════
final Map<String, List<WordItem>> allWordCategories = {
  "Animals":    animalWords,
  "Fruits":     fruitWords,
  "Vegetables": vegetableWords,
  "Transport":  transportWords,
  "Shapes":     shapeWords,
  "Colors":     colorWords,
};

// ═══════════════════════════════════════════
// WRONG LETTER GENERATOR (confusable letters)
// ═══════════════════════════════════════════
const Map<String, List<String>> confusableLetters = {
  'A':['E','O','U'], 'B':['D','P','Q'], 'C':['G','O','K'],
  'D':['B','P','Q'], 'E':['A','I','F'], 'F':['E','P','T'],
  'G':['C','Q','O'], 'H':['N','M','K'], 'I':['L','J','T'],
  'J':['I','L','G'], 'K':['H','X','R'], 'L':['I','J','T'],
  'M':['N','W','H'], 'N':['M','H','U'], 'O':['C','Q','G'],
  'P':['B','D','F'], 'Q':['O','G','C'], 'R':['P','K','N'],
  'S':['Z','C','G'], 'T':['F','I','L'], 'U':['V','N','W'],
  'V':['U','W','Y'], 'W':['M','V','U'], 'X':['K','Y','Z'],
  'Y':['V','X','J'], 'Z':['S','X','N'],
};

List<String> getWrongLetters(String correct) {
  List<String> wrongs = List.from(
    confusableLetters[correct.toUpperCase()] ?? ['X','Y','Z']
  );
  wrongs.removeWhere((l) => l == correct.toUpperCase());
  return wrongs.take(3).toList();
}

// ═══════════════════════════════════════════
// UNLIMITED ENDLESS MODE GENERATOR
// Pulls from ALL categories — infinite sessions
// ═══════════════════════════════════════════
List<WordItem> generateEndlessRound({int count = 10, int roundNumber = 1}) {
  final random = Random(DateTime.now().millisecondsSinceEpoch + roundNumber);
  List<WordItem> all = [];
  allWordCategories.forEach((_, words) => all.addAll(words));
  
  all.shuffle(random);
  // Mix difficulties based on round number — gets harder as rounds increase
  if (roundNumber <= 3) {
    all = all.where((w) => w.difficulty == "Easy").toList();
  } else if (roundNumber <= 6) {
    all = all.where((w) => w.difficulty == "Medium").toList();
  } else if (roundNumber <= 10) {
    all = all.where((w) => w.difficulty == "Hard").toList();
  }
  
  if (all.length < count) {
    // If not enough words of specific difficulty, add some more
    List<WordItem> extra = [];
    allWordCategories.forEach((_, words) => extra.addAll(words));
    extra.shuffle(random);
    all.addAll(extra);
  }
  
  all.shuffle(random);
  return all.take(count).toList();
}

// ═══════════════════════════════════════════
// DAILY CHALLENGE GENERATOR
// New 5 words every day — same for all players
// Resets automatically at midnight every day
// ═══════════════════════════════════════════
List<WordItem> getDailyChallenge() {
  final today = DateTime.now();
  // Seed changes every day automatically at midnight
  final seed = today.year * 10000 + today.month * 100 + today.day;
  final random = Random(seed);
  List<WordItem> all = [];
  allWordCategories.forEach((_, words) => all.addAll(words));
  all.shuffle(random);
  return all.take(5).toList();
}

// ═══════════════════════════════════════════
// PRESTIGE MODE GENERATOR
// Unlocks after completing ALL categories Expert
// Ultra hard — only Expert words, all scrambled
// Infinite prestige levels 1, 2, 3...
// ═══════════════════════════════════════════
List<WordItem> generatePrestigeRound({required int prestigeLevel, int count = 10}) {
  final random = Random(prestigeLevel * 9999);
  List<WordItem> expertOnly = [];
  allWordCategories.forEach((_, words) {
    expertOnly.addAll(words.where((w) => w.difficulty == "Expert"));
  });
  
  // Force ALL letters missing for prestige mode
  List<WordItem> prestigeWords = expertOnly.map((w) => WordItem(
    id: w.id + (prestigeLevel * 1000),
    word: w.word,
    imagePath: w.imagePath,
    category: w.category,
    urduName: w.urduName,
    hint: w.hint,
    funFact: w.funFact,
    difficulty: "Prestige $prestigeLevel",
    missingIndexes: List.generate(w.word.length, (i) => i), // ALL letters missing
  )).toList();
  prestigeWords.shuffle(random);
  return prestigeWords.take(count).toList();
}

// ═══════════════════════════════════════════
// ROUND RECYCLER — makes any category unlimited
// After completing all words → reshuffles for Round 2
// Round 3 → reverse difficulty
// Round 4 → mixed with other categories
// Round 5+ → full unlimited random forever
// ═══════════════════════════════════════════
List<WordItem> getRecycledRound({
  required String category,
  required String difficulty,
  required int roundNumber,
}) {
  final random = Random(DateTime.now().millisecondsSinceEpoch);
  List<WordItem> base = List.from(allWordCategories[category] ?? []);

  if (roundNumber == 1 || roundNumber == 2) {
    // Normal or Round 2 — same words different order
    return base.where((w) => w.difficulty == difficulty).toList()..shuffle(random);
  } else if (roundNumber == 3) {
    // Round 3 — reverse difficulty (harder)
    String nextDiff = difficulty == "Easy" ? "Medium"
                    : difficulty == "Medium" ? "Hard"
                    : difficulty == "Hard" ? "Expert" : "Expert";
    List<WordItem> next = base.where((w) => w.difficulty == nextDiff).toList();
    if (next.isEmpty) next = base..shuffle(random);
    return next..shuffle(random);
  } else if (roundNumber == 4) {
    // Round 4 — mix current category with random other category
    List<WordItem> other = [];
    allWordCategories.forEach((cat, words) {
      if (cat != category) other.addAll(words);
    });
    other.shuffle(random);
    List<WordItem> mixed = [
      ...base.where((w) => w.difficulty == difficulty).take(5),
      ...other.take(5),
    ]..shuffle(random);
    return mixed;
  } else {
    // Round 5+ — full unlimited random forever
    List<WordItem> all = [];
    allWordCategories.forEach((_, words) => all.addAll(words));
    all.shuffle(random);
    return all.take(10).toList();
  }
}
