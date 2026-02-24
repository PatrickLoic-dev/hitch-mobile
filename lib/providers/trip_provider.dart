import 'package:flutter/material.dart';
import '../models/booking.dart';
import '../models/ride.dart';
import '../services/booking_service.dart';
import '../services/ride_service.dart';

class TripProvider with ChangeNotifier {
  final BookingService _bookingService = BookingService();
  final RideService _rideService = RideService();

  List<Booking> _bookings = [];
  List<Ride> _publishedRides = [];
  bool _isLoading = false;

  List<Booking> get bookings => _bookings;
  List<Ride> get publishedRides => _publishedRides;
  bool get isLoading => _isLoading;

  // Booked rides (Passenger context)
  List<Booking> get upcomingBookings => _bookings.where((b) => b.status.name == 'CONFIRMED' || b.status.name == 'AWAITING_CONFIRMATION').toList();
  List<Booking> get pastBookings => _bookings.where((b) => b.status.name == 'COMPLETED' || b.status.name == 'CANCELLED').toList();

  // Published rides (Driver context)
  List<Ride> get upcomingPublishedRides => _publishedRides.where((r) => r.departureTime.isAfter(DateTime.now())).toList();
  List<Ride> get pastPublishedRides => _publishedRides.where((r) => r.departureTime.isBefore(DateTime.now())).toList();

  List<Booking> get activeTrips => _bookings.where((b) => b.status.name == 'ON_TRIP').toList();

  Future<void> fetchTrips() async {
    _isLoading = true;
    notifyListeners();
    try {
      // Fetch both bookings and published rides in parallel
      final results = await Future.wait([
        _bookingService.getUserBookings(),
        _rideService.getMyRides(),
      ]);
      
      _bookings = results[0] as List<Booking>;
      _publishedRides = results[1] as List<Ride>;
    } catch (e) {
      print('Error fetching trips: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
