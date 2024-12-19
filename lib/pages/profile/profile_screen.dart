// import 'package:flutter/material.dart';
// import '../../functions/functions.dart';
// import '../../styles/styles.dart';
// import '../../translations/translation.dart';
// import '../../widgets/widgets.dart';
// import '../loadingPage/loading.dart';
// import '../onTripPage/map_page.dart';
//
// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});
//
//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }
//
// dynamic referralCode;
//
// class _ProfileScreenState extends State<ProfileScreen> {
//
//
//   @override
//   void initState() {
//
//     super.initState();
//   }
//
//   //navigate
//   navigate() {
//     Navigator.pushReplacement(
//         context, MaterialPageRoute(builder: (context) => const Maps()));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var media = MediaQuery.of(context).size;
//
//     return Scaffold(
//       body: Column(
//         children: [
//           Container(
//             color: Colors.amber,
//             padding: EdgeInsets.symmetric(horizontal:  media.width * 0.07, vertical:  media.width * 0.1),
//
//             child: Column(
//               children: [
//
//                 Container(
//                  // padding: EdgeInsets.symmetric(horizontal:  media.width * 0.07, vertical:  media.width * 0.1),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Container(
//                         height: media.width * 0.07,
//                         width: media.width * 0.07,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           border: Border.all(color: Colors.black),
//
//                         ),
//                         child: Icon(Icons.remove),
//                       ),
//                       Container(
//                         height: media.width * 0.07,
//                         width: media.width * 0.07,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           border: Border.all(color: Colors.black),
//
//                         ),
//                         child: Icon(Icons.edit),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 SizedBox(height: media.width * 0.10,),
//
//                 Row(
//                   children: [
//                     Container(
//                       width: media.width * 0.15,
//                       height: media.width * 0.15,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(8),
//                           image: DecorationImage(
//                               image: NetworkImage(
//                                   userDetails['profile_picture']),
//                               fit: BoxFit.cover)),
//                     ),
//                     SizedBox(
//                       width: media.width * 0.025,
//                     ),
//                     Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             MyText(
//                               text: userDetails['name'],
//                               size: media.width * fourteen,
//                               fontweight: FontWeight.w600,
//                               maxLines: 1,
//                             ),
//                             MyText(
//                               text: userDetails['mobile'],
//                               size: media.width * fourteen,
//                               fontweight: FontWeight.w500,
//                               maxLines: 1,
//                             ),
//                           ],
//                         )),
//                     SizedBox(
//                       width: media.width * 0.025,
//                     ),
//
//                   ],
//                 ),
//
//               ],
//             ),
//           ),
//
//           SizedBox(height: media.width * 0.05,),
//
//           Container(
//             color: Colors.blueGrey,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     Icon(Icons.wallet),
//                     Text("Wallet Balance"),
//                   ],
//                 ),
//
//                 Container(
//                   color: Colors.amber,
//                   padding: EdgeInsets.symmetric(horizontal: media.width * 0.05,
//                       vertical: media.width * 0.01),
//                   child: Row(
//
//                     children: [
//                       Text("\$420"),
//                       Icon(Icons.arrow_forward_ios_outlined)
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: media.width * 0.05,),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal:  media.width * 0.05, vertical:  media.width * 0.05),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20), // Set the radius here
//                   color: Colors.cyanAccent,
//                 ),
//
//                 child: Column(
//                   children: [
//                     Icon(Icons.location_on),
//                     SizedBox(height: media.width * 0.02,),
//                     Text("Addresses")
//
//                   ],
//                 ),
//
//               ),
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal:  media.width * 0.05, vertical:  media.width * 0.05),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20), // Set the radius here
//                   color: Colors.cyanAccent,
//                 ),
//
//                 child: Column(
//                   children: [
//                     Icon(Icons.location_on),
//                     SizedBox(height: media.width * 0.02,),
//                     Text("Addresses")
//
//                   ],
//                 ),
//
//               ),
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal:  media.width * 0.05, vertical:  media.width * 0.05),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20), // Set the radius here
//                   color: Colors.cyanAccent,
//                 ),
//
//                 child: Column(
//                   children: [
//                     Icon(Icons.location_on),
//                     SizedBox(height: media.width * 0.02,),
//                     Text("Addresses")
//
//                   ],
//                 ),
//
//               ),
//             ],
//           ),
//
//           Text("Account Settings"),
//
//           Container(
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         Icon(Icons.wallet),
//                         Text("Change Language"),
//                       ],
//                     ),
//
//                     Icon(Icons.arrow_forward_ios_outlined),
//
//
//                   ],
//                 ),
//                 Divider(),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         Icon(Icons.wallet),
//                         Text("Invite Friends"),
//                       ],
//                     ),
//
//                     Icon(Icons.arrow_forward_ios_outlined),
//
//
//                   ],
//                 ),
//                 Divider(),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         Icon(Icons.wallet),
//                         Text("SOS Contancts"),
//                       ],
//                     ),
//
//                     Icon(Icons.arrow_forward_ios_outlined),
//
//
//                   ],
//                 ),
//                 Divider(),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         Icon(Icons.wallet),
//                         Text("Raise Complaints"),
//                       ],
//                     ),
//
//                     Icon(Icons.arrow_forward_ios_outlined),
//
//
//                   ],
//                 ),
//               ],
//             ),
//           ),
//
//           Text("Notification Settings"),
//
//           Container(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     Icon(Icons.wallet),
//                     Text("Change Language"),
//                   ],
//                 ),
//
//                 Icon(Icons.arrow_forward_ios_outlined),
//
//
//               ],
//             ),
//           ),
//
//
//         ],
//       ),
//     );
//   }
// }

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_user/pages/profile/adresses_screen.dart';
import 'package:flutter_user/pages/profile/edit_profile_screen.dart';
import 'package:flutter_user/pages/profile/payment_screen.dart';
import 'package:flutter_user/pages/profile/setting_screen.dart';
import 'package:flutter_user/styles/styles.dart';
import 'package:flutter_user/widgets/appbar.dart';

import '../../functions/functions.dart';
import '../../widgets/widgets.dart';
import '../NavigatorPages/editprofile.dart';
import '../NavigatorPages/makecomplaint.dart';
import '../language/languages.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: backgroundColors,

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture and Name
        
            Container(
              padding:  EdgeInsets.symmetric(horizontal:16,vertical: media.width*0.06 ),
              color: Colors.white,
              child: Column(
                children: [
        
                  SizedBox(height: media.width*0.06,),
        
                  appBarProfileWidget(context: context),
        
                  SizedBox(height: media.width*0.06,),
        
                  Row(
                    children: [
                      Container(
                        height: media.width * 0.25,
                        width: media.width * 0.25,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: page,
                            image: (profileImageFile == null)
                                ? DecorationImage(
                                image: NetworkImage(
                                  userDetails[
                                  'profile_picture'],
                                ),
                                fit: BoxFit.cover)
                                : DecorationImage(
                                image: FileImage(File(
                                    profileImageFile)),
                                fit: BoxFit.cover)
                        ),
                      ),
                      //  CircleAvatar(
                      //   radius: 40,
                      //   backgroundColor: Colors.grey[200],
                      //   backgroundImage: NetworkImage(userDetails['profile_picture']
                      //   ), // Add your profile image here
                      // ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:  [
                          MyText(
                            text: userDetails['name'],
                            size: font24Size,
                            color: headingColors,
                            fontweight: FontWeight.w700,
                          ),
                          MyText(
                            text: userDetails['mobile'],
                            size: font16Size,
                            color: Color(0xff697176),
                            fontweight: FontWeight.w400,
                          ),

                        ],
                      ),
                    ],
                  ),
        
                  SizedBox(height: media.width*0.01,),
        
                ],
              ),
            ),
        
        
        
            Padding(
              padding:  EdgeInsets.symmetric(vertical: 10,horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
        
                  const SizedBox(height: 20),
                  // Wallet Balance Section
                  Container(
                    padding:  EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: whiteColors,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children:  [
                            Icon(Icons.account_balance_wallet, color: Colors.black , size: 24,),
                            SizedBox(width: 8),
                            MyText(
                              text:  "Wallet Balance",
                              size: font16Size,
                              color: headingColors,
                              fontweight: FontWeight.w500,
                            ),

                          ],
                        ),
        
                        Container(
                          padding:  EdgeInsets.symmetric(
                              vertical: 8, horizontal: 08),
                          decoration: BoxDecoration(
                            color: buttonColors,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Row(
                            children: [
                              MyText(
                                text:  "\$420",
                                size: font16Size,
                                color: headingColors,
                                fontweight: FontWeight.w600,
                              ),
                              SizedBox(width: 05,),
                              Icon(Icons.arrow_forward_ios_outlined,color: Colors.black,size: 18,)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
        
                  Padding(
                    padding: const EdgeInsets.all(04.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap:(){
                           Navigator.push(context, MaterialPageRoute(builder: (context)=>AddressesScreen()));
                            },
                          child: Container(
                            width: media.width*0.27,
                            padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 05),
                            decoration: BoxDecoration(
                              color: whiteColors,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                               Icon(Icons.location_on,color: Colors.black,size: 24),
                                SizedBox(height: 04,),
                                MyText(
                                  text:  "Addresses",
                                  size: font14Size,
                                  color: Color(0xff303030),
                                  fontweight: FontWeight.w400,
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                          //  Navigator.push(context, MaterialPageRoute(builder: (context)=> PaymentMethodsScreen()));
                          },
                          child: Container(
                            width: media.width*0.27,
                            padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 05),
                            decoration: BoxDecoration(
                              color: whiteColors,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(Icons.payment_outlined,color: Colors.black,size: 24),
                                SizedBox(height: 04,),
                                MyText(
                                  text:  "Payment",
                                  size: font14Size,
                                  color: Color(0xff303030),
                                  fontweight: FontWeight.w400,
                                ),

                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>SettingsScreen()));
                          },
                          child: Container(
                            width: media.width*0.27,
                            padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 05),
                            decoration: BoxDecoration(
                              color: whiteColors,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(Icons.settings,color: Colors.black,size: 24),
                                SizedBox(height: 04,),
                                MyText(
                                  text:  "Setting",
                                  size: font14Size,
                                  color: Color(0xff303030),
                                  fontweight: FontWeight.w400,
                                ),

                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: media.width*0.055,),
        


                  MyText(
                    text:  "Account Settings",
                    size: font16Size,
                    color: Color(0xff4F4F4F),
                    fontweight: FontWeight.w700,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: media.width,
                    padding: EdgeInsets.symmetric(horizontal: 04,vertical: 05),
                    decoration: BoxDecoration(
                      color:whiteColors,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _buildAccountOption(Icons.language, "Change Language",1,context),
                        horizontalDivider(),
                        _buildAccountOption(Icons.lock_outline, "Invite Friends",2,context),
                        horizontalDivider(),
                        _buildAccountOption(Icons.car_crash_outlined, "SOS Contacts",3,context),
                        horizontalDivider(),
                        _buildAccountOption(Icons.report, "Raise Complaints",4,context),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
        

                  MyText(
                    text:  "Notification Settings",
                    size: font16Size,
                    color: Color(0xff4F4F4F),
                    fontweight: FontWeight.w700,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 08),
                    decoration: BoxDecoration(
                      color: whiteColors,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children:  [
                            Icon(Icons.notifications_none_outlined,color: normalText1Colors, size: 24),
                            SizedBox(width: 8),
                            MyText(
                              text: "Push Notifications",
                              size: font16Size,
                              color: normalText1Colors,
                              fontweight: FontWeight.w500,
                            ),
                          ],
                        ),
                        Switch(
                          value: true,
                          // activeColor: Color(0xff0FDC79),
                          activeTrackColor: Color(0xff0FDC79),
                          onChanged: (bool value) {},
                        ),
                      ],
                    ),
                  ),
                   SizedBox(height: media.width*0.1),
                ],
              ),
            ),
        
        
          ],
        ),
      ),
    );
  }

  Widget _buildAccountOption(IconData icon, String title ,int index, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14,vertical: 18),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              if(index==1){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Languages()));

              }else if(index==2){

              }else if(index==3){

              }else if(index==4){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>MakeComplaint()));


              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(icon,size: 24,color: normalText1Colors,),
                    SizedBox(width: 15,),
                    MyText(
                      text:  title,
                      size: font16Size,
                      color: normalText1Colors,
                      fontweight: FontWeight.w500,
                    ),
                  ],
                ),

                Icon(Icons.arrow_forward_ios,color: normalText1Colors, size: 18),

              ],
            ),
          ),
          // ListTile(
          //
          //   leading: Icon(icon,size: 24,color: normalText1Colors,),
          //   title: MyText(
          //   text:  title,
          //     size: font16Size,
          //     color: normalText1Colors,
          //     fontweight: FontWeight.w500,
          //   ),
          //   trailing:  Icon(Icons.arrow_forward_ios,color: normalText1Colors, size: 18),
          //   onTap: () {
          //     if(index==1){
          //       Navigator.push(context, MaterialPageRoute(builder: (context)=>Languages()));
          //
          //     }else if(index==2){
          //
          //     }else if(index==3){
          //
          //     }else if(index==4){
          //       Navigator.push(context, MaterialPageRoute(builder: (context)=>MakeComplaint()));
          //
          //
          //     }
          //   },
          // ),

        ],
      ),
    );
  }
  Widget horizontalDivider() {
    return Padding(
      padding: EdgeInsets.only(left: 15,top:03,right: 18,bottom: 03 ),
      child: const Divider(height: 1),
    );
  }
}
