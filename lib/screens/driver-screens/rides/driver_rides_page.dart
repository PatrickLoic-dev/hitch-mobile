
import 'package:flutter/material.dart';
import 'package:Hitch/enums/trip_detail_status.enum.dart';

//Personnal components
import 'package:Hitch/components/past_ride_card.dart';
import 'package:Hitch/components/upcoming_ride_card.dart';
import 'package:Hitch/components/active_ride_card.dart';

// Import de la page de détails
import 'package:Hitch/screens/rider-screens/home/trips/trip_detail_page.dart';

class DriverRidesPage extends StatefulWidget {
  const DriverRidesPage({super.key});

  @override
  State<DriverRidesPage> createState() => _DriverRidesPageState();
}

// On utilise un 'TickerProviderStateMixin' pour animer le changement d'onglet
class _DriverRidesPageState extends State<DriverRidesPage> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Initialise le contrôleur avec 3 onglets
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Titre de la page ---
            const Padding(
              padding: EdgeInsets.only(left: 24, top: 20, bottom: 16),
              child: Text(
                'Trips',
                style: TextStyle(
                  fontFamily: 'Jokker',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // --- Barre d'onglets principale ---
            TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey.shade500,
              indicatorColor: Colors.black,
              indicatorWeight: 3.0,
              labelStyle: const TextStyle(
                fontFamily: 'Jokker',
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              unselectedLabelStyle: const TextStyle(
                fontFamily: 'Jokker',
                fontWeight: FontWeight.normal,
                fontSize: 16,
              ),
              tabs: const <Widget>[
                Tab(text: 'Booked'),
                Tab(text: 'Published'),
                Tab(text: 'Active'),
              ],
            ),

            // --- Contenu des onglets ---
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  // Contenu pour l'onglet "Booked"
                  TabContentWithSubTabs(
                    // On passe la liste des trajets à venir
                    upcomingContent: ListView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 20.0),
                      children: [
                        UpcomingRideCard(
                          pickUpLocation: "Yassa, Douala",
                          dropOffLocation: "Bonabéri, Douala",
                          dateTime: "28 Nov, 08:00 PM",
                          price: "XAF 2,500.00",
                          driverName: "Loïc Patrick",
                          driverAvatar: 'assets/images/default-avatar.jpg',
                          vehicleModel: 'Toyota Yaris',
                          vehiclePlate: 'LT 123 AE',
                          status: UpcomingRideStatus.confirmed,
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const TripDetailPage(status: TripDetailStatus.confirmed),
                            ));
                          },
                        ),
                        const SizedBox(height: 16),
                        UpcomingRideCard(
                          pickUpLocation: "Village, Douala",
                          dropOffLocation: "Ndogbong, Douala",
                          dateTime: "29 Nov, 10:00 AM",
                          price: "XAF 1,000.00",
                          driverName: "Stéphane K.",
                          driverAvatar: 'assets/images/default-avatar.jpg',
                          vehicleModel: 'Toyota RAV4',
                          vehiclePlate: 'LT 456 BS',
                          status: UpcomingRideStatus.awaiting,
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const TripDetailPage(status: TripDetailStatus.awaitingConfirmation),
                            ));
                          },
                        ),
                      ],
                    ),
                  ),
                  // Contenu pour l'onglet "Published"
                  const TabContentWithSubTabs(
                    upcomingContent: EmptyStateWidget(
                      title: 'You haven’t offered any rides yet',
                      description: 'Offer a ride and they will appear here',
                      showSwitchToDriverLink: true,
                    ),
                  ),
                  // Contenu pour l'onglet "Active"
                  ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                    children: [
                      ActiveRideCard(
                        pickUpLocation: "Rond-point Deido, Douala",
                        dropOffLocation: "Japoma, Douala",
                        dateTime: "26 Nov, 03:45 PM",
                        price: "XAF 3,000.00",
                        driverName: "Aline F.",
                        driverAvatar: 'assets/images/default-avatar.jpg',
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const TripDetailPage(status: TripDetailStatus.onTrip),
                          ));
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// WIDGET POUR LES CONTENUS "BOOKED" ET "PUBLISHED" (AVEC SOUS-ONGLETS)
class TabContentWithSubTabs extends StatefulWidget {
  final Widget upcomingContent;

  const TabContentWithSubTabs({
    super.key,
    required this.upcomingContent,
  });

  @override
  State<TabContentWithSubTabs> createState() => _TabContentWithSubTabsState();
}

class _TabContentWithSubTabsState extends State<TabContentWithSubTabs> {
  // 0 pour "Upcoming", 1 pour "Past"
  int _selectedSubTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            children: [
              SubTabButton(
                text: 'Upcoming',
                isSelected: _selectedSubTabIndex == 0,
                onPressed: () => setState(() => _selectedSubTabIndex = 0),
              ),
              const SizedBox(width: 12),
              SubTabButton(
                text: 'Past',
                isSelected: _selectedSubTabIndex == 1,
                onPressed: () => setState(() => _selectedSubTabIndex = 1),
              ),
            ],
          ),
        ),
        Expanded(
          child: _selectedSubTabIndex == 0
              ? widget.upcomingContent
          // Contenu statique pour l'onglet "Past"
              : ListView(
            padding: const EdgeInsets.symmetric(
                horizontal: 24.0, vertical: 20.0),
            children: [
              PastRideCard(
                pickUpLocation: "Akwa, Douala",
                dropOffLocation: "Bonapriso, Douala",
                dateTime: "18 Aug, 06:00 AM",
                price: "XAF 1,500.00",
                status: RideStatus.completed,
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const TripDetailPage(status: TripDetailStatus.completed),
                  ));
                },
              ),
              const SizedBox(height: 16),
              PastRideCard(
                pickUpLocation: "Logpom, Douala",
                dropOffLocation: "Deido, Douala",
                dateTime: "15 Aug, 09:30 PM",
                price: "XAF 2,000.00",
                status: RideStatus.cancelled,
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const TripDetailPage(status: TripDetailStatus.cancelled),
                  ));
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// WIDGET POUR AFFICHER LES MESSAGES QUAND C'EST VIDE
class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String description;
  final bool showSwitchToDriverLink;

  const EmptyStateWidget({
    super.key,
    required this.title,
    required this.description,
    this.showSwitchToDriverLink = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Jokker',
              ),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade600,
                fontFamily: 'Jokker',
              ),
            ),
            if (showSwitchToDriverLink) ...[
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  // TODO: Logique pour changer de profil
                  print('Changer de profil cliqué');
                },
                child: const Text(
                  'Switch to driver profile',
                  style: TextStyle(
                    color: Colors.blue, // Couleur typique pour un lien
                    decoration: TextDecoration.underline,
                    fontFamily: 'Jokker',
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// WIDGET BOUTON POUR LES SOUS-ONGLETS "UPCOMING" / "PAST"
class SubTabButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onPressed;

  const SubTabButton({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor:
        isSelected ? Colors.lightGreenAccent : Colors.grey.shade200,
        foregroundColor: Colors.black,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Bord bien arrondi
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: 'Jokker',
        ),
      ),
    );
  }
}
