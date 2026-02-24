import 'package:dio/dio.dart';
import '../config/api_client.dart';
import '../config/constants.dart';
import '../models/message.dart';

class MessageService {
  final ApiClient _apiClient = ApiClient();

  Future<List<Message>> getConversation(String senderId, String receiverId) async {
    try {
      final response = await _apiClient.dio.post(
        '${ApiConstants.messages}/conversation',
        data: {
          'sender_id': senderId,
          'receiver_id': receiverId,
        },
      );
      return (response.data as List).map((json) => Message.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Message> sendMessage(Map<String, dynamic> messageData) async {
    try {
      final response = await _apiClient.dio.post(
        ApiConstants.messages,
        data: messageData,
      );
      return Message.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Message> markAsRead(int id) async {
    try {
      final response = await _apiClient.dio.put('${ApiConstants.messages}/$id/read');
      return Message.fromJson(response.data);
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
