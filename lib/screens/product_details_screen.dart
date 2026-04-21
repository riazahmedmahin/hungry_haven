import 'package:flutter/material.dart';
import 'dart:math' as math;
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
              height: 350,
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
                        width: 280,
                        height: 280,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                      ),
                      Image.network(
                        product.image,
                        width: 300,
                        height: 300,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.fastfood,
                          size: 100,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  //const SizedBox(height: 10),
                  Text(
                    product.title,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1F1F1F),
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

                  const SizedBox(height: 15),

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

                  const SizedBox(height: 15),

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
                        _buildQtyBtn(
                          Icons.add,
                          () {
                            if (localQuantity < product.stock) {
                              setState(() => localQuantity++);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Only ${product.stock} items left in stock.")));
                              adminNotifications.insert(0, "User attempted to order more ${product.title} than the available stock (${product.stock}).");
                            }
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Ingredients",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),
                  const IngredientShowcase(),

                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),

          // Bottom Bar
          Positioned(
            left: 20,
            right: 20,
            bottom: 25,
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
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFD32F2F) : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Text(
          size,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade600,
            fontWeight: FontWeight.bold,
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
  const IngredientShowcase({super.key});

  @override
  State<IngredientShowcase> createState() => _IngredientShowcaseState();
}

class _IngredientShowcaseState extends State<IngredientShowcase> {
  final List<Map<String, dynamic>> ingredients = [
    {
      "title": "Onions",
      "image": "https://pngimg.com/d/onion_PNG3821.png",
      "color": Color(0xFFE0C097),
      "glow": Color(0xFFD32F2F).withOpacity(0.3),
      "gradient": [Color(0xFFE0C097), Color(0xFFB88E5E)],
    },
    {
      "title": "Tomato",
      "image": "https://pngimg.com/d/tomato_PNG12590.png",
      "color": Color(0xFFFF5252),
      "glow": Color(0xFFFF5252).withOpacity(0.4),
      "gradient": [Color(0xFFFF8A80), Color(0xFFD32F2F)],
    },
    {
      "title": "Cheese",
      "image": "https://pngimg.com/d/cheese_PNG25298.png",
      "color": Color(0xFFFFCA28),
      "glow": Color(0xFFFFB300).withOpacity(0.4),
      "gradient": [Color(0xFFFFEE58), Color(0xFFFFCA28)],
    },
    {
      "title": "Basil",
      "image": "https://pngimg.com/d/basil_PNG40.png",
      "color": Color(0xFF66BB6A),
      "glow": Color(0xFF66BB6A).withOpacity(0.4),
      "gradient": [Color(0xFFA5D6A7), Color(0xFF388E3C)],
    },
    {
      "title": "Pickles",
      "image": "https://pngimg.com/d/cucumber_PNG12608.png",
      "color": Color(0xFF9CCC65),
      "glow": Color(0xFF9CCC65).withOpacity(0.4),
      "gradient": [Color(0xFFC5E1A5), Color(0xFF689F38)],
    },
    {
      "title": "Pepper",
      "image": "https://pngimg.com/d/pepper_PNG4124.png",
      "color": Color(0xFFEF5350),
      "glow": Color(0xFFEF5350).withOpacity(0.4),
      "gradient": [Color(0xFFFF8A80), Color(0xFFC62828)],
    },
  ];

  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController(initialScrollOffset: 2 * 90.0);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: AnimatedBuilder(
        animation: _scrollController,
        builder: (context, child) {
          double offset = _scrollController.hasClients
              ? _scrollController.offset
              : 2 * 90.0;
          return ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 2 - 45,
            ),
            itemCount: ingredients.length,
            itemBuilder: (context, index) {
              double itemPosition = index * 90.0;
              double distance = (offset - itemPosition).abs();
              double scale = (1.0 - (distance / 250).clamp(0.0, 0.4));
              double shift = math.pow((distance / 80), 2) * 20;
              if (shift > 60) shift = 60;
              bool isFocused = distance < 45;

              return GestureDetector(
                onTap: () {
                  _scrollController.animateTo(
                    itemPosition,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOutBack,
                  );
                },
                child: Transform.translate(
                  offset: Offset(0, shift),
                  child: Transform.scale(
                    scale: scale,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: _buildMeltyItem(ingredients[index], isFocused),
                    ),
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
      children: [
        Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none, // Ensure drips are not clipped
          children: [
            // Organic Teardrop Effect (The 'Jul Jule' part)
            if (isFocused) ...[
              // Primary Organic Drop
              Positioned(
                bottom: -15,
                child: CustomPaint(
                  size: const Size(25, 40),
                  painter: TeardropPainter(
                    color: (data['gradient'] as List<Color>)[1],
                  ),
                ),
              ),
              // Secondary Small Organic Drop
              Positioned(
                bottom: 5,
                right: 15,
                child: CustomPaint(
                  size: const Size(12, 25),
                  painter: TeardropPainter(
                    color: (data['gradient'] as List<Color>)[1].withOpacity(
                      0.7,
                    ),
                  ),
                ),
              ),
            ],
            // Background Circle
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: isFocused ? 95 : 70,
              height: isFocused ? 95 : 70,
              decoration: BoxDecoration(
                color: isFocused ? null : Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: isFocused
                        ? data['glow']
                        : Colors.black.withOpacity(0.05),
                    blurRadius: isFocused ? 25 : 10,
                    spreadRadius: isFocused ? 2 : 0,
                  ),
                ],
                gradient: isFocused
                    ? RadialGradient(colors: data['gradient'])
                    : null,
              ),
            ),
            // Content
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.network(
                  data['image'],
                  width: isFocused ? 45 : 35,
                  height: isFocused ? 45 : 35,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.restaurant, size: 20),
                ),
                if (isFocused)
                  Text(
                    data['title'],
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                      color: data['color'].computeLuminance() > 0.5
                          ? Colors.black87
                          : Colors.white,
                    ),
                  ),
              ],
            ),
          ],
        ),
        if (!isFocused) ...[
          const SizedBox(height: 8),
          Text(
            data['title'],
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ],
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
    // Start at top center
    path.moveTo(size.width / 2, 0);
    // Left side curve to bottom center
    path.cubicTo(
      0,
      size.height * 0.4,
      0,
      size.height,
      size.width / 2,
      size.height,
    );
    // Right side curve back to top center
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
