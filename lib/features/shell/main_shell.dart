import 'package:flutter/material.dart';
import 'package:nando/core/constants/app_data.dart';
import 'package:nando/features/help/help_screen.dart';
import 'package:nando/features/home/home_screen.dart';
import 'package:nando/features/stopwatch/stopwatch_screen.dart';

class MainShell extends StatefulWidget {
  final String username;

  const MainShell({super.key, required this.username});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomeScreen(username: widget.username),
          const StopwatchScreen(),
          const HelpScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: kPrimaryColor,
        unselectedItemColor: kTextMuted,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.timer_rounded), label: 'Stopwatch'),
          BottomNavigationBarItem(icon: Icon(Icons.help_outline), label: 'Bantuan'),
        ],
      ),
    );
  }
}
