import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:Hitch/enums/trip_detail_status.enum.dart';
import 'package:Hitch/providers/trip_provider.dart';
import 'package:Hitch/providers/auth_provider.dart';
import 'package:Hitch/models/booking.dart';
import 'package:Hitch/models/ride.dart';
import 'package:Hitch/screens/registration/driver_verification/proof_of_identity_page.dart';

//Personnal components
import 'package:Hitch/components/past_ride_card.dart';
import 'package:Hitch/components/upcoming_ride_card.dart';
import 'package:Hitch/components/active_ride_card.dart';

// Import de la page de détails
import 'package:Hitch/screens/rider-screens/home/trips/trip_detail_page.dart';

class TripsPage extends StatefulWidget {
  const TripsPage({super.key});

  @override
  State<TripsPage> createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TripProvider>(context, listen: false).fetchTrips();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final isPassenger = authProvider.user?.role == 'PASSENGER';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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

            TabBar(
              controller: _tabController,
              labelColor: const Color(0xFFF2640E),
              unselectedLabelColor: Colors.grey.shade500,
              indicatorColor: const Color(0xFFF2640E),
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

            Expanded(
              child: Consumer<TripProvider>(
                builder: (context, tripProvider, child) {
                  if (tripProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return TabBarView(
                    controller: _tabController,
                    children: <Widget>[
                      // "Booked" Tab
                      RefreshIndicator(
                        onRefresh: () => tripProvider.fetchTrips(),
                        child: TabContentWithSubTabs(
                          upcomingContent: _buildBookingsList(tripProvider.upcomingBookings),
                          pastContent: _buildBookingsList(tripProvider.pastBookings, isPast: true),
                        ),
                      ),
                      // "Published" Tab
                      isPassenger 
                        ? _buildPassengerPublishedState(context)
                        : RefreshIndicator(
                            onRefresh: () => tripProvider.fetchTrips(),
                            child: TabContentWithSubTabs(
                              upcomingContent: _buildPublishedRidesList(tripProvider.upcomingPublishedRides),
                              pastContent: _buildPublishedRidesList(tripProvider.pastPublishedRides, isPast: true),
                            ),
                          ),
                      // "Active" Tab
                      RefreshIndicator(
                        onRefresh: () => tripProvider.fetchTrips(),
                        child: _buildActiveTripsList(tripProvider.activeTrips),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingsList(List<Booking> bookings, {bool isPast = false}) {
    if (bookings.isEmpty) {
      return EmptyStateWidget(
        title: isPast ? 'No past bookings' : 'No upcoming bookings',
        description: isPast ? 'Your completed bookings will appear here' : 'Book a ride and it will appear here',
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        final ride = booking.rideDetails;
        if (isPast) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: PastRideCard(
              pickUpLocation: ride?.startingLocation ?? "Unknown",
              dropOffLocation: ride?.destination ?? "Unknown",
              dateTime: ride != null ? DateFormat('d MMM, hh:mm a').format(ride.departureTime) : "Unknown",
              price: "XAF ${booking.totalAmount}",
              status: booking.status.name == 'COMPLETED' ? RideStatus.completed : RideStatus.cancelled,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => TripDetailPage(status: booking.status.name == 'COMPLETED' ? TripDetailStatus.completed : TripDetailStatus.cancelled),
                ));
              },
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: UpcomingRideCard(
              pickUpLocation: ride?.startingLocation ?? "Unknown",
              dropOffLocation: ride?.destination ?? "Unknown",
              dateTime: ride != null ? DateFormat('d MMM, hh:mm a').format(ride.departureTime) : "Unknown",
              price: "XAF ${booking.totalAmount}",
              driverName: "Driver",
              driverAvatar: 'assets/images/default-avatar.jpg',
              vehicleModel: 'Unknown',
              vehiclePlate: 'Unknown',
              status: booking.status.name == 'CONFIRMED' ? UpcomingRideStatus.confirmed : UpcomingRideStatus.awaiting,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => TripDetailPage(status: booking.status.name == 'CONFIRMED' ? TripDetailStatus.confirmed : TripDetailStatus.awaitingConfirmation),
                ));
              },
            ),
          );
        }
      },
    );
  }

  Widget _buildPublishedRidesList(List<Ride> rides, {bool isPast = false}) {
    if (rides.isEmpty) {
      return EmptyStateWidget(
        title: isPast ? 'No past published rides' : 'No upcoming published rides',
        description: isPast ? 'Your completed offers will appear here' : 'Offer a ride and it will appear here',
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      itemCount: rides.length,
      itemBuilder: (context, index) {
        final ride = rides[index];
        if (isPast) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: PastRideCard(
              pickUpLocation: ride.startingLocation,
              dropOffLocation: ride.destination,
              dateTime: DateFormat('d MMM, hh:mm a').format(ride.departureTime),
              price: "XAF ${ride.price}",
              status: RideStatus.completed, // Assuming past is completed
              onTap: () {},
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: UpcomingRideCard(
              pickUpLocation: ride.startingLocation,
              dropOffLocation: ride.destination,
              dateTime: DateFormat('d MMM, hh:mm a').format(ride.departureTime),
              price: "XAF ${ride.price}",
              driverName: "You",
              driverAvatar: 'assets/images/default-avatar.jpg',
              vehicleModel: ride.vehicle,
              vehiclePlate: "My Plate",
              status: UpcomingRideStatus.confirmed,
              onTap: () {},
            ),
          );
        }
      },
    );
  }

  Widget _buildPassengerPublishedState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'You haven’t offered any rides yet.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Jokker',
              ),
            ),
            const SizedBox(height: 12),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade600,
                  fontFamily: 'Jokker',
                ),
                children: [
                  const TextSpan(text: 'To offer a ride you need to undergo '),
                  TextSpan(
                    text: 'driver verification',
                    style: const TextStyle(
                      color: Color(0xFFF2640E),
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ProofOfIdentityPage(),
                          ),
                        );
                      },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveTripsList(List<Booking> activeTrips) {
     if (activeTrips.isEmpty) {
      return const EmptyStateWidget(
        title: 'No active rides',
        description: 'Your current rides will appear here',
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      itemCount: activeTrips.length,
      itemBuilder: (context, index) {
        final trip = activeTrips[index];
        final ride = trip.rideDetails;
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: ActiveRideCard(
            pickUpLocation: ride?.startingLocation ?? "Unknown",
            dropOffLocation: ride?.destination ?? "Unknown",
            dateTime: ride != null ? DateFormat('d MMM, hh:mm a').format(ride.departureTime) : "Unknown",
            price: "XAF ${trip.totalAmount}",
            driverName: "Driver", 
            driverAvatar: 'assets/images/default-avatar.jpg',
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const TripDetailPage(status: TripDetailStatus.onTrip),
              ));
            },
          ),
        );
      },
    );
  }
}

class TabContentWithSubTabs extends StatefulWidget {
  final Widget upcomingContent;
  final Widget pastContent;

  const TabContentWithSubTabs({
    super.key,
    required this.upcomingContent,
    required this.pastContent,
  });

  @override
  State<TabContentWithSubTabs> createState() => _TabContentWithSubTabsState();
}

class _TabContentWithSubTabsState extends State<TabContentWithSubTabs> {
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
              : widget.pastContent,
        ),
      ],
    );
  }
}

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
                  print('Changer de profil cliqué');
                },
                child: const Text(
                  'Switch to driver profile',
                  style: TextStyle(
                    color: Colors.blue,
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
          borderRadius: BorderRadius.circular(30),
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
