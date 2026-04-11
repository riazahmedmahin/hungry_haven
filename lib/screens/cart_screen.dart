import 'package:flutter/material.dart';
import 'checkout_screen.dart';

class CartItemModel {
  final String id;
  final String title;
  final String subtitle;
  final String image;
  final double price;
  int quantity;
  bool extraTopping;

  CartItemModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.price,
    this.quantity = 1,
    this.extraTopping = false,
  });
}

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Prepopulating to exactly match the provided visual mockup text and products!
  List<CartItemModel> cartItems = [
    CartItemModel(
      id: "1",
      title: "Margarita",
      subtitle: "Large | Cheese, onion, and tomato pure",
      image: "https://pngimg.com/d/pizza_PNG44077.png",
      price: 57.0,
      quantity: 1,
    ),
    CartItemModel(
      id: "2",
      title: "Burger",
      subtitle: "Large | Fresh tomatos, Basil & green herbs",
      image: "https://pngimg.com/d/burger_sandwich_PNG4135.png",
      price: 57.0,
      quantity: 2,
    ),
    CartItemModel(
      id: "3",
      title: "Neapolitan",
      subtitle: "Ramen,noodles with soft boiled egg, shrimp, snow peas.",
      image: "https://pngimg.com/d/noodle_PNG38.png",
      price: 57.0,
      quantity: 1,
    ),
    CartItemModel(
      id: "4",
      title: "Farmhouse",
      subtitle: "Medium | Fresh vegetables, Basil & green herbs",
      image: "https://pngimg.com/d/pizza_PNG44077.png",
      price: 57.0,
      quantity: 1,
    )
  ];

  double get totalBill {
    return cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6), // Slight greyish background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
        ),
        title: const Text(
          "Cart",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
      body: cartItems.isEmpty
          ? const Center(child: Text("Your cart is empty", style: TextStyle(color: Colors.grey, fontSize: 18)))
          : ListView.builder(
              padding: const EdgeInsets.only(top: 20, bottom: 40),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Dismissible(
                  key: Key(item.id),
                  direction: DismissDirection.startToEnd, // Slide left to right to delete
                  onDismissed: (direction) {
                    setState(() {
                      cartItems.removeAt(index);
                    });
                  },
                  // The light purple delete underlay matching the design!
                  background: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: const BoxDecoration(
                      color: Color(0xFFC7C6EE), // Perfectly matching light purple
                      borderRadius: BorderRadius.horizontal(right: Radius.circular(20)), // rounds on the right
                    ),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 30),
                    child: const Icon(Icons.delete_outline, color: Colors.black87, size: 30),
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        )
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left Side (Image & Quantity Pill)
                        Column(
                          children: [
                            Image.network(
                              item.image,
                              width: 80,
                              height: 80,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => const Icon(Icons.fastfood, color: Colors.grey, size: 50),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3F3F3), // Light grey pill
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (item.quantity > 1) {
                                        setState(() => item.quantity--);
                                      }
                                    },
                                    child: const Icon(Icons.remove, size: 16, color: Colors.black54),
                                  ),
                                  const SizedBox(width: 14),
                                  Text(
                                    '${item.quantity}',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  const SizedBox(width: 14),
                                  GestureDetector(
                                    onTap: () => setState(() => item.quantity++),
                                    child: const Icon(Icons.add, size: 16, color: Colors.black54), // Faded slightly like the mock
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(width: 16),
                        
                        // Right Side (Details)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                item.subtitle,
                                style: TextStyle(color: Colors.grey.shade500, fontSize: 12, height: 1.4),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 12),
                              // Price 
                              Text(
                                '\$${(item.price * item.quantity).toInt()}', // Calculated total for this specific item
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900, 
                                  fontSize: 18, 
                                  color: Color(0xFF3B2D50), // Subtle purple/dark tint seen in mock
                                ),
                              ),
                              const SizedBox(height: 12),
                              // Checkbox
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => setState(() => item.extraTopping = !item.extraTopping),
                                    child: Container(
                                      width: 16,
                                      height: 16,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey.shade400, width: 1.5),
                                        borderRadius: BorderRadius.circular(4),
                                        color: item.extraTopping ? Colors.black87 : Colors.transparent,
                                      ),
                                      child: item.extraTopping ? const Icon(Icons.check, size: 12, color: Colors.white) : null,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    "Add Extra Topping",
                                    style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            
      // Bottom Blue Sticky Bar
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 15,
          left: 30,
          right: 30,
          top: 15,
        ),
        decoration: const BoxDecoration(
          color: Color(0xFF0D63F3), // Bright vibrant blue from the design
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)), // optional slight rounding
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Total Bill", style: TextStyle(color: Colors.white70, fontSize: 14)),
                const SizedBox(height: 2),
                Text(
                  "\$${totalBill.toInt()}",
                  style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CheckoutScreen(totalAmount: totalBill),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                elevation: 0,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text("Place Order", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
