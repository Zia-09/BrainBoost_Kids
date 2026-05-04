class AchievementService {
  // These badges take months to unlock all
  // After all unlocked → Prestige 1 starts → new set of badges

  static const List<Map<String, dynamic>> allBadges = [
    // First steps
    {"id":"first_word",    "title":"First Word!",      "emoji":"🌟", "desc":"Complete your first word",        "requirement": 1,    "type":"words"},
    {"id":"ten_words",     "title":"Word Learner",      "emoji":"📚", "desc":"Complete 10 words",               "requirement": 10,   "type":"words"},
    {"id":"fifty_words",   "title":"Word Explorer",     "emoji":"🗺️", "desc":"Complete 50 words",               "requirement": 50,   "type":"words"},
    {"id":"hundred_words", "title":"Word Master",       "emoji":"🏆", "desc":"Complete 100 words",              "requirement": 100,  "type":"words"},
    {"id":"fivehun_words", "title":"Word Legend",       "emoji":"👑", "desc":"Complete 500 words",              "requirement": 500,  "type":"words"},
    {"id":"thousand_words","title":"Word Wizard!",      "emoji":"🧙", "desc":"Complete 1000 words",             "requirement": 1000, "type":"words"},
    // Streaks
    {"id":"streak_5",      "title":"On Fire!",          "emoji":"🔥", "desc":"Get a 5 word streak",             "requirement": 5,    "type":"streak"},
    {"id":"streak_10",     "title":"Unstoppable!",      "emoji":"⚡", "desc":"Get a 10 word streak",            "requirement": 10,   "type":"streak"},
    {"id":"streak_25",     "title":"Lightning!",        "emoji":"🌩️", "desc":"Get a 25 word streak",            "requirement": 25,   "type":"streak"},
    {"id":"streak_50",     "title":"Legendary!",        "emoji":"💎", "desc":"Get a 50 word streak",            "requirement": 50,   "type":"streak"},
    // Perfect rounds
    {"id":"perfect_round", "title":"Perfectionist",     "emoji":"🎯", "desc":"Complete a round with no mistakes","requirement": 1,   "type":"perfect"},
    {"id":"perfect_5",     "title":"Sharp Mind",        "emoji":"🧠", "desc":"5 perfect rounds in a row",       "requirement": 5,    "type":"perfect"},
    // Daily challenge
    {"id":"daily_1",       "title":"Daily Champ",       "emoji":"📅", "desc":"Complete first daily challenge",  "requirement": 1,    "type":"daily"},
    {"id":"daily_7",       "title":"Weekly Warrior",    "emoji":"🗓️", "desc":"7 day streak on daily challenge", "requirement": 7,    "type":"daily"},
    {"id":"daily_30",      "title":"Monthly Master",    "emoji":"🌙", "desc":"30 day streak!",                  "requirement": 30,   "type":"daily"},
    {"id":"daily_365",     "title":"Yearly Legend",     "emoji":"🏅", "desc":"365 day streak!",                 "requirement": 365,  "type":"daily"},
    // Categories
    {"id":"animals_done",  "title":"Animal Expert",     "emoji":"🐾", "desc":"Complete all Animal words",       "requirement": 1,    "type":"category_animals"},
    {"id":"fruits_done",   "title":"Fruit Master",      "emoji":"🍎", "desc":"Complete all Fruit words",        "requirement": 1,    "type":"category_fruits"},
    {"id":"all_cats",      "title":"Category King",     "emoji":"👑", "desc":"Complete all 6 categories",       "requirement": 6,    "type":"categories_done"},
    // Prestige
    {"id":"prestige_1",    "title":"Prestige I",        "emoji":"🥇", "desc":"Reach Prestige Level 1",          "requirement": 1,    "type":"prestige"},
    {"id":"prestige_5",    "title":"Prestige V",        "emoji":"🏆", "desc":"Reach Prestige Level 5",          "requirement": 5,    "type":"prestige"},
    {"id":"prestige_10",   "title":"Prestige X",        "emoji":"💎", "desc":"Reach Prestige Level 10",         "requirement": 10,   "type":"prestige"},
    // Endless mode
    {"id":"endless_1",     "title":"Endless Starter",   "emoji":"♾️", "desc":"Play first endless round",        "requirement": 1,    "type":"endless"},
    {"id":"endless_10",    "title":"Endless Explorer",  "emoji":"🌌", "desc":"Complete 10 endless rounds",      "requirement": 10,   "type":"endless"},
    {"id":"endless_50",    "title":"Endless Legend",    "emoji":"⭐", "desc":"Complete 50 endless rounds",      "requirement": 50,   "type":"endless"},
    // Score milestones
    {"id":"score_1000",    "title":"Point Collector",   "emoji":"💰", "desc":"Reach 1,000 total points",        "requirement": 1000,  "type":"score"},
    {"id":"score_10000",   "title":"Point Hoarder",     "emoji":"💎", "desc":"Reach 10,000 total points",       "requirement": 10000, "type":"score"},
    {"id":"score_100000",  "title":"Point Legend",      "emoji":"🌟", "desc":"Reach 100,000 total points",      "requirement": 100000,"type":"score"},
  ];
}
