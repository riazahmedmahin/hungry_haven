import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/product_model.dart';
import 'signin_screen.dart';
import 'order_screen.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  int _currentIndex = 0;

  DateTime? _startDate;
  DateTime? _endDate;

  int _selectedYear = DateTime.now().year;
  int _selectedMonth = DateTime.now().month;

  @override
  void initState() {
    super.initState();
    // Default to Today's report initially
    DateTime now = DateTime.now();
    _startDate = DateTime(now.year, now.month, now.day);
    _endDate = DateTime(now.year, now.month, now.day);
  }

  void _applyMonthFilter() {
    _startDate = DateTime(_selectedYear, _selectedMonth, 1);
    // Rough estimate for end of month bounds
    _endDate = DateTime(_selectedYear, _selectedMonth + 1, 0); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.shield, color: Colors.blueAccent),
            const SizedBox(width: 8),
            Text(
              _getAppBarTitle(),
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(
                  Icons.notifications_active,
                  color: Colors.orangeAccent,
                ),
                if (adminNotifications.isNotEmpty)
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        adminNotifications.length.toString(),
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
            onPressed: _showNotificationsDialog,
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const SignInScreen()),
              );
            },
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: _currentIndex,
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.grey.shade400,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_rounded),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_rounded),
              label: 'Orders',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.inventory_2_rounded),
              label: 'Inventory',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.analytics_rounded),
              label: 'Reports',
            ),
          ],
        ),
      ),
      floatingActionButton: _currentIndex == 2
          ? FloatingActionButton.extended(
              onPressed: _showAddProductBottomSheet,
              backgroundColor: Colors.blueAccent,
              elevation: 4,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                "Add Item",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
    );
  }

  String _getAppBarTitle() {
    switch (_currentIndex) {
      case 0:
        return "Dashboard";
      case 1:
        return "Live Orders";
      case 2:
        return "Inventory POS";
      case 3:
        return "Analytics";
      default:
        return "Admin";
    }
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return _buildDashboardSection();
      case 1:
        return _buildOrdersSection();
      case 2:
        return _buildInventorySection();
      case 3:
        return _buildReportsSection();
      default:
        return _buildDashboardSection();
    }
  }

  // ================= Dashboard Section =================
  Widget _buildDashboardSection() {
    double todaySales = 0;
    int todayOrders = 0;
    DateTime now = DateTime.now();
    Map<String, int> categorySales = {};
    for (var order in orderHistory) {
      if (order['dateTime'] != null) {
        DateTime dt = order['dateTime'];
        if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
          todaySales += order['total'] ?? 0.0;
          todayOrders++;
          for (var item in order['items']) {
            int q = item['quantity'] ?? 1;
            String t = item['title'];
            String cat = "Other";
            try {
              Product curr = newDemoProducts.firstWhere((p) => p.title == t);
              cat = curr.category;
            } catch (e) {}
            categorySales[cat] = (categorySales[cat] ?? 0) + q;
          }
        }
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Today's Overview",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 16),
          // Total Revenue Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Icon(Icons.today, color: Colors.white70, size: 28),
                    SizedBox(height: 12),
                    Text(
                      "Today's Revenue",
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ],
                ),
                Text(
                  "৳${todaySales.toStringAsFixed(2)}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  "Today Orders",
                  todayOrders.toString(),
                  Icons.shopping_bag,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  "Products",
                  newDemoProducts.length.toString(),
                  Icons.fastfood,
                  Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const SizedBox(height: 24),
          const Text(
            "Last 7 Days Revenue",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 16),
          _build7DayGraph(),
          const SizedBox(height: 30),
          
          // ---- PIE CHART SECTION ----
          if (categorySales.isNotEmpty) ...[
            const Text(
              "Today's Top Dispatch Categories",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: CustomPaint(
                      painter: PieChartPainter(
                        categorySales,
                        [Colors.blueAccent, Colors.orange, Colors.purpleAccent, Colors.green, Colors.redAccent, Colors.amber],
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: categorySales.entries.toList().asMap().entries.map((entry) {
                        int index = entry.key;
                        var cat = entry.value;
                        List<Color> colors = [Colors.blueAccent, Colors.orange, Colors.purpleAccent, Colors.green, Colors.redAccent, Colors.amber];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            children: [
                              Container(width: 12, height: 12, decoration: BoxDecoration(color: colors[index % colors.length], shape: BoxShape.circle)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(cat.key, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), overflow: TextOverflow.ellipsis),
                              ),
                              Text("(${cat.value})", style: const TextStyle(color: Colors.grey, fontSize: 13)),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
          // ---- END PIE CHART SECTION ----

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _build7DayGraph() {
    List<double> dailySales = List.filled(7, 0.0);
    DateTime now = DateTime.now();
    for (var order in orderHistory) {
      if (order['dateTime'] != null) {
        DateTime dt = order['dateTime'];
        DateTime todayStart = DateTime(now.year, now.month, now.day);
        DateTime dtStart = DateTime(dt.year, dt.month, dt.day);
        int diff = todayStart.difference(dtStart).inDays;
        if (diff >= 0 && diff < 7) {
          dailySales[6 - diff] += (order['total'] ?? 0.0);
        }
      }
    }
    double maxSale = dailySales.reduce((a, b) => a > b ? a : b);
    if (maxSale == 0) maxSale = 1; // Prevent division by zero

    List<String> dayLabels = List.generate(7, (index) {
      DateTime day = now.subtract(Duration(days: 6 - index));
      return ["M", "T", "W", "T", "F", "S", "S"][day.weekday - 1];
    });

    return Container(
      height: 240,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(7, (index) {
          double heightRatio = dailySales[index] / maxSale;
          bool isToday = index == 6;
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "৳${dailySales[index].toStringAsFixed(0)}",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: isToday ? Colors.blueAccent : Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: 35,
                height: 120 * heightRatio, // Max height strictly bounded
                decoration: BoxDecoration(
                  color: isToday ? Colors.blueAccent : Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                dayLabels[index],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                  color: isToday ? Colors.black87 : Colors.grey.shade500,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }



  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  // ================= Reports Section (Custom Analytics) =================
  Widget _buildReportsSection() {
    double filteredSales = 0;
    int itemsSold = 0;
    Map<String, int> productSales = {};
    Map<String, int> categorySales = {};

    DateTime safeEnd = _endDate != null
        ? _endDate!.add(const Duration(hours: 23, minutes: 59))
        : DateTime.now();

    for (var order in orderHistory) {
      if (order['dateTime'] != null) {
        DateTime dt = order['dateTime'];
        bool inRange = true;
        if (_startDate != null && dt.isBefore(_startDate!)) inRange = false;
        if (_endDate != null && dt.isAfter(safeEnd)) inRange = false;

        if (inRange) {
          filteredSales += order['total'] ?? 0.0;
          for (var item in order['items']) {
            int q = item['quantity'] ?? 1;
            String t = item['title'];
            itemsSold += q;
            productSales[t] = (productSales[t] ?? 0) + q;
            
            // Find Category
            String cat = "Other";
            try {
              Product curr = newDemoProducts.firstWhere((p) => p.title == t);
              cat = curr.category;
            } catch (e) {}
            categorySales[cat] = (categorySales[cat] ?? 0) + q;
          }
        }
      }
    }

    var sortedProducts = productSales.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      children: [
        // Date Filter Header
        Container(
          padding: const EdgeInsets.all(20).copyWith(top: 10),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Select Month & Year", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(15)),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          isExpanded: true,
                          value: _selectedYear,
                          items: List.generate(10, (index) => 2024 + index).map((y) => DropdownMenuItem(value: y, child: Text(y.toString(), style: const TextStyle(fontWeight: FontWeight.bold)))).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                _selectedYear = val;
                                _applyMonthFilter();
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(15)),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          isExpanded: true,
                          value: _selectedMonth,
                          items: [
                            "Jan", "Feb", "Mar", "Apr", "May", "Jun", 
                            "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
                          ].asMap().entries.map((e) => DropdownMenuItem(value: e.key + 1, child: Text(e.value, style: const TextStyle(fontWeight: FontWeight.bold)))).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                _selectedMonth = val;
                                _applyMonthFilter();
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Center(child: Text("OR", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 12))),
              ),
              GestureDetector(
                onTap: () async {
                  DateTimeRange? range = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (range != null) {
                    setState(() {
                      _startDate = range.start;
                      _endDate = range.end;
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.date_range, color: Colors.blueAccent, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        _startDate == null
                            ? "Pick Custom Date Range"
                            : "Custom: ${_startDate!.day}/${_startDate!.month}/${_startDate!.year} - ${_endDate!.day}/${_endDate!.month}/${_endDate!.year}",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                // Filtered Total Revenue Layout
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1F2937),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Generated Revenue",
                        style: TextStyle(color: Colors.white54, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "৳${filteredSales.toStringAsFixed(2)}",
                        style: const TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "Total Items Sold: $itemsSold",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),


                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Items Breakdown",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                if (sortedProducts.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      "No sales found in this date range.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                else
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: sortedProducts.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.shade50,
                          child: Text(
                            "${index + 1}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(
                          sortedProducts[index].key,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "${sortedProducts[index].value} sold",
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _pickDateRange(BuildContext context, int daysBack) {
    setState(() {
      _endDate = DateTime.now();
      _startDate = _endDate!.subtract(Duration(days: daysBack));
    });
  }

  // ================= Orders Section =================
  Widget _buildOrdersSection() {
    if (orderHistory.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, size: 80, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            const Text(
              "No Orders Yet",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orderHistory.length,
      itemBuilder: (context, index) {
        final order = orderHistory[index];
        final items = order['items'] as List;
        int totalItems = items.fold(
          0,
          (sum, item) => sum + (item['quantity'] as int),
        );
        String payment = order['paymentMethod'] ?? 'Unknown';
        String user = order['user'] ?? 'Guest User';
        bool isCash = payment.toLowerCase().contains('cash');

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade100),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.blue.shade50,
                        child: const Icon(
                          Icons.person,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "Order #${order['id']}",
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isCash
                          ? Colors.orange.shade50
                          : Colors.purple.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isCash ? Icons.money : Icons.credit_card,
                          size: 14,
                          color: isCash ? Colors.orange : Colors.purple,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          payment,
                          style: TextStyle(
                            color: isCash ? Colors.orange : Colors.purple,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Divider(height: 1),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Items ordered",
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "$totalItems pieces",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        "Total Paid",
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "৳${order['total'].toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Colors.green,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: items.map((item) {
                  return Chip(
                    backgroundColor: Colors.grey.shade50,
                    label: Text(
                      "${item['quantity']}x ${item['title']}",
                      style: const TextStyle(fontSize: 12),
                    ),
                    avatar: Image.network(
                      item['image'],
                      width: 20,
                      height: 20,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.fastfood, size: 12),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  // ================= Inventory Section =================
  Widget _buildInventorySection() {
    return ListView.builder(
      padding: const EdgeInsets.all(16).copyWith(bottom: 100),
      itemCount: newDemoProducts.length,
      itemBuilder: (context, index) {
        final product = newDemoProducts[index];
        bool outOfStock = product.stock <= 0;

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: outOfStock ? Colors.red.shade200 : Colors.transparent,
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    product.image,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.fastfood, color: Colors.grey),
                  ),
                ),
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
                    const SizedBox(height: 4),
                    Text(
                      product.category,
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "৳${product.price.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1976D2),
                            fontSize: 16,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: outOfStock
                                ? Colors.red.shade50
                                : Colors.green.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            outOfStock
                                ? "Out of Stock"
                                : "Stock: ${product.stock}",
                            style: TextStyle(
                              color: outOfStock
                                  ? Colors.red.shade700
                                  : Colors.green.shade700,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.edit_square, color: Colors.blueAccent),
                onPressed: () => _showEditStockDialog(product),
              ),
            ],
          ),
        );
      },
    );
  }

  // ================= Bottom Sheets & Dialogs =================
  void _showAddProductBottomSheet() {
    final titleCtrl = TextEditingController();
    final categoryCtrl = TextEditingController(text: "Food");
    final priceCtrl = TextEditingController();
    final stockCtrl = TextEditingController(text: "10");
    final discountCtrl = TextEditingController(text: "No");

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 30,
            left: 24,
            right: 24,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              //crossAxisSize: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Add New Product",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Fill in the details to publish a new menu item globally.",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                _buildModernTextField(titleCtrl, "Food Name", Icons.fastfood),
                const SizedBox(height: 16),
                _buildModernTextField(categoryCtrl, "Category", Icons.category),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildModernTextField(
                        priceCtrl,
                        "Price",
                        Icons.attach_money,
                        isNumber: true,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildModernTextField(
                        stockCtrl,
                        "Stock Count",
                        Icons.inventory,
                        isNumber: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildModernTextField(
                  discountCtrl,
                  "Discount",
                  Icons.local_offer,
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        newDemoProducts.add(
                          Product(
                            id: DateTime.now().millisecondsSinceEpoch,
                            title: titleCtrl.text.isEmpty
                                ? "Unknown"
                                : titleCtrl.text,
                            subtitle: "Newly Added",
                            image:
                                "https://pngimg.com/d/burger_sandwich_PNG4135.png",
                            price: double.tryParse(priceCtrl.text) ?? 0.0,
                            category: categoryCtrl.text,
                            discount: discountCtrl.text,
                            stock: int.tryParse(stockCtrl.text) ?? 10,
                          ),
                        );
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Product Published Globally!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      "Publish Product",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildModernTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool isNumber = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey.shade600),
        prefixIcon: Icon(icon, color: Colors.black87),
        filled: true,
        fillColor: const Color(0xFFF3F4F6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
        ),
      ),
    );
  }

  void _showEditStockDialog(Product product) {
    final stockCtrl = TextEditingController(text: product.stock.toString());
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Text(
            "Edit Stock: ${product.title}",
            style: const TextStyle(fontSize: 16),
          ),
          content: _buildModernTextField(
            stockCtrl,
            "Current Stock",
            Icons.inventory,
            isNumber: true,
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.grey),
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                setState(() {
                  product.stock = int.tryParse(stockCtrl.text) ?? product.stock;
                });
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _showNotificationsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Alerts",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              if (adminNotifications.isNotEmpty)
                TextButton(
                  onPressed: () {
                    setState(() {
                      adminNotifications.clear();
                    });
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Clear All",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
          content: adminNotifications.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    "No new notifications.",
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : SizedBox(
                  width: double.maxFinite,
                  height: 300,
                  child: ListView.builder(
                    itemCount: adminNotifications.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.amber,
                        ),
                        title: Text(
                          adminNotifications[index],
                          style: const TextStyle(fontSize: 14),
                        ),
                      );
                    },
                  ),
                ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {}); // Refresh notification bell indicator
                Navigator.pop(context);
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }
}

class PieChartPainter extends CustomPainter {
  final Map<String, int> data;
  final List<Color> colors;

  PieChartPainter(this.data, this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    double total = data.values.fold(0, (sum, val) => sum + val).toDouble();
    if (total == 0) return;

    double startAngle = -math.pi / 2;
    Rect boundingSquare = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: size.width / 2,
    );

    int index = 0;
    data.forEach((key, value) {
      double sweepAngle = (value / total) * 2 * math.pi;
      Paint paint = Paint()
        ..color = colors[index % colors.length]
        ..style = PaintingStyle.fill;

      canvas.drawArc(boundingSquare, startAngle, sweepAngle, true, paint);
      
      // Calculate percentage text placement
      if (sweepAngle > 0.3) { // Only draw text for slices big enough
        double percentage = (value / total) * 100;
        double textAngle = startAngle + sweepAngle / 2;
        double textRadius = size.width / 3.5;
        double x = size.width / 2 + textRadius * math.cos(textAngle);
        double y = size.height / 2 + textRadius * math.sin(textAngle);

        TextPainter textPainter = TextPainter(
          text: TextSpan(
            text: "${percentage.toStringAsFixed(0)}%",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(canvas, Offset(x - textPainter.width / 2, y - textPainter.height / 2));
      }

      startAngle += sweepAngle;
      index++;
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
