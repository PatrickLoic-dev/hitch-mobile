// lib/navigation/driver_main_shell.dart

import 'package:flutter/material.dart';
import 'package:Hitch/screens/driver-screens/driver_home_page.dart';
import 'package:Hitch/screens/driver-screens/rides/driver_rides_page.dart';
import 'package:Hitch/screens/rider-screens/home/account_page.dart'; // Re-using the existing AccountPage for now

class DriverMainShell extends StatefulWidget {
  const DriverMainShell({super.key});

  @override
  State<DriverMainShell> createState() => _DriverMainShellState();
}

class _DriverMainShellState extends State<DriverMainShell> {
  int _selectedIndex = 0;

  // List of pages for the driver
  static const List<Widget> _pages = <Widget>[
    DriverHomePage(),
    DriverRidesPage(), // Placeholder for Driver's rides/trips
    AccountPage(), // Can be a shared or a different account page
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color inactiveColor = Color(0xFFB2BABA);

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Color(0xFFEAEAEA), width: 1.0),
          ),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.black,
          unselectedItemColor: inactiveColor,
          showUnselectedLabels: true,
          selectedFontSize: 12.0,
          unselectedFontSize: 12.0,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.alt_route_outlined),
              activeIcon: Icon(Icons.alt_route),
              label: 'Rides',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined),
              activeIcon: Icon(Icons.account_circle),
              label: 'Account',
            ),
          ],
        ),
      ),
    );
  }
}
