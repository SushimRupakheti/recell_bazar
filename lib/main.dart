import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recell_bazar/app/app.dart';
import 'package:recell_bazar/core/services/hive/hive_service.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ProviderScope(child: const App())
  );
  HiveService().init();
}

