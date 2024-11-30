import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

import '../styles/styles.dart';

class SuccessDialogContent extends StatefulWidget {
  String? image;
  String? title;
  String? description;

  SuccessDialogContent({ required this.image,required this.title,required this.description});

  @override
  State<SuccessDialogContent> createState() => _SuccessDialogContentState();
}

class _SuccessDialogContentState extends State<SuccessDialogContent> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding:  EdgeInsets.symmetric(vertical: media.width * 0.1),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: media.width * 0.15, // Set width
              height: media.width * 0.15,
              margin: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: buttonColors, // Background color
                shape: BoxShape.circle, // Makes the container circular
              ),
              child:  Icon(Icons.check, color: headingColors,size: 26,),

            ),
             SizedBox(height: media.width * 0.02),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: media.width * 0.15),
              child: Text(
                widget.title.toString(),
                style: GoogleFonts.inter(fontSize: font24Size,
                  color: headingColors,
                  fontWeight: FontWeight.w700,),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: media.width * 0.1),
              child: Text(
                widget.description.toString(),
                style: GoogleFonts.inter(fontSize: font16Size, color: normalTextColors,fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}