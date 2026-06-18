class GeminiClothingDetectionPrompt {
  static final String prompt = '''Analyze this fashion / clothing image.

    Your task is to identify EVERY clothing item that can be worn independently.

    Examples:

    Person wearing black t-shirt and blue jeans:

    * Top → T-Shirt → Black
    * Bottom → Jeans → Blue

    Person wearing hoodie over t-shirt:

    * Outerwear → Hoodie
    * Top → T-Shirt

    Return ONLY valid JSON.

    Schema:

    {
    "items": [
    {
    "category": "Top",
    "subcategory": "T-Shirt",
    "color": "Black",
    "confidence": 0.97
    }
    ]
    }

    Allowed categories:

    * Top
    * Bottom
    * Dress
    * Outerwear
    * Shoes
    * Accessory

    Allowed subcategories examples:

    Top:
    T-Shirt
    Shirt
    Polo
    Tank Top
    Blouse
    Sweater

    Bottom:
    Jeans
    Trousers
    Shorts
    Skirt
    Leggings

    Outerwear:
    Jacket
    Hoodie
    Coat
    Blazer

    Dress:
    Dress

    Shoes:
    Sneakers
    Boots
    Sandals
    Heels

    Accessory:
    Hat
    Cap
    Bag
    Scarf
    Belt

    Rules:

    * Detect ALL visible garments.
    * Do not merge top and bottom into one item.
    * Use the dominant color of each item.
    * Confidence must be between 0 and 1.
    * Return JSON only.
    * No markdown.
    * No explanation.

''';
}