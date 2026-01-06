// lib/navigation/main_shell.dart

import 'package:flutter/material.dart';
// Correction des chemins pour correspondre à la structure de dossiers
import 'package:Hitch/screens/rider-screens/home/account_page.dart';
import 'package:Hitch/screens/rider-screens/home/home_page.dart';
import 'package:Hitch/screens/rider-screens/home/trips/trips_page.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  // Index de la page actuellement sélectionnée
  int _selectedIndex = 0;

  // Liste des pages à afficher
  static const List<Widget> _pages = <Widget>[
    HomePage(),
    TripsPage(),
    AccountPage(),
  ];

  // Fonction pour gérer le changement d'onglet
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Couleur pour la bordure et les icônes inactives
    const Color inactiveColor = Color(0xFFB2BABA);

    return Scaffold(
      // Le corps du Scaffold affiche la page correspondante à l'index sélectionné
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container( // Enveloppe la barre de navigation dans un Container
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Color(0xFFEAEAEA), width: 1.0), // Ajout de la bordure supérieure
          ),
        ),
        child: BottomNavigationBar(
          // Apparence de la barre de navigation
          type: BottomNavigationBarType.fixed, // Garde la même apparence pour 3+ items
          backgroundColor: Colors.white,
          selectedItemColor: Colors.black, // Couleur de l'icône et du texte actifs
          unselectedItemColor: inactiveColor, // MODIFIÉ: Couleur pour les inactifs
          showUnselectedLabels: true, // Affiche le texte pour les items inactifs
          selectedFontSize: 12.0,
          unselectedFontSize: 12.0,

          // État actuel
          currentIndex: _selectedIndex,
          onTap: _onItemTapped, // Fonction appelée au clic

          // Items de la barre (je les ai laissés en version non-arrondie comme dans votre code)
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home), // Icône différente quand l'item est actif
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.directions_car_outlined),
              activeIcon: Icon(Icons.directions_car_filled),
              label: 'Trips',
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
