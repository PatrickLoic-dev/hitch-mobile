import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:Hitch/components/button.dart';
import 'package:Hitch/providers/trip_request_provider.dart';
import 'package:Hitch/screens/driver-screens/offer-ride/ride_summary_page.dart';

class SetPricePage extends StatefulWidget {
  const SetPricePage({super.key});

  @override
  State<SetPricePage> createState() => _SetPricePageState();
}

class _SetPricePageState extends State<SetPricePage> {
  final TextEditingController _priceController = TextEditingController(text: '750');

  @override
  Widget build(BuildContext context) {
    final tripProvider = Provider.of<TripRequestProvider>(context);
    final DateFormat formatter = DateFormat('EEE d MMM • hh:mm a');
    final String tripInfo = tripProvider.dateTime != null 
        ? "${formatter.format(tripProvider.dateTime!)} • ${tripProvider.seatCount} Seats"
        : "";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  tripProvider.departure?.mainText ?? '',
                  style: const TextStyle(color: Colors.orange, fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_forward, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  tripProvider.destination?.mainText ?? '',
                  style: const TextStyle(color: Colors.orange, fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Text(
              tripInfo,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Set your price per seat',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Jokker',
              ),
            ),
            const SizedBox(height: 60),
            Center(
              child: IntrinsicWidth(
                child: TextField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Jokker',
                  ),
                  decoration: const InputDecoration(
                    prefixText: 'XAF ',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.campaign, color: Colors.orange, size: 32),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tip',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
                        ),
                        const Text(
                          'Recommended price: XAF 500 - XAF 750',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Perfect price for this ride! You’ll get passengers in no time.',
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: Button(
                onPressed: () {
                  final price = double.tryParse(_priceController.text) ?? 0.0;
                  tripProvider.setPrice(price);
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const RideSummaryPage()),
                  );
                },
                text: 'Next',
                backgroundColor: const Color(0xFFA6EB2E),
                foregroundColor: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
