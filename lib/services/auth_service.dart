import 'package:dio/dio.dart';
import '../config/api_client.dart';
import '../config/constants.dart';
import '../models/account.dart';
import '../providers/auth_provider.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();

  Future<Map<String, dynamic>> sendRegisterOtp(int phoneNumber) async {
    try {
      final response = await _apiClient.dio.post(
        ApiConstants.registerSendOtp,
        data: {'phone_number': phoneNumber},
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> register({
    required int phoneNumber,
    required String otpCode,
    required String firstName,
    required String lastName,
    required String role,
    String? profilePicturePath,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'phone_number': phoneNumber,
        'otp_code': otpCode,
        'first_name': firstName,
        'last_name': lastName,
        'role': role,
      });

      if (profilePicturePath != null && profilePicturePath.isNotEmpty) {
        formData.files.add(MapEntry(
          'profile_picture',
          await MultipartFile.fromFile(profilePicturePath),
        ));
      }

      final response = await _apiClient.dio.post(
        ApiConstants.register,
        data: formData,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> sendLoginOtp(int phoneNumber) async {
    try {
      final response = await _apiClient.dio.post(
        ApiConstants.loginSendOtp,
        data: {'phone_number': phoneNumber},
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> login(int phoneNumber, String otpCode) async {
    try {
      final response = await _apiClient.dio.post(
        ApiConstants.login,
        data: {
          'phone_number': phoneNumber,
          'otp_code': otpCode,
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Account?> validateToken() async {
    try {
      final response = await _apiClient.dio.get(ApiConstants.validateToken);
      if (response.data['valid'] == true) {
        return Account.fromJson(response.data['account']);
      }
      return null;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    if (e.response != null) {
      final errorData = e.response?.data;
      final message = (errorData is Map) 
          ? (errorData['error'] ?? errorData['message'] ?? 'Server error')
          : 'Server error';
      
      final msgStr = message.toString().toLowerCase();
      
      if (e.response?.statusCode == 409 || msgStr.contains('already exists')) {
        return AccountExistsException(message.toString());
      }
      
      if (e.response?.statusCode == 404 || msgStr.contains('not found') || msgStr.contains('does not exist')) {
        return AccountNotFoundException(message.toString());
      }
      
      return Exception(message.toString());
    }
    return Exception('Network error');
  }
}
