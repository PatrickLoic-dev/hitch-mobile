import 'package:flutter/material.dart';
import '../models/booking.dart';
import '../services/booking_service.dart';

class TripProvider with ChangeNotifier {
  final BookingService _bookingService = BookingService();

  List<Booking> _trips = [];
  bool _isLoading = false;

  List<Booking> get trips => _trips;
  bool get isLoading => _isLoading;

  List<Booking> get upcomingTrips => _trips.where((trip) => trip.status == 'CONFIRMED').toList();
  List<Booking> get pastTrips => _trips.where((trip) => trip.status == 'COMPLETED').toList();
  List<Booking> get cancelledTrips => _trips.where((trip) => trip.status == 'CANCELLED').toList();

  Future<void> fetchTrips() async {
    _isLoading = true;
    notifyListeners();
    try {
      _trips = await _bookingService.getUserBookings();
    } catch (e) {
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
