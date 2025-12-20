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
  static const String _keyEnableAllExperiments = 'exp_enable_all_experiments';
  static const String _keyShowAddTaskButton = 'exp_show_add_task_button';

  // --- Master Toggle ---
  static bool _enableAllExperiments = false;
  static bool get enableAllExperiments => _enableAllExperiments;

  // Registry of experiment setters controlled by the master toggle
  static final List<Future<void> Function(bool)> _experimentSetters = [
    setExperiment1BypassLoginValidation,
    setExperimentShowAddTaskButton,
    // Add new experiment setters here
  ];

  static Future<void> setEnableAllExperiments(bool value) async {
    _enableAllExperiments = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyEnableAllExperiments, value);

    // Force all experiments to match the master toggle state
    for (final setter in _experimentSetters) {
      await setter(value);
    }
  }

  // --- EXPERIMENT A: Bypass Login Validation ---
  static bool _experiment1BypassLoginValidation = false;
  static bool get experiment1BypassLoginValidation => _experiment1BypassLoginValidation;

  static Future<void> setExperiment1BypassLoginValidation(bool value) async {
    _experiment1BypassLoginValidation = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyBypassLoginValidation, value);
  }

  // --- EXPERIMENT B: Show Add Task Button ---
  static bool _experimentShowAddTaskButton = false;
  static bool get experimentShowAddTaskButton => _experimentShowAddTaskButton;

  static Future<void> setExperimentShowAddTaskButton(bool value) async {
    _experimentShowAddTaskButton = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyShowAddTaskButton, value);
  }

  // --- FUTURE EXPERIMENTS (Template) ---
  // static bool _experimentB = false;
  // static bool get experimentB => _experimentB;
  // static Future<void> setExperimentB(bool value) async { ... }

  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    
    // 1. Load the Master Toggle
    _enableAllExperiments = prefs.getBool(_keyEnableAllExperiments) ?? false;

    // 2. Load Individual Experiments
    // Note: If Master is OFF, experiments are technically "off" for the user, 
    // but we still load their individual stored state so the UI reflects what was last selected.
    _experiment1BypassLoginValidation = prefs.getBool(_keyBypassLoginValidation) ?? false;
    _experimentShowAddTaskButton = prefs.getBool(_keyShowAddTaskButton) ?? false;

    //future experiments
  }
}