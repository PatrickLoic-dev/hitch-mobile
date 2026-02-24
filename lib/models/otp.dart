class OTP {
  final String otpId;
  final int phoneNumber;
  final String otpCode;
  final DateTime createdAt;
  final DateTime expiresAt;
  final bool verified;
  final String purpose;

  OTP({
    required this.otpId,
    required this.phoneNumber,
    required this.otpCode,
    required this.createdAt,
    required this.expiresAt,
    required this.verified,
    required this.purpose,
  });

  factory OTP.fromJson(Map<String, dynamic> json) {
    return OTP(
      otpId: json['otp_id'],
      phoneNumber: json['phone_number'],
      otpCode: json['otp_code'],
      createdAt: DateTime.parse(json['created_at']),
      expiresAt: DateTime.parse(json['expires_at']),
      verified: json['verified'],
      purpose: json['purpose'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'otp_id': otpId,
      'phone_number': phoneNumber,
      'otp_code': otpCode,
      'created_at': createdAt.toIso8601String(),
      'expires_at': expiresAt.toIso8601String(),
      'verified': verified,
      'purpose': purpose,
    };
  }
}
