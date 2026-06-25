import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/calculator_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatefulWidget {
  const CalculatorApp({super.key});

  @override
  State<CalculatorApp> createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  bool _isDarkMode = true;
  bool _isSoundEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.containsKey('isDarkMode')) {
        _isDarkMode = prefs.getBool('isDarkMode')!;
      } else {
        final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
        _isDarkMode = brightness == Brightness.dark;
      }
      _isSoundEnabled = prefs.getBool('isSoundEnabled') ?? true;
    });
  }

  void _toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = !_isDarkMode;
      prefs.setBool('isDarkMode', _isDarkMode);
    });
  }

  void _toggleSound(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isSoundEnabled = value;
      prefs.setBool('isSoundEnabled', value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kalkulator Super',
      debugShowCheckedModeBanner: false,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.indigo,
        colorScheme: const ColorScheme.light(
          primary: Colors.indigo,
          secondary: Colors.amber,
          background: Color(0xFFF5F6F9),
          surface: Colors.white,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.indigo,
        colorScheme: const ColorScheme.dark(
          primary: Colors.indigoAccent,
          secondary: Colors.amber,
          background: Color(0xFF121214),
          surface: Color(0xFF1E1E24),
        ),
        useMaterial3: true,
      ),
      home: CalculatorScreen(
        isDarkMode: _isDarkMode,
        onToggleTheme: _toggleTheme,
        isSoundEnabled: _isSoundEnabled,
        onToggleSound: _toggleSound,
      ),
    );
  }
}
