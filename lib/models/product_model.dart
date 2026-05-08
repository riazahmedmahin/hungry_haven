import 'package:flutter/material.dart';

class Product {
  final int id;
  String title;
  String subtitle;
  String image;
  double price;
  String discount;
  bool inCart;
  String category;
  int quantity;
  bool isFavorite;
  int stock;
  List<Map<String, dynamic>> ingredients;

  Product({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.price,
    this.discount = "-25%",
    this.inCart = false,
    required this.category,
    this.quantity = 0,
    this.isFavorite = false,
    this.stock = 10,
    this.ingredients = const [],
  });
}

final List<Map<String, dynamic>> allAvailableIngredients = [
  {
    "title": "Onions",
    "image": "https://pngimg.com/uploads/onion/small/onion_PNG603.png",
    "color": Color(0xFFE0C097),
    "glow": Color(0xFFD32F2F), // withOpacity will be applied in UI
    "gradient": [Color(0xFFE0C097), Color(0xFFB88E5E)],
  },
  {
    "title": "Tomato",
    "image": "https://pngimg.com/uploads/tomato/small/tomato_PNG12567.png",
    "color": Color(0xFFFF5252),
    "glow": Color(0xFFFF5252),
    "gradient": [Color(0xFFFF8A80), Color(0xFFD32F2F)],
  },
  {
    "title": "Cheese",
    "image": "https://pngimg.com/uploads/cheese/small/cheese_PNG11.png",
    "color": Color(0xFFFFCA28),
    "glow": Color(0xFFFFB300),
    "gradient": [Color(0xFFFFEE58), Color(0xFFFFCA28)],
  },
  {
    "title": "Basil",
    "image": "https://pngimg.com/uploads/basil/small/basil_PNG7.png",
    "color": Color(0xFF66BB6A),
    "glow": Color(0xFF66BB6A),
    "gradient": [Color(0xFFA5D6A7), Color(0xFF388E3C)],
  },
  {
    "title": "Egg",
    "image": "https://pngimg.com/uploads/egg/small/egg_PNG97961.png",
    "color": Color(0xFFFFE082),
    "glow": Color(0xFFFFC107),
    "gradient": [Color(0xFFFFF176), Color(0xFFFFA000)],
  },
  {
    "title": "Pepper",
    "image": "https://pngimg.com/uploads/pepper/small/pepper_PNG3245.png",
    "color": Color(0xFFEF5350),
    "glow": Color(0xFFEF5350),
    "gradient": [Color(0xFFFF8A80), Color(0xFFC62828)],
  },
];

double totalAdminSales = 0.0;
List<String> adminNotifications = [];

// Highly reliable Vecteezy fully-transparent preview URLs matching mockup perfectly
List<Product> newDemoProducts = [
  Product(
    id: 1,
    title: "Noodles Twistara",
    subtitle: "With Spicy Sauce",
    image: "https://pngimg.com/uploads/noodle/noodle_PNG38.png",
    price: 5.33,
    discount: "-25%",
    inCart: false,
    category: "Food",
    ingredients: [
      allAvailableIngredients[0],
      allAvailableIngredients[1],
      allAvailableIngredients[4],
      allAvailableIngredients[5],
      allAvailableIngredients[3],
      allAvailableIngredients[2],
    ],
  ),
  Product(
    id: 2,
    title: "Pizza Sicilia",
    subtitle: "Pizza Sicilia",
    image: "https://pngimg.com/uploads/pizza/pizza_PNG44029.png",
    price: 8.99,
    discount: "-25%",
    inCart: true,
    category: "Food",
    ingredients: [
      allAvailableIngredients[0],
      allAvailableIngredients[1],
      allAvailableIngredients[4],
      allAvailableIngredients[5],
      allAvailableIngredients[3],
      allAvailableIngredients[2],
    ],
  ),
  Product(
    id: 3,
    title: "Classic Cheese Burger",
    subtitle: "Beef Combo",
    image:
        "https://pngimg.com/uploads/burger_sandwich/burger_sandwich_PNG4159.png",
    price: 12.50,
    discount: "-10%",
    inCart: false,
    category: "Food",
    ingredients: [
      allAvailableIngredients[0],
      allAvailableIngredients[1],
      allAvailableIngredients[4],
      allAvailableIngredients[5],
      allAvailableIngredients[3],
      allAvailableIngredients[2],
    ],
  ),
  Product(
    id: 4,
    title: "Spicy Kebab",
    subtitle: "Chicken Roast",
    image: "https://pngimg.com/uploads/kebab/small/kebab_PNG25.png",
    price: 14.10,
    discount: "-15%",
    inCart: false,
    category: "Food",
    ingredients: [
      allAvailableIngredients[0],
      allAvailableIngredients[1],
      allAvailableIngredients[4],
      allAvailableIngredients[5],
      allAvailableIngredients[3],
      allAvailableIngredients[2],
    ],
  ),
  Product(
    id: 5,
    title: "Chicken Sandwitch",
    subtitle: "Organic Fruit",
    image: "https://pngimg.com/uploads/sandwich/sandwich_PNG45.png",
    price: 3.50,
    discount: "-10%",
    inCart: false,
    category: "Food",
    ingredients: [
      allAvailableIngredients[0],
      allAvailableIngredients[1],
      allAvailableIngredients[4],
      allAvailableIngredients[5],
      allAvailableIngredients[3],
      allAvailableIngredients[2],
    ],
  ),
  Product(
    id: 6,
    title: "Orange Juice",
    subtitle: "Fresh & Lime",
    image: "https://purepng.com/public/uploads/large/drinks-wra.png",
    price: 4.10,
    discount: "-20%",
    inCart: false,
    category: "Drinks",
    ingredients: [
      allAvailableIngredients[0],
      allAvailableIngredients[1],
      allAvailableIngredients[4],
      allAvailableIngredients[5],
      allAvailableIngredients[3],
      allAvailableIngredients[2],
    ],
  ),
  Product(
    id: 7,
    title: "Fish Fry",
    subtitle: "Crunchy Snack",
    image:
        "https://purepng.com/public/uploads/large/purepng.com-fried-fishfood-fish-tasty-dish-cook-eat-fried-seafood-fry-spicy-recipe-941524618184u09tn.png",
    price: 2.50,
    discount: "New",
    inCart: false,
    category: "Food",
    ingredients: [
      allAvailableIngredients[0],
      allAvailableIngredients[1],
      allAvailableIngredients[4],
      allAvailableIngredients[5],
      allAvailableIngredients[3],
      allAvailableIngredients[2],
    ],
  ),
  Product(
    id: 8,
    title: "KFC Bucket",
    subtitle: "Crispy Chicken",
    image: "https://pngimg.com/uploads/kfc_food/kfc_food_PNG21.png",
    price: 15.99,
    discount: "-25%",
    inCart: false,
    category: "Food",
    ingredients: [
      allAvailableIngredients[0],
      allAvailableIngredients[1],
      allAvailableIngredients[4],
      allAvailableIngredients[5],
      allAvailableIngredients[3],
      allAvailableIngredients[2],
    ],
  ),
  Product(
    id: 9,
    title: "Zinger Burger",
    subtitle: "Spicy & Fresh",
    image:
        "https://pngimg.com/uploads/burger_sandwich/burger_sandwich_PNG4135.png",
    price: 9.50,
    discount: "-10%",
    inCart: false,
    category: "Food",
    ingredients: [
      allAvailableIngredients[0],
      allAvailableIngredients[1],
      allAvailableIngredients[4],
      allAvailableIngredients[5],
      allAvailableIngredients[3],
      allAvailableIngredients[2],
    ],
  ),
];

final List<Map<String, String>> categoryData = [
  {"title": "Fruits", "image": "https://pngimg.com/d/mango_PNG9173.png"},
  {"title": "Drinks", "image": "https://pngimg.com/d/cocktail_PNG62.png"},
  {"title": "All", "image": "https://pngimg.com/d/burger_sandwich_PNG4135.png"},
  {"title": "Snack", "image": "https://pngimg.com/d/potato_chips_PNG45.png"},
  {"title": "Food", "image": "https://pngimg.com/d/pizza_PNG44077.png"},
];
