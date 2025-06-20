import 'package:flutter/material.dart';
import 'package:hey_champ_app/common/widgets/screen_name.dart';
import 'package:hey_champ_app/core/constants/color_constants.dart';
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            ScreenName(name: "Notes"),
            ValueListenableBuilder(
              valueListenable: Hive.box<Note>('notes').listenable(),
              builder: (context, Box<Note> box, _) {
                if (box.isEmpty) {
                  return Center(
                    child: Text(
                      "No notes yet.",
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontSize: 18,
                      ),
                    ),
                  );
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: box.length,
                    itemBuilder: (context, index) {
                      final note = box.getAt(index)!;
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryText,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ListTile(
                          title: Text(
                            note.title,
                            style: TextStyle(
                              color: AppColors.background,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          subtitle: Text(
                            note.content,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TakeNoteScreen(
                                  existingNote: note,
                                  noteIndex: index,
                                ),
                              ),
                            );
                          },
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              controller.deleteNote(index);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.primaryText,
          foregroundColor: AppColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          child: Icon(Icons.add, size: 30,),
          onPressed: () {
            router.push('/take-note-screen');
          },
        ),
      ),
    );
  }
}
