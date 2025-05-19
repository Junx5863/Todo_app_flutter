import 'package:dash_todo_app/features/home_view/data/model/local/task_local_model.dart';
import 'package:dash_todo_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app/app.dart';
import 'package:dash_todo_app/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //Initialize Hive
  await Hive.initFlutter();

  // Register the Hive adapter
  Hive.registerAdapter(TaskLocalModelAdapter());

  // Initialize the dependency injection container
  await di.init();
  runApp(const App());
}
