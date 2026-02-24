class Vehicle {
  final String registration;
  final String model;
  final int seatNumber;
  final String color;
  final int registrationNumber;
  final String comfort;
  final String owner;

  Vehicle({
    required this.registration,
    required this.model,
    required this.seatNumber,
    required this.color,
    required this.registrationNumber,
    required this.comfort,
    required this.owner,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      registration: json['registration'],
      model: json['model'],
      seatNumber: json['seat_number'],
      color: json['color'],
      registrationNumber: json['registration_number'],
      comfort: json['comfort'],
      owner: json['owner'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'registration': registration,
      'model': model,
      'seat_number': seatNumber,
      'color': color,
      'registration_number': registrationNumber,
      'comfort': comfort,
      'owner': owner,
    };
  }
}
