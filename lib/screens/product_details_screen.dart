import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'home_screen.dart'; // To access the Product model. Ideally Product should be in a separate models file.
import 'cart_screen.dart';
import 'checkout_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;
  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  String selectedSize = "Medium";

  @override
  void initState() {
    super.initState();
    if (widget.product.quantity == 0) {
      widget.product.quantity = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _buildBottomBar(product),
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
                color: Color(0xFFFF5D5D),
                shape: BoxShape.circle,
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // Custom Top App Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
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
                            child: const Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                              size: 20,
                            ),
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
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CartScreen(),
                              ),
                            ).then((_) => setState(() {}));
                          },
                          child: const Icon(
                            Icons.shopping_cart_outlined,
                            color: Colors.white,
                            size: 26,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 35,
                  ), // Increased to clear the red top circle
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
                        width: 300, // Restored to original big size
                        height: 300,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.12),
                              blurRadius: 25,
                              offset: const Offset(0, 15),
                            ),
                          ],
                        ),
                        child: Image.network(
                          product.image,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                                Icons.fastfood,
                                size: 100,
                                color: Colors.white,
                              ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Dynamic Title from Product
                  Text(
                    product.title,
                    style: const TextStyle(
                      fontSize: 30, // Slightly increased
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF4A4A4A),
                    ),
                  ),

                  const SizedBox(height: 5),

                  const SizedBox(height: 10),

                  // Extra Food Details
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildInfoChip(Icons.star, "4.8", Colors.amber),
                      const SizedBox(width: 16),
                      _buildInfoChip(
                        Icons.local_fire_department,
                        "450 kcal",
                        Colors.redAccent,
                      ),
                      const SizedBox(width: 16),
                      _buildInfoChip(
                        Icons.access_time_filled,
                        "20 min",
                        Colors.blueAccent,
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Size Selector
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
                    height: 45,
                    width: 130,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove, size: 20),
                          onPressed: () {
                            if (product.quantity > 1) {
                              setState(() => product.quantity--);
                            }
                          },
                        ),
                        Text(
                          '${product.quantity}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add, size: 20),
                          onPressed: () => setState(() => product.quantity++),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  //const SizedBox(height: 25),

                  // Ingredients Arc Scroll List (Moved IDLE into the Column to prevent overlap)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 12, bottom: 0),
                        child: Text(
                          "Ingredients",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4A4A4A),
                          ),
                        ),
                      ),
                      IngredientArcScrollable(
                        ingredients: [
                          {
                            "title": "Chicken",
                            "image": "https://pngimg.com/d/pizza_PNG44077.png",
                          },
                          {
                            "title": "Tomato",
                            "image": "https://pngimg.com/d/pizza_PNG44077.png",
                          },
                          {
                            "title": "Cheese",
                            "image":
                                "https://pngimg.com/d/burger_sandwich_PNG4135.png",
                          },
                          {
                            "title": "Basil",
                            "image": "https://pngimg.com/d/noodle_PNG38.png",
                          },
                          {
                            "title": "Olive",
                            "image":
                                "https://pngimg.com/d/potato_chips_PNG45.png",
                          },
                          {
                            "title": "Onion",
                            "image":
                                "https://pngimg.com/d/burger_sandwich_PNG4135.png",
                          },
                          {
                            "title": "Pepper",
                            "image": "https://pngimg.com/d/pizza_PNG44077.png",
                          },
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(Product product) {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(35),
          topRight: Radius.circular(35),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Total Price",
                style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
              ),
              RichText(
                text: TextSpan(
                  text: '\$',
                  style: const TextStyle(
                    color: Color(0xFFFF5D5D),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text:
                          (product.price *
                                  (product.quantity > 0 ? product.quantity : 1))
                              .toStringAsFixed(2),
                      style: const TextStyle(
                        color: Color(0xFF2D2D2D),
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CheckoutScreen(
                    totalAmount:
                        product.price *
                        (product.quantity > 0 ? product.quantity : 1),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF5D5D),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 8,
              shadowColor: const Color(0xFFFF5D5D).withOpacity(0.4),
            ),
            child: const Row(
              children: [
                Icon(Icons.shopping_bag_outlined, size: 20),
                SizedBox(width: 8),
                Text(
                  "Order Now",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSizeOption(String size) {
    bool isSelected = selectedSize == size;
    return GestureDetector(
      onTap: () => setState(() => selectedSize = size),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF5D5D) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: const Color(0xFFFF5D5D).withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              )
            else
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
          ],
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
}

class IngredientArcScrollable extends StatefulWidget {
  final List<Map<String, String>> ingredients;
  const IngredientArcScrollable({super.key, required this.ingredients});

  @override
  State<IngredientArcScrollable> createState() =>
      _IngredientArcScrollableState();
}

class _IngredientArcScrollableState extends State<IngredientArcScrollable> {
  late ScrollController _scrollController;
  final double itemWidth = 80.0;
  int selectedIndex = 2; // Default focus

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController(
      initialScrollOffset: selectedIndex * itemWidth,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: AnimatedBuilder(
        animation: _scrollController,
        builder: (context, child) {
          double offset = 0;
          if (_scrollController.hasClients) {
            offset = _scrollController.offset;
          } else {
            offset = selectedIndex * itemWidth;
          }

          return ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal:
                  MediaQuery.of(context).size.width / 2 - (itemWidth / 2),
            ),
            itemCount: widget.ingredients.length,
            itemBuilder: (context, index) {
              double myCenter = index * itemWidth;
              double distance = (offset - myCenter).abs();

              // Arc effect logic: items sink as they move away from the center
              // Using a smoother power function for a deeper arc
              double shift = math.pow((distance / 100), 2) * 40;
              if (shift > 100) shift = 100;

              // Scale effect: center items are slightly larger
              double scale = 1.0 - (distance / 400).clamp(0.0, 0.3);

              // Opacity effect
              double opacity = 1.0 - (distance / 300).clamp(0.0, 0.6);

              return GestureDetector(
                onTap: () {
                  setState(() => selectedIndex = index);
                  _scrollController.animateTo(
                    myCenter,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOutBack,
                  );
                },
                child: Transform.translate(
                  offset: Offset(0, shift),
                  child: Transform.scale(
                    scale: scale,
                    child: Opacity(
                      opacity: opacity,
                      child: SizedBox(
                        width: itemWidth,
                        child: SmallPizzaCard(
                          title: widget.ingredients[index]["title"]!,
                          image: widget.ingredients[index]["image"]!,
                          isActive: selectedIndex == index,
                        ),
                      ),
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
}

class SmallPizzaCard extends StatelessWidget {
  final String title;
  final String image;
  final bool isActive;
  const SmallPizzaCard({
    super.key,
    required this.title,
    required this.image,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 65,
          height: 65,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFFFF5D5D) : Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: isActive
                    ? const Color(0xFFFF5D5D).withOpacity(0.3)
                    : Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
            border: Border.all(
              color: isActive ? Colors.transparent : Colors.grey.shade100,
              width: 1,
            ),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontWeight: isActive ? FontWeight.w900 : FontWeight.w600,
              fontSize: 12,
              color: isActive ? Colors.white : const Color(0xFF4A4A4A),
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (isActive)
          Container(
            margin: const EdgeInsets.only(top: 5),
            width: 5,
            height: 5,
            decoration: const BoxDecoration(
              color: Color(0xFFFF5D5D),
              shape: BoxShape.circle,
            ),
          ),
      ],
    );
  }
}
