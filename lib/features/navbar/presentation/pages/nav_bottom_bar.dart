import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../experimental/presentation/pages/experimental.dart';
import '../../../../core/config/app_config.dart';

class NavBottomBar extends StatefulWidget {
  const NavBottomBar({super.key});

  @override
  State<NavBottomBar> createState() => _NavBottomBarState();
}

class _NavBottomBarState extends State<NavBottomBar> {
  int _selectedIndex = 0;

  // Keys for identifying widgets in tests or inspector
  static const Key mainPageKey = Key('mainPageKey');
  static const Key taskListKey = Key('taskListKey');
  static const Key personalAccountKey = Key('personalAccountKey');
  static const Key moreKey = Key('moreKey');
  static const Key experimentalFeatureKey = Key('experimentalFeatureKey');

  List<Widget> get _widgetOptions {
    final options = [
      const Center(child: Text('Main Page', style: TextStyle(color: Colors.white, fontSize: 24))),
      const Center(child: Text('Task List', style: TextStyle(color: Colors.white, fontSize: 24))),
      const Center(child: Text('Personal Account', style: TextStyle(color: Colors.white, fontSize: 24))),
      const Center(child: Text('More', style: TextStyle(color: Colors.white, fontSize: 24))),
    ];

    if (AppConfig.isExperimentalFeatureVisible) {
      options.add(const Center(child: ExperimentalPage()));
    }

    return options;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      const BottomNavigationBarItem(
        key: mainPageKey,
        icon: Icon(Icons.home),
        label: 'Main',
      ),
      const BottomNavigationBarItem(
        key: taskListKey,
        icon: Icon(Icons.list),
        label: 'Tasks',
      ),
      const BottomNavigationBarItem(
        key: personalAccountKey,
        icon: Icon(Icons.person),
        label: 'Account',
      ),
      const BottomNavigationBarItem(
        key: moreKey,
        icon: Icon(Icons.more_horiz),
        label: 'More',
      ),
    ];

    if (AppConfig.isExperimentalFeatureVisible) {
      items.add(
        const BottomNavigationBarItem(
          key: experimentalFeatureKey,
          icon: Icon(FontAwesomeIcons.flask), // Experimental icon
          label: 'Exp.',
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: items,
        currentIndex: _selectedIndex,
          selectedItemColor: Theme.of(context).colorScheme.secondary, // Accent color
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed, // Needed for 4+ items
          backgroundColor: const Color(0xFF01344F).withOpacity(0.9), // Slightly different background if needed
          showUnselectedLabels: true,
      ),
    );
  }
}