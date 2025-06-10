import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hey_champ_app/features/take_note/application/note_model.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../application/take_note_controller.dart';

class TakeNoteScreen extends StatefulWidget {
  final Note? existingNote;
  final int? noteIndex;

  const TakeNoteScreen({super.key, this.existingNote, this.noteIndex});

  @override
  State<TakeNoteScreen> createState() => _TakeNoteScreenState();
}

class _TakeNoteScreenState extends State<TakeNoteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  String _fontFamily = 'Roboto';
  double _fontSize = 16;
  bool _isBold = false;
  bool _isItalic = false;
  String _textAlign = 'left';
  Color _textColor = Colors.black;

  final controller = TakeNoteController();

  @override
  void initState() {
    super.initState();
    if (widget.existingNote != null) {
      final note = widget.existingNote!;
      _titleController.text = note.title;
      _contentController.text = note.content;
      _fontFamily = note.fontFamily;
      _fontSize = note.fontSize;
      _isBold = note.isBold;
      _isItalic = note.isItalic;
      _textAlign = note.textAlign;
      _textColor = Color(note.colorValue);
    }
  }

  void _saveNote() {
    final note = Note(
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      fontFamily: _fontFamily,
      fontSize: _fontSize,
      isBold: _isBold,
      isItalic: _isItalic,
      textAlign: _textAlign,
      colorValue: _textColor.value,
    );

    if (widget.noteIndex != null) {
      controller.updateNote(widget.noteIndex!, note);
    } else {
      controller.addNote(note);
    }

    Navigator.pop(context);
  }

  Future<void> _exportAsPDF() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (context) => pw.Text(
          _contentController.text,
          style: pw.TextStyle(
            fontSize: _fontSize,
            fontWeight: _isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
            fontStyle: _isItalic ? pw.FontStyle.italic : pw.FontStyle.normal,
          ),
          textAlign: _textAlign == 'center'
              ? pw.TextAlign.center
              : _textAlign == 'right'
              ? pw.TextAlign.right
              : pw.TextAlign.left,
        ),
      ),
    );

    // --- Change Starts Here ---
    // Use Printing.layoutPdf to invoke the platform's print/share dialog
    // This will give the user the option to save to a PDF (e.g., in Downloads) or print.
    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
      name: "${_titleController.text}.pdf", // Suggests a filename to the system
    );

    // No need for ScaffoldMessenger.of(context).showSnackBar here
    // because the system's UI handles the success/failure feedback for saving/printing.
    // If you want some initial feedback, you can add it before Printing.layoutPdf:
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Opening PDF save/share options...")),
    );
    // --- Change Ends Here ---
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingNote == null ? "Create Note" : "Edit Note"),
        actions: [
          IconButton(icon: Icon(Icons.picture_as_pdf), onPressed: _exportAsPDF),
          IconButton(icon: Icon(Icons.save), onPressed: _saveNote),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _contentController,
              maxLines: 10,
              decoration: InputDecoration(labelText: 'Content'),
              style: TextStyle(
                fontFamily: _fontFamily,
                fontSize: _fontSize,
                fontWeight: _isBold ? FontWeight.bold : FontWeight.normal,
                fontStyle: _isItalic ? FontStyle.italic : FontStyle.normal,
                color: _textColor,
              ),
              textAlign: _textAlign == 'center'
                  ? TextAlign.center
                  : _textAlign == 'right'
                  ? TextAlign.right
                  : TextAlign.left,
            ),
            SizedBox(height: 10),
            Row(
              children: [
                TextButton(
                  child: Text(_isBold ? "Bold ✓" : "Bold"),
                  onPressed: () => setState(() => _isBold = !_isBold),
                ),
                TextButton(
                  child: Text(_isItalic ? "Italic ✓" : "Italic"),
                  onPressed: () => setState(() => _isItalic = !_isItalic),
                ),
                TextButton(
                  child: Text("Color"),
                  onPressed: () async {
                    final color = await showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text("Pick Text Color"),
                        content: SingleChildScrollView(
                          child: BlockPicker(
                            pickerColor: _textColor,
                            onColorChanged: (color) =>
                                Navigator.pop(context, color),
                          ),
                        ),
                      ),
                    );
                    if (color != null) setState(() => _textColor = color);
                  },
                ),
              ],
            ),
            DropdownButton<String>(
              value: _fontFamily,
              items: ['Roboto', 'OpenSans', 'Lato', 'Montserrat', 'Courier']
                  .map(
                    (font) => DropdownMenuItem(value: font, child: Text(font)),
                  )
                  .toList(),
              onChanged: (value) => setState(() => _fontFamily = value!),
            ),
            Slider(
              min: 12,
              max: 30,
              value: _fontSize,
              onChanged: (val) => setState(() => _fontSize = val),
              label: "Font Size",
            ),
            DropdownButton<String>(
              value: _textAlign,
              items: ['left', 'center', 'right']
                  .map(
                    (align) =>
                        DropdownMenuItem(value: align, child: Text(align)),
                  )
                  .toList(),
              onChanged: (val) => setState(() => _textAlign = val!),
            ),
          ],
        ),
      ),
    );
  }
}
