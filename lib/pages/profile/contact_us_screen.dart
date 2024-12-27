import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_user/functions/functions.dart';
import 'package:flutter_user/widgets/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../styles/styles.dart';
import '../../widgets/appbar.dart';

class ContactUsScreen extends StatefulWidget {
  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final _subjectController = TextEditingController();
  final _emailController = TextEditingController();
  final _descriptionController = TextEditingController();
  XFile? _selectedImage;

  void _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _selectedImage = image;
    });
  }

  void _submitForm() {
    // Implement your form submission logic
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: whiteColors,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: EdgeInsets.symmetric(horizontal: media.width * 0.04),
              child: appBarWidget(context: context,
                  onTaps: (){
                    Navigator.pop(context, true);
                  },
                  backgroundIcon: Color(0xffECECEC), title: "",iconColors: iconGrayColors),
            ),
        
        
            Center(
              child: Column(
                children: [
                  SizedBox(height:media.height*0.010),
                  Center(
                      child: Container(
                        height: media.width * 0.20,
                        width: media.width * 0.20,
                        child: Image.asset("assets/icons/contactUs.png",fit: BoxFit.cover,),
                      )
                  ),
                  SizedBox(height:media.height*0.015),
        
                  MyText(text: 'Contact Us',
                    size: font25Size,fontweight: FontWeight.w700,color: Color(0xff06213F),),
        
                  SizedBox(height:media.height*0.015),
                  MyText(text: 'Send us a message describing your issue\nand we will get back to you shortly.',
                    size: font16Size,fontweight: FontWeight.w400,color: Color(0xff5E5E5E),
                    textAlign: TextAlign.center,
                  ),
        
                ],
              ),
            ),
            SizedBox(height: media.height * 0.04),
        
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: media.width * 0.04),
              child: Column(children: [
        
                Container(
                  // padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 03),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(09),
                      border: Border.all(
                        color: hintColor,
                      )),
                  // width: width ?? media.width * 0.9,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  // padding: const EdgeInsets.only(right: 5, bottom: 5),
                  child:  TextField(
                    controller: _subjectController,
                    decoration: InputDecoration(
                        labelText: 'Subject',
                        labelStyle: GoogleFonts.inter(
                          color: Color(0xff5C6266),
                          fontSize: font16Size,
                          fontWeight: FontWeight.w400,
                        ) ,
                        hintStyle: GoogleFonts.inter(
                          color: Color(0xff5C6266),
                          fontSize: font16Size,
                          fontWeight: FontWeight.w400,
                        ),
                        border: InputBorder.none
                    ),
                    style: GoogleFonts.inter(
                      color: Color(0xff303030),
                      fontSize: font16Size,
                      fontWeight: FontWeight.w500,
                    ),
                    // onChanged: (val) {
                    //   setState(() {});
                    // },
                  ),
                ),
                SizedBox(height: media.height * 0.025),
                Container(
                  // padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 03),
        
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(09),
                      border: Border.all(
                        color: hintColor,
                      )),
                  // width: width ?? media.width * 0.9,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  // padding: const EdgeInsets.only(right: 5, bottom: 5),
                  child:  TextField(
                    controller: _emailController,
        
                    decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: GoogleFonts.inter(
                          color: Color(0xff5C6266),
                          fontSize: font16Size,
                          fontWeight: FontWeight.w400,
                        ) ,
                        hintStyle: GoogleFonts.inter(
                          color: Color(0xff5C6266),
                          fontSize: font16Size,
                          fontWeight: FontWeight.w400,
                        ),
                        border: InputBorder.none
                    ),
                    style: GoogleFonts.inter(
                      color: Color(0xff303030),
                      fontSize: font16Size,
                      fontWeight: FontWeight.w500,
                    ),
                    // onChanged: (val) {
                    //   setState(() {});
                    // },
                  ),
                ),
                SizedBox(height: media.height * 0.025),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(09),
                      border: Border.all(
                        color: hintColor,
                      )),
                  // width: width ?? media.width * 0.9,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  // padding: const EdgeInsets.only(right: 5, bottom: 5),
                  child:  TextField(
                    controller: _descriptionController,
                    readOnly: false,
                    maxLines: 6,
                    decoration: InputDecoration(
                        labelText: "Description",
                        alignLabelWithHint: true,
                        labelStyle: GoogleFonts.inter(
                          color: Color(0xff5C6266),
                          fontSize: font16Size,
                          fontWeight: FontWeight.w400,
                        ) ,
        
                        hintStyle: GoogleFonts.inter(
                          color: Color(0xff5C6266),
                          fontSize: font16Size,
                          fontWeight: FontWeight.w400,
                        ),
                        border: InputBorder.none
                    ),
                    style: GoogleFonts.inter(
                      color: Color(0xff303030),
                      fontSize: font16Size,
                      fontWeight: FontWeight.w400,
                    ),
                    // onChanged: (val) {
                    //   setState(() {});
                    // },
                  ),
                ),
                SizedBox(height: media.height * 0.025),
        
                Container(
                  alignment: Alignment.topLeft,
                  child: MyText(text: 'Attachment',
                    size: font16Size,fontweight: FontWeight.w400,color: Color(0xff5C6266),
                    textAlign: TextAlign.start,
                  ),
                ),
        
                SizedBox(height: media.height * 0.01),
        
                Row(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xffefeeee)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: _selectedImage == null
                            ? Icon(Icons.add, size: 25, color: hintColor)
                            : Image.file(File(_selectedImage!.path), fit: BoxFit.cover),
                      ),
                    ),
                    if (_selectedImage != null)
                      IconButton(
                        icon: Icon(Icons.cancel, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            _selectedImage = null;
                          });
                        },
                      ),
                  ],
                ),
        
                SizedBox(height: media.height * 0.02),
        
                Container(
                  padding: EdgeInsets.only(
                      top: media.width * 0.05,
                      bottom: media.width * 0.05),
                  child: Button(
                    color: buttonColors,
                    borcolor: buttonColors,
                    textcolor: Color(0xff030303),
                    onTap: () async {

                      ContactUsData(subject: _subjectController.text,
                          email: _emailController.text, des: _descriptionController.text,
                          files: _selectedImage?.path,context: context);
                    },
                    text: "Submit",
                  ),
                )
        
              ],),
            ),
          ],
        ),
      ),
    );
  }
}
