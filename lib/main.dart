import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/services/firebase_service.dart';
import 'injection.dart' as di;
import 'presentation/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await FirebaseService.initialize();
  

  await di.init();
  
  runApp(const App());
}