import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'home_screen.dart'; // To access the Product model. Ideally Product should be in a separate models file.
import 'cart_screen.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;
  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Huge Top Red Curve Drop
          Positioned(
            top: -MediaQuery.of(context).size.width,
            left: -MediaQuery.of(context).size.width * 0.2,
            right: -MediaQuery.of(context).size.width * 0.2,
            child: Container(
              height: MediaQuery.of(context).size.width * 2,
              decoration: const BoxDecoration(
                color: Color(0xFFFF5D5D), // Match the coral red color from the mockup
                shape: BoxShape.circle,
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                // Custom Top App Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                        ),
                      ),
                      const Text(
                        "Pizza Party",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 26),
                    ],
                  ),
                ),
                
                const SizedBox(height: 10),
                
                // Huge Center Product Image with underlying cream blob drop shadow
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Cream Blob Design Element beneath pizza
                    Positioned(
                      bottom: 20,
                      child: Container(
                        width: 250,
                        height: 150,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFBE4D2),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(80),
                            topRight: Radius.circular(150),
                            bottomLeft: Radius.circular(150),
                            bottomRight: Radius.circular(80),
                          ),
                        ),
                      ),
                    ),
                    // Drop shadow container for image (assuming image is completely transparent PNG)
                    Container(
                      width: 280,
                      height: 280,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 20,
                            offset: const Offset(0, 15),
                          )
                        ]
                      ),
                      child: Image.network(product.image, fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.fastfood, size: 100, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Dynamic Title from Product
                Text(
                  product.title.split(" ").first, // Match the concise layout (or use product.title)
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF4A4A4A),
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Price row
                RichText(
                  text: TextSpan(
                    text: 'Large | ',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                    children: [
                      TextSpan(
                        text: '\$${(product.price * (product.quantity > 0 ? product.quantity : 1)).toStringAsFixed(2)}', // dynamically multiplies from global Product state
                        style: const TextStyle(color: Color(0xFF4A4A4A), fontSize: 24, fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Description (could also be dynamic, leaving static matched to mocked image for now)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    "Tomato, Mozzarella, Green basil, Olives,\nBell pepper",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14, height: 1.5),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Add to cart button
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const CartScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF5D5D),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                    shadowColor: const Color(0xFFFF5D5D).withOpacity(0.5),
                  ),
                  child: const Text(
                    "Add to cart",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                
                const Spacer(),
              ],
            ),
          ),
          
          // Bottom Wheel Decor & Carousel Overlay
          Positioned(
            bottom: -MediaQuery.of(context).size.width * 1.5,
            left: -MediaQuery.of(context).size.width * 0.5,
            right: -MediaQuery.of(context).size.width * 0.5,
            child: SizedBox(
               height: MediaQuery.of(context).size.width * 2,
               child: Stack(
                 alignment: Alignment.topCenter,
                 children: [
                   // The bottom thick red circular arc acting as wheel background
                   Container(
                     decoration: const BoxDecoration(
                       color: Color(0xFFFF5D5D),
                       shape: BoxShape.circle,
                     ),
                   ),
                    
                   // The dotted wheel boundary acting as carousel rail
                   Positioned(
                     top: 40, // push it down slightly
                     child: Container(
                       width: MediaQuery.of(context).size.width * 0.8,
                       height: MediaQuery.of(context).size.width * 0.8,
                       decoration: BoxDecoration(
                         shape: BoxShape.circle,
                         border: Border.all(color: Colors.white.withOpacity(0.4), width: 3), 
                       ),
                     ),
                   ),
                   // Red selector needle/pointer
                   const Positioned(
                      top: 15,
                      child: Icon(Icons.arrow_drop_up_rounded, color: Colors.white, size: 60),
                   )
                 ]
               )
            ),
          ),

          // Wheel Pizza Cards Floating Elements
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 130, // Contain the rotating cards properly
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  // Left Fanning Card
                  Positioned(
                    left: 20,
                    bottom: -20,
                    child: Transform.rotate(
                      angle: -0.3,
                      child: const SmallPizzaCard(title: "Chicken", image: "https://pngimg.com/d/pizza_PNG44077.png"),
                    ),
                  ),
                  // Center Focus Card
                  Positioned(
                    bottom: 25, 
                    child: Transform.scale(
                      scale: 1.15,
                      child: SmallPizzaCard(
                        title: product.title.split(" ").first, 
                        image: product.image,
                      ),
                    ),
                  ),
                  // Right Fanning Card
                  Positioned(
                    right: 20,
                    bottom: -20,
                    child: Transform.rotate(
                      angle: 0.3,
                      child: const SmallPizzaCard(title: "Tomato", image: "https://pngimg.com/d/pizza_PNG44077.png"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SmallPizzaCard extends StatelessWidget {
  final String title;
  final String image;
  const SmallPizzaCard({super.key, required this.title, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 2),
              child: Image.network(image, fit: BoxFit.contain, errorBuilder: (c,e,s) => const Icon(Icons.fastfood, color: Colors.grey)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black87),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
