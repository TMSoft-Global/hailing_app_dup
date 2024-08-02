import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'pages/onboarding/splashScreen.dart';
import 'spec/properties.dart';
import 'spec/theme.dart';

FirebaseApp? firebaseApp;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

// Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize hive
  await Hive.initFlutter();
  // Open the itnBox
  await Hive.openLazyBox(Properties.hiveBox);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    Hive.close();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      theme: Themes.theme(),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
