import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isVibrationEnabled = true;
  String selectedTimerSound = 'Default';
  bool isStatisticsReset = false;
  double rating = 0;
  String userName = 'User';

  final TextEditingController _userNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 240, 174, 221),
                Color.fromARGB(255, 199, 152, 240),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'Personal Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Change Username'),
                      content: TextField(
                        controller: _userNameController,
                        decoration: const InputDecoration(
                          labelText: 'Enter New Username',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              userName = _userNameController.text.isNotEmpty
                                  ? _userNameController.text
                                  : 'User';
                            });
                            _userNameController.clear();
                            Navigator.of(context).pop();
                          },
                          child: const Text('Submit'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: ListTile(
                title: const Text('Account Name'),
                subtitle: Text(userName),
                trailing: CircleAvatar(
                  backgroundColor: const Color.fromARGB(255, 240, 174, 221),
                  child: Text(userName[0].toUpperCase()),
                ),
              ),
            ),
            const Divider(),
            const Text(
              'Statistics Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ListTile(
              title: const Text('Reset Statistics'),
              trailing: ElevatedButton(
                onPressed: () {
                  setState(() {
                    isStatisticsReset = true;
                  });
                },
                child: const Text('Reset'),
              ),
            ),
            const Divider(),
            const Text(
              'Timer Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ListTile(
              title: const Text('Timer Sound'),
              subtitle: Text(selectedTimerSound),
              trailing: DropdownButton<String>(
                value: selectedTimerSound,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedTimerSound = newValue!;
                  });
                },
                items: ['Default', 'Sound 1', 'Sound 2']
                    .map<DropdownMenuItem<String>>((value) {
return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            SwitchListTile(
              title: const Text('Enable Vibration'),
              value: isVibrationEnabled,
              onChanged: (bool value) {
                setState(() {
                  isVibrationEnabled = value;
                });
              },
              activeColor: const Color.fromARGB(255, 240, 174, 221),
            ),
            const Divider(),
            const Text(
              'Rate Our App',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  ),
                  onPressed: () {
                    setState(() {
                      rating = index + 1;
                    });
                  },
                );
              }),
            ),
            ElevatedButton(
              onPressed: () {
                String message = rating <= 3
                    ? 'Thank you for your feedback. We will improve the app!'
                    : 'Thank you for your rating of $rating stars!';
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(message)),
                );
              },
              child: const Text('Submit Rating'),
            ),
          ],
        ),
      ),
    );
  }
}