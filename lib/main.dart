import 'package:flutter/material.dart';
import 'Home.dart';
import 'Login.dart';
import 'Setting.dart'; 
import 'todo.dart'; 
import 'timer.dart'; 
import 'statistics.dart'; 

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  
  final Map<String, Duration> tagDurations = {
    'Work': Duration(minutes: 30),
    'Exercise': Duration(minutes: 15),
  };

  final Map<String, Color> tags = {
    'Work': Colors.blue,
    'Exercise': Colors.green,
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true),
      initialRoute: '/',
      routes: {
        "/": (context) => LoginPage(),
        "/home": (context) => const HomeScreen(remainingTime: "00:00", remainingTasks: 0),
        "/todo": (context) => TodoListScreen(),
        "/settings": (context) => const SettingsScreen(),
        "/timer": (context) => const TimerScreen(),
        "/statistics": (context) => StatisticsScreen(
          tagDurations: tagDurations, 
          tags: tags,
        ),
      },
    );
  }
}