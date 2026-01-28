import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';


// ====================== SHARED PREFERENCES PROVIDER ======================
//

/// Must be overridden in main.dart before runApp()
// final storageServiceProvider = Provider<StorageService>((ref) {
//   throw UnimplementedError('storageServiceProvider must be overridden');
// });

final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});