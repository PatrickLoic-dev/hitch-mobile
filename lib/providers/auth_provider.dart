import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/account.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  
  // Consistent storage with Android-specific options
  final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  Account? _user;
  bool _isLoggedIn = false;
  bool _isLoading = false;

  // Temporary registration data
  int? _regPhoneNumber;
  String? _regOtpCode;
  String? _regFirstName;
  String? _regLastName;
  String? _regGender;
  String? _regProfilePicture;

  Account? get user => _user;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;

  AuthProvider() {
    _loadUser();
  }

  Future<void> _loadUser() async {
    _isLoading = true;
    notifyListeners();
    try {
      final account = await _authService.validateToken();
      if (account != null) {
        _user = account;
        _isLoggedIn = true;
      }
    } catch (e) {
      _isLoggedIn = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setRegistrationPhone(int phoneNumber) {
    _regPhoneNumber = phoneNumber;
  }

  void setRegistrationOtp(String otpCode) {
    _regOtpCode = otpCode;
  }

  void setRegistrationNames(String firstName, String lastName) {
    _regFirstName = firstName;
    _regLastName = lastName;
  }

  void setRegistrationGender(String gender) {
    _regGender = gender;
  }

  void setRegistrationProfilePicture(String path) {
    _regProfilePicture = path;
  }

  Future<void> sendOtp(int phoneNumber, {bool isRegister = true}) async {
    _isLoading = true;
    notifyListeners();
    try {
      if (isRegister) {
        await _authService.sendRegisterOtp(phoneNumber);
        _regPhoneNumber = phoneNumber;
      } else {
        await _authService.sendLoginOtp(phoneNumber);
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register(String role) async {
    if (_regPhoneNumber == null || _regOtpCode == null || _regFirstName == null || _regLastName == null) {
      throw Exception('Missing registration data');
    }

    _isLoading = true;
    notifyListeners();
    try {
      final response = await _authService.register(
        phoneNumber: _regPhoneNumber!,
        otpCode: _regOtpCode!,
        firstName: _regFirstName!,
        lastName: _regLastName!,
        role: role,
        profilePicturePath: _regProfilePicture,
      );
      await _handleAuthResponse(response);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> login(int phoneNumber, String otpCode) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _authService.login(phoneNumber, otpCode);
      await _handleAuthResponse(response);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _handleAuthResponse(Map<String, dynamic> response) async {
    final token = response['token'] ?? response['access_token'];
    final accountJson = response['account'];
    if (token != null && accountJson != null) {
      try {
        await _storage.write(key: 'access_token', value: token);
        _user = Account.fromJson(accountJson);
        _isLoggedIn = true;
        notifyListeners();
      } catch (e) {
        await _storage.deleteAll();
        await _storage.write(key: 'access_token', value: token);
        _user = Account.fromJson(accountJson);
        _isLoggedIn = true;
        notifyListeners();
      }
    }
  }

  Future<void> logout() async {
    try {
      await _storage.delete(key: 'access_token');
      // For thoroughness on Android, clear everything
      await _storage.deleteAll(); 
    } catch (e) {
      print("Error during storage cleanup: $e");
    } finally {
      _user = null;
      _isLoggedIn = false;
      notifyListeners();
    }
  }
}

class AccountExistsException implements Exception {
  final String message;
  AccountExistsException(this.message);
  @override
  String toString() => message;
}

class AccountNotFoundException implements Exception {
  final String message;
  AccountNotFoundException(this.message);
  @override
  String toString() => message;
}
