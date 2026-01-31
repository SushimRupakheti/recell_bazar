class ApiEndpoints {
  ApiEndpoints._();

  // Base URL - change this for production
  // static const String baseUrl = 'http://localhost:5050/api/v1';
  static const String baseUrl = 'http://10.0.2.2:5050/api';


  //static const String baseUrl = 'http://localhost:3000/api/v1';ip halna pardaina?
  // For Android Emulator use: 'http://10.0.2.2:3000/api/v1'
  // For iOS Simulator use: 'http://localhost:5000/api/v1'
  // For Physical Device use your computer's IP: 'http://192.168.x.x:


  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);


  // ============ User Endpoints ============


  //auth endpoints
  static const String auth = '/auth';
  static const String register = '/auth/register';
  static const String login = '/auth/login';


  //item endpoints
  static const String items = '/items';
  static String itemById(String id) => '/items/$id';
  static String markAsSold(String id) => '/items/$id/mark-sold';
  static const String itemUploadPhoto = '/items/upload-photo';
  static const String itemUploadVideo = '/items/upload-video';
  static String itemsByCategory(String categoryId) => '/items/category/$categoryId';
  static String itemsByUser(String userId) => '/items/user/$userId';
  static String searchItems(String phoneModel, {String? categoryId}) =>'/items/search?model=$phoneModel${categoryId != null ? '&category=$categoryId' : ''}';

  // User endpoints
  static String uploadProfilePicture(String userId) => '/users/$userId/profile-picture';
  static String userById(String id) => '/users/$id';

}
