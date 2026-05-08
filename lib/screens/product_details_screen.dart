import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:math' as math;
import 'package:cached_network_image/cached_network_image.dart';
import '../models/product_model.dart';
import 'cart_screen.dart';
import 'checkout_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;
  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int localQuantity = 1;
  String selectedSize = "Medium";

  @override
  void initState() {
    super.initState();
    // If product is already in cart, use its current quantity
    if (widget.product.quantity > 0) {
      localQuantity = widget.product.quantity;
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F7),
      body: Stack(
        children: [
          // Simplified Clipper for better performance
          ClipPath(
            clipper: SimpleHeaderClipper(),
            child: Container(
              height:
                  MediaQuery.of(context).size.height * 0.33, // Reduced from 0.4
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 214, 106, 106),
                    Color(0xFFD32F2F),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // App Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildRoundButton(
                          icon: Icons.arrow_back_ios_new,
                          onTap: () => Navigator.pop(context),
                        ),
                        const Text(
                          "Details",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        _buildRoundButton(
                          icon: Icons.shopping_cart_outlined,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CartScreen(),
                              ),
                            ).then((_) => setState(() {}));
                          },
                        ),
                      ],
                    ),
                  ),

                  // Image Section
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.55,
                        height: MediaQuery.of(context).size.width * 0.55,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 25,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                      ),
                      product.image.startsWith('http')
                          ? Image.network(
                              product.image,
                              width: MediaQuery.of(context).size.width * 0.62,
                              height: MediaQuery.of(context).size.width * 0.62,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.fastfood,
                                size: 80,
                                color: Colors.white,
                              ),
                            )
                          : Image.file(
                              File(product.image),
                              width: MediaQuery.of(context).size.width * 0.62,
                              height: MediaQuery.of(context).size.width * 0.62,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.fastfood,
                                size: 80,
                                color: Colors.white,
                              ),
                            ),
                    ],
                  ),

                  //const SizedBox(height: 10),
                  Text(
                    product.title,
                    style: TextStyle(
                      fontSize:
                          MediaQuery.of(context).size.width *
                          0.065, // Slightly reduced
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF1F1F1F),
                    ),
                  ),

                  const SizedBox(height: 5),

                  // Stats Row
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 50),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStat(Icons.star, "4.8", Colors.amber),
                        _buildStat(
                          Icons.local_fire_department,
                          "450 kcal",
                          Colors.orange,
                        ),
                        _buildStat(
                          Icons.access_time_filled,
                          "20 min",
                          Colors.blue,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8), // Reduced from 15

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSizeOption("Regular"),
                      const SizedBox(width: 15),
                      _buildSizeOption("Medium"),
                      const SizedBox(width: 15),
                      _buildSizeOption("Large"),
                    ],
                  ),

                  const SizedBox(height: 8), // Reduced from 15
                  // Quantity Selector
                  Container(
                    width: 140,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildQtyBtn(Icons.remove, () {
                          if (localQuantity > 1)
                            setState(() => localQuantity--);
                        }),
                        Text(
                          '$localQuantity',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        _buildQtyBtn(Icons.add, () {
                          if (localQuantity < product.stock) {
                            setState(() => localQuantity++);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Only ${product.stock} items left in stock.",
                                ),
                              ),
                            );
                            adminNotifications.insert(
                              0,
                              "User attempted to order more ${product.title} than the available stock (${product.stock}).",
                            );
                          }
                        }),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12), // Reduced from 20

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Ingredients",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10), // Reduced from 15
                  IngredientShowcase(ingredients: widget.product.ingredients),

                  SizedBox(height: MediaQuery.of(context).padding.bottom + 110),
                ],
              ),
            ),
          ),

          // Bottom Bar
          Positioned(
            left: 20,
            right: 20,
            bottom: 10,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(35),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Total Price",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      Text(
                        "৳${(product.price * localQuantity).toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        widget.product.quantity = localQuantity;
                        widget.product.inCart = true;
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckoutScreen(
                            totalAmount: product.price * localQuantity,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 15,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF8B1212), Color(0xFFE53935)],
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.shopping_bag_outlined,
                            color: Colors.white,
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Order Now",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildRoundButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildStat(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 14),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildSizeOption(String size) {
    bool isSelected = selectedSize == size;
    return GestureDetector(
      onTap: () => setState(() => selectedSize = size),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFD32F2F) : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Text(
          size,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildQtyBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18),
      ),
    );
  }
}

class SimpleHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 80);
    var controlPoint = Offset(size.width / 2, size.height);
    var endPoint = Offset(size.width, size.height - 80);
    path.quadraticBezierTo(
      controlPoint.dx,
      controlPoint.dy,
      endPoint.dx,
      endPoint.dy,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class IngredientShowcase extends StatefulWidget {
  final List<Map<String, dynamic>> ingredients;
  const IngredientShowcase({super.key, required this.ingredients});

  @override
  State<IngredientShowcase> createState() => _IngredientShowcaseState();
}

class _IngredientShowcaseState extends State<IngredientShowcase> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    // Start at the middle item if available
    int initialPage =
        widget.ingredients.isNotEmpty ? (widget.ingredients.length / 2).floor() : 0;
    _pageController = PageController(
      viewportFraction: 0.22, // Reduced from 0.28 to bring items closer
      initialPage: initialPage,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.ingredients.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Text(
          "Ingredients info not available.",
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
      );
    }

    return SizedBox(
      height: 180,
      child: AnimatedBuilder(
        animation: _pageController,
        builder: (context, child) {
          return PageView.builder(
            controller: _pageController,
            clipBehavior: Clip.none,
            itemCount: widget.ingredients.length,
            itemBuilder: (context, index) {
              double pageOffset = 0.0;
              if (_pageController.position.haveDimensions) {
                pageOffset = _pageController.page! - index;
              } else {
                // Handle initial state before first frame
                pageOffset = (_pageController.initialPage - index).toDouble();
              }

              double distance = pageOffset.abs();

              // Scaling and shifting based on page distance
              double scale = (1.0 - (distance * 0.35).clamp(0.0, 0.45));
              double shift = math.pow(distance, 2) * 45;
              if (shift > 80) shift = 80;

              bool isFocused = distance < 0.5;

              return GestureDetector(
                onTap: () {
                  _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOutBack,
                  );
                },
                child: Transform.translate(
                  offset: Offset(0, shift),
                  child: Transform.scale(
                    scale: scale,
                    child: _buildMeltyItem(widget.ingredients[index], isFocused),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildMeltyItem(Map<String, dynamic> data, bool isFocused) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            if (isFocused) ...[
              Positioned(
                bottom: -25,
                child: CustomPaint(
                  size: const Size(45, 70),
                  painter: TeardropPainter(color: data['color']),
                ),
              ),
            ],
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: isFocused ? 100 : 75,
              height: isFocused ? 100 : 75,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: data['gradient'] as List<Color>,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: (data['glow'] as Color)
                        .withOpacity(isFocused ? 0.45 : 0.15),
                    blurRadius: isFocused ? 25 : 10,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Center(
                child: CachedNetworkImage(
                  imageUrl: data['image'],
                  width: isFocused ? 55 : 40,
                  height: isFocused ? 55 : 40,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          data['title'],
          style: TextStyle(
            fontSize: 11,
            fontWeight: isFocused ? FontWeight.bold : FontWeight.w500,
            color: isFocused ? Colors.black87 : Colors.grey.shade500,
          ),
        ),
      ],
    );
  }
}

class TeardropPainter extends CustomPainter {
  final Color color;
  TeardropPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..shader = LinearGradient(
        colors: [color, color.withOpacity(0)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    var path = Path();
    path.moveTo(size.width / 2, 0);
    path.cubicTo(
      0,
      size.height * 0.4,
      0,
      size.height,
      size.width / 2,
      size.height,
    );
    path.cubicTo(
      size.width,
      size.height,
      size.width,
      size.height * 0.4,
      size.width / 2,
      0,
    );
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
