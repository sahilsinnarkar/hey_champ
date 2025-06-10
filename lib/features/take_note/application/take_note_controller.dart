import 'package:hey_champ_app/features/take_note/application/note_model.dart';
import 'package:hive/hive.dart';

class TakeNoteController {
  final Box<Note> noteBox = Hive.box<Note>('notes');

  List<Note> get notes => noteBox.values.toList();

  void addNote(Note note) => noteBox.add(note);

  void updateNote(int index, Note note) {
    noteBox.putAt(index, note);
  }

  void deleteNote(int index) {
    noteBox.deleteAt(index);
  }
}