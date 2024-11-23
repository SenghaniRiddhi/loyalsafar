import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(

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
              padding: EdgeInsets.symmetric(horizontal: 16),
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
                    icon: Icons.lock_outline,
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
                    icon: Icons.share_outlined,
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
                    icon: Icons.remove_circle_outline,
                    title: 'Deactivate my Account',
                    onTap: () {

                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        isScrollControlled: true,
                        builder: (context) =>DeactivateAccountBottomSheetContent(image: '',
                            title: 'Deactivate your account?', description:'Deactivating your account '
                                'will permanently delete your profile, ride history, '
                                'and personal information associated with the account.'
                            ,
                            button1: 'Deactivate', button2: 'Cancel'),
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

                      showDialog(
                        context: context,
                        builder: (context) => DeactivateAccountDialogContent(image: '',
                            title: 'Account has been successfully deleted.', description: 'thank you for being a part of our community'),
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

  DeactivateAccountBottomSheetContent(
      {required this.image,required this.title,required this.description,required this.button1,
        required this.button2});

  @override
  State<DeactivateAccountBottomSheetContent> createState() => _DeactivateAccountBottomSheetContentState();
}

class _DeactivateAccountBottomSheetContentState extends State<DeactivateAccountBottomSheetContent> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.person_off,
            size: 64,
            color: Colors.black,
          ),
          const SizedBox(height: 16),
           Text(
             widget.title.toString(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
           Text(
            widget.description.toString(),
            style: TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
              onPressed: () {
                // Handle account deactivation
              },
              child:  Text(
                  widget.button1.toString(),
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(

              style: ElevatedButton.styleFrom(
                // backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
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
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ),
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
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.person_off,
              size: 64,
              color: Colors.black,
            ),
            const SizedBox(height: 16),
             Text(
              widget.title.toString(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
             Text(
               widget.description.toString(),
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
