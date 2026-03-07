// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:recell_bazar/app/app.dart';
// import 'package:recell_bazar/app/theme/theme_mode_controller.dart';
// import 'package:recell_bazar/core/services/hive/hive_service.dart';
// import 'package:recell_bazar/core/services/storage/user_session_service.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // Hive init
//   await HiveService().init();
//   final sharedPrefs = await SharedPreferences.getInstance();

//   await appThemeController.init(sharedPrefs);

//   // Stripe init
//   try {
//     Stripe.publishableKey = const String.fromEnvironment(
//       'STRIPE_PUBLISHABLE_KEY',
//       defaultValue:
//           'pk_test_51T173FI8viDoC0Q2S4IRHUVLqo4iH1wv1D2C2eL5vHHaekY9GJp1EaXsN1DS9sxAyXV36qQhy94WBXMUCyXgHXVr00sP5SNs4N',
//     );
//     Stripe.merchantIdentifier = 'merchant.recell_bazar';
//     await Stripe.instance.applySettings();
//   } catch (_) {}

//   runApp(
//     ProviderScope(
//       overrides: [sharedPreferencesProvider.overrideWithValue(sharedPrefs)],
//       child: const App(),
//     ),
//   );
// }
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recell_bazar/app/app.dart';
import 'package:recell_bazar/app/theme/theme_mode_controller.dart';
import 'package:recell_bazar/core/services/hive/hive_service.dart';
import 'package:recell_bazar/core/services/storage/user_session_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

// ✅ import your ApiEndpoints file (adjust import to your project)
import 'package:recell_bazar/core/api/api_endpoints.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ MUST be before any API call / Dio client creation
  await ApiEndpoints.init();

  // Hive init
  await HiveService().init();
  final sharedPrefs = await SharedPreferences.getInstance();
  await appThemeController.init(sharedPrefs);

  // Stripe init
  try {
    Stripe.publishableKey = const String.fromEnvironment(
      'STRIPE_PUBLISHABLE_KEY',
      defaultValue:
          'pk_test_51T173FI8viDoC0Q2S4IRHUVLqo4iH1wv1D2C2eL5vHHaekY9GJp1EaXsN1DS9sxAyXV36qQhy94WBXMUCyXgHXVr00sP5SNs4N',
    );
    Stripe.merchantIdentifier = 'merchant.recell_bazar';
    await Stripe.instance.applySettings();
  } catch (_) {}

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPrefs),
      ],
      child: const App(),
    ),
  );
}