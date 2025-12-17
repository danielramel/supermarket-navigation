import 'package:flutter/material.dart';

class ArrowNavigationPage2 extends StatefulWidget {
  const ArrowNavigationPage2({super.key});

  @override
  State<ArrowNavigationPage2> createState() => _ArrowNavigationPage2State();
}

class _ArrowNavigationPage2State extends State<ArrowNavigationPage2> {
  final PageController _pageController = PageController();
  final Map<int, String> _words = {}; // cache generated words per page index
  // distances removed: not used anymore

  // Command map based on numeric IDs.
  // 1: forward, 2: left, 3: right, 4: turn around, 5: item left, 6: item right
  static const Map<int, String> _commandMap = {
    1: 'go forward',
    2: 'go left',
    3: 'go right',
    4: 'turn around',
    5: 'the item is on your left',
    6: 'the item is on your right',
  };

  // Fixed path sequence to always follow.
  static const List<int> _path = [
    3, 1, 1, 5, 1, 2, 6, 1, 2, 1, 6, 1, 3, 6, 2
  ];

  String _commandForIndex(int index) {
    // Always select command from the fixed path sequence.
    final id = _path[index % _path.length];
    return _commandMap[id] ?? 'go forward';
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
        // Limit pages to the fixed path length to prevent overscroll beyond the end
        child: PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          itemCount: _path.length,
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
                        // distance removed; command is shown without steps
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
      case 'the item is on your right':
        // Use the same map-pin widget for both left/right item commands.
        return Stack(
          alignment: Alignment.center,
          children: [
            const Icon(
              Icons.place,
              size: mainSize,
              color: Colors.white,
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
