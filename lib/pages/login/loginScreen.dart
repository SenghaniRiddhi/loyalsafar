import 'package:flutter/material.dart';
import 'package:flutter_user/widgets/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../functions/functions.dart';
import '../../styles/styles.dart';
import 'OTPVerificationPage.dart';
import 'login.dart';


class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  bool isChecked = false;






  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(height: 50),
          // Header Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // App Logo and Image
              Center(
                child: Column(
                  children: [
                    Container(
                      width: media.width*0.25,
                      child: Image.asset(
                        'assets/icons/loginScreenLogo.png',
                        fit: BoxFit.cover,
                        // Replace with your logo asset
                      ),
                    ),
                    Container(
                      width: media.width,
                      // color: Colors.pink,
                      child: Image.asset(
                        'assets/icons/loginImage.png', // Replace with your car image asset
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 14),
                child: MyText(
                  text: "Go with Loyal Safar",
                  size: font24Size,
                  color: Color(0xff01041D),
                  fontweight: FontWeight.w700,
                ),

              ),
            ],
          ),

          // Phone Input
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: Column(
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
                          height: media.width * 0.12,
                          child: TextField(
                            keyboardType:
                            TextInputType.emailAddress,

                            readOnly: true,
                            // enabled: false,
                            // controller: _email,
                            onTap: (){
                              if(isChecked== true){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
                              }else{
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Please select Terms & Conditions'),
                                    // action: SnackBarAction(
                                    //   label: 'Undo',
                                    //   onPressed: () {
                                    //     // Code to execute when "Undo" is pressed
                                    //     print("Undo action clicked");
                                    //   },
                                    // ),
                                    duration: Duration(seconds: 3), // Optional: controls visibility duration
                                  ),
                                );
                              }

                            },
                            onChanged: (v) {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
                              // String pattern =
                              //     r'(^(?:[+0]9)?[0-9]{1,12}$)';
                              // RegExp regExp =
                              // RegExp(pattern);
                              // if (regExp.hasMatch(
                              //     _email.text) &&
                              //     isLoginemail == true &&
                              //     signIn == 0) {
                              //   setState(() {
                              //     isLoginemail = false;
                              //   });
                              // } else if (isLoginemail ==
                              //     false &&
                              //     regExp.hasMatch(
                              //         _email.text) ==
                              //         false) {
                              //   setState(() {
                              //     isLoginemail = true;
                              //   });
                              // }
                            },
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric( horizontal: 10.0), // Adjust padding here
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
                      // if (otpSent == true && signIn == 0)
                      //   IconButton(
                      //       onPressed: () {
                      //         setState(() {
                      //           _error = '';
                      //           otpSent = false;
                      //           _password.clear();
                      //         });
                      //       },
                      //       icon: Icon(
                      //         Icons.edit,
                      //         size: media.width * 0.05,
                      //       ))
                    ],
                  ),
                ),
                // const SizedBox(height: 15),
               //  MyText(
               //    text: "OR",
               //    size: font16Size,
               //    color: Color(0xffC5C5C5),
               //    fontweight: FontWeight.w400,
               //  ),
               //
               //  const SizedBox(height: 15),
               // Container(
               //   decoration: BoxDecoration(
               //     color: Color(0xffF0F0F0),
               //     // border: Border.all(color: Colors.grey),
               //     borderRadius: BorderRadius.circular(8),
               //   ),
               //   padding: EdgeInsets.symmetric(horizontal: 12,vertical: 15),
               //   child: Row(
               //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
               //     children: [
               //       MyText(
               //         text: "Connect via Social",
               //         size: font14Size,
               //         color: headingColors,
               //         fontweight: FontWeight.w500,
               //       ),
               //       Row(
               //         children: [
               //           Container(
               //             child: Image.asset('assets/icons/google.png'),
               //             height: 22,
               //             width: 22,
               //           ),
               //           SizedBox(width: 18,),
               //           Container(child: Image.asset('assets/icons/apple.png'),
               //             height: 24,
               //             width: 24,
               //           ),
               //         ],
               //       ),
               //     ],
               //
               //   )
               // ),

              ],
            ),
          ),
           SizedBox(height: media.height*0.03),
          // Footer

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Checkbox(
                  value: isChecked,
                 checkColor: Colors.black,
                  onChanged: (bool? value) {
                    setState(() {
                      isChecked = value!;
                    });
                  },
                  activeColor: buttonColors, // Matches the text color
                ),
                Expanded(
                  child: MyText(
                    text: "By signing in to continue Loyal Safar,\nTerms & Conditions and Privacy Policy.",
                    size: font14Size,
                    textAlign: TextAlign.start,
                    color: Color(0xff697176),
                    fontweight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),


          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
