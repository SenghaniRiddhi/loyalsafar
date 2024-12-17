import 'package:flutter/material.dart';
import 'package:flutter_user/widgets/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../styles/styles.dart';
import 'OTPVerificationPage.dart';
import 'login.dart';


class Loginscreen extends StatelessWidget {
  const Loginscreen({super.key});

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
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                IntlPhoneField(
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                  ),
                  showDropdownIcon:false,
                  initialCountryCode: 'IN',
                  // readOnly: true,

                  onChanged: (phone) {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
                    print(phone.completeNumber);
                  },
                ),
                // const SizedBox(height: 05),
                const Text(
                  "OR",
                  style: TextStyle(fontSize: 16, color: Colors.black38),
                ),
                const SizedBox(height: 05),
               Container(
                 decoration: BoxDecoration(
                   color: Color(0xffF0F0F0),
                   // border: Border.all(color: Colors.grey),
                   borderRadius: BorderRadius.circular(8),
                 ),
                 padding: EdgeInsets.symmetric(horizontal: 12,vertical: 15),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     MyText(
                       text: "Connect via Social",
                       size: font14Size,
                       color: headingColors,
                       fontweight: FontWeight.w500,
                     ),
                     Row(
                       children: [
                         Container(
                           child: Image.asset('assets/icons/google.png'),
                           height: 22,
                           width: 22,
                         ),
                         SizedBox(width: 18,),
                         Container(child: Image.asset('assets/icons/apple.png'),
                           height: 24,
                           width: 24,
                         ),
                       ],
                     ),
                   ],

                 )
               ),

              ],
            ),
          ),
          const SizedBox(height: 20),
          // Footer
          MyText(
            text: "By signing in to continue Loyal Safar,\nTerms & Conditions and Privacy Policy.",
            size: font14Size,
            textAlign: TextAlign.center,
            color: Color(0xff697176),
            fontweight: FontWeight.w400,
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
