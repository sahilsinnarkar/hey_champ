import 'package:flutter/material.dart';
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

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Subject' : 'Add Subject')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Subject Name'),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              Text(
                "Pick a Color",
                style: Theme.of(context).textTheme.labelLarge,
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
                              ? const Icon(Icons.check, color: Colors.white)
                              : null,
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 24),

              Text(
                "Pick an Icon",
                style: Theme.of(context).textTheme.labelLarge,
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

              ElevatedButton.icon(
                icon: Icon(isEditing ? Icons.save : Icons.add),
                label: Text(isEditing ? 'Save Changes' : 'Add Subject'),
                onPressed: _saveSubject,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
