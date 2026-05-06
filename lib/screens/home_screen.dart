import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/product_model.dart';
import 'product_details_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';
import 'menu_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<String> _searchHistory = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeScreenContent(
            searchHistory: _searchHistory,
            onUpdate: () => setState(() {}),
          ),
          const MenuScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color.fromARGB(255, 212, 100, 39),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        onTap: (index) {
          if (index == 2) {
            // Cart
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CartScreen()),
            ).then((_) => setState(() {}));
          } else if (index == 3) {
            // Profile
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            ).then((_) => setState(() {}));
          } else {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: "Menu",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: "Cart",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}

class HomeScreenContent extends StatefulWidget {
  final List<String> searchHistory;
  final VoidCallback onUpdate;
  const HomeScreenContent({
    super.key,
    required this.searchHistory,
    required this.onUpdate,
  });

  @override
  State<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  int selectedCategoryIndex = 2; // Default to 'All'
  String searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchSubmit(String value) {
    if (value.trim().isNotEmpty) {
      if (!widget.searchHistory.contains(value.trim())) {
        setState(() {
          widget.searchHistory.insert(0, value.trim());
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String currentCategoryStr = categoryData[selectedCategoryIndex]["title"]!;

    // Filter products dynamically based on category and search query
    List<Product> displayedProducts = newDemoProducts.where((p) {
      if (p.stock <= 0) return false;
      bool categoryMatch =
          currentCategoryStr == "All" || p.category == currentCategoryStr;
      bool searchMatch =
          p.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          p.subtitle.toLowerCase().contains(searchQuery.toLowerCase());
      return categoryMatch && searchMatch;
    }).toList();

    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 110),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TopBar(onUpdate: widget.onUpdate),
            const SizedBox(height: 24),
            const HeaderText(),
            const SizedBox(height: 24),
            SearchAndFilter(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              onSubmitted: _onSearchSubmit,
              searchHistory: widget.searchHistory,
            ),
            const SizedBox(height: 24),
            const OfferBanner(),
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
                    const SizedBox(height: 8),
                    ProductGrid(
                      products: displayedProducts,
                      onUpdate: widget.onUpdate,
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TopBar extends StatelessWidget {
  final VoidCallback? onUpdate;
  const TopBar({super.key, this.onUpdate});

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
          GestureDetector(
            onTap: () =>
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartScreen()),
                ).then((_) {
                  if (context.mounted && onUpdate != null) {
                    onUpdate!();
                  }
                }),
            child: Stack(
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
                    child: Text(
                      newDemoProducts
                          .where((p) => p.quantity > 0 || p.inCart)
                          .length
                          .toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final List<String> searchHistory;

  const SearchAndFilter({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onSubmitted,
    required this.searchHistory,
  });

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
                    color: Colors.grey.withValues(alpha: 0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
                border: Border.all(color: Colors.grey.shade100),
              ),
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                onSubmitted: onSubmitted,
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
                  suffixIcon: controller.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            controller.clear();
                            onChanged("");
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 18),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () {
              if (searchHistory.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("No search history yet.")),
                );
                return;
              }
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Search History"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: searchHistory
                        .map(
                          (history) => ListTile(
                            leading: const Icon(Icons.history),
                            title: Text(history),
                            onTap: () {
                              controller.text = history;
                              onChanged(history);
                              Navigator.pop(context);
                            },
                          ),
                        )
                        .toList(),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Close"),
                    ),
                  ],
                ),
              );
            },
            child: Container(
              height: 56,
              width: 56,
              decoration: const BoxDecoration(
                color: Color(0xFF1F1F1F),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.history, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class OfferBanner extends StatefulWidget {
  const OfferBanner({super.key});

  @override
  State<OfferBanner> createState() => _OfferBannerState();
}

class _OfferBannerState extends State<OfferBanner> {
  int _currentPage = 0;
  final PageController _pageController = PageController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (_pageController.hasClients) {
        int nextPage = _currentPage + 1;
        if (nextPage >= banners.length) {
          nextPage = 0;
        }
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> banners = [
    {
      "title": "Discount\n25% Off",
      "buttonText": "Order Now",
      "image": "https://pngimg.com/uploads/kfc_food/kfc_food_PNG21.png",
      "colors": [Color(0xFFFF9472), Color.fromARGB(255, 255, 57, 2)],
      "shadow": Color(0xFFFF6A42),
      "productIndex": 7,
    },
    {
      "title": "Your offer\n10% Off",
      "buttonText": "Claim Now",
      "image":
          "https://pngimg.com/uploads/burger_sandwich/burger_sandwich_PNG4135.png",
      "colors": [Color(0xFF42A5F5), Color(0xFF1976D2)],
      "shadow": Color(0xFF1976D2),
      "productIndex": 8,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            height: 150,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: banners.length,
              itemBuilder: (context, index) {
                final banner = banners[index];
                return _buildBannerItem(banner);
              },
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            banners.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(right: 6),
              height: 6,
              width: _currentPage == index ? 20 : 6,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? const Color(0xFFFF6A42)
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBannerItem(Map<String, dynamic> banner) {
    return GestureDetector(
      onTap: () {
        if (newDemoProducts.length > banner["productIndex"]) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailsScreen(
                product: newDemoProducts[banner["productIndex"]],
              ),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(right: 0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: banner["colors"],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: (banner["shadow"] as Color).withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -10,
              top: -15,
              bottom: -15,
              child: Transform.rotate(
                angle: 0.1,
                child: CachedNetworkImage(
                  imageUrl: banner["image"],
                  width: 160,
                  fit: BoxFit.contain,
                  errorWidget: (context, url, error) => const SizedBox.shrink(),
                ),
              ),
            ),
            Positioned(
              left: 20,
              top: 0,
              bottom: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    banner["title"],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 24,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 8), // Reduced from 12
                  ElevatedButton(
                    onPressed: () {
                      if (newDemoProducts.length > banner["productIndex"]) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailsScreen(
                              product: newDemoProducts[banner["productIndex"]],
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: banner["colors"][1],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      minimumSize: const Size(0, 36),
                      elevation: 0,
                    ),
                    child: Text(
                      banner["buttonText"],
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
    final double screenHalfWidth =
        MediaQuery.of(context).size.width / 2 - (itemWidth / 2);
    return SizedBox(
      height: 200,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: screenHalfWidth),
        itemCount: categoryData.length,
        itemBuilder: (context, index) {
          final double myCenter = index * itemWidth;

          return RepaintBoundary(
            child: AnimatedBuilder(
              animation: _scrollController,
              builder: (context, child) {
                double offset = _scrollController.hasClients
                    ? _scrollController.offset
                    : widget.selectedIndex * itemWidth;

                final double distance = (offset - myCenter).abs();
                double shift = math.pow((distance / 120), 2).toDouble() * 25;
                if (shift > 90) shift = 90;

                return SizedBox(
                  width: itemWidth,
                  child: Padding(
                    padding: EdgeInsets.only(top: shift),
                    child: child,
                  ),
                );
              },
              child: CategoryItem(
                data: categoryData[index],
                isActive: widget.selectedIndex == index,
                onTap: () {
                  widget.onCategoryChanged(index);
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
                    color: Colors.grey.withValues(alpha: 0.15),
                    blurRadius: 15,
                    spreadRadius: 2,
                    offset: const Offset(0, 5),
                  ),
              ],
            ),
            child: CachedNetworkImage(
              imageUrl: data["image"]!,
              fit: BoxFit.contain,
              memCacheWidth: 140,
              memCacheHeight: 140,
              fadeInDuration: const Duration(milliseconds: 150),
              errorWidget: (context, url, error) =>
                  const Icon(Icons.local_dining, color: Colors.grey),
              placeholder: (context, url) =>
                  const CircularProgressIndicator(strokeWidth: 2),
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

class ProductGrid extends StatelessWidget {
  final List<Product> products;
  final VoidCallback? onUpdate;

  const ProductGrid({super.key, required this.products, this.onUpdate});

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
          mainAxisSpacing: 30,
          crossAxisSpacing: 20,
          childAspectRatio:
              0.7, // Increased from 0.65 to reduce empty space at bottom
        ),
        itemBuilder: (context, index) {
          return RepaintBoundary(
            child: ProductCard(product: products[index], onUpdate: onUpdate),
          );
        },
      ),
    );
  }
}

class ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback? onUpdate;
  const ProductCard({super.key, required this.product, this.onUpdate});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  void initState() {
    super.initState();
    if (widget.product.quantity == 0 && widget.product.inCart) {
      widget.product.quantity = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(product: product),
          ),
        );
      },
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        fit: StackFit.expand,
        children: [
          // Main Background Card
          Container(
            margin: const EdgeInsets.only(
              top: 70, // Reduced from 80 to pull the box up
            ),
            padding: const EdgeInsets.only(
              top: 40, // Reduced from 45 to be more compact
              left: 14,
              right: 14,
              bottom: 12,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.08),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
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
                const SizedBox(height: 10),
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
                const SizedBox(height: 12),
                // Price and Add Button row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: "৳ ",
                                style: TextStyle(
                                  color: Color(0xFFFF6A42),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              TextSpan(
                                text:
                                    (product.price *
                                            (product.quantity > 0
                                                ? product.quantity
                                                : 1))
                                        .toStringAsFixed(2),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          maxLines: 1,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          widget.product.quantity = 1;
                          widget.product.inCart = true;
                        });
                        if (widget.onUpdate != null) {
                          widget.onUpdate!();
                        }
                      },
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: Color(0xFF1F1F1F),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // FULL FLOATING IMAGE
          Positioned(
            top: -15,
            child: CachedNetworkImage(
              imageUrl: product.image,
              width: 140,
              height: 140,
              fit: BoxFit.contain,
              memCacheWidth: 280,
              memCacheHeight: 280,
              fadeInDuration: const Duration(milliseconds: 200),
              errorWidget: (context, url, error) => Container(
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
          // Heart Icon for Favorites
          Positioned(
            top: 90,
            right: 15,
            child: GestureDetector(
              onTap: () {
                setState(
                  () => widget.product.isFavorite = !widget.product.isFavorite,
                );
                if (widget.onUpdate != null) {
                  widget.onUpdate!();
                }
              },
              child: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: product.isFavorite ? Colors.red : Colors.grey.shade400,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
