import 'package:flutter/material.dart';
import 'package:flutter_user/pages/profile/contact_us_screen.dart';
import 'package:flutter_user/styles/styles.dart';

import '../../functions/functions.dart';
import '../../widgets/appbar.dart';
import '../../widgets/bottom_sheet_content.dart';
import '../../widgets/success_dialog_content.dart';
import '../../widgets/widgets.dart';
import '../NavigatorPages/faq.dart';
import '../login/loginScreen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: backgroundColors,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height:media.width * 0.01 ,),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 14),
              child: appBarWidget(context: context,
                  onTaps: (){
                    Navigator.pop(context);
                  },
                  backgroundIcon: whiteColors, title: "",iconColors: iconGrayColors),
            ),

            SizedBox(height:media.width * 0.04,),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: MyText(
                  text: "Settings",
                  size: font26Size,
                  color: headingColors,
                  fontweight: FontWeight.w800,
                ),

            ),
            SizedBox(height:media.width * 0.01,),
            Container(
              margin: EdgeInsets.all(16.0),
              padding: EdgeInsets.symmetric(horizontal: 16,vertical: 05),
              decoration: BoxDecoration(
                color: whiteColors,
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

                      openBrowser('https://loyalsafar.com/terms');

                      // Navigate to About Us
                    },
                  ),
                  horizontalDivider(),
                  // Contact Us
                  SettingsTile(
                    icon: Icons.mail_outline,
                    title: 'Contact Us',
                    onTap: () {
                     // Navigator.push(context, MaterialPageRoute(builder: (context)=>ContactUsScreen()));
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Loginscreen()));

                      // Navigate to Contact Us
                    },
                  ),
                  horizontalDivider(),
                  // Terms & Conditions
                  SettingsTile(
                    icon: Icons.description_outlined,
                    title: 'Terms & Conditions',
                    onTap: () {
                      // Navigate to Terms & Conditions
                    },
                  ),
                  horizontalDivider(),
                  // Privacy Policy
                  SettingsTile(
                    icon: Icons.contact_page_outlined,
                    title: 'Privacy Policy',
                    onTap: () {
                      // Navigate to Privacy Policy
                    },
                  ),
                  horizontalDivider(),
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
                  horizontalDivider(),
                  // Rate the App
                  SettingsTile(
                    icon: Icons.star_outline,
                    title: 'Rate The App',
                    onTap: () {
                      // Navigate to Rate The App
                    },
                  ),
                  horizontalDivider(),
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
                color: whiteColors,
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
                        backgroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        isScrollControlled: true,
                        builder: (context) =>BottomSheetContent(image: 'assets/icons/deactivate.png',
                            title: 'Deactivate your account?', description:'Deactivating your account '
                                'will permanently delete your profile, ride history, '
                                'and personal information associated with the account.'
                            ,
                            button1: 'Deactivate', button2: 'Cancel',onClick: (){

                            showDialog(
                              context: context,
                              builder: (context) => SuccessDialogContent(image: '',
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

                  horizontalDivider(),
                  SettingsTile(
                    icon: Icons.delete_outline,
                    title: 'Delete Account',
                    onTap: () {


                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        isScrollControlled: true,
                        builder: (context) =>BottomSheetContent(image: 'assets/icons/delete.png',
                            title: '''Are you sure you want to delete your account?''', description:'''Please note that this action cannot be undone. If you proceed, all your data will be lost, and you will need to create a new account if you wish to use our services in the future.
                            ''', button1: 'Delete My Account', button2: 'Cancel',onClick: (){
                            showDialog(
                              context: context,
                              builder: (context) => SuccessDialogContent(image: '',
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
            SizedBox(height:media.width * 0.03,),
          ],
        ),
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 18),
      child: GestureDetector(
        onTap:onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon,size: 25,color: normalText1Colors,),
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
    );
    //   ListTile(
    //   leading: Icon(icon, color: Color(0xff4F4F4F),size: 30,),
    //   title: MyText(
    //     text: title,
    //     size: font16Size,
    //     color: normalText1Colors,
    //     fontweight: FontWeight.w500,
    //   ),
    //
    //   trailing: const Icon(Icons.chevron_right,color: Color(0xff4F4F4F),size: 27),
    //   onTap: onTap,
    // );
  }
}





