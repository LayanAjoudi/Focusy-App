import 'package:flutter/material.dart';
import 'Setting.dart'; 
import 'timer.dart'; 
import 'todo.dart'; 
import 'statistics.dart'; 

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key, required this.remainingTime, required this.remainingTasks}) 
      : super(key: key);

  final String remainingTime;
  final int remainingTasks;

  @override
  Widget build(BuildContext context) {
    final double buttonSize = MediaQuery.of(context).size.width / 4.5;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Timer App'),
        backgroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 240, 174, 221),
              Color.fromARGB(255, 199, 152, 240),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildButton(context, 'Timer', buttonSize, () => Navigator.pushNamed(context, '/timer')),
                  const SizedBox(width: 8),
                  _buildButton(context, 'To-Do', buttonSize, () => Navigator.pushNamed(context, '/todo')),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildButton(context, 'Statistics', buttonSize, () => Navigator.pushNamed(context, '/statistics')),
                  const SizedBox(width: 8),
                  _buildButton(
                    context,
                    'Settings',
                    buttonSize,
                    () => Navigator.pushNamed(context, '/settings'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, double size, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(size, size),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(text, style: const TextStyle(fontSize: 19)),
    );
  }
}