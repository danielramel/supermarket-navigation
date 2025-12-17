import 'package:flutter/material.dart';

/// Empty placeholder for the Map Navigation menu/page.
class MapNavigationPage2 extends StatelessWidget {
  const MapNavigationPage2({super.key});

  static const List<String> _imagePaths = [
    'assets/2_1.png',
    'assets/2_2.png',
    'assets/2_3.png',
    'assets/2_4.png',
    'assets/2_5.png',
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
            return Container(
              color: Colors.black,
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
            );
          },
        ),
      ),
    );
  }
}