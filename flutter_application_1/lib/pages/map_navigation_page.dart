import 'package:flutter/material.dart';

/// Empty placeholder for the Map Navigation menu/page.
class MapNavigationPage extends StatelessWidget {
  const MapNavigationPage({super.key});

  static const List<String> _imagePaths = [
    'assets/1_1.png',
    'assets/1_2.png',
    'assets/1_3.png',
    'assets/1_4.png',
    'assets/1_5.png',
  ];

  static const List<String> _items = [
    'Garlic',
    'Chicken Breast',
    'Lidl Socks',
    'Sandwich Cheese',
    'Go to checkout',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView.builder(
          scrollDirection: Axis.vertical,
          itemCount: _imagePaths.length,
          itemBuilder: (context, index) {
            final path = _imagePaths[index];
            final itemLabel = index < _items.length ? _items[index] : '';
            return Container(
              color: Colors.black,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Text(
                      itemLabel,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: InteractiveViewer(
                        minScale: 0.5,
                        maxScale: 4.0,
                        child: Image.asset(
                          path,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}