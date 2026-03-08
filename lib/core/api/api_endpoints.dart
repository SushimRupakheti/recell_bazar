// class ApiEndpoints {
//   ApiEndpoints._();

//   // Base URL - change this for production
//   // static const String baseUrl = 'http://localhost:5050/api/v1';
//   // Use your PC's LAN IP for physical devices (not the router/gateway)
//   // static const String baseUrl = 'http://192.168.31.161:5050/api/v1';
//   static const String baseUrl = 'http://10.0.2.2:5050/api';
 

//   //static const String baseUrl = 'http://localhost:3000/api/v1';ip halna pardaina?
//   // For Android Emulator use: 'http://10.0.2.2:3000/api/v1'
//   // For iOS Simulator use: 'http://localhost:5000/api/v1'
//   // For Physical Device use your computer's IP: 'http://192.168.x.x:

//   static const bool isPhysicalDevice = true;
//   static const Duration connectionTimeout = Duration(seconds: 30);
//   static const Duration receiveTimeout = Duration(seconds: 30);


//   // ============ User Endpoints ============


//   //auth endpoints
//   static const String auth = '/auth';
//   static const String register = '/auth/register';
//   static const String login = '/auth/login';


//   //item endpoints
//   static const String items = '/items';
//   static String itemById(String id) => '/items/$id';
//   static String markAsSold(String id) => '/items/$id/mark-sold';
//   static const String itemUploadPhoto = '/items/upload-photo';
//   static const String itemUploadVideo = '/items/upload-video';
//   static String itemsByCategory(String categoryId) => '/items/category/$categoryId';
//   static String itemsByUser(String userId) => '/items/user/$userId';
//   static String searchItems(String phoneModel, {String? categoryId}) =>'/items/search?model=$phoneModel${categoryId != null ? '&category=$categoryId' : ''}';

//   // cart endpoints
//   static const String cart = '/cart';
//   static const String cartAdd = '/cart/add';
//   static String cartRemove(String cartItemId) => '/cart/remove/$cartItemId';

//   // User endpoints
//   static String uploadProfilePicture(String userId) => '/users/$userId/profile-picture';
//   static String userById(String id) => '/users/$id';
//   static String updateUser(String id) => '/users/update/$id';

//   // notification endpoints
//   static const String notifications = '/notifications';
//   static String notificationById(String id) => '/notifications/$id';
//   static String markNotificationAsRead(String id) => '/notifications/$id/read';

// }

  //     import 'dart:io';
  //     import 'package:flutter/foundation.dart';

  //     class ApiEndpoints {
  //       // Private constructor to prevent instantiation
  //       ApiEndpoints._();

  //       // ================= CONFIGURATION =================
  //       /// Set to true when running on a real physical device
  //       static const bool isPhysicalDevice = true;

  //       /// Your computer's local IP (reachable by phone)
  //       static const String _ipAddress = '192.168.31.161';

  //       /// Backend port
  //       static const int _port = 5050;

  //       // ================= HOST =================
  //       static String get _host {
  //         if (isPhysicalDevice) return _ipAddress;
  //         if (kIsWeb || Platform.isIOS) return 'localhost';
  //         if (Platform.isAndroid) return '10.0.2.2';
  //         return 'localhost';
  //       }

  //       // ================= BASE URL =================
  //       static String get serverUrl => 'http://$_host:$_port';

  //       /// Base URL for your backend
  //       static String get baseUrl => '$serverUrl/api';

  //       // ================= TIMEOUTS =================
  //       static const Duration connectionTimeout = Duration(seconds: 30);
  //       static const Duration receiveTimeout = Duration(seconds: 30);

  //       // ================= AUTH ENDPOINTS =================
  //       static const String login = '/auth/login';
  //       static const String register = '/auth/register';

  //       // ================= ITEM ENDPOINTS =================
  //       static const String items = '/items';
  //       static String itemById(String id) => '/items/$id';
  //       static String markAsSold(String id) => '/items/$id/mark-sold';
  //       static const String itemUploadPhoto = '/items/upload-photo';
  //       static const String itemUploadVideo = '/items/upload-video';
  //       static String itemsByCategory(String categoryId) => '/items/category/$categoryId';
  //       static String itemsByUser(String userId) => '/items/user/$userId';
  //       static String searchItems(String phoneModel, {String? categoryId}) =>
  //           '/items/search?model=$phoneModel${categoryId != null ? '&category=$categoryId' : ''}';

  //       // ================= USER ENDPOINTS =================
  //       static String uploadProfilePicture(String userId) => '/users/$userId/profile-picture';
  //       static String userById(String id) => '/users/$id';

  //       // notification endpoints
  // static const String notifications = '/notifications';
  // static String notificationById(String id) => '/notifications/$id';
  // static String markNotificationAsRead(String id) => '/notifications/$id/read';

  //     }

import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

class ApiEndpoints {
  ApiEndpoints._();

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  static const int _port = int.fromEnvironment('API_PORT', defaultValue: 5050);

  // Default LAN IP for your physical device testing
  static const String _defaultLanHost = '192.168.1.24';

  // Optional override:
  // flutter run --dart-define=API_LAN_HOST=192.168.xx.xx
  static const String _lanHostFromEnv =
      String.fromEnvironment('API_LAN_HOST', defaultValue: '');

  // Full override (highest priority):
  // flutter run --dart-define=API_BASE_URL=http://192.168.31.161:5050/api
  static const String _baseUrlOverride =
      String.fromEnvironment('API_BASE_URL', defaultValue: '');

  static String get _lanHost =>
      _lanHostFromEnv.isNotEmpty ? _lanHostFromEnv : _defaultLanHost;

  static String baseUrl =
      _baseUrlOverride.isNotEmpty ? _baseUrlOverride : _startupBaseUrl();

  static bool isPhysicalDevice = true;

  static bool _initialized = false;
  static bool get initialized => _initialized;

  static String _startupBaseUrl() {
    if (kIsWeb) {
      return 'http://$_lanHost:$_port/api';
    }

    if (Platform.isAndroid) {
      // Safe startup fallback before init()
      return 'http://10.0.2.2:$_port/api';
    }

    if (Platform.isIOS) {
      return 'http://localhost:$_port/api';
    }

    return 'http://localhost:$_port/api';
  }

  static Future<void> init() async {
    if (_initialized) return;

    if (_baseUrlOverride.isNotEmpty) {
      baseUrl = _baseUrlOverride;
      _initialized = true;
      if (kDebugMode) {
        debugPrint('[ApiEndpoints] Using override base URL -> $baseUrl');
      }
      return;
    }

    final deviceInfo = DeviceInfoPlugin();

    if (!kIsWeb && Platform.isAndroid) {
      final android = await deviceInfo.androidInfo;
      isPhysicalDevice = android.isPhysicalDevice ?? true;

      final host = isPhysicalDevice ? _lanHost : '10.0.2.2';
      baseUrl = 'http://$host:$_port/api';

      if (kDebugMode) {
        debugPrint(
          '[ApiEndpoints] Android ${isPhysicalDevice ? "physical" : "emulator"} -> $baseUrl',
        );
      }

      _initialized = true;
      return;
    }

    if (!kIsWeb && Platform.isIOS) {
      final ios = await deviceInfo.iosInfo;
      isPhysicalDevice = ios.isPhysicalDevice ?? true;

      final host = isPhysicalDevice ? _lanHost : 'localhost';
      baseUrl = 'http://$host:$_port/api';

      if (kDebugMode) {
        debugPrint(
          '[ApiEndpoints] iOS ${isPhysicalDevice ? "physical" : "simulator"} -> $baseUrl',
        );
      }

      _initialized = true;
      return;
    }

    if (kIsWeb) {
      baseUrl = 'http://$_lanHost:$_port/api';
      isPhysicalDevice = true;

      if (kDebugMode) {
        debugPrint('[ApiEndpoints] Web -> $baseUrl');
      }

      _initialized = true;
      return;
    }

    baseUrl = 'http://localhost:$_port/api';
    isPhysicalDevice = true;

    if (kDebugMode) {
      debugPrint('[ApiEndpoints] Desktop/fallback -> $baseUrl');
    }

    _initialized = true;
  }

  // ================= AUTH ENDPOINTS =================
  static const String auth = '/auth';
  static const String register = '/auth/register';
  static const String login = '/auth/login';

  // ================= ITEM ENDPOINTS =================
  static const String items = '/items';
  static String itemById(String id) => '/items/$id';
  static String markAsSold(String id) => '/items/$id/mark-sold';
  static const String itemUploadPhoto = '/items/upload-photo';
  static const String itemUploadVideo = '/items/upload-video';
  static String itemsByCategory(String categoryId) => '/items/category/$categoryId';
  static String itemsByUser(String userId) => '/items/user/$userId';
  static String searchItems(String phoneModel, {String? categoryId}) =>
      '/items/search?model=$phoneModel${categoryId != null ? '&category=$categoryId' : ''}';

  // ================= CART ENDPOINTS =================
  static const String cart = '/cart';
  static const String cartAdd = '/cart/add';
  static String cartRemove(String cartItemId) => '/cart/remove/$cartItemId';

  // ================= USER ENDPOINTS =================
  static String uploadProfilePicture(String userId) =>
      '/users/$userId/profile-picture';
  static String userById(String id) => '/users/$id';
  static String updateUser(String id) => '/users/update/$id';

  // ================= NOTIFICATION ENDPOINTS =================
  static const String notifications = '/notifications';
  static String notificationById(String id) => '/notifications/$id';
  static String markNotificationAsRead(String id) =>
      '/notifications/$id/read';
}