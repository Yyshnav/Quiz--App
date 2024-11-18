import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider package
import 'package:quizapp/Model/Provider/q.dart';
import 'package:quizapp/Model/Provider/time_provider.dart';
import 'package:quizapp/das.dart';

import 'login_screen.dart';
import 'quiz_screen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    // Only initialize sqflite_ffi for desktop platforms
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TimerProvider>(
          create: (_) => TimerProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => QuizProvider(),
        ),
        // Add other providers here if needed
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Quiz App',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/',
        routes: {
          '/': (context) => LoginScreen(),
          '/quiz': (context) => QuizScreen(),
        },
      ),
    );
  }
}
