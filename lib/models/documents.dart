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
      documentId: json['document_id']?.toString() ?? '',
      documentName: json['document_name']?.toString() ?? '',
      filePath: json['filePath']?.toString() ?? '',
      fileType: json['file_type']?.toString() ?? '',
      status: DocumentStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => DocumentStatus.PENDING,
      ),
      account: Account.fromJson(json['account'] ?? {}),
      issueDate: json['issue_date'] != null 
          ? DateTime.parse(json['issue_date']) 
          : DateTime.now(),
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
