import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:shamba_agrovets/screens/splash_screen.dart';
import 'package:shamba_agrovets/utils/hive.dart';
import 'package:shamba_agrovets/utils/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint("Starting app...");
  await dotenv.load(fileName: ".env");
  debugPrint("Environment variables loaded");
  await Hive.initFlutter();
  await HiveService.init();
  debugPrint("Hive initialized");
  runApp(MultiProvider(providers: appProviders, child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shamba Agrovets',
      themeMode: ThemeMode.light, 
      theme: ThemeData(
        brightness: Brightness.light,
        colorSchemeSeed: const Color(0xFF15C233),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
