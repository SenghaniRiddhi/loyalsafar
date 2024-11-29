

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../styles/styles.dart';

class TextFieldUI extends StatefulWidget {
  dynamic icon;
  dynamic onTap;
  final String? hintText;
  final String labelText;
  final TextEditingController textController;
  dynamic inputType;
  dynamic maxLength;
  dynamic color;
  dynamic underline;
  dynamic autofocus;
  bool? readonly;
  FocusNode? focusNode;

  // ignore: use_key_in_widget_constructors
  TextFieldUI(
      {this.icon,
        this.onTap,
        required this.textController,
        this.inputType,
        this.maxLength,
        this.color,
        this.readonly,
        this.autofocus,
        this.underline,
        required this.labelText,
         this.hintText , this.focusNode});

  @override
  State<TextFieldUI> createState() => _TextFieldUIState();
}

class _TextFieldUIState extends State<TextFieldUI> {

  @override
  Widget build(BuildContext context) {
    print("facousNode ${widget.focusNode?.hasFocus}");
    var media = MediaQuery.of(context).size;
    return   Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: TextFormField(
        controller: widget.textController,
        decoration: InputDecoration(
          labelText: widget.labelText,
          // hintText: !cilckTextField ? "Enter First Name" : "",
          border: InputBorder.none,
        ),
      ),
    );
  }
}