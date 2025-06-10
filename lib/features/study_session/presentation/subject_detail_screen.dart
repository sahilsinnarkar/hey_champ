import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hey_champ_app/features/study_session/application/focus_session_controller.dart';
import 'package:hey_champ_app/features/study_session/application/subject_model.dart';
import 'package:intl/intl.dart';

class SubjectDetailScreen extends StatefulWidget {
  final Subject subject;

  const SubjectDetailScreen({super.key, required this.subject});

  @override
  State<SubjectDetailScreen> createState() => _SubjectDetailScreenState();
}

class _SubjectDetailScreenState extends State<SubjectDetailScreen> {
  String? _activeSessionId;

  void _startSession() {
    final controller = Provider.of<FocusSessionController>(context, listen: false);
    final newId = UniqueKey().toString();
    controller.startSession(widget.subject.id);
    setState(() {
      _activeSessionId = newId;
    });
  }

  void _endSession() {
    if (_activeSessionId != null) {
      final controller = Provider.of<FocusSessionController>(context, listen: false);
      controller.endSession(_activeSessionId!);
      setState(() {
        _activeSessionId = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<FocusSessionController>(context);
    final sessions = controller.getSessionsBySubject(widget.subject.id);
    final totalDuration = controller.getTotalFocusTime(widget.subject.id);

    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(Duration(days: 6));
    final chartData = controller.getFocusPerSubjectInRange(weekStart, weekEnd);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subject.name),
        backgroundColor: widget.subject.color,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 🔢 Total Focus Time
            Text(
              "Total Focus Time: ${_formatDuration(totalDuration)}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // 🟢 Start/Stop Button
            ElevatedButton.icon(
              icon: Icon(_activeSessionId == null ? Icons.play_arrow : Icons.stop),
              onPressed: _activeSessionId == null ? _startSession : _endSession,
              label: Text(_activeSessionId == null ? "Start Focus" : "End Focus"),
            ),

            const SizedBox(height: 20),

            // 📊 Pie Chart
            Expanded(
              child: PieChart(
                PieChartData(
                  sections: chartData.entries.map((entry) {
                    final isThis = entry.key == widget.subject.id;
                    return PieChartSectionData(
                      color: isThis ? widget.subject.color : Colors.grey[300],
                      value: entry.value.inMinutes.toDouble(),
                      title: isThis ? '${entry.value.inMinutes} min' : '',
                      radius: isThis ? 70 : 60,
                      titleStyle: const TextStyle(color: Colors.white, fontSize: 16),
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 🕒 Recent Sessions
            Expanded(
              child: ListView.builder(
                itemCount: sessions.length,
                itemBuilder: (context, index) {
                  final session = sessions[sessions.length - 1 - index]; // latest first
                  return ListTile(
                    leading: Icon(Icons.timer),
                    title: Text(
                      "${DateFormat.yMMMd().add_jm().format(session.startTime)} → ${DateFormat.jm().format(session.endTime)}",
                    ),
                    subtitle: Text("Duration: ${_formatDuration(session.duration)}"),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    return "${d.inHours.toString().padLeft(2, '0')}:${(d.inMinutes % 60).toString().padLeft(2, '0')}h";
  }
}
