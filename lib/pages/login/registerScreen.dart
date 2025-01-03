

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../functions/functions.dart';
import '../../styles/styles.dart';
import '../../translations/translation.dart';
import '../../widgets/appbar.dart';
import '../../widgets/widgets.dart';
import '../NavigatorPages/editprofile.dart';
import '../onTripPage/map_page.dart';
import '../profile/HomeScreen.dart';
import '../referralcode/referral_code.dart';
import 'login.dart';

class Registerscreen extends StatefulWidget {
  String numbers;
  String countryCode;

  Registerscreen({required this.numbers,required this.countryCode});

  @override
  State<Registerscreen> createState() => _RegisterscreenState();
}

class _RegisterscreenState extends State<Registerscreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  String country ="";
  final _formKey = GlobalKey<FormState>();
  // TextEditingController usergender = TextEditingController();

  navigate() {

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => CustomBottomNavExample()));
  }

  //pick image from gallery
  pickImageFromGallery() async {
    var permission = await getGalleryPermission();
    if (permission == PermissionStatus.granted) {
      final pickedFile =
      await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

      proImageFile1 = pickedFile?.path;
      pickImage = false;
      valueNotifierLogin.incrementNotifier();
      profilepicturesink.add('');
    } else {
      valueNotifierLogin.incrementNotifier();
      profilepicturesink.add('');
    }
  }

  getGalleryPermission() async {
    dynamic status;
    if (platform == TargetPlatform.android) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt <= 32) {
        status = await Permission.storage.status;
        if (status != PermissionStatus.granted) {
          status = await Permission.storage.request();
        }

        /// use [Permissions.storage.status]
      } else {
        status = await Permission.photos.status;
        if (status != PermissionStatus.granted) {
          status = await Permission.photos.request();
        }
      }
    } else {
      status = await Permission.photos.status;
      if (status != PermissionStatus.granted) {
        status = await Permission.photos.request();
      }
    }
    return status;
  }

//get camera permission
  getCameraPermission() async {
    var status = await Permission.camera.status;
    if (status != PermissionStatus.granted) {
      status = await Permission.camera.request();
    }
    return status;
  }

//pick image from camera
  pickImageFromCamera() async {
    var permission = await getCameraPermission();
    if (permission == PermissionStatus.granted) {
      final pickedFile =
      await picker.pickImage(source: ImageSource.camera, imageQuality: 50);

      proImageFile1 = pickedFile?.path;
      pickImage = false;
      valueNotifierLogin.incrementNotifier();
      profilepicturesink.add('');
    } else {
      valueNotifierLogin.incrementNotifier();
      profilepicturesink.add('');
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    mobileController.text = widget.numbers;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: whiteColors,
      // appBar: AppBar(),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: media.width * 0.12,),
                Padding(padding: EdgeInsets.symmetric(horizontal: media.width * 0.03),
                  child:  appBarWithoutHeightWidget(context: context,
                      onTaps: (){
                        Navigator.pop(context);
                      },
                      backgroundIcon: Color(0xffECECEC), title: "",iconColors: iconGrayColors),
                ),


                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(media.width * 0.05),
                    width: media.width * 1,
                    color: page,
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                // SizedBox(height: media.width * 0.05),

                                AnimatedCrossFade(
                                    firstChild: Container(),
                                    secondChild: Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              pickImage = true;
                                            });
                                          },
                                          child: Stack(
                                            children: [
                                              Container(
                                                height: media.width * 0.35,
                                                width: media.width * 0.35,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.red,
                                                    image: (proImageFile1 ==
                                                        null)
                                                        ? const DecorationImage(
                                                        image:
                                                        AssetImage(
                                                          'assets/images/default-profile-picture.jpeg',
                                                        ),
                                                        fit: BoxFit
                                                            .cover)
                                                        : DecorationImage(
                                                        image: FileImage(
                                                            File(
                                                                proImageFile1)),
                                                        fit: BoxFit
                                                            .cover)),
                                              ),
                                              Positioned(
                                                  // bottom: 0,
                                                  top: media.height * 0.12,
                                                  right: media.height * 0.022,
                                                  child: Container(
                                                      padding:
                                                      EdgeInsets.all(
                                                          media.width *
                                                              0.015),
                                                      decoration:
                                                      const BoxDecoration(
                                                          shape: BoxShape
                                                              .circle,
                                                          color: Colors
                                                              .grey),
                                                      child: Icon(
                                                        Icons.edit,
                                                        size: media.width *
                                                            0.025,
                                                      )))
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: media.width * 0.05,
                                        ),
                                      ],
                                    ),
                                    crossFadeState: CrossFadeState.showSecond,
                                    duration:
                                    const Duration(milliseconds: 200)),



                                SizedBox(
                                  height: media.width * 0.04,
                                ),




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
                                    controller: nameController,

                                    decoration: InputDecoration(
                                        labelText: "name",
                                        labelStyle: GoogleFonts.inter(
                                          color: Color(0xff5C6266),
                                          fontSize: font13Size,
                                          fontWeight: FontWeight.w500,
                                        ) ,
                                        // hintText: hinttext,
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

                                SizedBox(
                                  height: media.height * 0.02,
                                ),

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
                                    controller: lastnameController,
                                    decoration: InputDecoration(
                                        labelText: "Last Name",
                                        labelStyle: GoogleFonts.inter(
                                          color: Color(0xff5C6266),
                                          fontSize: font13Size,
                                          fontWeight: FontWeight.w500,
                                        ) ,
                                        // hintText: hinttext,
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

                                SizedBox(
                                  height: media.height * 0.02,
                                ),

                                // Text("hello"),


                                Column(
                                  children: [
                                    Container(
                                      height: media.width * 0.13,
                                      width: media.width,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Color(0xffD9D9D9)),
                                          borderRadius:
                                          BorderRadius.circular(8),
                                          color: Colors.white),
                                      padding: EdgeInsets.only(
                                          right: media.width * 0.025,
                                          left: media.width * 0.025),
                                      child: Row(
                                        children: [
                                          // if (isLoginemail == false &&
                                          //     phcode != null)
                                          InkWell(
                                            onTap: () {

                                            },
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  right: media.width * 0.025),
                                              child: Row(
                                                children: [
                                                  CircleAvatar(
                                                    backgroundImage:
                                                    NetworkImage(
                                                        countries[phcode]
                                                        ['flag']),
                                                    radius: media.width *
                                                        0.03, // Adjust the size
                                                  ),

                                                  // Image.network(
                                                  //   countries[phcode]['flag'],
                                                  //   width: media.width * 0.06,
                                                  // ),
                                                  SizedBox(
                                                    width: media.width * 0.03,
                                                  ),

                                                  MyText(
                                                    text: "${countries[phcode]
                                                    ['dial_code']}",
                                                    size: font15Size,
                                                    color: Color(0xff697176),
                                                    fontweight: FontWeight.w500,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          VerticalDivider(
                                            color: Color(
                                                0xffD9D9D9), // Color of the divider
                                            // Thickness of the divider
                                            width: 20, // Space occupied by the divider (including margin)
                                            // Space from bottom
                                          ),
                                          Expanded(
                                            child: SizedBox(
                                              height: media.width * 0.15,
                                              child: TextField(
                                                keyboardType: TextInputType.number,
                                                controller: mobileController,
                                                readOnly: true,
                                                style: GoogleFonts.inter(
                                                  color: Color(0xff303030),
                                                  fontSize: font16Size,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                // enabled: false,
                                                // controller: _email,
                                                onTap: (){

                                                },
                                                onChanged: (v) {

                                                },
                                                decoration: InputDecoration(
                                                    labelText: "Phone Number",
                                                    labelStyle: GoogleFonts.inter(
                                                      color: Color(0xff5C6266),
                                                      fontSize: font13Size,
                                                      fontWeight: FontWeight.w500,
                                                    ) ,

                                                    hintStyle: TextStyle(
                                                        color:
                                                        Color(0xff5C6266),
                                                        fontWeight:
                                                        FontWeight.w400,
                                                        fontSize: font16Size),
                                                    hintText:  "Phone Number",
                                                    border: InputBorder.none),
                                              ),
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),


                                  ],
                                ),


                                SizedBox(
                                  height: media.height * 0.02,
                                ),
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
                                  child:  TextFormField(
                                    controller: emailController,
                                    validator: (value){
                                      // if(value == null || value.isEmpty){
                                      //   return "Enter Email";
                                      // }
                                    },
                                    decoration: InputDecoration(
                                        labelText: "Email",

                                        labelStyle: GoogleFonts.inter(
                                          color: Color(0xff5C6266),
                                          fontSize: font13Size,
                                          fontWeight: FontWeight.w500,
                                        ) ,

                                        // hintText: hinttext,
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

                                SizedBox(
                                  height: media.width * 0.05,
                                ),

                              ],
                            ),
                          ),
                        ),
                        // if (_error != '')
                        //   Container(
                        //     padding: EdgeInsets.only(top: media.width * 0.02),
                        //     child: MyText(
                        //       text: _error,
                        //       size: media.width * twelve,
                        //       color: Colors.red,
                        //     ),
                        //   ),

                        Button(
                            textcolor: Colors.black,
                            color: buttonColors,
                            borcolor: Colors.white,
                            onTap: () async {
                             if (_formKey.currentState!.validate()) {
                               var register = await  registerData(name: nameController.text,
                                   lastName: lastnameController.text, email: emailController.text,
                                   mobile: mobileController.text, country: country);

                               if (register == 'true') {
                                 //referral page
                                 navigate();
                               }
                             }


                            },
                            text: "Register"),
                      ],
                    ),
                  ),
                ),


              ],
            ),
          ),

          (pickImage == true)
              ? Positioned(
              bottom: 0,
              child: InkWell(
                onTap: () {
                  setState(() {
                    pickImage = false;
                  });
                },
                child: Container(
                  height: media.height * 1,
                  width: media.width * 1,
                  color: Colors.transparent.withOpacity(0.6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding:
                        EdgeInsets.all(media.width * 0.05),
                        width: media.width * 1,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(25),
                                topRight: Radius.circular(25)),
                            border: Border.all(
                              color: borderLines,
                              width: 1.2,
                            ),
                            color: page),
                        child: Column(
                          children: [
                            Container(
                              height: media.width * 0.02,
                              width: media.width * 0.15,
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(
                                    media.width * 0.01),
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(
                              height: media.width * 0.05,
                            ),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        pickImageFromCamera();
                                      },
                                      child: Container(
                                          height:
                                          media.width * 0.171,
                                          width:
                                          media.width * 0.171,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color:
                                                  borderLines,
                                                  width: 1.2),
                                              borderRadius:
                                              BorderRadius
                                                  .circular(
                                                  12)),
                                          child: Icon(
                                            Icons
                                                .camera_alt_outlined,
                                            size: media.width *
                                                0.064,
                                            color: textColor,
                                          )),
                                    ),
                                    SizedBox(
                                      height: media.width * 0.02,
                                    ),
                                    MyText(
                                      text: languages[
                                      choosenLanguage]
                                      ['text_camera'],
                                      size: media.width * ten,
                                      color: textColor
                                          .withOpacity(0.4),
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        pickImageFromGallery();
                                      },
                                      child: Container(
                                          height:
                                          media.width * 0.171,
                                          width:
                                          media.width * 0.171,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color:
                                                  borderLines,
                                                  width: 1.2),
                                              borderRadius:
                                              BorderRadius
                                                  .circular(
                                                  12)),
                                          child: Icon(
                                            Icons.image_outlined,
                                            size: media.width *
                                                0.064,
                                            color: textColor,
                                          )),
                                    ),
                                    SizedBox(
                                      height: media.width * 0.02,
                                    ),
                                    MyText(
                                      text: languages[
                                      choosenLanguage]
                                      ['text_gallery'],
                                      size: media.width * ten,
                                      color: textColor
                                          .withOpacity(0.4),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ))
              : Container(),
        ],
      ),
    );
  }
}
