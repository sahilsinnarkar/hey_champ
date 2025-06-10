import 'package:flutter/material.dart';
import 'package:hey_champ_app/features/study_session/application/focus_session_model.dart';
import 'package:hive/hive.dart';

class FocusSessionController with ChangeNotifier {
  late Box<FocusSession> _sessionBox;

  List<FocusSession> get sessions => _sessionBox.values.toList();

  FocusSessionController() {
    _sessionBox = Hive.box<FocusSession>('sessions');
  }

  FocusSession? _activeSession;

  FocusSession? get activeSession => _activeSession;

  void startSession(String subjectId) {
    final now = DateTime.now();
    final session = FocusSession(
      id: UniqueKey().toString(),
      subjectId: subjectId,
      startTime: now,
      endTime: now,
    );
    _activeSession = session;
    _sessionBox.put(session.id, session);
    notifyListeners();
  }

  void endSession(String s) {
    if (_activeSession != null) {
      _activeSession!.endTime = DateTime.now();
      _activeSession!.save();
      _activeSession = null;
      notifyListeners();
    }
  }

  List<FocusSession> getSessionsBySubject(String subjectId) {
    return _sessionBox.values.where((s) => s.subjectId == subjectId).toList();
  }

  Duration getTotalFocusTime(String subjectId) {
    final sessions = getSessionsBySubject(subjectId);
    return sessions.fold(Duration.zero, (sum, s) => sum + s.duration);
  }

  List<FocusSession> getSessionsInRange(DateTime start, DateTime end) {
    return _sessionBox.values
        .where((s) => s.startTime.isAfter(start) && s.endTime.isBefore(end))
        .toList();
  }

  Map<String, Duration> getFocusPerSubjectInRange(
    DateTime start,
    DateTime end,
  ) {
    final sessions = getSessionsInRange(start, end);
    final Map<String, Duration> data = {};
    for (var session in sessions) {
      data[session.subjectId] =
          (data[session.subjectId] ?? Duration.zero) + session.duration;
    }
    return data;
  }
}
