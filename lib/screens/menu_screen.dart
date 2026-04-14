import 'package:flutter/material.dart';
import 'home_screen.dart'; // To access Product model and demo data

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int selectedCategoryIndex = 2; // Default to 'All'
  String searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String currentCategoryStr = categoryData[selectedCategoryIndex]["title"]!;

    // Filter products dynamically based on category and search query
    List<Product> displayedProducts = newDemoProducts.where((p) {
      bool categoryMatch =
          currentCategoryStr == "All" || p.category == currentCategoryStr;
      bool searchMatch =
          p.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          p.subtitle.toLowerCase().contains(searchQuery.toLowerCase());
      return categoryMatch && searchMatch;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Menu",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          SearchAndFilter(
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
            onSubmitted: (value) {},
            searchHistory: [], // Simplified for now
          ),
          const SizedBox(height: 20),
          // Category Selection
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: categoryData.length,
              itemBuilder: (context, index) {
                bool isActive = selectedCategoryIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategoryIndex = index;
                    });
                  },
                  child: Container(
                    width: 70,
                    margin: const EdgeInsets.only(right: 15),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isActive
                                ? const Color(0xFFFF6A42)
                                : Colors.grey.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: Image.network(
                            categoryData[index]["image"]!,
                            height: 30,
                            width: 30,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          categoryData[index]["title"]!,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isActive
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isActive
                                ? const Color(0xFFFF6A42)
                                : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 20),
              child: ProductGrid(
                products: displayedProducts,
                onUpdate: () => setState(() {}),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
