

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../functions/functions.dart';
import '../../styles/styles.dart';
import '../../translations/translation.dart';
import '../../widgets/widgets.dart';
import '../onTripPage/map_page.dart';
import '../referralcode/referral_code.dart';

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
            builder: (context) => const Maps()));
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
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: Column(
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
    );
  }
}
