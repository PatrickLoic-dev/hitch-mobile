class Ride {
  final String rideId;
  final String startingLocation;
  final String destination;
  final double price;
  final String vehicle;
  final int seats;
  final DateTime departureTime;
  final double distance;
  final String createdBy;
  final DateTime createdAt;

  Ride({
    required this.rideId,
    required this.startingLocation,
    required this.destination,
    required this.price,
    required this.vehicle,
    required this.seats,
    required this.departureTime,
    required this.distance,
    required this.createdBy,
    required this.createdAt,
  });

  factory Ride.fromJson(Map<String, dynamic> json) {
    return Ride(
      rideId: json['ride_id'],
      startingLocation: json['starting_location'],
      destination: json['destination'],
      price: (json['price'] as num).toDouble(),
      vehicle: json['vehicle'],
      seats: json['seats'],
      departureTime: DateTime.parse(json['departure_time']),
      distance: (json['distance'] as num).toDouble(),
      createdBy: json['created_By'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ride_id': rideId,
      'starting_location': startingLocation,
      'destination': destination,
      'price': price,
      'vehicle': vehicle,
      'seats': seats,
      'departure_time': departureTime.toIso8601String(),
      'distance': distance,
      'created_By': createdBy,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
