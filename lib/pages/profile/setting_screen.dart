import 'package:flutter/material.dart';
import 'package:flutter_user/pages/profile/contact_us_screen.dart';
import 'package:flutter_user/styles/styles.dart';

import '../NavigatorPages/faq.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: media.height*0.06,),

            GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(
                width: media.width * 0.1, // Set width
                height: media.width * 0.1,
                margin: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white, // Background color
                  shape: BoxShape.circle, // Makes the container circular
                ),
                child: const Icon(Icons.arrow_back_ios_new, color: Colors.black),

              ),
            ),

            SizedBox(height: media.height * 0.02,),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: Text('Settings',style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),)),

            Container(
              margin: EdgeInsets.all(16.0),
              padding: EdgeInsets.symmetric(horizontal: 16,vertical: 05),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                // padding: const EdgeInsets.symmetric(vertical: 16.0),
                children: [
                  // About Us
                  SettingsTile(
                    icon: Icons.info_outline,
                    title: 'About Us',
                    onTap: () {
                      // Navigate to About Us
                    },
                  ),
                  Divider(),
                  // Contact Us
                  SettingsTile(
                    icon: Icons.mail_outline,
                    title: 'Contact Us',
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ContactUsScreen()));
                      // Navigate to Contact Us
                    },
                  ),
                  Divider(),
                  // Terms & Conditions
                  SettingsTile(
                    icon: Icons.description_outlined,
                    title: 'Terms & Conditions',
                    onTap: () {
                      // Navigate to Terms & Conditions
                    },
                  ),
                  Divider(),
                  // Privacy Policy
                  SettingsTile(
                    icon: Icons.contact_page_outlined,
                    title: 'Privacy Policy',
                    onTap: () {
                      // Navigate to Privacy Policy
                    },
                  ),
                  Divider(),
                  // FAQ's
                  SettingsTile(
                    icon: Icons.help_outline,
                    title: 'FAQ’s',
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>
                      Faq())
                      );


                      // Navigate to FAQ's
                    },
                  ),
                  Divider(),
                  // Rate the App
                  SettingsTile(
                    icon: Icons.star_outline,
                    title: 'Rate The App',
                    onTap: () {
                      // Navigate to Rate The App
                    },
                  ),
                  Divider(),
                  // Share App
                  SettingsTile(
                    icon: Icons.share,
                    title: 'Share App',
                    onTap: () {
                      // Handle app sharing
                    },
                  ),
                ],
              ),
            ),

            Container(
              margin: EdgeInsets.all(16.0),
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
               // padding: const EdgeInsets.symmetric(vertical: 16.0),
                children: [


                  // Deactivate Account
                  SettingsTile(
                    icon: Icons.person_off_outlined,
                    title: 'Deactivate my Account',
                    onTap: () {

                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        isScrollControlled: true,
                        builder: (context) =>DeactivateAccountBottomSheetContent(image: 'assets/icons/deactivate.png',
                            title: 'Deactivate your account?', description:'Deactivating your account '
                                'will permanently delete your profile, ride history, '
                                'and personal information associated with the account.'
                            ,
                            button1: 'Deactivate', button2: 'Cancel',onClick: (){

                            showDialog(
                              context: context,
                              builder: (context) => DeactivateAccountDialogContent(image: '',
                                  title: '''We're sorry to see you go!''', description: 'Your account has been deactivated.If you decide to reactivate it, simply log back in to our platform. Thank you for using our app!"'),
                            );
                          },),
                      );

                      // showDialog(
                      //   context: context,
                      //   builder: (context) => DeactivateAccountDialogContent(),
                      // );
                      // Navigate to Deactivate Account
                    },
                  ),
                  // Delete Account

                  Divider(),
                  SettingsTile(
                    icon: Icons.delete_outline,
                    title: 'Delete Account',
                    onTap: () {


                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        isScrollControlled: true,
                        builder: (context) =>DeactivateAccountBottomSheetContent(image: 'assets/icons/delete.png',
                            title: '''Are you sure you want to delete your account?''', description:'''Please note that this action cannot be undone. If you proceed, all your data will be lost, and you will need to create a new account if you wish to use our services in the future.
                            '''
                            ,
                            button1: 'Delete My Account', button2: 'Cancel',onClick: (){
                            showDialog(
                              context: context,
                              builder: (context) => DeactivateAccountDialogContent(image: '',
                                  title:'''Account has been successfully deleted.''', description: '''Thank you for being a part of our community. We appreciate your contributions and wish you all the best in your future endeavors.'''),
                            );
                          },),
                      );

                      // Navigate to Delete Account
                    },
                  ),
                
                  // Sign Out

                ],
              ),
            ),

            SizedBox(height: media.height*0.02,),

            Center(
              child: TextButton(
                onPressed: () {
                  // Handle sign out
                },
                child: const Text(
                  'Sign out',
                  style: TextStyle(color: Colors.red, fontSize: 16.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const SettingsTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[700]),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}


class DeactivateAccountBottomSheetContent extends StatefulWidget {
  String? title;
  String? description;
  String? image;
  String? button1;
  String? button2;
  Function()? onClick;

  DeactivateAccountBottomSheetContent(
      {required this.image,required this.title,required this.description,required this.button1,
        required this.button2,required this.onClick});

  @override
  State<DeactivateAccountBottomSheetContent> createState() => _DeactivateAccountBottomSheetContentState();
}

class _DeactivateAccountBottomSheetContentState extends State<DeactivateAccountBottomSheetContent> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
         Container(
           width: media.width*0.3,
             height: media.width*0.3,
             child: Image.asset(widget.image.toString(),fit: BoxFit.cover,)),
          const SizedBox(height: 05),
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: Text(
               widget.title.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.black
              ),
              ),
           ),
          const SizedBox(height: 8),
           Padding(
             padding:  EdgeInsets.symmetric(horizontal: media.width*0.09),
             child: Text(
              widget.description.toString(),
              style: TextStyle(fontSize: 20, color: Colors.black),
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
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
                onPressed: widget.onClick,
                child:  Text(
                    widget.button1.toString(),
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 20),
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
                  // backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  side: const BorderSide(
                    color: Colors.black, // Set your border color

                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  // Handle account deactivation
                },
                child:  Text(
                    widget.button2.toString(),
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 20),
                ),
              ),
            ),
          ),
          SizedBox(height: media.width*0.01),
          // SizedBox(
          //   width: double.infinity,
          //   child: TextButton(
          //     onPressed: () {
          //       Navigator.pop(context);
          //     },
          //     child: const Text(
          //       'Cancel',
          //       style: TextStyle(color: Colors.black),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}


class DeactivateAccountDialogContent extends StatefulWidget {
  String? image;
  String? title;
  String? description;

  DeactivateAccountDialogContent({ required this.image,required this.title,required this.description});

  @override
  State<DeactivateAccountDialogContent> createState() => _DeactivateAccountDialogContentState();
}

class _DeactivateAccountDialogContentState extends State<DeactivateAccountDialogContent> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: media.width * 0.15, // Set width
              height: media.width * 0.15,
              margin: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: buttonColors, // Background color
                shape: BoxShape.circle, // Makes the container circular
              ),
              child: const Icon(Icons.check, color: Colors.black,size: 26,),

            ),
            const SizedBox(height: 16),
             Padding(
               padding:  EdgeInsets.symmetric(horizontal: media.width * 0.15),
               child: Text(
                widget.title.toString(),
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                           ),
             ),
            const SizedBox(height: 8),
             Padding(
               padding:  EdgeInsets.symmetric(horizontal: media.width * 0.1),
               child: Text(
                 widget.description.toString(),
                style: TextStyle(fontSize: 18, color: Colors.black),

                 textAlign: TextAlign.center,
                           ),
             ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
