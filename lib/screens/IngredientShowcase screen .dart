import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class IngredientShowcase extends StatefulWidget {
  final List<Map<String, dynamic>> ingredients;
  const IngredientShowcase({super.key, required this.ingredients});

  @override
  State<IngredientShowcase> createState() => _IngredientShowcaseState();
}

class _IngredientShowcaseState extends State<IngredientShowcase> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    // Centering the list to the middle item for a balanced look
    double initialOffset = 0.0;
    if (widget.ingredients.length > 1) {
      int middleIndex = (widget.ingredients.length / 2).floor();
      initialOffset = middleIndex * 100.0;
    }
    _scrollController = ScrollController(initialScrollOffset: initialOffset);
  }

  @override
  void dispose() {
    _scrollController.dispose();
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        return SizedBox(
          height: 160,
          child: AnimatedBuilder(
            animation: _scrollController,
            builder: (context, child) {
              double offset = _scrollController.hasClients
                  ? _scrollController.offset
                  : 0.0;
              return ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: width / 2 - 50),
                itemCount: widget.ingredients.length,
                itemBuilder: (context, index) {
                  double itemPosition = index * 100.0;
                  double distance = (offset - itemPosition).abs();
                  double scale = (1.0 - (distance / 400).clamp(0.0, 0.3));
                  double shift = math.pow((distance / 100), 2) * 25;
                  if (shift > 50) shift = 50;
                  bool isFocused = distance < 50;

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
                          child: _buildMeltyItem(
                            widget.ingredients[index],
                            isFocused,
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
      },
    );
  }

  Widget _buildMeltyItem(Map<String, dynamic> data, bool isFocused) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            if (isFocused) ...[
              Positioned(
                bottom: -20,
                child: CustomPaint(
                  size: const Size(40, 60),
                  painter: TeardropPainter(color: data['color']),
                ),
              ),
            ],
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: isFocused ? 85 : 70,
              height: isFocused ? 85 : 70,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: data['gradient'] as List<Color>,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: (data['glow'] as Color).withOpacity(
                      isFocused ? 0.4 : 0.2,
                    ),
                    blurRadius: isFocused ? 20 : 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Center(
                child: CachedNetworkImage(
                  imageUrl: data['image'],
                  width: isFocused ? 45 : 35,
                  height: isFocused ? 45 : 35,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          data['title'],
          style: TextStyle(
            fontSize: 10,
            fontWeight: isFocused ? FontWeight.bold : FontWeight.normal,
            color: isFocused ? Colors.black87 : Colors.grey,
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
