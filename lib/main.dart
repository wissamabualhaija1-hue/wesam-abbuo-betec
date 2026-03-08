import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const JordanTourApp());
}

class JordanTourApp extends StatefulWidget {
  const JordanTourApp({super.key});

  @override
  State<JordanTourApp> createState() => _JordanTourAppState();
}

class _JordanTourAppState extends State<JordanTourApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jordan Tour Guide',
      // ثيم الفاتح
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: const Color(0xFF003366),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF003366),
        ),
      ),
      // ثيم الداكن (فخم ذهبي مع أسود)
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: const Color(0xFFD4AF37),
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.black,
          foregroundColor: Color(0xFFD4AF37),
        ),
      ),
      themeMode: _themeMode,
      home: HomeScreen(onThemeChanged: toggleTheme),
    );
  }
}
