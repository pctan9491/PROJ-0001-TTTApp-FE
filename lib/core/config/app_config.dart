import 'package:shared_preferences/shared_preferences.dart';

enum AppEnvironment {
  dev,
  test,
  main,
}

class AppConfig {
  // Use --dart-define=APP_ENV=dev to set this
  static const String _env = String.fromEnvironment('APP_ENV', defaultValue: 'dev');

  static AppEnvironment get environment {
    switch (_env.toLowerCase()) {
      case 'dev':
        return AppEnvironment.dev;
      case 'test':
        return AppEnvironment.test;
      default:
        return AppEnvironment.main; // Default to main
    }
  }

  static bool get isExperimentalFeatureVisible {
    return environment == AppEnvironment.dev || environment == AppEnvironment.test;
  }

  // Persistence Keys
  static const String _keyBypassLoginValidation = 'exp_bypass_login_validation';

  // --- EXPERIMENT A: Bypass Login Validation ---
  static bool _experiment1BypassLoginValidation = false;
  static bool get experiment1BypassLoginValidation => _experiment1BypassLoginValidation;

  static Future<void> setExperiment1BypassLoginValidation(bool value) async {
    _experiment1BypassLoginValidation = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyBypassLoginValidation, value);
  }

  // --- FUTURE EXPERIMENTS (Template) ---
  // static bool _experimentB = false;
  // static bool get experimentB => _experimentB;
  // static Future<void> setExperimentB(bool value) async { ... }

  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _experiment1BypassLoginValidation = prefs.getBool(_keyBypassLoginValidation) ?? false;
    // Load future experiments here...
  }
}