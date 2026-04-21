import 'package:flutter/material.dart';
import 'package:hungry_haven/models/product_model.dart';
import 'package:hungry_haven/screens/home_screen.dart';
import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Accessing the unified global list
  List<Product> get cartItems =>
      newDemoProducts.where((p) => p.quantity > 0 || p.inCart).toList();

  double get totalBill {
    return cartItems.fold(
      0,
      (sum, item) =>
          sum + (item.price * (item.quantity > 0 ? item.quantity : 1)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Cart",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: cartItems.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Your cart is empty",
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.only(top: 20, bottom: 40),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final product = cartItems[index];
                return Dismissible(
                  key: Key(product.id.toString()),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (direction) {
                    setState(() {
                      product.quantity = 0;
                      product.inCart = false;
                    });
                  },
                  background: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: const BoxDecoration(
                      color: Color(0xFFC7C6EE),
                      borderRadius: BorderRadius.horizontal(
                        right: Radius.circular(20),
                      ),
                    ),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 30),
                    child: const Icon(
                      Icons.delete_outline,
                      color: Colors.black87,
                      size: 30,
                    ),
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: 20,
                    ),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Image.network(
                              product.image,
                              width: 80,
                              height: 80,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                    Icons.fastfood,
                                    color: Colors.grey,
                                    size: 50,
                                  ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3F3F3),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (product.quantity > 1) {
                                        setState(() => product.quantity--);
                                      } else if (product.quantity == 1) {
                                        // Optional: remove if quantity goes below 1
                                        setState(() {
                                          product.quantity = 0;
                                          product.inCart = false;
                                        });
                                      }
                                    },
                                    child: const Icon(
                                      Icons.remove,
                                      size: 16,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Text(
                                    '${product.quantity == 0 ? 1 : product.quantity}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  GestureDetector(
                                    onTap: () {
                                      if (product.quantity < product.stock) {
                                        setState(() => product.quantity++);
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Only ${product.stock} items left in stock.")));
                                        adminNotifications.insert(0, "User attempted to order more ${product.title} than the available stock (${product.stock}).");
                                      }
                                    },
                                    child: const Icon(
                                      Icons.add,
                                      size: 16,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                product.subtitle,
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 12,
                                  height: 1.4,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                '৳${(product.price * (product.quantity > 0 ? product.quantity : 1)).toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 18,
                                  color: Color(0xFF3B2D50),
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Row(
                                children: [
                                  Icon(
                                    Icons.check_box,
                                    size: 16,
                                    color: Colors.black87,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "Ready for Checkout",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
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
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 15,
          left: 30,
          right: 30,
          top: 15,
        ),
        decoration: const BoxDecoration(
          color: Color(0xFF0D63F3),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
                const Text(
                  "Total Bill",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text(
                  "৳${totalBill.toStringAsFixed(2)}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                if (cartItems.isEmpty) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CheckoutScreen(totalAmount: totalBill),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Place Order",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
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
