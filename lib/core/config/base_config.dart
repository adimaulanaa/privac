// File: lib/core/config/config.dart

class BaseConfig {
  //! Core Id 
  static const String baseUrl = 'https://uat-smart.mcf.co.id';
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
  };
  
  // time to verification OTP
  static const int remainingTime = 180; // for minutes
  static const int timeOutServer = 120; // for minutes 

}
