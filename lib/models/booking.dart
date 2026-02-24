import '../enums/booking_status.enum.dart';
import 'ride.dart';

class Booking {
  final String bookingId;
  final dynamic ride; // Can be a String (ID) or a Ride object
  final int seatsReserved;
  final BookingStatus status;
  final double totalAmount;
  final String bookedBy;
  final DateTime bookingDate;

  Booking({
    required this.bookingId,
    required this.ride,
    required this.seatsReserved,
    required this.status,
    required this.totalAmount,
    required this.bookedBy,
    required this.bookingDate,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      bookingId: json['booking_id'],
      ride: json['ride'] is Map<String, dynamic> 
          ? Ride.fromJson(json['ride']) 
          : json['ride'],
      seatsReserved: json['seats_reserved'],
      status: BookingStatus.values.firstWhere(
        (e) => e.name == json['status'], 
        orElse: () => BookingStatus.AWAITING_CONFIRMATION
      ),
      totalAmount: (json['total_amount'] as num).toDouble(),
      bookedBy: json['booked_by'],
      bookingDate: DateTime.parse(json['booking_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'booking_id': bookingId,
      'ride': ride is Ride ? (ride as Ride).toJson() : ride,
      'seats_reserved': seatsReserved,
      'status': status.name,
      'total_amount': totalAmount,
      'booked_by': bookedBy,
      'booking_date': bookingDate.toIso8601String(),
    };
  }

  // Helper getters to safely access ride details
  Ride? get rideDetails => ride is Ride ? ride as Ride : null;
}
