import 'package:flutter/material.dart';

class ArrowNavigationPage extends StatefulWidget {
  const ArrowNavigationPage({super.key});

  @override
  State<ArrowNavigationPage> createState() => _ArrowNavigationPageState();
}

class _ArrowNavigationPageState extends State<ArrowNavigationPage> {
  final PageController _pageController = PageController();
  final Map<int, String> _words = {};

  static const Map<int, String> _commandMap = {
    1: 'go forward',
    2: 'go left',
    3: 'go right',
    4: 'turn around',
    5: 'the item is on your left',
    6: 'the item is on your right',
  };

  static const List<String> _items = [
    'Garlic',
    'Chicken Breast',
    'Lidl Socks',
    'Sandwich Cheese',
    'Go to checkout',
  ];

  static const List<int> _path = [
    1, 3, 6, 1, 1, 1, 6, 2, 2, 5, 4, 1, 2, 6, 2, 
  ];

  int _itemIndex = 0;

  String _commandForIndex(int index) {
    final id = _path[index % _path.length];
    String cmd = _commandMap[id] ?? 'go forward';
    
    if (id == 5 || id == 6) {
      cmd = cmd.replaceFirst('the item', _items[_itemIndex]);
      _itemIndex = (_itemIndex + 1) % _items.length;
    }
    
    return cmd;
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
                        _iconForCommand(word),
                        const SizedBox(height: 16),
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
    if (cmd.startsWith('go forward')) {
      return const Icon(Icons.arrow_upward, size: mainSize, color: Colors.white);
    } else if (cmd.startsWith('go left')) {
      return const Icon(Icons.arrow_back, size: mainSize, color: Colors.white);
    } else if (cmd.startsWith('go right')) {
      return const Icon(Icons.arrow_forward, size: mainSize, color: Colors.white);
    } else if (cmd.startsWith('turn around')) {
      return const Icon(Icons.rotate_left, size: mainSize, color: Colors.white);
    } else if (cmd.contains('is on your')) {
      return const Icon(Icons.place, size: mainSize, color: Colors.white);
    }
    return const Icon(Icons.help_outline, size: mainSize, color: Colors.white);
  }
}