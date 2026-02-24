import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import '../config/api_client.dart';
import '../config/constants.dart';
import '../models/ride.dart';

class RideService {
  final ApiClient _apiClient = ApiClient();

  Future<Ride> createRide(Map<String, dynamic> rideData) async {
    try {
      final response = await _apiClient.dio.post(
        ApiConstants.rides,
        data: rideData,
      );
      return Ride.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Ride>> searchRides({
    required String startingLocation,
    required String destination,
    required double price,
    required int seats,
    required DateTime departureTime,
  }) async {
    try {
      final response = await _apiClient.dio.get(
        '${ApiConstants.rides}/search',
        queryParameters: {
          'starting_location': startingLocation,
          'destination': destination,
          'price': price,
          'seats': seats,
          'departure_time': DateFormat('yyyy-MM-dd').format(departureTime),
        },
      );
      return (response.data as List).map((json) => Ride.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Ride> getRideById(String id) async {
    try {
      final response = await _apiClient.dio.get('${ApiConstants.rides}/$id');
      return Ride.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Ride>> getAllRides({int? page, int? size}) async {
    try {
      final response = await _apiClient.dio.get(
        ApiConstants.rides,
        queryParameters: {
          if (page != null) 'page': page,
          if (size != null) 'size': size,
        },
      );
      return (response.data as List).map((json) => Ride.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Ride> updateRide(String id, Map<String, dynamic> rideData) async {
    try {
      final response = await _apiClient.dio.put(
        '${ApiConstants.rides}/$id',
        data: rideData,
      );
      return Ride.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deleteRide(String id) async {
    try {
      await _apiClient.dio.delete('${ApiConstants.rides}/$id');
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
