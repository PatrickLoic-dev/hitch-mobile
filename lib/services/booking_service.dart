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
      // Assuming the backend returns the current user's bookings based on the token
      final response = await _apiClient.dio.get('${ApiConstants.bookings}/me');
      return (response.data as List).map((json) => Booking.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Booking>> getBookingsByAccount(String accountId) async {
    try {
      final response = await _apiClient.dio.get('${ApiConstants.bookings}/account/$accountId');
      return (response.data as List).map((json) => Booking.fromJson(json)).toList();
    } on DioException catch (e) {
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
    if (e.response != null) {
      return Exception(e.response?.data['message'] ?? 'Server error');
    }
    return Exception('Network error');
  }
}
