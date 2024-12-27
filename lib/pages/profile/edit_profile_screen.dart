import 'package:flutter/material.dart';
import 'package:flutter_user/pages/profile/text_field.dart';

import '../../styles/styles.dart';
import '../../widgets/widgets.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController controllersDemo = TextEditingController();


  bool autoFocusNode=false;
  bool cilckTextField=false;

  final FocusNode focusNode1 = FocusNode();
  bool isFocused = false;

  @override
  void initState() {
    super.initState();
    // Add listener to detect focus changes
    // focusNode1.addListener(() {
    //   setState(() {
    //     isFocused = focusNode1.hasFocus;
    //   });
    // });
  }

  @override
  void dispose() {
    focusNode1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(

        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Edit Profile"),
        backgroundColor:Colors. grey.shade200,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Stack(
        children: [
          // Gray Container
          Positioned.fill(
            top: 80, // Push the container down for the profile picture overlap
            child: Container(
              color: Colors.white, // Light gray background
              child: Padding(
                padding:  EdgeInsets.only(top: media.width*0.2,left: media.width*0.04,right: media.width*0.04 ), // Padding for the fields
                child: Column(
                  children: [

                    TextFieldUI(textController: controllersDemo,labelText:"First Name" ,),
                   SizedBox(height: media.height*0.02),
                   TextFieldUI(textController: controllersDemo,labelText:"Last Name" ,),
                   SizedBox(height: media.height*0.02),

                    Container(
                      // width: media.height*0.,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset("assets/icons/india.png"),
                          SizedBox(width:  media.width*0.03,),
                          Text("+91"),
                          SizedBox(width:  media.width*0.04,),
                          Container(
                            width: media.width*0.004,
                            height: media.height*0.065,
                            color: Colors.grey,
                          ),
                          SizedBox(width:  media.width*0.04,),
                          Expanded(
                            child: TextFormField(
                              controller: controllersDemo,
                              decoration: InputDecoration(
                                labelText: "Phone Number",
                                // hintText: !cilckTextField ? "Enter First Name" : "",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: media.height*0.02),
                   TextFieldUI(textController: controllersDemo,labelText:"Email" ,),

                    Spacer(),
                    // Save Button
                Button(
                          color: buttonColors,
                          textcolor: Colors.black,
                          borcolor: Colors.white,
                          onTap: () async {

                          },
                          text: "Save",),
                    SizedBox(height: media.height*0.04),
                  ],
                ),
              ),
            ),
          ),
          // Profile Picture
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                SizedBox(height: 20), // Spacing from top
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 58,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 55,
                        backgroundImage: AssetImage("assets/icons/userIcon.png"), // Replace with user image URL
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
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
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      // Padding(
      //   padding: const EdgeInsets.all(16.0),
      //   child: Column(
      //     children: [
      //       CircleAvatar(
      //         radius: 50,
      //         backgroundImage: AssetImage("assets/profile_picture.jpg"), // Replace with your image
      //         child: Align(
      //           alignment: Alignment.bottomRight,
      //           child: CircleAvatar(
      //             backgroundColor: Colors.white,
      //             radius: 15,
      //             child: Icon(
      //               Icons.edit,
      //               size: 15,
      //               color: Colors.black,
      //             ),
      //           ),
      //         ),
      //       ),
      //       SizedBox(height: media.height*0.05),
      //       TextFieldUI(textController: controllersDemo,labelText:"First Name" ,),
      //       SizedBox(height: media.height*0.02),
      //       TextFieldUI(textController: controllersDemo,labelText:"Last Name" ,),
      //       SizedBox(height: media.height*0.02),
      //       TextFieldUI(textController: controllersDemo,labelText:"Email" ,),
      //       SizedBox(height: media.height*0.4),
      //
      //
      //
      //
      //       Button(
      //         color: buttonColors,
      //         textcolor: Colors.black,
      //         borcolor: Colors.white,
      //         onTap: () async {
      //
      //         },
      //         text: "Save",),
      //     ],
      //   ),
      // ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: EditProfileScreen(),
  ));
}
