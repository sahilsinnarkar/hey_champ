import 'package:hey_champ_app/routes/app_routes.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:hey_champ_app/features/study_session/application/subject_controller.dart';

class SubjectListScreen extends StatefulWidget {
  const SubjectListScreen({super.key});

  @override
  State<SubjectListScreen> createState() => _SubjectListScreenState();
}

class _SubjectListScreenState extends State<SubjectListScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SubjectController>(
      builder: (context, controller, child) {
        return Scaffold(
          appBar: AppBar(title: Text("Subjects")),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // navigate to AddEditSubjectScreen
              router.push('/add-edit-subject-screen');
            },
            child: Icon(Icons.add),
          ),
          body: ListView.builder(
            itemCount: controller.subjects.length,
            itemBuilder: (context, index) {
              final subject = controller.subjects[index];
              return GestureDetector(
                onTap: () {
                  // navigate to SubjectDetailScreen
                  router.push('/subject-detail-screen', extra: subject);
                },
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: subject.color,
                    child: Icon(subject.icon ?? Icons.book),
                  ),
                  title: Text(subject.name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          // open edit screen
                          router.push('/add-edit-subject-screen', extra: subject);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          controller.deleteSubject(subject.id);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
