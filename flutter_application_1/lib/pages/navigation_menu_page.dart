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
  final Map<int, int> _distances = {}; // cache generated distances per page index
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

  int _distanceForIndex(int index) {
    // Return cached distance or generate a random 1..50 steps value
    return _distances.putIfAbsent(index, () => _random.nextInt(50) + 1);
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
                        // Icon/widget for the command (may be a composed widget for map pins)
                        _iconForCommand(word),
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
                        const SizedBox(height: 6),
                        // distance line e.g. "in 15 steps"
                        Builder(builder: (ctx) {
                          final dist = _distanceForIndex(index);
                          final unit = dist == 1 ? 'step' : 'steps';
                          return Text(
                            'in $dist $unit',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white70,
                            ),
                          );
                        }),
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

  Widget _iconForCommand(String cmd) {
    const double mainSize = 120;
    const double badgeSize = 40;
    switch (cmd) {
      case 'go forward':
        return const Icon(
          Icons.arrow_upward,
          size: mainSize,
          color: Colors.white,
        );
      case 'go left':
        return const Icon(
          Icons.arrow_back,
          size: mainSize,
          color: Colors.white,
        );
      case 'go right':
        return const Icon(
          Icons.arrow_forward,
          size: mainSize,
          color: Colors.white,
        );
      case 'turn around':
        return const Icon(
          Icons.rotate_left,
          size: mainSize,
          color: Colors.white,
        );
      case 'the item is on your left':
        return Stack(
          alignment: Alignment.center,
          children: [
            const Icon(
              Icons.place,
              size: mainSize,
              color: Colors.white,
            ),
            Positioned(
              left: 16,
              child: Transform.rotate(
                angle: 0, // keep arrow pointing left
                child: const Icon(
                  Icons.arrow_back_ios,
                  size: badgeSize,
                  color: Colors.white70,
                ),
              ),
            ),
          ],
        );
      case 'the item is on your right':
        return Stack(
          alignment: Alignment.center,
          children: [
            const Icon(
              Icons.place,
              size: mainSize,
              color: Colors.white,
            ),
            Positioned(
              right: 16,
              child: Transform.rotate(
                angle: 0,
                child: const Icon(
                  Icons.arrow_forward_ios,
                  size: badgeSize,
                  color: Colors.white70,
                ),
              ),
            ),
          ],
        );
      default:
        return const Icon(
          Icons.help_outline,
          size: mainSize,
          color: Colors.white,
        );
    }
  }
}
