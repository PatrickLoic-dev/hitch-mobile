import 'package:flutter/material.dart';
import 'package:Hitch/components/button.dart';
import 'package:Hitch/providers/auth_provider.dart';
import 'package:Hitch/providers/trip_request_provider.dart';
import 'package:Hitch/screens/rider-screens/home/trips-request/search_location_page.dart';
import 'package:Hitch/screens/driver-screens/offer-ride/pickup_location_page.dart';
import 'package:Hitch/screens/driver-screens/offer-ride/set_price_page.dart';
import 'package:Hitch/screens/rider-screens/home/trips-request/find_ride_loading_page.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    final userName = user?.firstName ?? 'User';
    final isDriver = user?.role == 'DRIVER';

    return Consumer<TripRequestProvider>(
      builder: (context, tripProvider, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset('assets/images/road.png', fit: BoxFit.contain),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hi $userName',
                                  style: const TextStyle(
                                    fontFamily: 'Jokker',
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'What would you like to do today?',
                                  style: TextStyle(
                                    fontFamily: 'Jokker',
                                    fontSize: 16,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(Icons.notifications_none_rounded, color: Colors.black, size: 30),
                              onPressed: () {
                                print('Bouton Notifications cliqué');
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 26),
                      _buildSearchForm(context, tripProvider, isDriver),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        child: Button(
                          text: isDriver ? 'Offer a ride' : 'Find a ride',
                          onPressed: tripProvider.isTripConfigured
                              ? () {
                                  if (isDriver) {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) => const SetPricePage()),
                                    );
                                  } else {
                                    // Navigate to Loading Page for Passengers
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) => const FindRideLoadingPage()),
                                    );
                                  }
                                }
                              : null,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchForm(BuildContext context, TripRequestProvider tripProvider, bool isDriver) {
    final DateFormat dayFormatter = DateFormat('EEEE, d MMM');
    final DateFormat timeFormatter = DateFormat('h:mm a');

    return GestureDetector(
      onTap: () async {
        tripProvider.clearTrip();
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => isDriver ? const PickupLocationPage() : const SearchLocationPage(),
        ));
      },
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: const Color(0xFFEAEAEA), width: 1.5),
        ),
        child: Column(
          children: [
            _buildContinuousUnderlineInput(
              hint: tripProvider.departure?.mainText ?? 'From',
              icon: null,
            ),
            _buildContinuousUnderlineInput(
              hint: tripProvider.destination?.mainText ?? 'To',
              icon: null,
            ),

            _buildContinuousUnderlineInput(
              hint: tripProvider.dateTime != null ? dayFormatter.format(tripProvider.dateTime!) : 'Today',
              icon: Icons.calendar_today_outlined,
            ),
            Row(
              children: [
                Expanded(
                  flex: 75,
                  child: _buildFormInput(
                    hint: tripProvider.dateTime != null ? timeFormatter.format(tripProvider.dateTime!) : 'Time',
                    icon: Icons.access_time_outlined,
                    hasBorder: false,
                  ),
                ),
                Container(
                  width: 1,
                  height: 30,
                  color: Colors.grey.shade300,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                ),
                Expanded(
                  flex: 25,
                  child: _buildFormInput(
                    hint: tripProvider.seatCount?.toString() ?? '0',
                    icon: Icons.person_outline,
                    hasBorder: false,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContinuousUnderlineInput({required String hint, IconData? icon}) {
    return Column(
      children: [
        _buildFormInput(hint: hint, icon: icon, hasBorder: false),
        Divider(
          height: 1,
          thickness: 1,
          color: Colors.grey.shade300,
        ),
      ],
    );
  }

  Widget _buildFormInput({required String hint, IconData? icon, bool hasBorder = true}) {
    return AbsorbPointer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.grey.shade600, size: 20),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                hint,
                style: TextStyle(
                  color: hint == 'From' || hint == 'To' || hint == 'Today' || hint == 'Time' || hint == '0'
                      ? Colors.grey.shade500
                      : Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
