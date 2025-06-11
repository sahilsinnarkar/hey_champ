import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hey_champ_app/common/widgets/my_button.dart';
import 'package:hey_champ_app/common/widgets/my_textfield.dart';
import 'package:hey_champ_app/common/widgets/screen_name.dart';
import 'package:hey_champ_app/core/constants/color_constants.dart';
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

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
      name: "${_titleController.text}.pdf", // Suggests a filename to the system
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Opening PDF save/share options...")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double h = MediaQuery.of(context).size.height;
    final double w = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            ScreenName(
              name: widget.existingNote == null ? "Create Note" : "Edit Note",
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: ListView(
                  children: [
                    MyTextField(
                      controller: _titleController,
                      hintText: "Title",
                      height: h * 0.06,
                    ),
                    SizedBox(height: 8),
                    Container(
                      height: 300, // Fixed height
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryText,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: _contentController,
                        expands: true,
                        maxLines: null,
                        minLines: null,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Content',
                          labelStyle: TextStyle(
                            color: AppColors.buttonDisabled,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: TextStyle(
                          fontFamily: _fontFamily,
                          fontSize: _fontSize,
                          fontWeight: _isBold
                              ? FontWeight.bold
                              : FontWeight.normal,
                          fontStyle: _isItalic
                              ? FontStyle.italic
                              : FontStyle.normal,
                          color: _textColor,
                        ),
                        textAlign: _textAlign == 'center'
                            ? TextAlign.center
                            : _textAlign == 'right'
                            ? TextAlign.right
                            : TextAlign.left,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        TextButton(
                          child: Text(
                            _isBold ? "Bold ✔️" : "Bold",
                            style: TextStyle(
                              color: AppColors.primaryText,
                              fontSize: 18,
                            ),
                          ),
                          onPressed: () => setState(() => _isBold = !_isBold),
                        ),
                        TextButton(
                          child: Text(
                            _isItalic ? "Italic ✔️" : "Italic",
                            style: TextStyle(
                              color: AppColors.primaryText,
                              fontSize: 18,
                            ),
                          ),
                          onPressed: () =>
                              setState(() => _isItalic = !_isItalic),
                        ),
                        TextButton(
                          child: Text(
                            "Color",
                            style: TextStyle(
                              color: AppColors.primaryText,
                              fontSize: 18,
                            ),
                          ),
                          onPressed: () async {
                            final color = await showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text(
                                  "Pick Text Color",
                                  style: TextStyle(
                                    color: AppColors.background,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                content: SingleChildScrollView(
                                  child: BlockPicker(
                                    pickerColor: _textColor,
                                    onColorChanged: (color) =>
                                        Navigator.pop(context, color),
                                  ),
                                ),
                              ),
                            );
                            if (color != null) {
                              setState(() => _textColor = color);
                            }
                          },
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      width: w,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          style: BorderStyle.solid,
                          width: 2,
                          color: AppColors.primaryText,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        // Removes default underline
                        child: DropdownButton<String>(
                          value: _fontFamily,
                          isExpanded: true,
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: AppColors.primaryText,
                          ),
                          dropdownColor: AppColors.background,
                          style: TextStyle(
                            color: AppColors.primaryText,
                            fontSize: 15,
                          ),
                          items:
                              [
                                    'Roboto',
                                    'OpenSans',
                                    'Lato',
                                    'Montserrat',
                                    'Courier',
                                  ]
                                  .map(
                                    (font) => DropdownMenuItem(
                                      value: font,
                                      child: Text(font),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (value) =>
                              setState(() => _fontFamily = value!),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "Font Size",
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontSize: 18,
                      ),
                    ),
                    Slider(
                      min: 12,
                      max: 30,
                      value: _fontSize,
                      onChanged: (val) => setState(() => _fontSize = val),
                      label: "Font Size",
                      activeColor: AppColors.primaryText,
                      inactiveColor: AppColors.secondaryText,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      width: w,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          style: BorderStyle.solid,
                          width: 2,
                          color: AppColors.primaryText,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _textAlign,
                          isExpanded: true,
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: AppColors.primaryText,
                          ),
                          dropdownColor: AppColors.background,
                          style: TextStyle(
                            color: AppColors.primaryText,
                            fontSize: 15,
                          ),
                          items: ['left', 'center', 'right']
                              .map(
                                (align) => DropdownMenuItem(
                                  value: align,
                                  child: Text(align),
                                ),
                              )
                              .toList(),
                          onChanged: (val) => setState(() => _textAlign = val!),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyButton(
                          text: "Save", 
                          onPressed: _saveNote,
                          width: w * 0.45,
                          height: h * 0.04,
                        ),
                        MyButton(
                          text: "PDF", 
                          onPressed: _exportAsPDF,
                          width: w * 0.45,
                          height: h * 0.04,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
