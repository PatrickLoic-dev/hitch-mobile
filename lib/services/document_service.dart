import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import '../config/api_client.dart';
import '../config/constants.dart';
import '../models/documents.dart';

class DocumentService {
  final ApiClient _apiClient = ApiClient();

  Future<Documents?> uploadDocument({
    required String filePath,
    required String documentName,
    required String accountId,
    required String fileType,
    required DateTime issueDate,
  }) async {
    try {
      String fileName = filePath.split('/').last;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(filePath, filename: fileName),
        "document_name": documentName,
        "accountId": accountId,
        "file_type": fileType,
        "issue_date": DateFormat('yyyy-MM-dd').format(issueDate),
      });

      final response = await _apiClient.dio.post(
        ApiConstants.documents,
        data: formData,
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        return Documents.fromJson(data);
      } else if (data is List && data.isNotEmpty) {
        return Documents.fromJson(data[0] as Map<String, dynamic>);
      }
      
      return null;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Documents> getDocumentById(String id) async {
    try {
      final response = await _apiClient.dio.get('${ApiConstants.documents}/$id');
      return Documents.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Documents>> getDocumentsByAccount(String accountId) async {
    try {
      final response = await _apiClient.dio.get('${ApiConstants.documents}/account/$accountId');
      final data = response.data;
      if (data is List) {
        return data.map((json) => Documents.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Documents> updateDocumentStatus(String id, String status) async {
    try {
      final response = await _apiClient.dio.put(
        '${ApiConstants.documents}/$id',
        data: {'status': status},
      );
      return Documents.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deleteDocument(String id) async {
    try {
      await _apiClient.dio.delete('${ApiConstants.documents}/$id');
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
      print('DocumentService Error Response: $data');
    } else {
      message = 'Network error: ${e.message}';
    }
    return Exception(message);
  }
}
