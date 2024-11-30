
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../styles/styles.dart';

class BottomSheetContent extends StatefulWidget {
  String? title;
  String? description;
  String? image;
  String? button1;
  String? button2;
  Function()? onClick;

  BottomSheetContent(
      {required this.image,required this.title,required this.description,required this.button1,
        required this.button2,required this.onClick});

  @override
  State<BottomSheetContent> createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<BottomSheetContent> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: media.width*0.03),
          Container(
              width: media.width*0.3,
              height: media.width*0.3,
              child: Image.asset(widget.image.toString(),fit: BoxFit.cover,color: iconColors,)),
          const SizedBox(height: 05),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.title.toString(),
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                  fontSize: font24Size,
                  fontWeight: FontWeight.w800,
                  color: headingColors
              ),

            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: media.width*0.09),
            child: Text(
              widget.description.toString(),
              style: GoogleFonts.inter(
                  fontSize: font18Size,
                  fontWeight: FontWeight.w400,
                  color: headingColors
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 35),
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: media.width*0.04),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: iconColors,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
                onPressed: widget.onClick,
                child:  Text(
                  widget.button1.toString(),
                  style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600,fontSize: font18Size),
                ),
              ),
            ),
          ),
          SizedBox(height: media.width*0.05),
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: media.width*0.04),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  side:  BorderSide(
                    color: Color(0xffC6C6C6), // Set your border color
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  // Handle account deactivation
                },
                child:  Text(
                  widget.button2.toString(),
                  style:GoogleFonts.inter(color: Color(0xff5E5E5E), fontWeight: FontWeight.w700,fontSize: font16Size),
                ),
              ),
            ),
          ),
          SizedBox(height: media.width*0.03),

        ],
      ),
    );
  }
}