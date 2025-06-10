import 'package:flutter/material.dart';
import 'package:hey_champ_app/features/study_session/application/subject_model.dart';
import 'package:hive/hive.dart';

class SubjectController with ChangeNotifier {
  late Box<Subject> _subjectBox;

  List<Subject> get subjects => _subjectBox.values.toList();

  SubjectController() {
    _subjectBox = Hive.box<Subject>('subjects');
  }

  void addSubject(Subject subject) {
    _subjectBox.put(subject.id, subject);
    notifyListeners();
  }

  void editSubject(String id, Subject updated) {
    _subjectBox.put(id, updated);
    notifyListeners();
  }

  void deleteSubject(String id) {
    _subjectBox.delete(id);
    notifyListeners();
  }
}