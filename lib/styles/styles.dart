import 'package:flutter/material.dart';

var scrheight = 813.0;
var scrwidth = 375.0;

double eight = 0.0213;
double ten = 0.0267;
double twelve = 0.032;
double fourteen = 0.037;
double thirty = 0.08;
double fifteen = 0.04;
double sixteen = 0.042666;
double eighteen = 0.048;
double twenty = 0.053;
double twentysix = 0.0693;
double twentyeight = 0.07466;
double twentyfour = 0.064;
double fourty = 0.10667;
Color backgroundColor = const Color(0xffe5e5e5);
Color textColor = const Color(0xff12121D);
Color backIcon = const Color(0xff12121D);
Color underline = const Color(0xff12121D).withOpacity(0.3);
Color hintColor = const Color(0xff12121D).withOpacity(0.3);
Color inputUnderline = const Color(0xff12121D).withOpacity(0.3);
Color inputfocusedUnderline = const Color(0xff12121D);
Color boxShadowColor = const Color(0xff12121D).withOpacity(0.2);
Color topBar = const Color(0xffFFFFFF);
Color page = const Color(0xffFFFFFF);
Color buttonColor = const Color(0xffFFCC00);
Color theme = const Color(0xffFFCC00);
Color buttonText = const Color(0xffFFFFFF);
Color inputFieldSeparator = const Color(0xff1DA1F2);
Color termsCheckBox = const Color(0xff39BF4E);
Color loaderColor = const Color(0xffFFCC00);
Color notUploadedColor = Colors.orange;
Color verifyPendingBck = const Color(0xffFEF2F2);
Color verifyPending = const Color(0xffFFB800);
Color verifyDeclined = const Color(0xffE70000);
Color offline = const Color(0xff898989);
Color online = const Color(0xff309700);
Color dropColor = const Color(0xffE70000);
Color onlineOfflineText = const Color(0xffFFFFFF);
Color borderLines = const Color(0xffE5E5E5);
Color starColor = const Color(0xffFac500);
bool isDarkTheme = false;
Color greyText = const Color(0xff808080);
Color borderColor = const Color(0xffAAABAA);
Color boxColors = const Color(0xffAAAAAA).withOpacity(0.20);


Color buttonColors = const Color(0xffBCFD5D);
Color borderColors = const Color(0xffD9D9D9);
Color headingColors = const Color(0xff1D1B20);
Color backgroundColors = const Color(0xffE8E9EA);
Color backgroundWhiteColors = const Color(0xff1D1B20);
Color iconColors = const Color(0xff1D1B20);
Color iconGrayColors = const Color(0xff6D6D6D);
Color normalTextColors = const Color(0xff494A52);
Color normalText1Colors = const Color(0xff5E5E5E);
Color buttonTextColors = const Color(0xff030303);
Color whiteColors = const Color(0xffFFFFFF);
Color dividerColors = const Color(0xffEBEBEB);


double font12Size =12;
double font13Size =13;
double font14Size = 14;
double font16Size = 16;
double font18Size =18;
double font20Size = 20;
double font24Size = 24;
double font25Size = 25;
double font26Size = 26;
double font15Size = 15;
double font22Size = 22;
double font27Size = 27;
double font40Size =40;



dynamic shimmer;
List<Color> shaderColor = [
  const Color(0xFFEBEBF4).withOpacity(0.2),
  const Color(0xffFBFBFB).withOpacity(0.42),
  const Color(0xFFEBEBF4).withOpacity(0.2),
];

List<double> shaderStops = [
  0.1,
  0.3,
  0.4,
];

Alignment shaderBegin = const Alignment(-1.0, -0.3);
Alignment shaderEnd = const Alignment(1.0, 0.3);

BoxShadow boxshadow = BoxShadow(
    blurRadius: 2, color: textColor.withOpacity(0.2), spreadRadius: 2);
