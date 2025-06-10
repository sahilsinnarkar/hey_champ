import 'package:flutter/material.dart';
import 'package:hey_champ_app/features/take_note/application/note_model.dart';
import 'package:hey_champ_app/features/take_note/presentation/take_note_screen.dart';
import 'package:hey_champ_app/routes/app_routes.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../application/take_note_controller.dart';

class NoteListScreen extends StatefulWidget {
  const NoteListScreen({super.key});

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  final controller = TakeNoteController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Your Notes")),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Note>('notes').listenable(),
        builder: (context, Box<Note> box, _) {
          if (box.isEmpty) return Center(child: Text("No notes yet."));
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final note = box.getAt(index)!;
              return ListTile(
                title: Text(note.title),
                subtitle: Text(
                  note.content,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          TakeNoteScreen(existingNote: note, noteIndex: index),
                    ),
                  );
                },
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    controller.deleteNote(index);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          router.push('/take-note-screen');
        },
      ),
    );
  }
}
