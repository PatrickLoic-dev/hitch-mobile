import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:Hitch/models/ride.dart';
import 'package:Hitch/models/account.dart';
import 'package:Hitch/components/button.dart';
import 'package:Hitch/services/account_service.dart';
import 'package:Hitch/screens/rider-screens/home/trips-request/book_ride_page.dart';
import 'package:Hitch/config/constants.dart';

class PassengerTripDetailPage extends StatefulWidget {
  final Ride ride;

  const PassengerTripDetailPage({super.key, required this.ride});

  @override
  State<PassengerTripDetailPage> createState() => _PassengerTripDetailPageState();
}

class _PassengerTripDetailPageState extends State<PassengerTripDetailPage> {
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
    final DateFormat dayFormatter = DateFormat('EEE d MMM');
    final DateFormat timeFormatter = DateFormat('hh:mm a');
    final String avatarUrl = "${ApiConstants.baseUrl}/accounts/${widget.ride.createdBy}/profile-picture";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'TRIP DETAILS',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1.2),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      widget.ride.startingLocation,
                      style: const TextStyle(color: Colors.orange, fontSize: 14, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(Icons.arrow_forward, size: 14, color: Colors.grey),
                  ),
                  Flexible(
                    child: Text(
                      widget.ride.destination,
                      style: const TextStyle(color: Colors.orange, fontSize: 14, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Text(
                "${dayFormatter.format(widget.ride.departureTime)} • ${timeFormatter.format(widget.ride.departureTime)} • ${widget.ride.seats} Seats",
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
            const Divider(height: 32),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  _buildSectionCard(
                    title: 'Departure',
                    children: [
                      _buildDetailRow(label: 'PICK UP', value: widget.ride.startingLocation, icon: Icons.location_on_outlined),
                      const SizedBox(height: 12),
                      _buildDetailRow(label: 'DROP OFF', value: widget.ride.destination, icon: Icons.location_on_outlined),
                      const Divider(height: 32),
                      _buildInfoRow(icon: Icons.access_time, label: 'Depart', value: timeFormatter.format(widget.ride.departureTime)),
                      const SizedBox(height: 12),
                      _buildInfoRow(icon: Icons.person_outline, label: 'Seats available', value: widget.ride.seats.toString()),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  _buildSectionCard(
                    title: 'Driver and Vehicle details',
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.grey.shade200,
                            backgroundImage: NetworkImage(avatarUrl),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _driver != null ? '${_driver!.firstName} ${_driver!.lastName}' : 'Driver',
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const Text(
                                  'Verified driver',
                                  style: TextStyle(color: Colors.orange, fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Row(
                                children: [
                                  Text('4.9', style: TextStyle(fontWeight: FontWeight.bold)),
                                  Icon(Icons.star, color: Colors.amber, size: 16),
                                ],
                              ),
                              Text('50 Trips', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                            ],
                          ),
                          const Icon(Icons.chevron_right, color: Colors.grey),
                        ],
                      ),
                      const Divider(height: 32),
                      Row(
                        children: [
                          const Icon(Icons.directions_car_outlined, color: Colors.grey),
                          const SizedBox(width: 12),
                          Text(widget.ride.vehicle, style: const TextStyle(fontWeight: FontWeight.w500)),
                          const Spacer(),
                          const Text('Black', style: TextStyle(color: Colors.grey)), 
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4))],
        ),
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'XAF ${widget.ride.price.toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange),
                ),
                const Text('/Passenger', style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Button(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => BookRidePage(ride: widget.ride),
                    ),
                  );
                },
                text: 'Book',
                backgroundColor: const Color(0xFFA6EB2E),
                foregroundColor: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow({required String label, required String value, required IconData icon}) {
    return Row(
      children: [
        SizedBox(width: 70, child: Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold))),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                Icon(icon, size: 14, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(child: Text(value, style: const TextStyle(fontSize: 13), overflow: TextOverflow.ellipsis)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow({required IconData icon, required String label, required String value}) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 12),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        const Spacer(),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
