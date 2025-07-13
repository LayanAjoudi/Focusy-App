import 'package:flutter/material.dart';  // this is a package for create chart
import 'package:fl_chart/fl_chart.dart';

class StatisticsScreen extends StatelessWidget {
  final Map<String, Duration> tagDurations;          // these is provided info
  final Map<String, Color> tags;

  const StatisticsScreen({
    Key? key,
    required this.tagDurations,
    required this.tags,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalDuration = tagDurations.values.fold(Duration.zero, (sum, item) => sum + item);
    final sections = tagDurations.entries.map((entry) {   // this create obj contain section for each tag
      final percentage = totalDuration.inSeconds == 0 ? 0.0 : (entry.value.inSeconds / totalDuration.inSeconds * 100); // the rule to calculate the precentage
      return PieChartSectionData(
        color: tags[entry.key],
        value: percentage,
        title: "${percentage.toStringAsFixed(1)}%",
      );
    }).toList();

    String _formatDuration(Duration duration) {
      String twoDigits(int n) => n.toString().padLeft(2, '0');
      String hours = twoDigits(duration.inHours);
      String minutes = twoDigits(duration.inMinutes.remainder(60));
      String seconds = twoDigits(duration.inSeconds.remainder(60));
      return "$hours:$minutes:$seconds";
    }

return Scaffold(
  appBar: AppBar(
    flexibleSpace: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [
          Color.fromARGB(255, 240, 174, 221),
          Color.fromARGB(255, 199, 152, 240),
        ]),
      ),
    ),
    title: const Text(
      "The Statistics",
      style: TextStyle(fontSize: 33, fontWeight: FontWeight.w400),
    ),
    toolbarHeight: 100, // Adjust the height to give more space for the title
  ),
  body: Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(colors: [
        Color.fromARGB(255, 240, 174, 221),
        Color.fromARGB(255, 199, 152, 240),
      ]),
    ),
    child: ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(30), // Upper left corner
        topRight: Radius.circular(30), // Upper right corner
      ),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(44), // Inner padding
        child: Column(
          children: [
            if (sections.isNotEmpty)
              SizedBox(
                height: 300,
                child: PieChart(
                  PieChartData(
                    sections: sections,
                    centerSpaceRadius: 50,
                    sectionsSpace: 2,
                  ),
                ),
              )
            else
              const Text("No data yet"),
            const SizedBox(height: 20),
            Text("Total: ${_formatDuration(totalDuration)}"),
            Expanded(
              child: ListView.builder(
                itemCount: tagDurations.length,
                itemBuilder: (context, index) {
                  final tag = tagDurations.keys.elementAt(index);
                  final time = tagDurations[tag]!;
                  return ListTile(
                    leading: CircleAvatar(backgroundColor: tags[tag]),
                    title: Text(tag),
                    subtitle: Text(_formatDuration(time)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ),
  ),
);

  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(duration.inHours)}:${twoDigits(duration.inMinutes.remainder(60))}";
  }
}
