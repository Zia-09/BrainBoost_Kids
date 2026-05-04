import '../models/question.dart';

List<Question> scienceQuestions = [

  // ────────────────────────────────
  // EASY — 10 questions (3+3+2+2)
  // ────────────────────────────────

  // PLANTS - Easy
  Question(
    text: "What color are most leaves in spring?",
    options: ["Red", "Green", "Blue", "Yellow"],
    correctOptionIndex: 1,
    topic: "Plants",
    difficulty: "Easy",
    subject: "Science",
  ),
  Question(
    text: "What do plants need to grow?",
    options: ["Pizza", "Water and Sun", "Candy", "Toys"],
    correctOptionIndex: 1,
    topic: "Plants",
    difficulty: "Easy",
    subject: "Science",
  ),
  Question(
    text: "Which part of the plant makes seeds?",
    options: ["Root", "Stem", "Flower", "Leaf"],
    correctOptionIndex: 2,
    topic: "Plants",
    difficulty: "Easy",
    subject: "Science",
  ),

  // ANIMALS - Easy
  Question(
    text: "Which animal is known as the king of the jungle?",
    options: ["Tiger", "Elephant", "Lion", "Bear"],
    correctOptionIndex: 2,
    topic: "Animals",
    difficulty: "Easy",
    subject: "Science",
  ),
  Question(
    text: "Which animal has a very long neck?",
    options: ["Giraffe", "Zebra", "Horse", "Cow"],
    correctOptionIndex: 0,
    topic: "Animals",
    difficulty: "Easy",
    subject: "Science",
  ),
  Question(
    text: "What sound does a cow make?",
    options: ["Bark", "Moo", "Roar", "Chirp"],
    correctOptionIndex: 1,
    topic: "Animals",
    difficulty: "Easy",
    subject: "Science",
  ),

  // SOLAR SYSTEM - Easy
  Question(
    text: "Which is our home planet?",
    options: ["Mars", "Venus", "Earth", "Jupiter"],
    correctOptionIndex: 2,
    topic: "Solar System",
    difficulty: "Easy",
    subject: "Science",
  ),
  Question(
    text: "What is at the center of our solar system?",
    options: ["Earth", "Moon", "Sun", "Mars"],
    correctOptionIndex: 2,
    topic: "Solar System",
    difficulty: "Easy",
    subject: "Science",
  ),

  // HUMAN BODY - Easy
  Question(
    text: "What do we breathe to stay alive?",
    options: ["Water", "Oxygen", "Fire", "Dirt"],
    correctOptionIndex: 1,
    topic: "Human Body",
    difficulty: "Easy",
    subject: "Science",
  ),
  Question(
    text: "How many eyes do humans normally have?",
    options: ["1", "2", "3", "4"],
    correctOptionIndex: 1,
    topic: "Human Body",
    difficulty: "Easy",
    subject: "Science",
  ),

  // ────────────────────────────────
  // MEDIUM — 10 questions (3+2+3+2)
  // ────────────────────────────────

  // PLANTS - Medium
  Question(
    text: "Which part of the plant is underground?",
    options: ["Stem", "Leaves", "Roots", "Flower"],
    correctOptionIndex: 2,
    topic: "Plants",
    difficulty: "Medium",
    subject: "Science",
  ),
  Question(
    text: "What is the process called where plants make food?",
    options: ["Cooking", "Photosynthesis", "Breathing", "Eating"],
    correctOptionIndex: 1,
    topic: "Plants",
    difficulty: "Medium",
    subject: "Science",
  ),
  Question(
    text: "Which gas do plants release during photosynthesis?",
    options: ["Carbon dioxide", "Nitrogen", "Oxygen", "Hydrogen"],
    correctOptionIndex: 2,
    topic: "Plants",
    difficulty: "Medium",
    subject: "Science",
  ),

  // ANIMALS - Medium
  Question(
    text: "Which of these is a mammal?",
    options: ["Shark", "Whale", "Snake", "Spider"],
    correctOptionIndex: 1,
    topic: "Animals",
    difficulty: "Medium",
    subject: "Science",
  ),
  Question(
    text: "Where do fish breathe from?",
    options: ["Lungs", "Gills", "Nose", "Skin"],
    correctOptionIndex: 1,
    topic: "Animals",
    difficulty: "Medium",
    subject: "Science",
  ),

  // SOLAR SYSTEM - Medium
  Question(
    text: "Which planet is known as the Red Planet?",
    options: ["Venus", "Mars", "Saturn", "Mercury"],
    correctOptionIndex: 1,
    topic: "Solar System",
    difficulty: "Medium",
    subject: "Science",
  ),
  Question(
    text: "Which is the largest planet in our solar system?",
    options: ["Saturn", "Neptune", "Jupiter", "Uranus"],
    correctOptionIndex: 2,
    topic: "Solar System",
    difficulty: "Medium",
    subject: "Science",
  ),
  Question(
    text: "What do we call a rocky object that orbits the sun?",
    options: ["Comet", "Asteroid", "Meteor", "Galaxy"],
    correctOptionIndex: 1,
    topic: "Solar System",
    difficulty: "Medium",
    subject: "Science",
  ),

  // HUMAN BODY - Medium
  Question(
    text: "Which organ pumps blood in your body?",
    options: ["Lungs", "Brain", "Heart", "Stomach"],
    correctOptionIndex: 2,
    topic: "Human Body",
    difficulty: "Medium",
    subject: "Science",
  ),
  Question(
    text: "What part of your body tells you what you are seeing?",
    options: ["Ears", "Hands", "Brain", "Mouth"],
    correctOptionIndex: 2,
    topic: "Human Body",
    difficulty: "Medium",
    subject: "Science",
  ),

  // ────────────────────────────────
  // HARD — 10 questions (3+2+3+2)
  // ────────────────────────────────

  // PLANTS - Hard
  Question(
    text: "What is the green substance in leaves called?",
    options: ["Chlorophyll", "Cytoplasm", "Cellulose", "Chloride"],
    correctOptionIndex: 0,
    topic: "Plants",
    difficulty: "Hard",
    subject: "Science",
  ),
  Question(
    text: "What process do plants use to lose water through leaves?",
    options: ["Respiration", "Transpiration", "Absorption", "Germination"],
    correctOptionIndex: 1,
    topic: "Plants",
    difficulty: "Hard",
    subject: "Science",
  ),
  Question(
    text: "What is the male reproductive part of a flower called?",
    options: ["Pistil", "Petal", "Stamen", "Sepal"],
    correctOptionIndex: 2,
    topic: "Plants",
    difficulty: "Hard",
    subject: "Science",
  ),

  // ANIMALS - Hard
  Question(
    text: "Which bird cannot fly?",
    options: ["Eagle", "Penguin", "Parrot", "Sparrow"],
    correctOptionIndex: 1,
    topic: "Animals",
    difficulty: "Hard",
    subject: "Science",
  ),
  Question(
    text: "What is the process called when a caterpillar becomes a butterfly?",
    options: ["Hibernation", "Migration", "Metamorphosis", "Evolution"],
    correctOptionIndex: 2,
    topic: "Animals",
    difficulty: "Hard",
    subject: "Science",
  ),

  // SOLAR SYSTEM - Hard
  Question(
    text: "How many planets are in our solar system?",
    options: ["7", "8", "9", "10"],
    correctOptionIndex: 1,
    topic: "Solar System",
    difficulty: "Hard",
    subject: "Science",
  ),
  Question(
    text: "Which planet has the most known moons?",
    options: ["Jupiter", "Saturn", "Uranus", "Neptune"],
    correctOptionIndex: 1,
    topic: "Solar System",
    difficulty: "Hard",
    subject: "Science",
  ),
  Question(
    text: "What causes a solar eclipse?",
    options: [
      "Earth blocks the Sun",
      "Moon blocks the Sun",
      "Sun goes behind Mars",
      "Earth moves away from the Sun"
    ],
    correctOptionIndex: 1,
    topic: "Solar System",
    difficulty: "Hard",
    subject: "Science",
  ),

  // HUMAN BODY - Hard
  Question(
    text: "How many bones are in an adult human body?",
    options: ["106", "206", "306", "406"],
    correctOptionIndex: 1,
    topic: "Human Body",
    difficulty: "Hard",
    subject: "Science",
  ),
  Question(
    text: "What is the largest organ in the human body?",
    options: ["Brain", "Liver", "Skin", "Lungs"],
    correctOptionIndex: 2,
    topic: "Human Body",
    difficulty: "Hard",
    subject: "Science",
  ),
];
