import 'package:flutter/material.dart';

appBarWidget(
    {required BuildContext context,
      required Color backgroundIcon,
      required String title,
      required bool showTitle}){
  var media = MediaQuery.of(context).size;
  return Column(
    children: [
      SizedBox(height: media.height*0.04,),
      GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Padding(
          padding:  EdgeInsets.only(left: 10),
          child: CircleAvatar(
            backgroundColor: backgroundIcon,
            radius: 20,
            // Half of the desired width/height
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 23,
            ),
          ),
        ),
      ),
    ],
  );


}