class CategoryKeywords {
  static List<String> getKeywords(String category) {
    switch (category) {

      case "Clothing, Shoes & Jewellery":
        return [
          "men t shirts",
          "women dresses",
          "sneakers shoes",
          "hoodies men",
          "casual shirts",
          "jeans men",
          "handbags women",
          "sports shoes",
          "watches men",
          "sunglasses"
        ];

      case "Healthcare & Beauty":
        return [
          "skincare products",
          "face wash",
          "moisturizer",
          "makeup kit",
          "lipstick",
          "hair care",
          "vitamins supplements",
          "perfume women",
          "body lotion",
          "face serum"
        ];

      case "Sports & Outdoors":
        return [
          "dumbbells",
          "yoga mat",
          "gym equipment",
          "treadmill",
          "basketball",
          "football",
          "camping gear",
          "cycling accessories",
          "fitness bands",
          "protein powder"
        ];

      case "Electronics & Software":
        return [
          "smartphones",
          "laptops",
          "wireless earbuds",
          "smart watch",
          "bluetooth speaker",
          "gaming mouse",
          "keyboard",
          "tablet",
          "monitor",
          "power bank"
        ];

      case "Toys & Games":
        return [
          "kids toys",
          "lego sets",
          "remote control car",
          "board games",
          "puzzle games",
          "action figures",
          "educational toys",
          "baby toys",
          "dolls",
          "toy cars"
        ];

      case "Books & Ebooks":
        return [
          "best selling books",
          "novels",
          "self help books",
          "business books",
          "motivational books",
          "fiction books",
          "romance novels",
          "ebooks kindle",
          "biography books",
          "children books"
        ];

      case "Home & Kitchen":
        return [
          "kitchen appliances",
          "cookware set",
          "non stick pan",
          "blender",
          "microwave oven",
          "home decor",
          "bedsheets",
          "curtains",
          "storage containers",
          "wall decor"
        ];

      case "Grocery & Gourmet Food":
        return [
          "snacks",
          "chocolate",
          "dry fruits",
          "organic food",
          "coffee beans",
          "tea bags",
          "protein snacks",
          "instant noodles",
          "healthy snacks",
          "energy drinks"
        ];

      case "Finance & Marketing":
        return [
          "business books",
          "marketing books",
          "startup guide",
          "finance books",
          "investment books",
          "digital marketing",
          "entrepreneur books",
          "sales books",
          "branding books",
          "seo books"
        ];

      case "Real Estate & Property":
        return [
          "home decor",
          "furniture",
          "sofa set",
          "bed frames",
          "wardrobe",
          "dining table",
          "lighting fixtures",
          "interior decor",
          "office furniture",
          "home accessories"
        ];

      case "Education & Training":
        return [
          "online courses",
          "coding books",
          "programming courses",
          "english learning",
          "skill development",
          "study materials",
          "competitive exams",
          "training courses",
          "certification courses",
          "learning kits"
        ];

      case "Professional Services":
        return [
          "office tools",
          "business software",
          "accounting software",
          "crm software",
          "project management tools",
          "productivity tools",
          "design software",
          "freelancing tools",
          "marketing tools",
          "analytics tools"
        ];

      case "Pet Supplies":
        return [
          "dog food",
          "cat food",
          "pet toys",
          "pet grooming",
          "dog leash",
          "cat litter",
          "pet beds",
          "aquarium supplies",
          "bird food",
          "pet accessories"
        ];

      case "Patio, Lawn & Garden":
        return [
          "garden tools",
          "plants",
          "flower pots",
          "lawn mower",
          "watering can",
          "garden decor",
          "outdoor furniture",
          "seeds",
          "fertilizer",
          "garden lights"
        ];

      case "Arts, Crafts & Sewing":
        return [
          "art supplies",
          "paint brushes",
          "canvas painting",
          "craft kits",
          "sewing machine",
          "embroidery kit",
          "diy crafts",
          "sketch pens",
          "drawing books",
          "handmade crafts"
        ];

      case "Automotive Parts":
        return [
          "car accessories",
          "car covers",
          "bike accessories",
          "car cleaning kit",
          "car seat covers",
          "helmet",
          "car charger",
          "dash cam",
          "tyre inflator",
          "car perfume"
        ];

      case "Musical Instruments":
        return [
          "guitar",
          "keyboard piano",
          "drum set",
          "violin",
          "ukulele",
          "microphone",
          "dj equipment",
          "music accessories",
          "guitar strings",
          "studio headphones"
        ];

      case "Luggage & Travel Gear":
        return [
          "travel bags",
          "suitcase",
          "backpack",
          "luggage set",
          "travel accessories",
          "neck pillow",
          "travel organizer",
          "trolley bag",
          "duffel bag",
          "passport holder"
        ];

      case "Tools & Furniture":
        return [
          "power tools",
          "hand tools",
          "drill machine",
          "furniture set",
          "office chair",
          "work desk",
          "tool kit",
          "storage rack",
          "bookshelf",
          "wood furniture"
        ];

      case "Logistics & Transport":
        return [
          "warehouse equipment",
          "trolley cart",
          "packing materials",
          "shipping boxes",
          "industrial tools",
          "logistics tools",
          "transport equipment",
          "forklift accessories",
          "storage bins",
          "cargo tools"
        ];

      case "Office Products":
        return [
          "office supplies",
          "notebooks",
          "printer",
          "pens",
          "desk organizer",
          "office chair",
          "whiteboard",
          "files folders",
          "stationery",
          "paper reams"
        ];

      case "Agricultural Products":
        return [
          "farming tools",
          "seeds",
          "fertilizer",
          "irrigation tools",
          "tractor accessories",
          "pesticides",
          "agriculture equipment",
          "garden tools",
          "soil nutrients",
          "plant care"
        ];

      case "Construction Parts":
        return [
          "construction tools",
          "cement tools",
          "drill machine",
          "safety helmet",
          "measuring tools",
          "hardware tools",
          "building materials",
          "electric tools",
          "hand tools",
          "construction equipment"
        ];

      default:
        return ["trending products"];
    }
  }
}
