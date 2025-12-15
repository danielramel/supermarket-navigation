import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/bottom_hamburger_menu.dart';
import 'package:flutter_application_1/pages/settings_page.dart';
import 'package:flutter_application_1/pages/shopping_list_page.dart';
import 'package:flutter_application_1/pages/navigation_menu_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supermarket Assistant',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  static const List<Widget> _pages = <Widget>[
    SettingsPage(),
    ShoppingListPage(),
    NavigationMenuPage(),
  ];

  static const List<String> _titles = <String>[
    'Settings',
    'Shopping List',
    'Navigation',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_currentIndex])),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}
