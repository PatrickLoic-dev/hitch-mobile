import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:Hitch/components/button.dart';
import 'package:Hitch/providers/auth_provider.dart';
import 'package:Hitch/providers/trip_request_provider.dart';
import 'package:Hitch/services/ride_service.dart';
import 'package:Hitch/navigation/main_shell.dart';

class RideSummaryPage extends StatefulWidget {
  const RideSummaryPage({super.key});

  @override
  State<RideSummaryPage> createState() => _RideSummaryPageState();
}

class _RideSummaryPageState extends State<RideSummaryPage> {
  bool _isPublishing = false;

  @override
  Widget build(BuildContext context) {
    final tripProvider = Provider.of<TripRequestProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final rideService = RideService();

    final DateFormat timeFormatter = DateFormat('hh:mm a');

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
          'RIDE SUMMARY',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: 'Jokker',
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Departure',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Jokker'),
                  ),
                  const SizedBox(height: 20),
                  _buildSummaryRow(
                    label: 'PICK UP',
                    value: tripProvider.departure?.mainText ?? '',
                    icon: Icons.location_on_outlined,
                  ),
                  const SizedBox(height: 12),
                  _buildSummaryRow(
                    label: 'DROP OFF',
                    value: tripProvider.destination?.mainText ?? '',
                    icon: Icons.location_on_outlined,
                  ),
                  const Divider(height: 32),
                  _buildSummaryDetail(
                    icon: Icons.access_time,
                    label: 'Depart',
                    value: timeFormatter.format(tripProvider.dateTime!),
                  ),
                  const SizedBox(height: 12),
                  _buildSummaryDetail(
                    icon: Icons.person_outline,
                    label: 'Seats available',
                    value: tripProvider.seatCount.toString(),
                  ),
                  const SizedBox(height: 12),
                  _buildSummaryDetail(
                    icon: Icons.payments_outlined,
                    label: 'Price/seat',
                    value: 'XAF ${tripProvider.price?.toStringAsFixed(2)}',
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: _isPublishing
                  ? const Center(child: CircularProgressIndicator(color: Color(0xFFA6EB2E)))
                  : Button(
                      onPressed: () async {
                        setState(() => _isPublishing = true);
                        try {
                          final rideData = {
                            "ride_id": const Uuid().v4(),
                            "starting_location": tripProvider.departure!.mainText,
                            "destination": tripProvider.destination!.mainText,
                            "price": tripProvider.price ?? 0.0,
                            "vehicle": "My Vehicle", // Placeholder
                            "seats": tripProvider.seatCount,
                            "departure_time": tripProvider.dateTime!.toIso8601String(),
                            "distance": 0.0, // Placeholder
                            "created_By": authProvider.user?.accountId ?? "unknown",
                            "created_at": DateTime.now().toIso8601String(),
                          };

                          await rideService.createRide(rideData);
                          
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Ride published successfully!')),
                            );
                            tripProvider.clearTrip();
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => const MainShell()),
                              (route) => false,
                            );
                          }
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: ${e.toString()}')),
                            );
                          }
                        } finally {
                          if (mounted) setState(() => _isPublishing = false);
                        }
                      },
                      text: 'Publish ride',
                      backgroundColor: const Color(0xFFA6EB2E),
                      foregroundColor: Colors.black,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow({required String label, required String value, required IconData icon}) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(icon, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    value,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
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

  Widget _buildSummaryDetail({required IconData icon, required String label, required String value}) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(fontSize: 15, color: Colors.grey, fontWeight: FontWeight.w500),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
