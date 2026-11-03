import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme.dart';
import 'screens/welcome_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );
  runApp(const RakshanApp());
}

class RakshanApp extends StatelessWidget {
  const RakshanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rakshan — Family Cyber Safety & Parental Protection',
      debugShowCheckedModeBanner: false,
      theme: RakshanTheme.lightTheme,
      home: const WelcomeScreen(),
    );
  }
}
