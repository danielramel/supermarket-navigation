import 'dart:math';

import 'package:flutter/material.dart';

class NavigationMenuPage extends StatefulWidget {
  const NavigationMenuPage({super.key});

  @override
  State<NavigationMenuPage> createState() => _NavigationMenuPageState();
}

class _NavigationMenuPageState extends State<NavigationMenuPage> {
  final PageController _pageController = PageController();
  final Map<int, String> _words = {}; // cache generated words per page index
  final Random _random = Random();

  // Fixed set of navigation commands to show on each page.
  static const List<String> _commands = [
    'go forward',
    'go left',
    'go right',
    'turn around',
    'the item is on your left',
    'the item is on your right',
  ];

  String _commandForIndex(int index) {
    // Choose a command deterministically based on a pseudo-random choice but cache per index.
    return _commands[_random.nextInt(_commands.length)];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // PageView.builder without itemCount produces an effectively infinite scroll
        child: PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            final word = _words.putIfAbsent(index, () => _commandForIndex(index));
            final color = Colors.primaries[index % Colors.primaries.length].shade400;

            return Container(
              color: color,
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _iconForCommand(word),
                          size: 120,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 16),
                        // small label for accessibility, optional visible text in a subtle style
                        Text(
                          word.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white70,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 16,
                    bottom: 20,
                    child: Opacity(
                      opacity: 0.85,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Swipe up or down for a new command',
                          style: TextStyle(color: Colors.white70),
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

  IconData _iconForCommand(String cmd) {
    switch (cmd) {
      case 'go forward':
        return Icons.arrow_upward;
      case 'go left':
        return Icons.arrow_back;
      case 'go right':
        return Icons.arrow_forward;
      case 'turn around':
        return Icons.rotate_left;
      case 'the item is on your left':
        return Icons.shopping_bag_outlined;
      case 'the item is on your right':
        return Icons.shopping_bag;
      default:
        return Icons.help_outline;
    }
  }
}
