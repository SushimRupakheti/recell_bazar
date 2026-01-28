

//PROVIDER
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';


//shared prefs provider
final sharedPreferencesProvider = Provider<SharedPreferences> ((ref){
  throw UnimplementedError("shared prefs lai hamle main.dart ma initialize garinxa,so tmi dhukka basa sir dinu hunxa hai");
});

final userSessionServiceProvider = Provider<UserSessionServices>((ref) {
  final prefs = ref.read(sharedPreferencesProvider); // SharedPreferences directly
  return UserSessionServices(prefs: prefs);
});




class UserSessionServices{
  final SharedPreferences _prefs;

  UserSessionServices({required SharedPreferences prefs}) : _prefs = prefs;

  //keys for stroing data
  static const String _keysIsLoggedIn='is_logged_in';
  static const String _keyUserId='user_id';
  static const String _keyUserEmail='user_email';
  static const String _keyUserFirstName='user_first_name';
  static const String _keyUserLastName='user_last_name';
  static const String _keyUserContactNo='user_phone_number';
  static const String _keyUserAddress='user_address';
  static const String _keyUserProfileImage='user_profile_image';

// Store user session data

Future<void> saveUserSession({
required String userId,
required String email,
required String firstName,
required String lastName,
String? contactNo,
String? address,
String? profileImage,

}) async {
await _prefs.setBool(_keysIsLoggedIn, true);
await _prefs.setString(_keyUserId, userId);
await _prefs.setString(_keyUserEmail, email);
await _prefs.setString(_keyUserFirstName, firstName);
await _prefs.setString(_keyUserLastName, lastName);
  // For optional fields, overwrite or remove the key to avoid stale data
  if (profileImage != null) {
    await _prefs.setString(_keyUserProfileImage, profileImage);
  } else {
    await _prefs.remove(_keyUserProfileImage);
  }

  if (contactNo != null) {
    await _prefs.setString(_keyUserContactNo, contactNo);
  } else {
    await _prefs.remove(_keyUserContactNo);
  }

  if (address != null) {
    await _prefs.setString(_keyUserAddress, address);
  } else {
    await _prefs.remove(_keyUserAddress);
  }


}

  Future<void> clearUserSession() async{
    await _prefs.remove(_keysIsLoggedIn);
    await _prefs.remove(_keyUserId);
    await _prefs.remove(_keyUserEmail);
    await _prefs.remove(_keyUserFirstName);
    await _prefs.remove(_keyUserLastName);
    await _prefs.remove(_keyUserContactNo);
    await _prefs.remove(_keyUserAddress);
    await _prefs.remove(_keyUserProfileImage);

 
  }

  bool isLoggedIn(){
    return _prefs.getBool(_keysIsLoggedIn) ?? false;
  }
  String? getUserId(){
    return _prefs.getString(_keyUserId);
  }

  String? getUserEmail() {
  return _prefs.getString(_keyUserEmail);
  }

  String? getFirstName() {
  return _prefs.getString(_keyUserFirstName);
  }

  String? getUserLastName() {
  return _prefs.getString(_keyUserLastName);
  }

  String? getUserPhoneNumber() {
  return _prefs.getString(_keyUserContactNo);
  }

  String? getUserAddress() {
  return _prefs.getString(_keyUserAddress);
  }

  String? getUserProfileImage() {
  return _prefs.getString(_keyUserProfileImage);
  }
Future<void> saveProfileImage(String imageUrl) async {
  await _prefs.setString(_keyUserProfileImage, imageUrl);
}



}