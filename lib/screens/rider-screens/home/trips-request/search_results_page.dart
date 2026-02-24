import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:Hitch/models/ride.dart';
import 'package:Hitch/models/account.dart';
import 'package:Hitch/providers/trip_request_provider.dart';
import 'package:Hitch/services/account_service.dart';
import 'package:Hitch/screens/rider-screens/home/trips-request/passenger_trip_detail_page.dart';
import 'package:Hitch/config/constants.dart';

class SearchResultsPage extends StatelessWidget {
  final List<Ride> rides;

  const SearchResultsPage({super.key, required this.rides});

  @override
  Widget build(BuildContext context) {
    final tripProvider = Provider.of<TripRequestProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            Flexible(
              child: Text(
                tripProvider.departure?.mainText ?? '',
                style: const TextStyle(color: Colors.orange, fontSize: 14, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0),
              child: Icon(Icons.arrow_forward, size: 14, color: Colors.grey),
            ),
            Flexible(
              child: Text(
                tripProvider.destination?.mainText ?? '',
                style: const TextStyle(color: Colors.orange, fontSize: 14, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      body: rides.isEmpty
          ? const Center(
              child: Text(
                'No rides found for your query.',
                style: TextStyle(fontSize: 16, color: Colors.grey, fontFamily: 'Jokker'),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              itemCount: rides.length,
              itemBuilder: (context, index) {
                final ride = rides[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: _ResultRideCard(
                    ride: ride,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PassengerTripDetailPage(ride: ride),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

class _ResultRideCard extends StatefulWidget {
  final Ride ride;
  final VoidCallback onTap;

  const _ResultRideCard({required this.ride, required this.onTap});

  @override
  State<_ResultRideCard> createState() => _ResultRideCardState();
}

class _ResultRideCardState extends State<_ResultRideCard> {
  Account? _driver;
  final AccountService _accountService = AccountService();

  @override
  void initState() {
    super.initState();
    _fetchDriverDetails();
  }

  Future<void> _fetchDriverDetails() async {
    try {
      final driver = await _accountService.getAccountById(widget.ride.createdBy);
      if (mounted) {
        setState(() {
          _driver = driver;
        });
      }
    } catch (e) {
      print('Error fetching driver details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final String avatarUrl = "${ApiConstants.baseUrl}/accounts/${widget.ride.createdBy}/profile-picture";

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: const Color(0xFFEAEAEA), width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLocationRow("PICK UP", widget.ride.startingLocation),
            const SizedBox(height: 12),
            _buildLocationRow("DROP OFF", widget.ride.destination),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('d MMM, hh:mm a').format(widget.ride.departureTime),
                  style: TextStyle(color: Colors.grey.shade600, fontFamily: 'Jokker'),
                ),
                Text(
                  "XAF ${widget.ride.price}",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Jokker'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: Color(0xFFEAEAEA), height: 1, thickness: 1),
            const SizedBox(height: 16),
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: NetworkImage(avatarUrl),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _driver != null ? '${_driver!.firstName} ${_driver!.lastName}' : 'Driver',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Jokker', fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(widget.ride.vehicle, style: const TextStyle(fontFamily: 'Jokker', color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationRow(String label, String location) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(color: Colors.grey, fontSize: 12, fontFamily: 'Jokker', fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.location_pin, color: Colors.grey, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    location,
                    style: const TextStyle(fontFamily: 'Jokker', fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
