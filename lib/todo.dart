import 'package:flutter/material.dart';

void main() {
  runApp(Todo());
}

class Todo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final _tasks = <Task>[]; 
  final _controller = TextEditingController();
  final List<String> _days = [
    'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'
  ];
  final List<bool> _expanded = List.generate(7, (index) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              Color.fromARGB(255, 240, 174, 221),
              Color.fromARGB(255, 199, 152, 240),
            ]),
          ),
          child: AppBar(
            title: Text('To-Do List'),
            backgroundColor: Colors.transparent,  
            elevation: 0,  
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 10), 
            Expanded(
              child: ListView.builder( // هنا يسوي لي قائمه على عدد ايام الاسبوع الي حددتها 
                itemCount: _days.length, // يعد الكاردز الي هي ايام الاسبوع
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [
                          Color.fromARGB(255, 240, 174, 221),
                          Color.fromARGB(255, 199, 152, 240),
                        ]),
                        borderRadius: BorderRadius.circular(15),
                      ), // الستايل هنا بيكون موحد عل كل الكاردز
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(_days[index], style: TextStyle(fontWeight: FontWeight.bold)), // عنوان اليوم
                            onTap: () {
                              setState(() {
                                _expanded[index] = !_expanded[index]; 
                              });
                            },
                          ),
                          if (_expanded[index]) ...[ // إذا كانت القائمة مفتوحة
                            ..._tasks.where((task) => task.dayIndex == index).map((task) { // نجيب المهام اللي تخص اليوم
                              return ListTile(
                                title: Text(task.title, style: TextStyle(decoration: task.completed ? TextDecoration.lineThrough : null)), // عنوان المهمة مع خط إذا كانت مكتملة
                                trailing: Checkbox(
                                  value: task.completed, // إذا كانت المهمة مكتملة
                                  onChanged: (value) { // إذا تغيرت حالة الشيك بوكس
                                    setState(() {
                                      task.completed = value!; // نغير حالة المهمة
                                    });
                                  },
                                ),
                                onLongPress: () { //  نحذف التاسك إذا ضغط المستخدم ضغط طويل
                                  _removeTask(task); 
                                },
                              );
                            }).toList(),
                            ListTile(
                              title: TextField(
                                controller: _controller, // يتحكم في الجزء حق ادخال التاسك
                                decoration: InputDecoration(labelText: 'Add new task'), 
                                onSubmitted: (value) { 
                                  _addTask(index); 
                                },
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.add), 
                                onPressed: () {
                                  _addTask(index); 
                                
                                },
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addTask(int dayIndex) {
    if (_controller.text.isNotEmpty) { // إذا كان حقل الإدخال مو فاضي
      setState(() {
        _tasks.add(Task(title: _controller.text, dayIndex: dayIndex)); // اضيف التاسك للقائمه
        _controller.clear(); 
      });
    }
  }

  void _removeTask(Task task) {
    setState(() {
      _tasks.remove(task); 
    });
  }
}

class Task {
  String title; 
  bool completed; 
  int dayIndex; 

  Task({required this.title, this.completed = false, required this.dayIndex}); 
}