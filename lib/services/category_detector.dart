Map<String, List<String>> categoryKeywords = {

  "Coupons & Promo Codes":[
    "coupon","promo","discount","offer","deal"
  ],

  "Electronics & Software":[
    "laptop","phone","electronics","computer","software","tablet","monitor"
  ],

  "Clothing, Shoes & Jewellery":[
    "shirt","jeans","shoes","clothing","fashion","jacket","dress"
  ],

  "Healthcare & Beauty":[
    "beauty","skincare","lipstick","cosmetics","vitamin","health","supplement"
  ],

  "Home & Kitchen":[
    "kitchen","furniture","home","cookware","bed","sofa","decor"
  ],

  "Sports & Outdoors":[
    "sports","football","gym","fitness","outdoor","camping","cycling"
  ],

  "Grocery & Gourmet Food":[
    "grocery","food","snacks","coffee","tea","organic","spices"
  ],

  "Toys & Games":[
    "toy","lego","game","board game","puzzle","kids"
  ],

  "Books & Ebooks":[
    "book","ebook","novel","reading","kindle"
  ],

  "Finance & Marketing":[
    "finance","marketing","investment","crypto","stock","seo"
  ],

  "Real Estate & Property":[
    "house","property","real estate","rent","apartment"
  ],

  "Education & Training":[
    "course","training","education","learning","tutorial"
  ],

  "Pet Supplies":[
    "dog","cat","pet","pet food","pet toys"
  ],

  "Musical Instruments":[
    "guitar","piano","drum","keyboard","music instrument"
  ],

  "Automotive Parts":[
    "car","auto","engine","tire","brake","vehicle"
  ],

  "Tools & Furniture":[
    "drill","hammer","tools","construction","plumbing"
  ]

};

String detectCategory(String query) {

  query = query.toLowerCase();

  for (var category in categoryKeywords.keys) {

    for (var keyword in categoryKeywords[category]!) {

      if (query.contains(keyword)) {
        return category;
      }

    }

  }

  return "NoResults";

}