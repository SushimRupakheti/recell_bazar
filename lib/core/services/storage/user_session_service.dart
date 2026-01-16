

//PROVIDER
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';


//shared prefs provider
final sharedPreferencesProvider = Provider<SharedPreferences> ((ref){
  throw UnimplementedError("shared prefs lai hamle main.dart ma initialize garinxa,so tmi dhukka basa sir dinu hunxa hai");
});

final userSessionServiceProvider =Provider <UserSessionServices>((ref) {
  return UserSessionServices(prefs: ref.read(sharedPreferencesProvider));
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
  static const String _keyUserPhoneNumber='user_phone_number';
  static const String _keyUserAddress='user_address';

// Store user session data

Future<void> saveUserSession({
required String userId,
required String email,
required String firstName,
required String lastName,
String? phoneNumber,
String? address,

}) async {
await _prefs.setBool(_keysIsLoggedIn, true);
await _prefs.setString(_keyUserId, userId);
await _prefs.setString(_keyUserEmail, email);
await _prefs.setString(_keyUserFirstName, firstName);
await _prefs.setString(_keyUserLastName, lastName);

  if (phoneNumber != null) {
    await _prefs.setString(_keyUserPhoneNumber, phoneNumber);
  }

  if (address != null) {
    await _prefs.setString(_keyUserAddress, address);
  }


}

  Future<void> clearUserSession() async{
    await _prefs.remove(_keysIsLoggedIn);
    await _prefs.remove(_keyUserId);
    await _prefs.remove(_keyUserEmail);
    await _prefs.remove(_keyUserFirstName);
    await _prefs.remove(_keyUserLastName);
    await _prefs.remove(_keyUserPhoneNumber);
    await _prefs.remove(_keyUserAddress);
 
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
  return _prefs.getString(_keyUserPhoneNumber);
  }

  String? getUserAddress() {
  return _prefs.getString(_keyUserAddress);
  }


  

}