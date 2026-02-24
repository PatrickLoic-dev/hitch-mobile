import 'package:dio/dio.dart';
import '../config/api_client.dart';
import '../config/constants.dart';
import '../models/vehicle.dart';

class VehicleService {
  final ApiClient _apiClient = ApiClient();

  Future<Vehicle> addVehicle(String accountId, Map<String, dynamic> vehicleData) async {
    try {
      final response = await _apiClient.dio.post(
        ApiConstants.vehicles,
        queryParameters: {'accountId': accountId},
        data: vehicleData,
      );
      return Vehicle.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Vehicle> getVehicleById(String id) async {
    try {
      final response = await _apiClient.dio.get('${ApiConstants.vehicles}/$id');
      return Vehicle.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Vehicle> updateVehicle(String id, Map<String, dynamic> vehicleData) async {
    try {
      final response = await _apiClient.dio.put(
        '${ApiConstants.vehicles}/$id',
        data: vehicleData,
      );
      return Vehicle.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deleteVehicle(String id) async {
    try {
      await _apiClient.dio.delete('${ApiConstants.vehicles}/$id');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    if (e.response != null) {
      return Exception(e.response?.data['message'] ?? 'Server error');
    }
    return Exception('Network error');
  }
}
