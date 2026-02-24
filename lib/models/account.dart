import 'documents.dart';

class Account {
  final String accountId;
  final int phoneNumber;
  final String firstName;
  final String lastName;
  final String role;
  final bool isActive;
  final bool isVerified;
  final String? profilePicturePath;
  final List<Documents>? documents;
  final DateTime createdAt;
  final DateTime updatedAt;

  Account({
    required this.accountId,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.isActive,
    required this.isVerified,
    this.profilePicturePath,
    this.documents,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      accountId: json['account_id']?.toString() ?? '',
      phoneNumber: json['phone_number'] is int ? json['phone_number'] : (int.tryParse(json['phone_number']?.toString() ?? '0') ?? 0),
      firstName: json['first_name']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? '',
      role: json['role']?.toString() ?? 'PASSENGER',
      isActive: json['is_active'] ?? false,
      isVerified: json['is_verified'] ?? false,
      profilePicturePath: json['profile_picture_path'],
      documents: json['documents'] != null
          ? (json['documents'] as List).map((i) => Documents.fromJson(i)).toList()
          : null,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'account_id': accountId,
      'phone_number': phoneNumber,
      'first_name': firstName,
      'last_name': lastName,
      'role': role,
      'is_active': isActive,
      'is_verified': isVerified,
      'profile_picture_path': profilePicturePath,
      'documents': documents?.map((i) => i.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
