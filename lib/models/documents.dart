import '../enums/document_status.enum.dart';
import 'account.dart';

class Documents {
  final String documentId;
  final String documentName;
  final String filePath;
  final String fileType;
  final DocumentStatus status;
  final Account account;
  final DateTime issueDate;

  Documents({
    required this.documentId,
    required this.documentName,
    required this.filePath,
    required this.fileType,
    required this.status,
    required this.account,
    required this.issueDate,
  });

  factory Documents.fromJson(Map<String, dynamic> json) {
    return Documents(
      documentId: json['document_id'],
      documentName: json['document_name'],
      filePath: json['filePath'],
      fileType: json['file_type'],
      status: DocumentStatus.values.firstWhere((e) => e.name == json['status']),
      account: Account.fromJson(json['account']),
      issueDate: DateTime.parse(json['issue_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'document_id': documentId,
      'document_name': documentName,
      'filePath': filePath,
      'file_type': fileType,
      'status': status.name,
      'account': account.toJson(),
      'issue_date': issueDate.toIso8601String(),
    };
  }
}
