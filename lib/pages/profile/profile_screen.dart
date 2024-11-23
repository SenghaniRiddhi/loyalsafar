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
import 'package:flutter_user/pages/profile/payment_screen.dart';
import 'package:flutter_user/pages/profile/setting_screen.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({Key? key}) : super(key: key);

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
                    Container(
                      width: media.width * 0.1, // Set width
                      height: media.width * 0.1,
                      decoration: BoxDecoration(
                        color: Colors.grey[200], // Background color
                        shape: BoxShape.circle, // Makes the container circular
                      ),
                      child: const Icon(Icons.close, color: Colors.black),
                      // onPressed: () {},
                    ),
                    Container(
                      width: media.width * 0.1, // Set width
                      height: media.width * 0.1,
                      decoration: BoxDecoration(
                        color: Colors.grey[200], // Background color
                        shape: BoxShape.circle, // Makes the container circular
                      ),
                      child: const Icon(Icons.edit, color: Colors.black),
                      // onPressed: () {},
                    ),


                  ],),

                SizedBox(height: media.width*0.06,),

                Row(
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/profile.jpg'), // Add your profile image here
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

                SizedBox(height: media.width*0.06,),

              ],
            ),
          ),



          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 20),
                // Wallet Balance Section
                Container(
                  padding: const EdgeInsets.all(16),
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
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          "\$420",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.all(08.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap:(){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>AddressesScreen()));
                          },
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                             Icon(Icons.location_on),
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
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.payment),
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
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.settings),
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
                      fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      _buildAccountOption(Icons.language, "Change Language"),
                      _buildAccountOption(Icons.group_add, "Invite Friends"),
                      _buildAccountOption(Icons.contacts, "SOS Contacts"),
                      _buildAccountOption(Icons.report, "Raise Complaints"),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Notification Settings Section
                const Text(
                  "Notification Settings",
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.notifications, color: Colors.black),
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

  Widget _buildAccountOption(IconData icon, String title) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon),
          title: Text(title),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {},
        ),
        const Divider(height: 1),
      ],
    );
  }
}
