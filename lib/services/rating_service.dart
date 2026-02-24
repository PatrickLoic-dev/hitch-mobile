import 'package:dio/dio.dart';
import '../config/api_client.dart';
import '../config/constants.dart';
import '../models/rating.dart';

class RatingService {
  final ApiClient _apiClient = ApiClient();

  Future<Rating> createRating(Map<String, dynamic> ratingData) async {
    try {
      final response = await _apiClient.dio.post(
        ApiConstants.ratings,
        data: ratingData,
      );
      return Rating.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Rating> getRatingById(int id) async {
    try {
      final response = await _apiClient.dio.get('${ApiConstants.ratings}/$id');
      return Rating.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Rating>> getRatingsByAccount(String accountId) async {
    try {
      final response = await _apiClient.dio.get('${ApiConstants.ratings}/account/$accountId');
      return (response.data as List).map((json) => Rating.fromJson(json)).toList();
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
