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
      rideId: json['ride_id']?.toString() ?? '',
      startingLocation: json['starting_location']?.toString() ?? '',
      destination: json['destination']?.toString() ?? '',
      price: (json['price'] is String) 
          ? double.tryParse(json['price']) ?? 0.0 
          : (json['price'] as num?)?.toDouble() ?? 0.0,
      vehicle: json['vehicle']?.toString() ?? '',
      seats: (json['seats'] is String) 
          ? int.tryParse(json['seats']) ?? 0 
          : (json['seats'] as num?)?.toInt() ?? 0,
      departureTime: json['departure_time'] != null 
          ? DateTime.parse(json['departure_time']) 
          : DateTime.now(),
      distance: (json['distance'] is String) 
          ? double.tryParse(json['distance']) ?? 0.0 
          : (json['distance'] as num?)?.toDouble() ?? 0.0,
      createdBy: json['created_By']?.toString() ?? '',
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
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
