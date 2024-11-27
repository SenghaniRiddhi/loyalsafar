

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../styles/styles.dart';

class TextFieldUI extends StatefulWidget {
  dynamic icon;
  dynamic onTap;
  final String text;
  final String hintText;
  final TextEditingController textController;
  dynamic inputType;
  dynamic maxLength;
  dynamic color;
  dynamic underline;
  dynamic autofocus;
  bool? readonly;

  // ignore: use_key_in_widget_constructors
  TextFieldUI(
      {this.icon,
        this.onTap,
        required this.text,
        required this.textController,
        this.inputType,
        this.maxLength,
        this.color,
        this.readonly,
        this.autofocus,
        this.underline, required this.hintText});

  @override
  State<TextFieldUI> createState() => _TextFieldUIState();
}

class _TextFieldUIState extends State<TextFieldUI> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return TextFormField(
      maxLength: (widget.maxLength == null) ? null : widget.maxLength,
      keyboardType: (widget.inputType == null)
          ? TextInputType.emailAddress
          : widget.inputType,
      autofocus: widget.autofocus ?? false,
      readOnly: widget.readonly ?? false,
      controller: widget.textController,
      decoration: InputDecoration(
        labelText: widget.text,
        hintText: widget.hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      style: GoogleFonts.notoSans(
        fontSize: media.width * sixteen,
        color: widget.color,
      ),
      onChanged: widget.onTap,
    );
  }
}