import '../models/learn_item.dart';

class LearnEverythingData {
  static const List<Map<String, dynamic>> categoriesRaw = [
    {
      'name': 'Home & Furniture',
      'icon': '🏠',
      'background': 'assets/images/learn/home_bg.png',
      'items': [
        'chair', 'table', 'bed', 'sofa', 'cupboard', 'wardrobe', 'drawer', 'shelf', 'door', 'window',
        'curtain', 'carpet', 'pillow', 'blanket', 'mirror', 'fan', 'lamp', 'bulb', 'switch', 'socket',
        'stairs', 'balcony', 'roof', 'wall', 'floor', 'ceiling', 'gate', 'fence', 'chimney', 'fireplace'
      ]
    },
    {
      'name': 'Kitchen Things',
      'icon': '🍳',
      'background': 'assets/images/learn/kitchen_bg.png',
      'items': [
        'stove', 'oven', 'fridge', 'microwave', 'kettle', 'toaster', 'blender', 'pot', 'pan', 'plate',
        'bowl', 'cup', 'glass', 'spoon', 'fork', 'knife', 'tray', 'bottle', 'jar', 'tin', 'lunchbox',
        'thermos', 'sink', 'tap', 'dish', 'spatula', 'ladle', 'grater', 'chopping board', 'apron'
      ]
    },
    {
      'name': 'Bathroom Things',
      'icon': '🚿',
      'background': 'assets/images/learn/bathroom_bg.png',
      'items': [
        'toilet', 'sink', 'bathtub', 'shower', 'mirror', 'towel', 'toothbrush', 'toothpaste', 'soap',
        'shampoo', 'comb', 'brush', 'razor', 'bucket', 'mug', 'tap', 'scale', 'mat', 'tissue', 'hairdryer'
      ]
    },
    {
      'name': 'Clothing & Accessories',
      'icon': '👕',
      'background': 'assets/images/learn/clothing_bg.png',
      'items': [
        'shirt', 'tshirt', 'pants', 'jeans', 'shorts', 'dress', 'skirt', 'jacket', 'coat', 'sweater',
        'hoodie', 'socks', 'shoes', 'sandals', 'boots', 'slippers', 'hat', 'cap', 'scarf', 'gloves',
        'belt', 'tie', 'bag', 'backpack', 'handbag', 'watch', 'glasses', 'ring', 'bracelet', 'umbrella',
        'diaper', 'school uniform', 'raincoat', 'swimsuit', 'pajamas'
      ]
    },
    {
      'name': 'Fruits',
      'icon': '🍎',
      'background': 'assets/images/learn/fruits_bg.png',
      'items': [
        'apple', 'banana', 'mango', 'orange', 'grape', 'watermelon', 'strawberry', 'pineapple', 'cherry',
        'pear', 'peach', 'plum', 'lemon', 'coconut', 'papaya', 'guava', 'kiwi', 'pomegranate', 'fig',
        'date', 'lychee', 'melon', 'avocado', 'blueberry', 'raspberry', 'apricot'
      ]
    },
    {
      'name': 'Vegetables',
      'icon': '🥦',
      'background': 'assets/images/learn/vegetables_bg.png',
      'items': [
        'carrot', 'potato', 'tomato', 'onion', 'garlic', 'cucumber', 'brinjal', 'spinach', 'cabbage',
        'cauliflower', 'peas', 'corn', 'beans', 'pumpkin', 'mushroom', 'pepper', 'radish', 'lettuce',
        'celery', 'ginger', 'turnip', 'beetroot', 'broccoli', 'zucchini', 'sweet potato', 'leek', 'asparagus'
      ]
    },
    {
      'name': 'Food & Drinks',
      'icon': '🍔',
      'background': 'assets/images/learn/food_bg.png',
      'items': [
        'rice', 'bread', 'egg', 'milk', 'butter', 'cheese', 'yogurt', 'pasta', 'noodles', 'pizza',
        'burger', 'sandwich', 'soup', 'salad', 'curry', 'roti', 'paratha', 'biryani', 'cake', 'biscuit',
        'chocolate', 'candy', 'ice cream', 'juice', 'water', 'tea', 'coffee', 'cola', 'honey', 'jam',
        'sauce', 'cereal', 'porridge', 'chips', 'popcorn', 'waffle', 'pancake', 'donut', 'cookie'
      ]
    },
    {
      'name': 'Animals — Pets',
      'icon': '🐶',
      'background': 'assets/images/learn/pets_bg.png',
      'items': [
        'cat', 'dog', 'rabbit', 'hamster', 'parrot', 'goldfish', 'turtle', 'guinea pig', 'mouse', 'bird',
        'lizard', 'snake', 'hedgehog'
      ]
    },
    {
      'name': 'Animals — Wild',
      'icon': '🐘',
      'background': 'assets/images/learn/wild_bg.png',
      'items': [
        'lion', 'tiger', 'elephant', 'giraffe', 'zebra', 'monkey', 'gorilla', 'cheetah', 'leopard',
        'hippo', 'rhino', 'bear', 'wolf', 'fox', 'deer', 'kangaroo', 'koala', 'panda', 'camel',
        'crocodile', 'alligator', 'chimpanzee', 'jaguar', 'hyena', 'meerkat', 'warthog', 'bison',
        'moose', 'reindeer'
      ]
    },
    {
      'name': 'Birds',
      'icon': '🐦',
      'background': 'assets/images/learn/birds_bg.png',
      'items': [
        'sparrow', 'eagle', 'parrot', 'peacock', 'penguin', 'owl', 'flamingo', 'swan', 'duck', 'hen',
        'rooster', 'pigeon', 'crow', 'toucan', 'woodpecker', 'hummingbird', 'ostrich', 'vulture',
        'albatross', 'stork', 'kingfisher'
      ]
    },
    {
      'name': 'Sea Creatures',
      'icon': '🐠',
      'background': 'assets/images/learn/sea_bg.png',
      'items': [
        'fish', 'shark', 'whale', 'dolphin', 'octopus', 'crab', 'lobster', 'starfish', 'jellyfish',
        'seahorse', 'turtle', 'seal', 'walrus', 'clownfish', 'squid', 'shrimp', 'oyster', 'coral',
        'stingray', 'swordfish'
      ]
    },
    {
      'name': 'Insects & Small Creatures',
      'icon': '🐛',
      'background': 'assets/images/learn/insects_bg.png',
      'items': [
        'butterfly', 'bee', 'ant', 'spider', 'mosquito', 'dragonfly', 'grasshopper', 'caterpillar',
        'ladybug', 'cockroach', 'beetle', 'fly', 'worm', 'snail', 'frog', 'lizard', 'scorpion',
        'centipede', 'firefly', 'moth'
      ]
    },
    {
      'name': 'Nature & Plants',
      'icon': '🌳',
      'background': 'assets/images/learn/nature_bg.png',
      'items': [
        'tree', 'flower', 'grass', 'leaf', 'root', 'branch', 'seed', 'bush', 'cactus', 'mushroom',
        'seaweed', 'moss', 'vine', 'bamboo', 'fern', 'tulip', 'rose', 'sunflower', 'daisy', 'lily',
        'orchid', 'dandelion', 'palm tree', 'oak tree', 'pine tree', 'coconut tree', 'mango tree'
      ]
    },
    {
      'name': 'Weather & Sky',
      'icon': '⛅',
      'background': 'assets/images/learn/weather_bg.png',
      'items': [
        'sun', 'moon', 'star', 'cloud', 'rain', 'snow', 'rainbow', 'lightning', 'thunder', 'wind',
        'fog', 'hail', 'storm', 'tornado', 'hurricane', 'sunrise', 'sunset', 'eclipse', 'comet', 'meteor'
      ]
    },
    {
      'name': 'Earth & Landforms',
      'icon': '🌍',
      'background': 'assets/images/learn/earth_bg.png',
      'items': [
        'mountain', 'hill', 'valley', 'river', 'lake', 'ocean', 'sea', 'beach', 'desert', 'forest',
        'jungle', 'island', 'volcano', 'cave', 'waterfall', 'glacier', 'cliff', 'plain', 'swamp',
        'marsh', 'pond', 'stream', 'reef', 'dune', 'canyon'
      ]
    },
    {
      'name': 'Transport & Vehicles',
      'icon': '🚗',
      'background': 'assets/images/learn/transport_bg.png',
      'items': [
        'car', 'bus', 'truck', 'van', 'bicycle', 'motorcycle', 'scooter', 'train', 'tram', 'subway',
        'airplane', 'helicopter', 'rocket', 'boat', 'ship', 'submarine', 'ferry', 'hot air balloon',
        'ambulance', 'fire truck', 'police car', 'taxi', 'tractor', 'bulldozer', 'crane', 'forklift',
        'rickshaw', 'skateboard', 'wheelchair', 'horse cart'
      ]
    },
    {
      'name': 'School & Stationery',
      'icon': '✏️',
      'background': 'assets/images/learn/school_bg.png',
      'items': [
        'pencil', 'pen', 'eraser', 'sharpener', 'ruler', 'notebook', 'book', 'bag', 'scissors', 'glue',
        'stapler', 'tape', 'marker', 'crayon', 'paintbrush', 'paint', 'compass', 'calculator', 'globe',
        'map', 'whiteboard', 'chalk', 'blackboard', 'desk', 'chair', 'locker', 'lunchbox', 'water bottle',
        'school uniform', 'geometry box'
      ]
    },
    {
      'name': 'Electronics & Gadgets',
      'icon': '💻',
      'background': 'assets/images/learn/electronics_bg.png',
      'items': [
        'phone', 'tablet', 'laptop', 'computer', 'keyboard', 'mouse', 'monitor', 'printer', 'camera',
        'television', 'remote', 'headphones', 'speaker', 'radio', 'smartwatch', 'game controller',
        'charger', 'USB', 'hard drive', 'microphone', 'projector', 'calculator', 'ATM', 'scanner'
      ]
    },
    {
      'name': 'Medical & Health',
      'icon': '🏥',
      'background': 'assets/images/learn/medical_bg.png',
      'items': [
        'doctor', 'nurse', 'stethoscope', 'thermometer', 'syringe', 'medicine', 'tablet', 'bandage',
        'wheelchair', 'ambulance', 'hospital', 'bed', 'gloves', 'mask', 'X-ray', 'blood pressure machine',
        'crutches', 'eye drops', 'ointment', 'first aid box', 'scale', 'oxygen mask'
      ]
    },
    {
      'name': 'Sports & Games',
      'icon': '🏋️',
      'background': 'assets/images/learn/sports_bg.png',
      'items': [
        'football', 'basketball', 'cricket bat', 'tennis racket', 'badminton', 'volleyball', 'baseball',
        'hockey stick', 'golf club', 'swimming pool', 'bicycle', 'skateboard', 'chess', 'dice', 'cards',
        'puzzle', 'kite', 'jump rope', 'frisbee', 'dartboard', 'bowling pin', 'table tennis', 'archery bow',
        'boxing gloves', 'helmet', 'jersey'
      ]
    },
    {
      'name': 'Art & Music',
      'icon': '🎨',
      'background': 'assets/images/learn/art_bg.png',
      'items': [
        'guitar', 'piano', 'drum', 'violin', 'flute', 'trumpet', 'microphone', 'paintbrush', 'canvas',
        'palette', 'clay', 'origami', 'camera', 'pencil', 'sketchbook', 'crayon', 'watercolor',
        'sculpture', 'easel', 'tambourine', 'xylophone', 'harmonica', 'accordion', 'ukulele', 'keyboard'
      ]
    },
    {
      'name': 'Buildings & Places',
      'icon': '🏗️',
      'background': 'assets/images/learn/places_bg.png',
      'items': [
        'house', 'apartment', 'school', 'hospital', 'mosque', 'church', 'temple', 'market', 'shop',
        'mall', 'restaurant', 'hotel', 'bank', 'library', 'park', 'playground', 'stadium', 'airport',
        'train station', 'bus stop', 'farm', 'factory', 'museum', 'police station', 'fire station',
        'post office', 'petrol station', 'lighthouse', 'castle', 'palace', 'fort', 'bridge', 'tunnel', 'tower'
      ]
    },
    {
      'name': 'Tools & Equipment',
      'icon': '🧰',
      'background': 'assets/images/learn/tools_bg.png',
      'items': [
        'hammer', 'screwdriver', 'wrench', 'pliers', 'saw', 'drill', 'nail', 'screw', 'bolt',
        'measuring tape', 'ladder', 'bucket', 'broom', 'mop', 'vacuum cleaner', 'iron', 'sewing machine',
        'needle', 'thread', 'rope', 'chain', 'lock', 'key', 'torch', 'magnifying glass', 'telescope',
        'microscope', 'compass', 'binoculars'
      ]
    },
    {
      'name': 'Space & Universe',
      'icon': '🌙',
      'background': 'assets/images/learn/space_bg.png',
      'items': [
        'sun', 'moon', 'earth', 'mars', 'jupiter', 'saturn', 'venus', 'mercury', 'neptune', 'uranus',
        'star', 'comet', 'asteroid', 'galaxy', 'black hole', 'rocket', 'astronaut', 'satellite',
        'telescope', 'space station', 'meteor', 'constellation', 'milky way', 'solar system', 'orbit',
        'universe', 'alien', 'UFO', 'nebula', 'supernova'
      ]
    },
    {
      'name': 'People & Community',
      'icon': '👨‍👩‍👧',
      'background': 'assets/images/learn/people_bg.png',
      'items': [
        'baby', 'boy', 'girl', 'man', 'woman', 'mother', 'father', 'grandma', 'grandpa', 'teacher',
        'doctor', 'nurse', 'police officer', 'firefighter', 'farmer', 'chef', 'driver', 'pilot',
        'engineer', 'soldier', 'postman', 'shopkeeper', 'baker', 'painter', 'barber', 'tailor',
        'fisherman', 'carpenter', 'scientist', 'astronaut'
      ]
    },
    {
      'name': 'Emotions & Feelings',
      'icon': '🎭',
      'background': 'assets/images/learn/emotions_bg.png',
      'items': [
        'happy', 'sad', 'angry', 'scared', 'surprised', 'confused', 'excited', 'bored', 'tired',
        'proud', 'shy', 'love', 'cry', 'laugh', 'smile', 'worried', 'calm', 'lonely', 'jealous', 'grateful'
      ]
    },
  ];

  static List<LearnCategory> getCategories() {
    return categoriesRaw.map((cat) {
      final String categoryName = cat['name'];
      final List<String> itemsList = List<String>.from(cat['items']);
      
      final items = itemsList.map((itemName) {
        return LearnItem(
          id: '${categoryName.toLowerCase().replaceAll(' ', '_')}_${itemName.toLowerCase().replaceAll(' ', '_')}',
          name: itemName[0].toUpperCase() + itemName.substring(1),
          category: categoryName,
          imagePath: 'assets/images/learn/${categoryName.toLowerCase().replaceAll(' ', '_')}/${itemName.toLowerCase().replaceAll(' ', '_')}.png',
        );
      }).toList();

      return LearnCategory(
        name: categoryName,
        icon: cat['icon'],
        items: items,
        backgroundPath: cat['background'],
        isLocked: categoryName != 'Home & Furniture', // Only first one unlocked by default
      );
    }).toList();
  }
}
