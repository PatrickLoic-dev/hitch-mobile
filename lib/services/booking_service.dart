import 'package:dio/dio.dart';
import '../config/api_client.dart';
import '../config/constants.dart';
import '../models/booking.dart';

class BookingService {
  final ApiClient _apiClient = ApiClient();

  Future<Booking> createBooking(Map<String, dynamic> bookingData) async {
    try {
      final response = await _apiClient.dio.post(
        ApiConstants.bookings,
        data: bookingData,
      );
      return Booking.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Booking> getBookingById(String id) async {
    try {
      final response = await _apiClient.dio.get('${ApiConstants.bookings}/$id');
      return Booking.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Booking>> getUserBookings() async {
    try {
      final response = await _apiClient.dio.get('${ApiConstants.bookings}/me');
      final data = response.data;

      if (data is List) {
        return data.map((json) => Booking.fromJson(json)).toList();
      } else if (data is Map) {
        if (data['bookings'] is List) {
          return (data['bookings'] as List).map((json) => Booking.fromJson(json)).toList();
        }
        print('getUserBookings: Info/Error received: ${data['message'] ?? data['error']}');
        return [];
      }
      return [];
    } on DioException catch (e) {
      if (e.response?.statusCode == 404 || e.response?.statusCode == 401) {
        return [];
      }
      throw _handleError(e);
    }
  }

  Future<List<Booking>> getBookingsByAccount(String accountId) async {
    try {
      final response = await _apiClient.dio.get('${ApiConstants.bookings}/account/$accountId');
      final data = response.data;
      if (data is List) {
        return data.map((json) => Booking.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return [];
      throw _handleError(e);
    }
  }

  Future<Booking> updateBooking(String id, Map<String, dynamic> bookingData) async {
    try {
      final response = await _apiClient.dio.put(
        '${ApiConstants.bookings}/$id',
        data: bookingData,
      );
      return Booking.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> cancelBooking(String id) async {
    try {
      await _apiClient.dio.delete('${ApiConstants.bookings}/$id');
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
