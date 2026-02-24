class ApiConstants {
  // Use 10.0.2.2 for Android Emulator, or your local IP for physical devices
  static const String baseUrl = "http://10.0.2.2:8080/api";
  
  // Auth Endpoints
  static const String registerSendOtp = "/auth/register/send-otp";
  static const String register = "/auth/register";
  static const String loginSendOtp = "/auth/login/send-otp";
  static const String login = "/auth/login";
  static const String validateToken = "/auth/validate";

  // Account Endpoints
  static const String accounts = "/accounts";

  // Ride Endpoints
  static const String rides = "/rides";

  // Booking Endpoints
  static const String bookings = "/bookings";

  // Vehicle Endpoints
  static const String vehicles = "/vehicles";

  // Message Endpoints
  static const String messages = "/messages";

  // Rating Endpoints
  static const String ratings = "/ratings";

  // Transaction Endpoints
  static const String transactions = "/transactions";

  // Document Endpoints
  static const String documents = "/documents";
}
