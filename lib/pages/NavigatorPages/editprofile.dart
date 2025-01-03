import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_user/translations/translation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import '../../functions/functions.dart';
import '../../styles/styles.dart';
import '../../widgets/appbar.dart';
import '../../widgets/success_dialog_content.dart';
import '../../widgets/widgets.dart';
import '../loadingPage/loading.dart';
import '../login/login.dart';
import '../login/loginScreen.dart';
import '../noInternet/nointernet.dart';
import '../profile/setting_screen.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

dynamic profileImageFile;

class _EditProfileState extends State<EditProfile> {
  ImagePicker picker = ImagePicker();
  bool _isLoading = false;
  String _error = '';
  bool _pickImage = false;
  String _permission = '';
  bool showToast = false;
  TextEditingController name = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController mobilenum = TextEditingController();
  TextEditingController usergender = TextEditingController();
  bool islastname = false;

//get gallery permission
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

  bool isEdit = false;

  showToastFunc() {
    setState(() {
      showToast = true;
      showDialog(
        context: context,
        builder: (context) => SuccessDialogContent(image: '',
            title: '''Profile Updated''', description: 'Your Profile has been successfully updated.'),
      );
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          showToast = false;
        });
      }
    });
  }

  navigateLogout() {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Loginscreen()),
          (route) => false);
    });
  }

//get camera permission
  getCameraPermission() async {
    var status = await Permission.camera.status;
    if (status != PermissionStatus.granted) {
      status = await Permission.camera.request();
    }
    return status;
  }

//pick image from gallery
  pickImageFromGallery() async {
    var permission = await getGalleryPermission();
    if (permission == PermissionStatus.granted) {
      final pickedFile =
          await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
      setState(() {
        profileImageFile = pickedFile?.path;
        _pickImage = false;
      });
    } else {
      setState(() {
        _permission = 'noPhotos';
      });
    }
  }

//pick image from camera
  pickImageFromCamera() async {
    var permission = await getCameraPermission();
    if (permission == PermissionStatus.granted) {
      final pickedFile =
          await picker.pickImage(source: ImageSource.camera, imageQuality: 50);
      setState(() {
        profileImageFile = pickedFile?.path;
        _pickImage = false;
      });
    } else {
      setState(() {
        _permission = 'noCamera';
      });
    }
  }

  @override
  void initState() {
    _error = '';
    profileImageFile = null;
    isEdit = false;
    name.text = (userDetails['name'] == null)
        ? languages[choosenLanguage]['text_not_specified']
        : userDetails['name'].toString().split(' ')[0];
    lastname.text = (userDetails['name'].toString().split(' ').length > 1)
        ? userDetails['name'].toString().split(' ')[1]
        : '';

    mobilenum.text = userDetails['mobile'];
    email.text = userDetails['email'].toString();

    usergender.text = (userDetails['gender'] == null)
        ? ""
        : userDetails['gender'];
    setState(() {});
    super.initState();
  }

  pop() {
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Material(
      child: Scaffold(
        backgroundColor: Color(0xffE8E9EA),


        body: Directionality(
          textDirection: (languageDirection == 'rtl')
              ? TextDirection.rtl
              : TextDirection.ltr,
          child: Stack(
            children: [

              Positioned.fill(
                top:media.height*0.25, // Push the container down for the profile picture overlap
                child: Container(
                  color: Colors.white, // Light gray background
                  child: Padding(
                    padding:  EdgeInsets.only(top: media.width*0.2,), // Padding for the fields
                    child:  Column(
                      children: [

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
                                        //
                                        // //images
                                        // InkWell(
                                        //   onTap: () {
                                        //     // if (isEdit) {
                                        //     setState(() {
                                        //       _pickImage = true;
                                        //     });
                                        //     // }
                                        //   },
                                        //   child: Stack(
                                        //     children: [
                                        //       Container(
                                        //         height: media.width * 0.25,
                                        //         width: media.width * 0.25,
                                        //         decoration: BoxDecoration(
                                        //             shape: BoxShape.circle,
                                        //             color: page,
                                        //             image: (profileImageFile == null)
                                        //                 ? DecorationImage(
                                        //                 image: NetworkImage(
                                        //                   userDetails[
                                        //                   'profile_picture'],
                                        //                 ),
                                        //                 fit: BoxFit.cover)
                                        //                 : DecorationImage(
                                        //                 image: FileImage(File(
                                        //                     profileImageFile)),
                                        //                 fit: BoxFit.cover)),
                                        //       ),
                                        //
                                        //       Positioned(
                                        //           right: media.width * 0.02,
                                        //           bottom: media.width * 0.02,
                                        //           child: Container(
                                        //             height: media.width * 0.05,
                                        //             width: media.width * 0.05,
                                        //             decoration: const BoxDecoration(
                                        //                 shape: BoxShape.circle,
                                        //                 color: Color(0xff898989)),
                                        //             child: Icon(
                                        //               Icons.edit,
                                        //               color: topBar,
                                        //               size: media.width * 0.04,
                                        //             ),
                                        //           ))
                                        //     ],
                                        //   ),
                                        // ),
                                        // SizedBox(
                                        //   height: media.width * 0.04,
                                        // ),

                                        //textfield

                                        ProfileDetails(
                                          text:languages[choosenLanguage]
                                          ['text_name'],
                                          // heading: languages[choosenLanguage]
                                          // ['text_name'],
                                          controller: name,
                                          // width: media.width * 0.9,
                                          readyonly:  false ,
                                        ),
                                        SizedBox(
                                          height: media.height * 0.02,
                                        ),

                                        ProfileDetails(
                                          text: "Last Name",
                                          controller: lastname,
                                          // width: media.width * 0.9,
                                          readyonly: false ,
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
                                                       controller: mobilenum,
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
                                        ProfileDetails(
                                          text: languages[choosenLanguage]
                                          ['text_email'],
                                          controller: email,
                                          readyonly: false ,
                                        ),
                                        SizedBox(
                                          height: media.width * 0.05,
                                        ),

                                      ],
                                    ),
                                  ),
                                ),
                                if (_error != '')
                                  Container(
                                    padding: EdgeInsets.only(top: media.width * 0.02),
                                    child: MyText(
                                      text: _error,
                                      size: media.width * twelve,
                                      color: Colors.red,
                                    ),
                                  ),

                                Button(
                                    textcolor: Colors.black,
                                    color: buttonColors,
                                    borcolor: Colors.white,
                                    onTap: () async {
                                      setState(() {
                                        _error = '';
                                      });
                                      String pattern =
                                          r"^[A-Za-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[A-Za-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?\.)+[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])*$";
                                      var remail = email.text.replaceAll(' ', '');
                                      RegExp regex = RegExp(pattern);
                                      if (regex.hasMatch(remail)) {
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        // ignore: prefer_typing_uninitialized_variables
                                        var nav;
                                        if (userDetails['email'] == remail) {
                                          nav = await updateProfile(
                                              '${name.text} ${lastname.text}',
                                              remail,
                                              usergender.text
                                            // userDetails['mobile']
                                          );
                                          if (nav != 'success') {
                                            _error = nav.toString();
                                          } else {
                                            isEdit = false;
                                            _isLoading = false;
                                            showToastFunc();
                                          }
                                        } else {
                                          var result = await validateEmail(remail);
                                          if (result == 'success') {
                                            nav = await updateProfile(
                                                '${name.text} ${lastname.text}',
                                                remail,
                                                usergender.text
                                              // userDetails['mobile']
                                            );
                                            if (nav != 'success') {
                                              _error = nav.toString();
                                            } else {
                                              showToastFunc();
                                            }
                                          } else {
                                            setState(() {
                                              _isLoading = false;
                                              _error = result;
                                            });
                                          }

                                          setState(() {
                                            _isLoading = false;
                                          });
                                        }
                                      } else {
                                        setState(() {
                                          _error = languages[choosenLanguage]
                                          ['text_email_validation'];
                                        });
                                      }
                                    },
                                    text: languages[choosenLanguage]
                                    ['text_confirm']),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      children: [
                        SizedBox(height: media.height*0.06),

                        appBarTitleWidget(
                            onTaps: (){
                              Navigator.pop(context);
                            },
                            context: context,
                            backgroundIcon: whiteColors,
                            title: "Edit Profile",
                            iconColors: iconGrayColors),
                        SizedBox(height: media.height*0.07), // Spacing from top

                        Stack(
                          children: [


                            CircleAvatar(
                              radius: 58,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 55,
                                backgroundImage: profileImageFile == null
                                    ? NetworkImage(userDetails['profile_picture']) as ImageProvider
                                    : FileImage(File(profileImageFile)), // Replace with user image URL
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              right: 0,
                              child: InkWell(
                                onTap: () {
                                  // if (isEdit) {
                                  setState(() {
                                    _pickImage = true;
                                  });
                                  // }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5), // Shadow color
                                        spreadRadius: 2, // Spread radius
                                        blurRadius: 4, // Blur radius
                                        offset: Offset(2, 2), // Offset for the shadow (x, y)
                                      ),
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    radius: 16,
                                    backgroundColor: Colors.white,
                                    child: CircleAvatar(

                                      radius: 14,
                                      backgroundColor: Colors.white,
                                      child: Icon(
                                        Icons.edit,
                                        size: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // if (showToast == true)
              //   Positioned(
              //       bottom: media.width * 0.05,
              //       child: Container(
              //         margin: EdgeInsets.fromLTRB(
              //             media.width * 0.05, 0, media.width * 0.05, 0),
              //         width: media.width * 0.9,
              //         padding: EdgeInsets.all(media.width * 0.03),
              //         decoration: BoxDecoration(
              //             color: page,
              //             boxShadow: [boxshadow],
              //             borderRadius: BorderRadius.circular(8)),
              //         alignment: Alignment.center,
              //         child: MyText(
              //           text: 'Profile Updated Successfully',
              //           size: media.width * fourteen,
              //           color: Colors.green,
              //           fontweight: FontWeight.w500,
              //         ),
              //       )),

              //pick image popup
              (_pickImage == true)
                  ? Positioned(
                      bottom: 0,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _pickImage = false;
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
                                padding: EdgeInsets.all(media.width * 0.05),
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
                                    Text("Your Profile photos",style: TextStyle(color: Colors.black,
                                        fontWeight: FontWeight.bold ,fontSize: 17),),
                                    // Container(
                                    //   height: media.width * 0.02,
                                    //   width: media.width * 0.15,
                                    //   decoration: BoxDecoration(
                                    //     borderRadius: BorderRadius.circular(
                                    //         media.width * 0.01),
                                    //     color: Colors.grey,
                                    //   ),
                                    // ),
                                    SizedBox(
                                      height: media.width * 0.08,
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
                                                  height: media.width * 0.171,
                                                  width: media.width * 0.171,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: buttonColors,
                                                          width: 1.2),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              media.width * 0.171)),
                                                  child: Icon(
                                                    Icons.camera_alt_rounded,
                                                    size: media.width * 0.064,
                                                    color: textColor,
                                                  )),
                                            ),
                                            SizedBox(
                                              height: media.width * 0.02,
                                            ),
                                            MyText(
                                              text: languages[choosenLanguage]
                                                  ['text_camera'],
                                              size: media.width * ten,
                                              color: textColor.withOpacity(0.4),
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
                                                  height: media.width * 0.171,
                                                  width: media.width * 0.171,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: buttonColors,
                                                          width: 1.2),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              media.width * 0.171)),
                                                  child: Icon(
                                                    Icons.image_outlined,
                                                    size: media.width * 0.064,
                                                    color: textColor,
                                                  )),
                                            ),
                                            SizedBox(
                                              height: media.width * 0.02,
                                            ),
                                            MyText(
                                              text: languages[choosenLanguage]
                                                  ['text_gallery'],
                                              size: media.width * ten,
                                              color: textColor.withOpacity(0.4),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: media.width * 0.09,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ))
                  : Container(),

              //permission denied popup
              (_permission != '')
                  ? Positioned(
                      child: Container(
                      height: media.height * 1,
                      width: media.width * 1,
                      color: Colors.transparent.withOpacity(0.6),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: media.width * 0.9,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _permission = '';
                                      _pickImage = false;
                                    });
                                  },
                                  child: Container(
                                    height: media.width * 0.1,
                                    width: media.width * 0.1,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle, color: page),
                                    child: Icon(Icons.cancel_outlined,
                                        color: textColor),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: media.width * 0.05,
                          ),
                          Container(
                            padding: EdgeInsets.all(media.width * 0.05),
                            width: media.width * 0.9,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: page,
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 2.0,
                                      spreadRadius: 2.0,
                                      color: Colors.black.withOpacity(0.2))
                                ]),
                            child: Column(
                              children: [
                                SizedBox(
                                    width: media.width * 0.8,
                                    child: MyText(
                                      text: (_permission == 'noPhotos')
                                          ? languages[choosenLanguage]
                                              ['text_open_photos_setting']
                                          : languages[choosenLanguage]
                                              ['text_open_camera_setting'],
                                      size: media.width * sixteen,
                                      fontweight: FontWeight.w600,
                                    )),
                                SizedBox(height: media.width * 0.05),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                        onTap: () async {
                                          await openAppSettings();
                                        },
                                        child: MyText(
                                          text: languages[choosenLanguage]
                                              ['text_open_settings'],
                                          size: media.width * sixteen,
                                          fontweight: FontWeight.w600,
                                          color: buttonColor,
                                        )),
                                    InkWell(
                                        onTap: () async {
                                          (_permission == 'noCamera')
                                              ? pickImageFromCamera()
                                              : pickImageFromGallery();
                                          setState(() {
                                            _permission = '';
                                          });
                                        },
                                        child: MyText(
                                          text: languages[choosenLanguage]
                                              ['text_done'],
                                          size: media.width * sixteen,
                                          fontweight: FontWeight.w600,
                                          color: buttonColor,
                                        ))
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ))
                  : Container(),
              //loader
              (_isLoading == true)
                  ? const Positioned(top: 0, child: Loading())
                  : Container(),

              //error
              (_error != '')
                  ? Positioned(
                      child: Container(
                      height: media.height * 1,
                      width: media.width * 1,
                      color: Colors.transparent.withOpacity(0.6),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(media.width * 0.05),
                            width: media.width * 0.9,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: page),
                            child: Column(
                              children: [
                                SizedBox(
                                  width: media.width * 0.8,
                                  child: MyText(
                                    text: _error.toString(),
                                    textAlign: TextAlign.center,
                                    size: media.width * sixteen,
                                    fontweight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                  height: media.width * 0.05,
                                ),
                                Button(
                                    onTap: () async {
                                      setState(() {
                                        _error = '';
                                      });
                                    },
                                    text: languages[choosenLanguage]['text_ok'])
                              ],
                            ),
                          )
                        ],
                      ),
                    ))
                  : Container(),

              //no internet
              (internet == false)
                  ? Positioned(
                      top: 0,
                      child: NoInternet(
                        onTap: () {
                          setState(() {
                            internetTrue();
                          });
                        },
                      ))
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}


