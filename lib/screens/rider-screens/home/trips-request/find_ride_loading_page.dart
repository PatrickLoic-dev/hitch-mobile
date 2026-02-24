import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Hitch/providers/trip_request_provider.dart';
import 'package:Hitch/services/ride_service.dart';
import 'package:Hitch/screens/rider-screens/home/trips-request/search_results_page.dart';

class FindRideLoadingPage extends StatefulWidget {
  const FindRideLoadingPage({super.key});

  @override
  State<FindRideLoadingPage> createState() => _FindRideLoadingPageState();
}

class _FindRideLoadingPageState extends State<FindRideLoadingPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _performSearch();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _performSearch() async {
    final tripProvider = Provider.of<TripRequestProvider>(context, listen: false);
    final rideService = RideService();

    try {
      final rides = await rideService.searchRides(
        startingLocation: tripProvider.departure!.mainText,
        destination: tripProvider.destination!.mainText,
        departureTime: tripProvider.dateTime!,
      );

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => SearchResultsPage(rides: rides),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
        Navigator.of(context).pop();
      }
    }
  }

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return _PulsingCircle(controller: _controller, index: index);
              }),
            ),
            const SizedBox(height: 40),
            const Text(
              'Looking for\nrides near you',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Jokker',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PulsingCircle extends StatelessWidget {
  final AnimationController controller;
  final int index;

  const _PulsingCircle({required this.controller, required this.index});

  @override
  Widget build(BuildContext context) {
    final double delay = index * 0.2;
    final Animation<double> animation = CurvedAnimation(
      parent: controller,
      curve: Interval(delay, 0.6 + delay, curve: Curves.easeInOut),
    );

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        double scale = 1.0;
        double opacity = 0.3;

        // Use index to vary the baseline size
        double baseRadius = (index == 1) ? 8.0 : 4.0;

        // Apply wave effect
        if (controller.value >= delay && controller.value <= 0.6 + delay) {
          scale = 1.0 + (animation.value * 0.5);
          opacity = 0.3 + (animation.value * 0.7);
        }

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: baseRadius * 2 * scale,
          height: baseRadius * 2 * scale,
          decoration: BoxDecoration(
            color: const Color(0xFFA6EB2E).withOpacity(opacity.clamp(0.0, 1.0)),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}
