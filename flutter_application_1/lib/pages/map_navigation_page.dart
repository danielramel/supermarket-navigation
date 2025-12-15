import 'package:flutter/material.dart';

/// Empty placeholder for the Map Navigation menu/page.
class MapNavigationPage extends StatelessWidget {
  const MapNavigationPage({super.key});

  static const List<String> _imagePaths = [
    'assets/1.png',
    'assets/2.png',
    'assets/3.png',
    'assets/4.png',
    'assets/5.png',
    'assets/6.png',
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