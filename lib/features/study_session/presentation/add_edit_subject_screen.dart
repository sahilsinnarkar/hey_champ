import 'package:flutter/material.dart';
import 'package:hey_champ_app/common/widgets/my_button.dart';
import 'package:hey_champ_app/common/widgets/screen_name.dart';
import 'package:hey_champ_app/core/constants/color_constants.dart';
import 'package:hey_champ_app/features/study_session/application/subject_model.dart';
import 'package:hey_champ_app/features/study_session/application/subject_controller.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddEditSubjectScreen extends StatefulWidget {
  final Subject? subject; // If null, it's Add mode

  const AddEditSubjectScreen({super.key, this.subject});

  @override
  State<AddEditSubjectScreen> createState() => _AddEditSubjectScreenState();
}

class _AddEditSubjectScreenState extends State<AddEditSubjectScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  Color _selectedColor = Colors.blue;
  IconData? _selectedIcon;

  final List<IconData> _iconChoices = [
    Icons.book,
    Icons.laptop,
    Icons.science,
    Icons.code,
    Icons.edit,
    Icons.calculate,
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.subject?.name ?? "");
    _selectedColor = widget.subject?.color ?? Colors.blue;
    _selectedIcon = widget.subject?.icon ?? Icons.book;
  }

  void _saveSubject() {
    if (_formKey.currentState!.validate()) {
      final controller = Provider.of<SubjectController>(context, listen: false);

      final newSubject = Subject.withUI(
        id: widget.subject?.id ?? const Uuid().v4(),
        name: _nameController.text.trim(),
        color: _selectedColor,
        icon: _selectedIcon,
      );

      if (widget.subject == null) {
        controller.addSubject(newSubject);
      } else {
        controller.editSubject(widget.subject!.id, newSubject);
      }

      Navigator.of(context).pop(); // Close the form
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.subject != null;
    final w = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            ScreenName(name: isEditing ? 'Edit Subject' : 'Add Subject'),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 10),
                        width: w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            style: BorderStyle.solid,
                            width: 2,
                            color: AppColors.primaryText,
                          ),
                        ),
                        child: TextFormField(
                          controller: _nameController,
                          style: TextStyle(
                            color: AppColors.primaryText,
                            fontSize: 15,
                          ),
                          validator: (value) =>
                              value == null || value.trim().isEmpty
                              ? 'Required'
                              : null,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Subject Name',
                            hintStyle: TextStyle(
                              color: AppColors.secondaryText,
                              fontSize: 15,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 16,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Text(
                        "Pick a Color",
                        style: TextStyle(
                          color: AppColors.primaryText,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: Colors.primaries
                            .take(8)
                            .map(
                              (color) => GestureDetector(
                                onTap: () {
                                  setState(() => _selectedColor = color);
                                },
                                child: CircleAvatar(
                                  backgroundColor: color,
                                  radius: 20,
                                  child: _selectedColor == color
                                      ? const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                        )
                                      : null,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 24),

                      Text(
                        "Pick an Icon",
                        style: TextStyle(
                          color: AppColors.primaryText,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 12,
                        children: _iconChoices.map((icon) {
                          return GestureDetector(
                            onTap: () => setState(() => _selectedIcon = icon),
                            child: CircleAvatar(
                              backgroundColor: _selectedIcon == icon
                                  ? _selectedColor
                                  : Colors.grey[300],
                              child: Icon(
                                icon,
                                color: _selectedIcon == icon
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 32),
                      MyButton(text: "Add Subject", onPressed: _saveSubject),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
