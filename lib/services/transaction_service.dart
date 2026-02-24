import 'package:dio/dio.dart';
import '../config/api_client.dart';
import '../config/constants.dart';
import '../models/transaction.dart';

class TransactionService {
  final ApiClient _apiClient = ApiClient();

  Future<Transaction> createTransaction(Map<String, dynamic> transactionData) async {
    try {
      final response = await _apiClient.dio.post(
        ApiConstants.transactions,
        data: transactionData,
      );
      return Transaction.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Transaction> getTransactionById(String id) async {
    try {
      final response = await _apiClient.dio.get('${ApiConstants.transactions}/$id');
      return Transaction.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Transaction>> getAccountTransactions(String accountId) async {
    try {
      final response = await _apiClient.dio.get('${ApiConstants.transactions}/account/$accountId');
      return (response.data as List).map((json) => Transaction.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Transaction>> getTransactionsByType(String type) async {
    try {
      final response = await _apiClient.dio.get('${ApiConstants.transactions}/type/$type');
      return (response.data as List).map((json) => Transaction.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Transaction> updateTransaction(String id, Map<String, dynamic> transactionData) async {
    try {
      final response = await _apiClient.dio.put(
        '${ApiConstants.transactions}/$id',
        data: transactionData,
      );
      return Transaction.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deleteTransaction(String id) async {
    try {
      await _apiClient.dio.delete('${ApiConstants.transactions}/$id');
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
