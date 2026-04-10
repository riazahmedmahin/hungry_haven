import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'product_details_screen.dart';

final List<Map<String, String>> categoryData = [
  {"title": "Fruits", "image": "https://pngimg.com/d/mango_PNG9173.png"},
  {"title": "Drinks", "image": "https://pngimg.com/d/cocktail_PNG62.png"},
  {"title": "All", "image": "https://pngimg.com/d/burger_sandwich_PNG4135.png"},
  {"title": "Snack", "image": "https://pngimg.com/d/potato_chips_PNG45.png"},
  {"title": "Food", "image": "https://pngimg.com/d/pizza_PNG44077.png"},
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedCategoryIndex = 2; // Default to 'All'

  @override
  Widget build(BuildContext context) {
    String currentCategoryStr = categoryData[selectedCategoryIndex]["title"]!;

    // Filter products dynamically based on category
    List<Product> displayedProducts = newDemoProducts.where((p) {
      if (currentCategoryStr == "All") return true;
      return p.category == currentCategoryStr;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TopBar(),
              const SizedBox(height: 24),
              const HeaderText(),
              const SizedBox(height: 24),
              const SearchAndFilter(),
              const SizedBox(height: 30),
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Catagory"),
                  ),
                  // Circular huge curved background simulating the ellipse backdrop
                  Positioned(
                    top: 40,
                    left: -150,
                    right: -150,
                    bottom: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFFF9F9F9),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.elliptical(800, 250),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      CategoryArcScrollable(
                        selectedIndex: selectedCategoryIndex,
                        onCategoryChanged: (index) {
                          setState(() {
                            selectedCategoryIndex = index;
                          });
                        },
                      ),
                      const SizedBox(height: 0),
                      PopularFoodGrid(products: displayedProducts),
                      const SizedBox(height: 40),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hi!Jhon",
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Text(
                  "11/2 Agrabad,Chittagong",
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const Icon(
              Icons.notifications_none,
              color: Colors.black87,
              size: 22,
            ),
          ),
          const SizedBox(width: 8),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  color: Colors.black87,
                  size: 22,
                ),
              ),
              Positioned(
                top: -2,
                right: -2,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF6A42),
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    "3",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class HeaderText extends StatelessWidget {
  const HeaderText({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: RichText(
        text: const TextSpan(
          text: 'Hungry? ',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: Colors.black,
            letterSpacing: -0.5,
          ),
          children: [
            TextSpan(
              text: 'Order & Eat.',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchAndFilter extends StatelessWidget {
  const SearchAndFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
                border: Border.all(color: Colors.grey.shade100),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search for fast food...",
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 14,
                  ),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(left: 20, right: 12),
                    child: Icon(Icons.search, color: Colors.black45, size: 24),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 18),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            height: 56,
            width: 56,
            decoration: const BoxDecoration(
              color: Color(0xFF1F1F1F),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.tune, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class CategoryArcScrollable extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onCategoryChanged;

  const CategoryArcScrollable({
    super.key,
    required this.selectedIndex,
    required this.onCategoryChanged,
  });

  @override
  State<CategoryArcScrollable> createState() => _CategoryArcScrollableState();
}

class _CategoryArcScrollableState extends State<CategoryArcScrollable> {
  late ScrollController _scrollController;
  final double itemWidth = 95.0;

  @override
  void initState() {
    super.initState();
    // Start with the currently selected item snapped smoothly to the center
    _scrollController = ScrollController(
      initialScrollOffset: widget.selectedIndex * itemWidth,
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
      height: 200,
      child: AnimatedBuilder(
        animation: _scrollController,
        builder: (context, child) {
          double offset = 0;
          if (_scrollController.hasClients) {
            offset = _scrollController.offset;
          } else {
            offset = widget.selectedIndex * itemWidth;
          }

          return ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            // Ensure first and last items can reach exactly the horizontal center
            padding: EdgeInsets.symmetric(
              horizontal:
                  MediaQuery.of(context).size.width / 2 - (itemWidth / 2),
            ),
            itemCount: categoryData.length,
            itemBuilder: (context, index) {
              double myCenter = index * itemWidth;
              // Distance of this item from the active center of the screen
              double distance = (offset - myCenter).abs();

              // Calculate a dynamic arc vertical drop based on distance
              // k * curve^2 creates a stunning smooth arc
              double shift = math.pow((distance / 120), 2) * 25;
              if (shift > 90)
                shift = 90; // Clamp so items don't sink infinitely

              return SizedBox(
                width: itemWidth,
                child: Padding(
                  padding: EdgeInsets.only(top: shift),
                  child: CategoryItem(
                    data: categoryData[index],
                    isActive: widget.selectedIndex == index,
                    onTap: () {
                      widget.onCategoryChanged(index);
                      // Smoothly snap the clicked item to the literal center/peak
                      _scrollController.animateTo(
                        myCenter,
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeOutCubic,
                      );
                    },
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

class CategoryItem extends StatelessWidget {
  final Map<String, String> data;
  final bool isActive;
  final VoidCallback onTap;

  const CategoryItem({
    super.key,
    required this.data,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 70,
            height: 70,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                if (isActive)
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.15),
                    blurRadius: 15,
                    spreadRadius: 2,
                    offset: const Offset(0, 5),
                  ),
              ],
            ),
            child: Image.network(
              data["image"]!,
              fit: BoxFit
                  .contain, // Transparent images perfectly rendered natively
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.local_dining, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            data["title"]!,
            style: TextStyle(
              color: isActive ? Colors.black : Colors.grey.shade500,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 6),
          if (isActive)
            Container(
              width: 20,
              height: 3,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          if (!isActive) const SizedBox(height: 3),
        ],
      ),
    );
  }
}

class PopularFoodGrid extends StatelessWidget {
  final List<Product> products;

  const PopularFoodGrid({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(40.0),
        child: Center(
          child: Text(
            "No items available in this category.",
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 30, // Large spacing for highly overgrown images
          crossAxisSpacing: 20,
          childAspectRatio: 0.60,
        ),
        itemBuilder: (context, index) {
          return ProductCard(product: products[index]);
        },
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailsScreen(product: product)));
      },
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
        // Main Background Card
        Container(
          margin: const EdgeInsets.only(
            top: 80,
          ), // Push the box deeply to allow full image out-of-bounds rendering
          padding: const EdgeInsets.only(
            top: 55,
            left: 16,
            right: 16,
            bottom: 16,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.08),
                blurRadius: 20,
                spreadRadius: 2,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Discount Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1F1F1F),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  product.discount,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Title
              Text(
                product.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              // Subtitle
              Text(
                product.subtitle,
                style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              // Price and Add Button row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: "\$ ",
                          style: TextStyle(
                            color: Color(0xFFFF6A42),
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        TextSpan(
                          text: product.price.toStringAsFixed(2),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: product.inCart
                          ? const Color(0xFF1F1F1F)
                          : Colors.white,
                      shape: BoxShape.circle,
                      border: product.inCart
                          ? null
                          : Border.all(color: Colors.grey.shade300),
                    ),
                    child: Icon(
                      product.inCart ? Icons.remove : Icons.add,
                      color: product.inCart ? Colors.white : Colors.black,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // FULL FLOATING IMAGE
        Positioned(
          top: -15, // aggressive overlap
          child: Image.network(
            product.image,
            width: 140, // very large image
            height: 140,
            fit: BoxFit.contain, // pristine transparency bounds
            errorBuilder: (context, error, stackTrace) => Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.fastfood, color: Colors.grey, size: 40),
            ),
          ),
        ),
      ],
    ),
    );
  }
}

class Product {
  final int id;
  final String title;
  final String subtitle;
  final String image;
  final double price;
  final String discount;
  final bool inCart;
  final String category;

  Product({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.price,
    this.discount = "-25%",
    this.inCart = false,
    required this.category,
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
    title: "Classic Cheeseburger",
    subtitle: "Beef Combo",
    image:
        "https://static.vecteezy.com/system/resources/previews/022/484/505/non_2x/tasty-burger-on-transparent-background-png.png",
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
    title: "Fresh Mango",
    subtitle: "Organic Fruit",
    image:
        "https://static.vecteezy.com/system/resources/previews/010/856/649/non_2x/a-basket-of-fruits-transparent-background-png.png",
    price: 3.50,
    discount: "-10%",
    inCart: false,
    category: "Fruits",
  ),
  Product(
    id: 6,
    title: "Mojito Splash",
    subtitle: "Mint & Lime",
    image:
        "https://static.vecteezy.com/system/resources/previews/009/887/309/non_2x/glass-of-lemonade-with-lemon-and-mint-png.png",
    price: 4.10,
    discount: "-20%",
    inCart: false,
    category: "Drinks",
  ),
  Product(
    id: 7,
    title: "Potato Chips",
    subtitle: "Crunchy Snack",
    image:
        "https://static.vecteezy.com/system/resources/previews/008/848/438/non_2x/potato-chips-falling-on-glass-bowl-png.png",
    price: 2.50,
    discount: "New",
    inCart: false,
    category: "Snack",
  ),
  Product(
    id: 7,
    title: "Pizza Sicilia",
    subtitle: "Pizza Sicilia",
    image: "https://pngimg.com/d/pizza_PNG44077.png",
    price: 8.99,
    discount: "-25%",
    inCart: true,
    category: "Food",
  ),
];
