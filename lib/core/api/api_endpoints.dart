class ApiEndpoints {
  ApiEndpoints._();

  // Base URL - change this for production
  // static const String baseUrl = 'http://92.168.31.161:5050/api';
  static const String baseUrl = 'http://10.0.2.2:5050/api';


  //static const String baseUrl = 'http://localhost:3000/api/v1';ip halna pardaina?
  // For Android Emulator use: 'http://10.0.2.2:3000/api/v1'
  // For iOS Simulator use: 'http://localhost:5000/api/v1'
  // For Physical Device use your computer's IP: 'http://192.168.x.x:


  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);


  // ============ User Endpoints ============
  static const String auth = '/auth';
  static const String register = '/auth/register';
  static const String login = '/auth/login';
}
