import 'package:dio/dio.dart';
import '../config/api_client.dart';
import '../config/constants.dart';
import '../models/account.dart';

class AccountService {
  final ApiClient _apiClient = ApiClient();

  Future<Account> getAccountById(String id) async {
    try {
      final response = await _apiClient.dio.get('${ApiConstants.accounts}/$id');
      return Account.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Account> updateAccount(Map<String, dynamic> accountData) async {
    try {
      final response = await _apiClient.dio.post(
        ApiConstants.accounts,
        data: accountData,
      );
      return Account.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deactivateAccount(String id) async {
    try {
      await _apiClient.dio.put('${ApiConstants.accounts}/$id/deactivate');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> verifyAccount(String id) async {
    try {
      await _apiClient.dio.put('${ApiConstants.accounts}/$id/verify');
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
