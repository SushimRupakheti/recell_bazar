import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recell_bazar/app/app.dart';
import 'package:recell_bazar/core/services/hive/hive_service.dart';
import 'package:recell_bazar/core/services/storage/user_session_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_stripe/flutter_stripe.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // Ensure Hive is initialized and boxes are open before starting the app to avoid races
  await HiveService().init();
  final sharedPrefs = await SharedPreferences.getInstance();
  
  // Initialize Stripe SDK - replace with your publishable key or keep empty and set at runtime
  try {
    Stripe.publishableKey = const String.fromEnvironment('STRIPE_PUBLISHABLE_KEY', defaultValue: 'pk_test_TYooMQauvdEDq54NiTphI7jx_KEY');
    Stripe.merchantIdentifier = 'merchant.recell_bazar';
    await Stripe.instance.applySettings();
  } catch (_) {}

  
  runApp(ProviderScope(overrides:[
    sharedPreferencesProvider.overrideWithValue(sharedPrefs)
  ],child: App()));
}

