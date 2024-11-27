import 'package:flutter/material.dart';
import 'package:flutter_user/pages/profile/text_field.dart';

class EditProfileScreen extends StatelessWidget {
  TextEditingController controllersDemo = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Edit Profile"),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage("assets/profile_picture.jpg"), // Replace with your image
              child: Align(
                alignment: Alignment.bottomRight,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 15,
                  child: Icon(
                    Icons.edit,
                    size: 15,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            TextFieldUI(text: "Email",hintText: "Enter Email", textController: controllersDemo),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text("First Name",style: TextStyle(fontSize: 15),),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "",
                      border: InputBorder.none,

                    ),
                  ),
                ],
              ),
            ),
            // TextField(
            //   decoration: InputDecoration(
            //     labelText: "First Name",
            //     hintText: "Enter your first name",
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(8.0),
            //     ),
            //   ),
            // ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: "Last Name",
                hintText: "Enter your last name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            // TextField(
            //   keyboardType: TextInputType.phone,
            //   decoration: InputDecoration(
            //     labelText: "Phone Number",
            //     prefixIcon: Padding(
            //       padding: const EdgeInsets.only(left: 8.0),
            //       child: Row(
            //         mainAxisSize: MainAxisSize.min,
            //         children: [
            //           Image.asset(
            //             "assets/flag.png", // Replace with your flag icon
            //             width: 24,
            //           ),
            //           SizedBox(width: 8),
            //           Text("+91"),
            //         ],
            //       ),
            //     ),
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(8.0),
            //     ),
            //   ),
            // ),
            // SizedBox(height: 20),

           TextFieldUI(text: "Email", textController: controllersDemo,hintText: "Enter Email",),

            // TextField(
            //   decoration: InputDecoration(
            //     labelText: "Email",
            //     hintText: "Enter your email",
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(8.0),
            //     ),
            //   ),
            // ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Handle save action
              },
              style: ElevatedButton.styleFrom(
                // primary: Colors.green,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "Save",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: EditProfileScreen(),
  ));
}
