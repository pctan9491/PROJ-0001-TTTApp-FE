import 'package:flutter/widgets.dart';
import 'app.dart';

void main() {
  // Future: Initialize Dependency Injection here
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const ToDoApp());
}