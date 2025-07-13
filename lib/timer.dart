import 'package:flutter/material.dart';
import 'dart:async';
import 'statistics.dart';

void main() => runApp(const MyApp());
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    //_______________________MaterialApp the root widget__________________________________//
    return MaterialApp(debugShowCheckedModeBanner: false, theme: ThemeData.light(useMaterial3: true), home: const TimerScreen());
  }
}
class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});
  @override
  _TimerScreenState createState() => _TimerScreenState();       //_________________  // here we create the statefull widget
}
class _TimerScreenState extends State<TimerScreen> {             // here the statefull start
  late Timer _timer;                                             // it will intialized lataer + Timer Class from dart:async library to create timer + _timer is obj
  Duration _duration = Duration.zero;                            //_duration obj from Duration class has set to zero second
  bool _isRunning = false;
  String? _selectedTag;                                         // ? sign indicating hold null ability
  final Map<String, Color> _tags = {};                          //final( can only set once ) + map string(tags) with color + _tags hold this map
  final Map<String, Duration> _tagDurations = {};               // map tags with duration
  final TextEditingController _tagNameController = TextEditingController();  //a controller for text field +create new obj from it
  Color _selectedColor = const Color.fromARGB(255, 214, 130, 158);                         // obj hold color
  void _toggleTimer() {
    _isRunning ? _stopTimer() : _startTimer();
  }
  void _startTimer() {                                          //periodic create timer updated at speci interval 
    _timer = Timer.periodic(const Duration(seconds: 1) /* update every on second*/ , (_) => setState(() => _duration += const Duration(seconds: 1)) /**this callback in every second */);
    setState(() => _isRunning = true);                                          //setState here ^ tiggers a rebulid of the widget
  }
  void _stopTimer() {
    _timer.cancel();                                               //stop the callback func
    if (_selectedTag != null /* there is a tag*/) _tagDurations[_selectedTag! /** ! insure it not null */] = (_tagDurations[_selectedTag!] ?? Duration.zero /**it intial 0 if it the first time */) + _duration;
    setState(() {
      _isRunning = false;
      _duration = Duration.zero;                                //the time taken
    });
  }
  void _addOrEditTag(String tag, Color color) {                // this for the dialog which for event exist tags
    setState(() {
      _tags[tag] = color;
      _tagDurations.putIfAbsent(tag, () => Duration.zero);      // if it new one put it duration to zero and add it to the list
      _selectedTag = tag;                                       // the new one is the selected
    });
    Navigator.pop(context);                                     // close the dialog and return to the previous screen
  }
  String _formatDuration(Duration duration) {                  //input duration to format
    String twoDigits(int n) => n.toString().padLeft(2, '0');   //helper fun convert int to string and pad it with 0 if necessary <3
    return "${twoDigits(duration.inHours)}:${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}"; //the remaining is what left above 60
  }
  void _showTagSelectionDialog() {
    showDialog(
      context: context,
      builder:/**this build in dialog */ (context) => AlertDialog(                                         //material design dialog :::::: shape, title, content, actions
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),  // rectangular border with rounded corners ::::::::: borderRadius
        title: const Text('Focus Tags'),
        content: SingleChildScrollView(                                          // scrollable widget that has single child ::::: child
          child: Column(
            mainAxisSize: MainAxisSize.min,  //it children take space as needed
            children: [
              ..._tags.keys.map((tag) => ListTile(                            //the following to each tag  //fixed height row with trailing icon here is edit :::::::: leading, title, trailing, onTap
                title: Text(tag, style: TextStyle(color: _tags[tag])),        //display tag with it color
                trailing: IconButton(icon: const Icon(Icons.edit_rounded), onPressed: () => _showTagCreationDialog(editTag: tag)), // pass exist tag
                onTap: () {
                  setState(() => _selectedTag = tag);
                  Navigator.pop(context);
                },
              )),
              ListTile(                 // this row with + sign but at the begining                                                 
                leading: const Icon(Icons.add),
                title: const Text("Add New"),
                onTap: _showTagCreationDialog, // no tag passed bc it new
              ),
            ],
          ),
        ),
      ),
    );
  }
void _showTagCreationDialog({String? editTag}) {
  if (editTag != null) {
    _tagNameController.text = editTag;
    _selectedColor = _tags[editTag] ?? const Color.fromARGB(255, 226, 95, 139);
  } else {
    _tagNameController.clear();
    _selectedColor = const Color.fromARGB(255, 232, 94, 140);
  }

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            title: Text(editTag != null ? 'Edit Tag' : 'Create New Tag'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _tagNameController,
                  decoration: const InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  children: [
                    const Color.fromARGB(255, 117, 106, 182),
                    const Color.fromARGB(255, 155, 135, 197),
                    const Color.fromARGB(255, 224, 174, 208),
                    const Color.fromARGB(255, 203, 128, 171),
                    const Color.fromARGB(255, 230, 217, 162),
                  ].map((color) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedColor = color;
                        });
                      },
                      child: CircleAvatar(
                        backgroundColor: color,
                        child: _selectedColor == color
                            ? const Icon(Icons.check, color: Colors.white)
                            : null,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            actions: [
              if (editTag != null)
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      _tags.remove(editTag);
                      _tagDurations.remove(editTag);
                      if (_selectedTag == editTag) _selectedTag = null;
                    });
                    Navigator.pop(context);
                  },
                ),
              IconButton(
                icon: const Icon(Icons.check),
                onPressed: () {
                  if (_tagNameController.text.isNotEmpty) {
                    _addOrEditTag(_tagNameController.text, _selectedColor);
                    _tagNameController.clear();
                  }
                },
              ),
            ],
          );
        },
      );
    },
  );
}

  @override
  void dispose() {
    _timer.cancel();
    _tagNameController.dispose();
    super.dispose();
  }
/*_________________________here the scaffold for visual layout____________________________*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(                                            //::::::::::: has the child
  child: Column(                                               //in vertical array :::::::: has mainAxisAlignment, children
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      GestureDetector(                                        //detects gestures and triggers call back :::::::::::: onTap, child
        onTap: _showTagSelectionDialog,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          decoration: BoxDecoration(                          //for box background and rounded corners
            color: _selectedTag != null ? _tags[_selectedTag!]!.withOpacity(0.3) : Colors.grey[300],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(                                        // in horizontal array :::::::: has mainAxisSize, children
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _selectedTag ?? 'Select Tag',
                style: TextStyle(
                  color: _selectedTag != null ? _tags[_selectedTag] : Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Icon(Icons.arrow_drop_down, color: Colors.black54),
            ],
          ),
        ),
      ),
      const SizedBox(height: 20),
      Text(                                                      //to display a string like here
        _formatDuration(_duration),
        style: const TextStyle(fontSize: 55, fontWeight: FontWeight.w400, color: Colors.black54),
      ),
      const SizedBox(height: 20),
      Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            Color.fromARGB(255, 240, 174, 221),
            Color.fromARGB(255, 199, 152, 240),
          ]),
          borderRadius: BorderRadius.all(Radius.circular(30)), 
        ),
        child: TextButton(                                        //button with text label ::::::::: onPressed, style, child
          onPressed: _toggleTimer,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 33),
            backgroundColor: Colors.transparent, 
          ),
          child: Text(
            _isRunning ? "STOP" : "START",
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
      const SizedBox(height: 20),
      IconButton(                                                 // button display icon ::::::::: icon, onPressed
        icon: const Icon(Icons.bar_chart),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => StatisticsScreen(tagDurations: _tagDurations, tags: _tags)));
        },
      ),
    ],
  ),
),

    );
  }
}