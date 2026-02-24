import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import '../config/api_client.dart';
import '../config/constants.dart';
import '../models/ride.dart';

class RideService {
  final ApiClient _apiClient = ApiClient();

  Future<Ride> createRide(Map<String, dynamic> rideData) async {
    try {
      print('Sending ride data: $rideData');
      final response = await _apiClient.dio.post(
        ApiConstants.rides,
        data: rideData,
      );
      
      print('Server response status: ${response.statusCode}');
      final data = response.data;
      
      if (data is List && data.isNotEmpty) {
        return Ride.fromJson(data[0] as Map<String, dynamic>);
      } else if (data is Map) {
        return Ride.fromJson(data as Map<String, dynamic>);
      } else {
        throw Exception("Invalid response format: Expected Map or List but got ${data.runtimeType}");
      }
    } on DioException catch (e) {
      print('Dio error in createRide: ${e.message}');
      if (e.response != null) {
        print('Response status: ${e.response?.statusCode}');
        print('Response data: ${e.response?.data}');
      }
      throw _handleError(e);
    } catch (e) {
      print('Unexpected error in createRide: $e');
      rethrow;
    }
  }

  Future<List<Ride>> getMyRides() async {
    try {
      final response = await _apiClient.dio.get('${ApiConstants.rides}/my-rides');
      final data = response.data;
      
      print('getMyRides status: ${response.statusCode}');
      print('getMyRides data: $data');

      if (data is List) {
        return data.map((json) => Ride.fromJson(json)).toList();
      } else if (data is Map) {
        if (data['rides'] is List) {
          return (data['rides'] as List).map((json) => Ride.fromJson(json)).toList();
        }
        print('getMyRides: Info/Error received: ${data['message'] ?? data['info'] ?? data['error']}');
        return [];
      }
      return [];
    } on DioException catch (e) {
      if (e.response?.statusCode == 404 || e.response?.statusCode == 401) {
        print('getMyRides failure: ${e.response?.statusCode}');
        return [];
      }
      throw _handleError(e);
    }
  }

  Future<List<Ride>> searchRides({
    required String startingLocation,
    required String destination,
    required DateTime departureTime,
  }) async {
    final queryParams = {
      'starting_location': startingLocation,
      'destination': destination,
      'departure_time': DateFormat('yyyy-MM-dd').format(departureTime),
    };
    
    try {
      print('Searching rides with params: $queryParams');
      final response = await _apiClient.dio.get(
        '${ApiConstants.rides}/search',
        queryParameters: queryParams,
      );
      
      print('Search rides status: ${response.statusCode}');
      print('Search rides data: ${response.data}');
      
      final data = response.data;
      if (data is List) {
        return data.map((json) => Ride.fromJson(json)).toList();
      } else if (data is Map && data['rides'] is List) {
        return (data['rides'] as List).map((json) => Ride.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      print('Dio error in searchRides: ${e.message}');
      if (e.response != null) {
        print('Response status: ${e.response?.statusCode}');
        print('Response data: ${e.response?.data}');
      }
      if (e.response?.statusCode == 404) return [];
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
      
      final data = response.data;
      if (data is List) {
        return data.map((json) => Ride.fromJson(json)).toList();
      } else if (data is Map && data['rides'] is List) {
        return (data['rides'] as List).map((json) => Ride.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return [];
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
    String message = 'Server error';
    if (e.response != null) {
      final data = e.response?.data;
      if (data is Map) {
        message = data['message'] ?? data['error'] ?? 'Server error';
      } else if (data is String && data.isNotEmpty) {
        message = data;
      }
    } else {
      message = 'Network error: ${e.message}';
    }
    return Exception(message);
  }
}
