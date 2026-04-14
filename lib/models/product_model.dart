import 'package:flutter/material.dart';

class Product {
  final int id;
  final String title;
  final String subtitle;
  final String image;
  final double price;
  final String discount;
  bool inCart;
  final String category;
  int quantity;
  bool isFavorite;

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
  });
}

// Highly reliable Vecteezy fully-transparent preview URLs matching mockup perfectly
List<Product> newDemoProducts = [
  Product(
    id: 1,
    title: "Noodles Twistara",
    subtitle: "With Spicy Sauce",
    image: "https://pngimg.com/d/noodle_PNG38.png",
    price: 5.33,
    discount: "-25%",
    inCart: false,
    category: "Food",
  ),
  Product(
    id: 2,
    title: "Pizza Sicilia",
    subtitle: "Pizza Sicilia",
    image: "https://pngimg.com/d/pizza_PNG44077.png",
    price: 8.99,
    discount: "-25%",
    inCart: true,
    category: "Food",
  ),
  Product(
    id: 3,
    title: "Classic Cheese Burger",
    subtitle: "Beef Combo",
    image: "https://pngimg.com/d/burger_sandwich_PNG4135.png",
    price: 12.50,
    discount: "-10%",
    inCart: false,
    category: "Food",
  ),
  Product(
    id: 4,
    title: "Spicy Kebab",
    subtitle: "Chicken Roast",
    image: "https://pngimg.com/d/kebab_PNG44.png",
    price: 14.10,
    discount: "-15%",
    inCart: false,
    category: "Food",
  ),
  Product(
    id: 5,
    title: "Chiken Shorma",
    subtitle: "Organic Fruit",
    image: "https://www.pngmart.com/files/23/Food-PNG-Isolated-HD.png",
    price: 3.50,
    discount: "-10%",
    inCart: false,
    category: "Food",
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
  ),
];

final List<Map<String, String>> categoryData = [
  {"title": "Fruits", "image": "https://pngimg.com/d/mango_PNG9173.png"},
  {"title": "Drinks", "image": "https://pngimg.com/d/cocktail_PNG62.png"},
  {"title": "All", "image": "https://pngimg.com/d/burger_sandwich_PNG4135.png"},
  {"title": "Snack", "image": "https://pngimg.com/d/potato_chips_PNG45.png"},
  {"title": "Food", "image": "https://pngimg.com/d/pizza_PNG44077.png"},
];
