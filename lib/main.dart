import 'package:flutter/widgets.dart';
import 'app.dart';
import 'core/config/app_config.dart';

void main() async {
  // Future: Initialize Dependency Injection here
  WidgetsFlutterBinding.ensureInitialized();
  
  await AppConfig.initialize();

  runApp(const ToDoApp());
}