import 'package:flutter/material.dart';
import '../models/vehicle.dart';
import '../services/vehicle_service.dart';

class VehicleProvider with ChangeNotifier {
  final VehicleService _vehicleService = VehicleService();
  Vehicle? _vehicle;
  bool _isLoading = false;

  Vehicle? get vehicle => _vehicle;
  bool get isLoading => _isLoading;

  Future<void> loadMyVehicle() async {
    _isLoading = true;
    notifyListeners();
    try {
      _vehicle = await _vehicleService.getMyVehicle();
    } catch (e) {
      print('Error loading vehicle: $e');
      _vehicle = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveVehicle(String accountId, Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();
    try {
      _vehicle = await _vehicleService.addVehicle(accountId, data);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  void setVehicle(Vehicle vehicle) {
    _vehicle = vehicle;
    notifyListeners();
  }
}
