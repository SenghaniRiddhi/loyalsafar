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

import 'package:flutter/material.dart';
import 'package:flutter_user/pages/profile/adresses_screen.dart';
import 'package:flutter_user/pages/profile/edit_profile_screen.dart';
import 'package:flutter_user/pages/profile/payment_screen.dart';
import 'package:flutter_user/pages/profile/setting_screen.dart';
import 'package:flutter_user/styles/styles.dart';
import 'package:flutter_user/widgets/appbar.dart';

import '../NavigatorPages/makecomplaint.dart';
import '../language/languages.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[200],

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Picture and Name

          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.white,
            child: Column(
              children: [

                SizedBox(height: media.width*0.04,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap:(){
                       Navigator.pop(context);
    },
                      child: Container(
                        width: media.width * 0.1, // Set width
                        height: media.width * 0.1,
                        decoration: BoxDecoration(
                          color: Colors.grey[200], // Background color
                          shape: BoxShape.circle, // Makes the container circular
                        ),
                        child: const Icon(Icons.close, color: Colors.black),
                        // onPressed: () {},
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context,MaterialPageRoute(builder: (context)=>EditProfileScreen()));
                      },
                      child: Container(
                        width: media.width * 0.1, // Set width
                        height: media.width * 0.1,
                        decoration: BoxDecoration(
                          color: Colors.grey[200], // Background color
                          shape: BoxShape.circle, // Makes the container circular
                        ),
                        child: const Icon(Icons.edit, color: Colors.black),

                      ),
                    ),


                  ],),

                SizedBox(height: media.width*0.06,),

                Row(
                  children: [
                     CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: AssetImage('assets/icons/userIcon.png'), // Add your profile image here
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Celina Mark",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "celinamark01@gmail.com",
                          style: TextStyle(color: Colors.grey),
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
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.account_balance_wallet, color: Colors.black),
                          SizedBox(width: 8),
                          Text(
                            "Wallet Balance",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                          color: buttonColors,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          children: [
                            const Text(
                              "\$420",
                              style: TextStyle(
                                  color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                            Icon(Icons.arrow_forward_ios_outlined,color: Colors.black,size: 20,)
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
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                             Icon(Icons.location_on),
                              SizedBox(height: 04,),
                              Text("Addresses"),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> PaymentMethodsScreen()));
                        },
                        child: Container(
                          width: media.width*0.27,
                          padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 05),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.payment_outlined),
                              SizedBox(height: 04,),
                              Text("Payment"),
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
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.settings),
                              SizedBox(height: 04,),
                              Text("Setting"),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: media.width*0.055,),

                // Account Settings Section
                const Text(
                  "Account Settings",
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const SizedBox(height: 10),
                Container(
                  width: media.width,
                  padding: EdgeInsets.symmetric(horizontal: 05,vertical: 05),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      _buildAccountOption(Icons.language, "Change Language",1,context),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 14,vertical: 03),
                        child: const Divider(height: 1),
                      ),
                      _buildAccountOption(Icons.lock_outline, "Invite Friends",2,context),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 14,vertical: 03),
                        child: const Divider(height: 1),
                      ),

                      _buildAccountOption(Icons.car_crash_outlined, "SOS Contacts",3,context),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 14,vertical: 03),
                        child: const Divider(height: 1),
                      ),
                      _buildAccountOption(Icons.report, "Raise Complaints",4,context),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Notification Settings Section
                const Text(
                  "Notification Settings",
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 08),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.notifications_none_outlined, color: Colors.black),
                          SizedBox(width: 8),
                          Text(
                            "Push Notifications",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Switch(
                        value: true,
                        onChanged: (bool value) {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),


        ],
      ),
    );
  }

  Widget _buildAccountOption(IconData icon, String title ,int index, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(

          leading: Icon(icon),
          title: Text(title),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            if(index==1){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Languages()));

            }else if(index==2){

            }else if(index==3){

            }else if(index==4){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>MakeComplaint()));


            }
          },
        ),

      ],
    );
  }
}
