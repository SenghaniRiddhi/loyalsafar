import 'package:flutter/material.dart';
import 'package:flutter_user/widgets/widgets.dart';

import '../pages/NavigatorPages/editprofile.dart';
import '../pages/profile/edit_profile_screen.dart';
import '../pages/profile/profile_screen.dart';
import '../styles/styles.dart';

appBarWidget(
    {required BuildContext context,
      required Color backgroundIcon,
      required Color iconColors,
      required String title,
      required Function() onTaps,
      }){
  var media = MediaQuery.of(context).size;
  return Column(
    children: [
      SizedBox(height: media.height*0.04,),
      GestureDetector(
        onTap: onTaps,
        child: CircleAvatar(
          backgroundColor: backgroundIcon,
          radius: 18,
          child: Padding(
            padding:  EdgeInsets.only(left: 09),
            child: Icon(
              Icons.arrow_back_ios,
              color: iconColors,
              size: 20,
            ),
          ),
        ),
      ),
    ],
  );
}

appBarWithoutHeightWidget(
    {required BuildContext context,
      required Color backgroundIcon,
      required Color iconColors,
      required String title,
      required Function() onTaps,
    }){
  var media = MediaQuery.of(context).size;
  return Column(
    children: [
      GestureDetector(
        onTap: onTaps,
        child: CircleAvatar(
          backgroundColor: backgroundIcon,
          radius: 18,
          child: Padding(
            padding:  EdgeInsets.only(left: 09),
            child: Icon(
              Icons.arrow_back_ios,
              color: iconColors,
              size: 20,
            ),
          ),
        ),
      ),
    ],
  );
}

appBarTitleWidget(
    {required BuildContext context,
      required Color backgroundIcon,
      required Color iconColors,
      required String title,
      required Function() onTaps,
    }){
  var media = MediaQuery.of(context).size;
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Row(
      children: [
        GestureDetector(
          onTap: onTaps,
          child: CircleAvatar(
            backgroundColor: backgroundIcon,
            radius: 18,
            child: Padding(
              padding:  EdgeInsets.only(left: 09),
              child: Icon(
                Icons.arrow_back_ios,
                color: iconColors,
                size: 20,
              ),
            ),
          ),
        ),
        SizedBox(width: 100,),
        MyText(text: title, size: font18Size,color: headingColors,fontweight: FontWeight.w600,)
      ],
    ),
  );


}

appBarProfileWidget(
    {required BuildContext context}){
  var media = MediaQuery.of(context).size;
  return  Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      GestureDetector(
        onTap: (){
          Navigator.pop(context);
        },
        child: CircleAvatar(
          radius: 18,
          backgroundColor: Color(0xffECECEC),
          child: Icon(Icons.close, color: iconGrayColors, size: 20,),
        ),
      ),

      GestureDetector(
        onTap: (){
          Navigator.push(context,MaterialPageRoute(builder: (context)=>EditProfile()));
        },
        child: CircleAvatar(
          radius: 18,
          backgroundColor: Color(0xffECECEC),
          child: Icon(Icons.edit, color: iconGrayColors, size: 18,),
        ),
      ),

    ],);
}

userProfile({required BuildContext context}){
  return GestureDetector(
    onTap: (){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen()));
    },
      child: Icon(Icons.account_circle, color: Colors.black,size: 45,));
}
