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
}