import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hey_champ_app/common/widgets/screen_name.dart';
import 'package:hey_champ_app/core/constants/color_constants.dart';
import 'package:hey_champ_app/features/study_session/application/subject_controller.dart';
import 'package:hey_champ_app/routes/app_routes.dart';

class SubjectListScreen extends StatefulWidget {
  const SubjectListScreen({super.key});

  @override
  State<SubjectListScreen> createState() => _SubjectListScreenState();
}

class _SubjectListScreenState extends State<SubjectListScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        floatingActionButton: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          backgroundColor: AppColors.primaryText,
          foregroundColor: AppColors.background,
          onPressed: () {
            router.push('/add-edit-subject-screen');
          },
          child: const Icon(Icons.add, size: 30,),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ScreenName(name: "Subjects"),
            const SizedBox(height: 10),
            Expanded(
              child: Consumer<SubjectController>(
                builder: (context, controller, child) {
                  if (controller.subjects.isEmpty) {
                    return const Center(
                      child: Text(
                        "No subjects added yet.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: controller.subjects.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final subject = controller.subjects[index];
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryText,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.primaryText),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: subject.color,
                              child: Icon(
                                subject.icon ?? Icons.book,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  router.push(
                                    '/subject-detail-screen',
                                    extra: subject,
                                  );
                                },
                                child: Text(
                                  subject.name.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.background,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                router.push(
                                  '/add-edit-subject-screen',
                                  extra: subject,
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                controller.deleteSubject(subject.id);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
