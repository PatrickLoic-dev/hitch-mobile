import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import '../config/api_client.dart';
import '../config/constants.dart';
import '../models/documents.dart';

class DocumentService {
  final ApiClient _apiClient = ApiClient();

  Future<Documents> uploadDocument({
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
      return Documents.fromJson(response.data);
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
      return (response.data as List).map((json) => Documents.fromJson(json)).toList();
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
    if (e.response != null) {
      return Exception(e.response?.data['message'] ?? 'Server error');
    }
    return Exception('Network error');
  }
}
