import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:Hitch/models/ride.dart';
import 'package:Hitch/models/account.dart';
import 'package:Hitch/components/button.dart';
import 'package:Hitch/providers/auth_provider.dart';
import 'package:Hitch/providers/trip_provider.dart';
import 'package:Hitch/providers/trip_request_provider.dart';
import 'package:Hitch/services/booking_service.dart';
import 'package:Hitch/services/ride_service.dart';
import 'package:Hitch/services/account_service.dart';
import 'package:Hitch/navigation/main_shell.dart';
import 'package:Hitch/screens/rider-screens/home/trips-request/payment_methods_page.dart';

class BookRidePage extends StatefulWidget {
  final Ride ride;

  const BookRidePage({super.key, required this.ride});

  @override
  State<BookRidePage> createState() => _BookRidePageState();
}

class _BookRidePageState extends State<BookRidePage> {
  int _selectedSeats = 1;
  bool _isRoundTrip = false;
  Account? _driver;
  final AccountService _accountService = AccountService();
  final RideService _rideService = RideService();

  @override
  void initState() {
    super.initState();
    final tripRequest = Provider.of<TripRequestProvider>(context, listen: false);
    _selectedSeats = tripRequest.seatCount ?? 1;
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

  void _showSeatPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _SeatSelectionModal(
        maxSeats: widget.ride.seats,
        initialSeats: _selectedSeats,
        onConfirm: (val) => setState(() => _selectedSeats = val),
      ),
    );
  }

  void _confirmBooking() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _GoldenRulesModal(
        onAccept: () {
          Navigator.of(ctx).pop();
          _processBooking();
        },
      ),
    );
  }

  Future<void> _processBooking() async {
    final bookingService = BookingService();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const _BookingWaitModal(),
    );

    try {
      // Format date strictly as YYYY-MM-DD to match @Temporal(TemporalType.DATE)
      final String dateOnly = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final String nowIso = DateTime.now().toIso8601String();
      
      // Sending every possible naming variation to force the backend to map correctly
      final bookingData = {
        "ride": widget.ride.rideId,
        "seats_reserved": _selectedSeats,
        "seatsReserved": _selectedSeats,
        "status": "AWAITING_CONFIRMATION",
        "total_amount": widget.ride.price * _selectedSeats,
        "totalAmount": widget.ride.price * _selectedSeats,
        "booked_by": authProvider.user?.accountId,
        "bookedBy": authProvider.user?.accountId,
        "booking_date": dateOnly,
        "bookingDate": dateOnly,
      };

      print('Sending aligned booking data: ${json.encode(bookingData)}');
      await bookingService.createBooking(bookingData);
      
      // Update Ride Seats
      final int remainingSeats = widget.ride.seats - _selectedSeats;
      final updateRideData = {
        "starting_location": widget.ride.startingLocation,
        "destination": widget.ride.destination,
        "price": widget.ride.price,
        "vehicle": widget.ride.vehicle,
        "seats": remainingSeats,
        "departure_time": widget.ride.departureTime.toIso8601String(),
        "distance": widget.ride.distance,
      };
      
      await _rideService.updateRide(widget.ride.rideId, updateRideData);

      if (mounted) {
        Navigator.of(context).pop(); 
        
        showModalBottomSheet(
          context: context,
          isDismissible: false,
          backgroundColor: Colors.transparent,
          builder: (ctx) => const _BookingConfirmModal(),
        );

        Provider.of<TripProvider>(context, listen: false).fetchTrips();
        Timer(const Duration(seconds: 3), () {
          if (mounted) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const MainShell()),
              (route) => false,
            );
          }
        });
      }
    } catch (e) {
      print('CRITICAL ERROR during booking flow: $e');
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double totalPrice = widget.ride.price * _selectedSeats;
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
          'BOOK RIDE',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1.2, fontFamily: 'Jokker'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 140),
        child: Column(
          children: [
            _buildBookingCard(
              title: 'Departure',
              children: [
                _buildSummaryRow(label: 'FROM', value: widget.ride.startingLocation),
                _buildSummaryRow(label: 'TO', value: widget.ride.destination),
                const Divider(height: 32),
                _buildInfoRow(icon: Icons.access_time, label: 'Depart', value: timeFormatter.format(widget.ride.departureTime)),
                _buildClickableRow(
                  icon: Icons.person_outline,
                  label: 'Seats',
                  value: '$_selectedSeats',
                  onTap: _showSeatPicker,
                ),
                _buildSwitchRow(
                  icon: Icons.sync,
                  label: 'Round trip',
                  value: _isRoundTrip,
                  onChanged: (val) => setState(() => _isRoundTrip = val),
                ),
              ],
            ),
            if (_isRoundTrip) ...[
              const SizedBox(height: 20),
              _buildBookingCard(
                title: 'Return',
                children: [
                  _buildSummaryRow(label: 'PICK UP', value: widget.ride.destination),
                  _buildSummaryRow(label: 'DROP OFF', value: widget.ride.startingLocation),
                  const Divider(height: 32),
                  _buildInfoRow(icon: Icons.access_time, label: 'Return', value: '06:00 PM'),
                ],
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4))],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const PaymentMethodsPage()),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.credit_card, color: Colors.orange, size: 24),
                      const SizedBox(width: 8),
                      const Text('•••• 5678', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Jokker')),
                      const Icon(Icons.chevron_right, color: Colors.grey),
                    ],
                  ),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Total price', style: TextStyle(color: Colors.grey, fontSize: 12, fontFamily: 'Jokker')),
                    Text('XAF ${totalPrice.toStringAsFixed(0)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange, fontFamily: 'Jokker')),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: Button(
                onPressed: _confirmBooking,
                text: 'Confirm',
                backgroundColor: const Color(0xFFA6EB2E),
                foregroundColor: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingCard({required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Jokker')),
        const SizedBox(height: 20),
        ...children,
      ]),
    );
  }

  Widget _buildSummaryRow({required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(children: [
        SizedBox(width: 60, child: Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold, fontFamily: 'Jokker'))),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8)),
            child: Row(children: [
              const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
              const SizedBox(width: 8),
              Expanded(child: Text(value, style: const TextStyle(fontSize: 13, fontFamily: 'Jokker'), overflow: TextOverflow.ellipsis)),
            ]),
          ),
        ),
      ]),
    );
  }

  Widget _buildInfoRow({required IconData icon, required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 12),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Jokker')),
        const Spacer(),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Jokker')),
      ]),
    );
  }

  Widget _buildClickableRow({required IconData icon, required String label, required String value, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Jokker')),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
            child: Row(children: [
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Jokker')),
              const Icon(Icons.keyboard_arrow_down, size: 16),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _buildSwitchRow({required IconData icon, required String label, required bool value, required ValueChanged<bool> onChanged}) {
    return Row(children: [
      Icon(icon, size: 20, color: Colors.grey),
      const SizedBox(width: 12),
      Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'Jokker')),
      const Spacer(),
      Switch(value: value, onChanged: onChanged, activeColor: const Color(0xFFA6EB2E)),
    ]);
  }
}

class _SeatSelectionModal extends StatefulWidget {
  final int maxSeats;
  final int initialSeats;
  final ValueChanged<int> onConfirm;

  const _SeatSelectionModal({required this.maxSeats, required this.initialSeats, required this.onConfirm});

  @override
  State<_SeatSelectionModal> createState() => _SeatSelectionModalState();
}

class _SeatSelectionModalState extends State<_SeatSelectionModal> {
  late int _count;

  @override
  void initState() {
    super.initState();
    _count = widget.initialSeats;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Text('How many seats would you like?', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Jokker'), textAlign: TextAlign.center),
        const SizedBox(height: 40),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          _buildBtn(Icons.remove, _count > 1 ? () => setState(() => _count--): null),
          SizedBox(width: 100, child: Text('$_count', textAlign: TextAlign.center, style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold, fontFamily: 'Jokker'))),
          _buildBtn(Icons.add, _count < widget.maxSeats ? () => setState(() => _count++) : null),
        ]),
        const SizedBox(height: 40),
        SizedBox(width: double.infinity, child: Button(onPressed: () { widget.onConfirm(_count); Navigator.pop(context); }, text: 'Confirm')),
      ]),
    );
  }

  Widget _buildBtn(IconData icon, VoidCallback? onTap) {
    return GestureDetector(onTap: onTap, child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)), child: Icon(icon, size: 32, color: onTap == null ? Colors.grey : Colors.black)));
  }
}

class _GoldenRulesModal extends StatelessWidget {
  final VoidCallback onAccept;
  const _GoldenRulesModal({required this.onAccept});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      child: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Center(child: Text('Trip Golden Rules', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Jokker'))),
          const SizedBox(height: 32),
          _rule(Icons.timer_outlined, 'Be Punctual', 'Arrive on time at the designated pick-up location. Being late can inconvenience other passengers.'),
          _rule(Icons.cleaning_services_outlined, 'Keep the Car Clean', 'Avoid leaving trash or making a mess in the car. Treat the vehicle as you would your own.'),
          _rule(Icons.volume_up_outlined, 'Be Courteous', 'Practice good etiquette during the ride. Avoid being overly loud, offensive, or intrusive.'),
          _rule(Icons.money_off_outlined, 'No Cash', 'Avoid offering or accepting cash payments for rides booked through the app.'),
          _rule(Icons.event_available_outlined, 'Be Reliable', 'If you need to make changes to the route, discuss it with the driver and other passengers.'),
          const SizedBox(height: 32),
          Row(children: [
            Expanded(child: Button(onPressed: onAccept, text: 'Accept')),
            const SizedBox(width: 16),
            Expanded(child: TextButton(onPressed: () => Navigator.pop(context), child: const Text('Decline', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontFamily: 'Jokker')))),
          ]),
          const SizedBox(height: 12),
          const Center(child: Text('By accepting you agree to Hitch\'s Terms of Use and Privacy Policy', style: TextStyle(fontSize: 10, color: Colors.grey, fontFamily: 'Jokker'), textAlign: TextAlign.center)),
        ]),
      ),
    );
  }

  Widget _rule(IconData icon, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: Colors.blueAccent, size: 28),
        const SizedBox(width: 16),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Jokker')),
          Text(desc, style: const TextStyle(color: Colors.grey, fontSize: 13, fontFamily: 'Jokker')),
        ])),
      ]),
    );
  }
}

class _BookingWaitModal extends StatelessWidget {
  const _BookingWaitModal();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const CircularProgressIndicator(color: Color(0xFFA6EB2E)),
          const SizedBox(height: 24),
          const Text('Please wait', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Jokker')),
        ]),
      ),
    );
  }
}

class _BookingConfirmModal extends StatelessWidget {
  const _BookingConfirmModal();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.check_circle_outline, color: Color(0xFF00C537), size: 80),
        const SizedBox(height: 24),
        const Text('Booking Confirmed', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Jokker')),
        const SizedBox(height: 12),
        const Text('We’d let you know when your booking is accepted by the driver.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Jokker')),
        const SizedBox(height: 32),
      ]),
    );
  }
}
