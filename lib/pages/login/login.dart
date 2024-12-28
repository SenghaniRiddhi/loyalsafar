// ignore_for_file: use_build_context_synchronously, unused_local_variable

import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_user/functions/notifications.dart';
import 'package:flutter_user/pages/onTripPage/invoice.dart';
import 'package:flutter_user/pages/onTripPage/map_page.dart';
import 'package:flutter_user/translations/translation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pinput/pinput.dart';
import '../../styles/styles.dart';
import '../../functions/functions.dart';
import '../../widgets/appbar.dart';
import '../../widgets/success_dialog_content.dart';
import '../../widgets/widgets.dart';
import 'dart:math' as math;
import '../loadingPage/loading.dart';
import '../profile/HomeScreen.dart';
import 'agreement.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

//code as int for getting phone dial code of choosen country
String phnumber = ''; // phone number as string entered in input field
// String phone = '';
List pages = [1, 2, 3, 4];
List images = [];
int currentPage = 0;
String currentPin = "";

var values = 0;
bool isfromomobile = true;

dynamic proImageFile1;
ImagePicker picker = ImagePicker();
bool pickImage = false;
bool isverifyemail = false;
String email = ''; // email of user
String password = '';
String name = ''; //name of user


late StreamController profilepicturecontroller;
StreamSink get profilepicturesink => profilepicturecontroller.sink;
Stream get profilepicturestream => profilepicturecontroller.stream;

class _LoginState extends State<Login> with TickerProviderStateMixin {
  TextEditingController controller = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _mobile = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController(text: "123456");
  final TextEditingController _name = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final FocusNode otpNode = FocusNode();
  // final TextEditingController _otp = TextEditingController();
  late TextEditingController _otp;

  bool loginLoading = true;
  final ScrollController _scroll = ScrollController();
  // final _pinPutController2 = TextEditingController();
  dynamic aController;
  String countyCode = "";
  String _error = '';
  bool showSignin = false;
  // bool _resend = false;
  int signIn = 0;
  var searchVal = '';
  bool isLoginemail = true;
  bool withOtp = true;
  bool showPassword = false;
  bool showNewPassword = false;
  bool otpSent = false;
  bool _resend = false;
  int resendTimer = 60;
  bool mobileVerified = false;
  dynamic resendTime;
  bool forgotPassword = false;
  bool newPassword = false;
  final _formKey = GlobalKey<FormState>();

  late final FocusNode focusNode;

  resend() {
    resendTime?.cancel();
    resendTime = null;

    resendTime = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (resendTimer > 0) {
          resendTimer--;
        } else {
          _resend = true;
          resendTime?.cancel();
          timer.cancel();
          resendTime = null;
        }
      });
    });
  }

  String get timerString {
    Duration duration = aController.duration * aController.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  bool terms = true; //terms and conditions true or false

  @override
  void initState() {
    currentPage = 0;
    _otp = TextEditingController();
    focusNode = FocusNode();
    controller.text = '';
    proImageFile1 = null;
    gender = '';
    aController =
        AnimationController(vsync: this, duration: const Duration(seconds: 60));
    countryCode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!otpSent && signIn == 0) {
        _focusNode.requestFocus();
      }
      otpNode.requestFocus();
    });


    // Add listeners to rebuild UI on focus changes


    super.initState();
  }

  @override
  void dispose() {
    // Dispose controllers and focus nodes
    print("focus nodes::-");
    controller.dispose();
    _otp.dispose();
    otpNode.dispose();
    focusNode.dispose();
    _focusNode.dispose();
    _mobile.dispose();
    _email.dispose();
    _focusNode.dispose();

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  getGalleryPermission() async {
    dynamic status;
    if (platform == TargetPlatform.android) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt <= 32) {
        status = await Permission.storage.status;
        if (status != PermissionStatus.granted) {
          status = await Permission.storage.request();
        }

        /// use [Permissions.storage.status]
      } else {
        status = await Permission.photos.status;
        if (status != PermissionStatus.granted) {
          status = await Permission.photos.request();
        }
      }
    } else {
      status = await Permission.photos.status;
      if (status != PermissionStatus.granted) {
        status = await Permission.photos.request();
      }
    }
    return status;
  }

//get camera permission
  getCameraPermission() async {
    var status = await Permission.camera.status;
    if (status != PermissionStatus.granted) {
      status = await Permission.camera.request();
    }
    return status;
  }

//pick image from gallery
  pickImageFromGallery() async {
    var permission = await getGalleryPermission();
    if (permission == PermissionStatus.granted) {
      final pickedFile =
          await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

      proImageFile1 = pickedFile?.path;
      pickImage = false;
      valueNotifierLogin.incrementNotifier();
      profilepicturesink.add('');
    } else {
      valueNotifierLogin.incrementNotifier();
      profilepicturesink.add('');
    }
  }

//pick image from camera
  pickImageFromCamera() async {
    var permission = await getCameraPermission();
    if (permission == PermissionStatus.granted) {
      final pickedFile =
          await picker.pickImage(source: ImageSource.camera, imageQuality: 50);

      proImageFile1 = pickedFile?.path;
      pickImage = false;
      valueNotifierLogin.incrementNotifier();
      profilepicturesink.add('');
    } else {
      valueNotifierLogin.incrementNotifier();
      profilepicturesink.add('');
    }
  }

  navigate(verify) {
    if (verify == true) {
      if (userRequestData.isNotEmpty && userRequestData['is_completed'] == 1) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Invoice()),
            (route) => false);
      } else {

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) =>  CustomBottomNavExample()),
                (route) => false);
        // Navigator.pushAndRemoveUntil(
        //     context,
        //     MaterialPageRoute(builder: (context) => const Maps()),
        //     (route) => false);
      }
    } else if (verify == false) {
      setState(() {
        _error =
            'User Doesn\'t exists with this number, please Signup to continue';
      });
    } else {
      _error = verify.toString();
    }
    loginLoading = false;
    valueNotifierLogin.incrementNotifier();
  }

  countryCode() async {
    isverifyemail = false;
    isfromomobile = true;
    var result = await getCountryCode();
    if (loginImages.isNotEmpty) {
      images.clear();
      for (var e in loginImages) {
        images.add(Image.network(
          e['onboarding_image'],
          gaplessPlayback: true,
          fit: BoxFit.cover,
        ));
      }
    }
    if (result == 'success') {
      setState(() {
        loginLoading = false;
      });
    } else {
      setState(() {
        loginLoading = false;
      });
    }
  }

  List landings = [
    {
      'heading': 'ASSURANCE',
      'text':
          'Customer safety first,Always and forever our pledge,Your well-being, our priority,With you every step, edge to edge.'
    },
    {
      'heading': 'CLARITY',
      'text':
          'Fair pricing, crystal clear, Your trust, our promise sincere. With us, you\'ll find no hidden fee, Transparency is our guarantee.'
    },
    {
      'heading': 'INTUTIVE',
      'text':
          'Seamless journeys, Just a tap away, Explore hassle-free, Every step of the way.'
    },
    {
      'heading': 'SUPPORT',
      'text':
          'Embark on your journey with confidence, knowing that our commitment to your satisfaction is unwavering'
    },
  ];

  var verifyEmailError = '';
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    const focusedBorderColor = Color(0xff1D1B20);
    const fillColor = Color(0xffFFFFFF);
    const borderColor = Color(0xffD9D9D9);
    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    final defaultPinTheme = PinTheme(
      width: 50,
      height: 58,
      textStyle:  TextStyle(
        fontSize: font20Size,
        fontWeight: FontWeight.w700,
        color: headingColors,
      ),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(06),
        border: Border.all(color: Color(0xffD9D9D9),width: 2),
      ),
    );
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Directionality(
              textDirection: (languageDirection == 'rtl')
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: media.width * 0.04),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
        
                    SizedBox(
                      height: media.height * 0.02,
                    ),
                    Container(
                      // margin: EdgeInsets.symmetric(horizontal: 14),
                      child: appBarWidget(
                          context: context,
                          onTaps: () {
                            if (otpSent == true) {
                              setState(() {
                                otpSent = false;
                              });
                            } else {
                              Navigator.pop(context);
                            }
                          },
                          backgroundIcon: Color(0xffECECEC),
                          title: "",
                          iconColors: iconGrayColors),
                    ),
                    SizedBox(
                      height: media.height * 0.02,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
        
        
                        otpSent == true
                            ? Column(
                          mainAxisAlignment:
                          MainAxisAlignment.start,
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: MyText(
                                text: "We just sent you an SMS",
                                size: font26Size,
                                color: headingColors,
                                fontweight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(height: 10),
                            MyText(
                              text: "Please enter the 6 digit code sent to",
                              size: font15Size,
                              color: normalText1Colors,
                              fontweight: FontWeight.w400,
                            ),
                            SizedBox(height: 4),
                            MyText(
                              text:
                              "${countries[phcode]
                              ['dial_code'] + " " + _email.text}",
                              size: font15Size,
                              color: headingColors,
                              fontweight: FontWeight.w700,
                            ),
                          ],
                        )
                            : Padding(
                          padding: EdgeInsets.only(
                              right: 10, bottom: 10),
                          child: MyText(
                            text: "What is Your phone number?",
                            size: font26Size,
                            color: headingColors,
                            fontweight: FontWeight.w800,
                          ),
                        ),
        
                        otpSent == true
                            ? SizedBox()
                            : Container(
                          height: media.width * 0.13,
                          width: media.width,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color(0xffD9D9D9)),
                              borderRadius:
                              BorderRadius.circular(8),
                              color: Colors.white),
                          margin: EdgeInsets.only(
                              top: media.width * 0.040),
                          padding: EdgeInsets.only(
                              right: media.width * 0.025,
                              left: media.width * 0.025),
                          child: Row(
                            children: [
        
                              InkWell(
                                onTap: () {
                                  if (otpSent == false) {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (builder) {
                                          return Container(
                                            padding: EdgeInsets.all(
                                                media.width * 0.05),
                                            width: media.width,
                                            color: page,
                                            child: Directionality(
                                              textDirection:
                                              (languageDirection ==
                                                  'rtl')
                                                  ? TextDirection
                                                  .rtl
                                                  : TextDirection
                                                  .ltr,
                                              child: Column(
                                                children: [
                                                  Container(
                                                    padding:
                                                    const EdgeInsets
                                                        .only(
                                                        left:
                                                        20,
                                                        right:
                                                        20),
                                                    height: 40,
                                                    width: media
                                                        .width *
                                                        0.9,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                        border: Border.all(
                                                            color: Colors
                                                                .grey,
                                                            width:
                                                            1.5)),
                                                    child:
                                                    TextField(
                                                      decoration: InputDecoration(
                                                          contentPadding: (languageDirection ==
                                                              'rtl')
                                                              ? EdgeInsets.only(
                                                              bottom: media.width *
                                                                  0.035)
                                                              : EdgeInsets.only(
                                                              bottom: media.width *
                                                                  0.04),
                                                          border: InputBorder
                                                              .none,
                                                          hintText:
                                                          languages[choosenLanguage][
                                                          'text_search'],
                                                          hintStyle: GoogleFonts.notoSans(
                                                              fontSize: media.width *
                                                                  sixteen,
                                                              color:
                                                              hintColor)),
                                                      style: GoogleFonts.notoSans(
                                                          fontSize:
                                                          media.width *
                                                              sixteen,
                                                          color:
                                                          textColor),
                                                      onChanged:
                                                          (val) {
                                                        setState(
                                                                () {
                                                              searchVal =
                                                                  val;
                                                            });
                                                      },
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                      height: 20),
                                                  Expanded(
                                                    child:
                                                    SingleChildScrollView(
                                                      child: Column(
                                                        children: countries
                                                            .asMap()
                                                            .map((i, value) {
                                                          return MapEntry(
                                                              i,
                                                              // MyText(text: 'ttwer', size: 14)
                                                              SizedBox(
                                                                width: media.width * 0.9,
                                                                child: (searchVal == '' && countries[i]['flag'] != null)
                                                                    ? InkWell(
                                                                    onTap: () {
                                                                      setState(() {
                                                                        phcode = i;
                                                                        countyCode = countries[i]['dial_code'].toString();
                                                                        print("phcode::- ${countyCode}");
                                                                      });
                                                                      Navigator.pop(context);
                                                                    },
                                                                    child: Container(
                                                                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                                                                      color: page,
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              Image.network(countries[i]['flag']),
                                                                              SizedBox(
                                                                                width: media.width * 0.02,
                                                                              ),
                                                                              SizedBox(
                                                                                width: media.width * 0.4,
                                                                                child: MyText(
                                                                                  text: countries[i]['name'],
                                                                                  size: media.width * sixteen,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          MyText(text: countries[i]['dial_code'], size: media.width * sixteen)
                                                                        ],
                                                                      ),
                                                                    ))
                                                                    : (countries[i]['flag'] != null && countries[i]['name'].toLowerCase().contains(searchVal.toLowerCase()))
                                                                    ? InkWell(
                                                                    onTap: () {
                                                                      setState(() {
                                                                        phcode = i;
                                                                        countyCode = countries[i]['dial_code'].toString();
                                                                        print("phcode ${countyCode}");
                                                                      });
                                                                      Navigator.pop(context);
                                                                    },
                                                                    child: Container(
                                                                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                                                                      color: page,
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              Image.network(countries[i]['flag']),
                                                                              SizedBox(
                                                                                width: media.width * 0.02,
                                                                              ),
                                                                              SizedBox(
                                                                                width: media.width * 0.4,
                                                                                child: MyText(text: countries[i]['name'], size: media.width * sixteen),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          MyText(text: countries[i]['dial_code'], size: media.width * sixteen)
                                                                        ],
                                                                      ),
                                                                    ))
                                                                    : Container(),
                                                              ));
                                                        })
                                                            .values
                                                            .toList(),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                  }
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      right: media.width * 0.025),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage:
                                        NetworkImage(
                                            countries[phcode]
                                            ['flag']),
                                        radius: media.width *
                                            0.03, // Adjust the size
                                      ),
        
                                      // Image.network(
                                      //   countries[phcode]['flag'],
                                      //   width: media.width * 0.06,
                                      // ),
                                      SizedBox(
                                        width: media.width * 0.03,
                                      ),
        
                                      MyText(
                                        text: "${countries[phcode]
                                        ['dial_code']}",
                                        size: font15Size,
                                        color: Color(0xff697176),
                                        fontweight: FontWeight.w500,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              VerticalDivider(
                                color: Color(
                                    0xffD9D9D9), // Color of the divider
                                  // Thickness of the divider
                                width: 20, // Space occupied by the divider (including margin)
                               // Space from bottom
                              ),
                              Expanded(
                                child: SizedBox(
                                  height: media.width * 0.12,
                                  child: TextField(
                                    focusNode: _focusNode,
                                    keyboardType:
                                    TextInputType.number,
                                    enabled: (otpSent == true &&
                                        signIn == 0)
                                        ? false
                                        : true,
                                    controller: _email,
                                    onChanged: (v) {
                                      String pattern =
                                          r'(^(?:[+0]9)?[0-9]{1,12}$)';
                                      RegExp regExp =
                                      RegExp(pattern);
                                      if (regExp.hasMatch(
                                          _email.text) &&
                                          isLoginemail == true &&
                                          signIn == 0) {
                                        setState(() {
                                          isLoginemail = false;
                                        });
                                      } else if (isLoginemail ==
                                          false &&
                                          regExp.hasMatch(
                                              _email.text) ==
                                              false) {
                                        setState(() {
                                          isLoginemail = true;
                                        });
                                      }
                                    },
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric( horizontal: 10.0),
                                        hintStyle: TextStyle(
                                            color:
                                            Color(0xff5C6266),
                                            fontWeight:
                                            FontWeight.w400,
                                            fontSize: font16Size),
                                        hintText: (signIn == 0)
                                            ? "Phone Number"
                                            : languages[
                                        choosenLanguage]
                                        ['text_email'],
                                        border: InputBorder.none),
                                  ),
                                ),
                              ),
        
                            ],
                          ),
                        ),
        
                        otpSent == true
                            ? SizedBox()
                            : Padding(
                          padding:
                          EdgeInsets.symmetric(vertical: 10),
                          child: MyText(
                            text:
                            "We’ll send you verification code.",
                            size: font13Size,
                            color: Color(0xff303030),
                            fontweight: FontWeight.w500,
                          ),
                        ),
        
        
        
        
                        if ((withOtp == false ||
                            otpSent == true ||
                            signIn == 1) )SizedBox(
                          height: 30,
                        ),
        
                        if ((withOtp == false ||
                            otpSent == true ||
                            signIn == 1) )
                          Pinput(
                          // You can pass your own SmsRetriever implementation based on any package
                          // in this example we are using the SmartAuth
                          // smsRetriever: smsRetriever,
                          controller: _otp,
                          focusNode: otpNode,
                          length: 6,
                          defaultPinTheme: defaultPinTheme,
                          separatorBuilder: (index) => const SizedBox(width: 15),
                          validator: (value) {
                          if(value == null || value.isEmpty){
                            return "Please enter OTP";
                          }else if(value.length != 6){
                            return "OTP must be 6 digits";
                          }
                          },
                          hapticFeedbackType: HapticFeedbackType.lightImpact,
                          onCompleted: (pin) {
                            _otp.text=pin;
                            debugPrint('onCompleted: $pin');
                          },
                          onChanged: (value) {
                            debugPrint('onChanged: $value');
                          },
                          cursor: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // Container(
                              //   margin: const EdgeInsets.only(bottom: 9),
                              //   width: 22,
                              //   height: 1,
                              //   color: focusedBorderColor,
                              // ),
                            ],
                          ),
                          focusedPinTheme: defaultPinTheme.copyWith(
                            decoration: defaultPinTheme.decoration!.copyWith(
                              borderRadius: BorderRadius.circular(06),
                              border: Border.all(color: focusedBorderColor,width: 2),
                            ),
                          ),
                          submittedPinTheme: defaultPinTheme.copyWith(
                            decoration: defaultPinTheme.decoration!.copyWith(
                              borderRadius: BorderRadius.circular(06),
                              border: Border.all(color: focusedBorderColor,width: 2),
                            ),
                            // decoration: defaultPinTheme.decoration!.copyWith(
                            //   color: fillColor,
                            //   borderRadius: BorderRadius.circular(04),
                            //   border: Border.all(color: focusedBorderColor),
                            // ),
                          ),
                          errorPinTheme: defaultPinTheme.copyBorderWith(
                            border: Border.all(color: Colors.redAccent),
                          ),
                        ),
        
        
                        SizedBox(
                          height: media.width * 0.03,
                        ),
                        if (otpSent == true && newPassword == false)
                          Container(
                            alignment: Alignment.center,
                            width: media.width,
                            height: media.width * 0.1,
                            child: (_resend == true)
                                ? GestureDetector(
                              onTap: () async {
                                if (signIn == 1) {
                                  String pattern =
                                      r'(^(?:[+0]9)?[0-9]{1,12}$)';
                                  RegExp regExp = RegExp(pattern);
                                  if (regExp
                                      .hasMatch(_mobile.text) &&
                                      _mobile.text.length <=
                                          countries[phcode]
                                          ['dial_max_length'] &&
                                      _mobile.text.length >=
                                          countries[phcode]
                                          ['dial_min_length']) {
                                    if (isCheckFireBaseOTP) {
                                      var val = await otpCall();
                                      if (val.value == true) {
                                        await phoneAuth(
                                            countries[phcode]
                                            ['dial_code'] +
                                                _mobile.text);
                                        phoneAuthCheck = true;
                                        _resend = false;
                                        otpSent = true;
                                        resendTimer = 60;
                                        resend();
                                      } else {
                                        phoneAuthCheck = false;
                                        RemoteNotification noti =
                                        const RemoteNotification(
                                            title:
                                            'Otp for Login',
                                            body:
                                            'Login to your account with test OTP 123456');
                                        showOtpNotification(noti);
                                      }
                                      // setState(() {
                                      _resend = false;
                                      otpSent = true;
                                      resendTimer = 60;
                                      resend();
                                    } else {
                                      var val =
                                      await sendOTPtoMobile(
                                          (signIn == 1)
                                              ? _mobile.text
                                              : _email.text,
                                          countries[phcode]
                                          ['dial_code']
                                              .toString());
                                      if (val == 'success') {
                                        phoneAuthCheck = true;
                                        _resend = false;
                                        otpSent = true;
                                        resendTimer = 60;
                                        resend();
                                      } else {
                                        _error = val;
                                      }
                                    }
        
                                    // });
                                  } else {
                                    //  setState(() {
                                    _error =
                                    'Please enter valid mobile number';
                                    // });
                                  }
                                } else {
                                  var exist = true;
                                  if (forgotPassword == true) {
                                    var ver = await verifyUser(
                                        _email.text,
                                        (isLoginemail == true)
                                            ? 1
                                            : 0,
                                        _password.text,
                                        '',
                                        withOtp,
                                        forgotPassword,context);
                                    if (ver == true) {
                                      exist = true;
                                    } else {
                                      exist = false;
                                    }
                                  }
                                  if (exist == true) {
                                    if (isLoginemail == false) {
                                      String pattern =
                                          r'(^(?:[+0]9)?[0-9]{1,12}$)';
                                      RegExp regExp =
                                      RegExp(pattern);
                                      if (regExp.hasMatch(
                                          _email.text) &&
                                          _email.text.length <=
                                              countries[phcode][
                                              'dial_max_length'] &&
                                          _email.text.length >=
                                              countries[phcode][
                                              'dial_min_length']) {
                                        if (isCheckFireBaseOTP) {
                                          var val = await otpCall();
                                          if (val.value == true) {
                                            await phoneAuth(countries[
                                            phcode]
                                            ['dial_code'] +
                                                _email.text);
                                            phoneAuthCheck = true;
                                            _resend = false;
                                            otpSent = true;
                                            resendTimer = 60;
                                            resend();
                                          } else {
                                            phoneAuthCheck = false;
                                            RemoteNotification
                                            noti =
                                            const RemoteNotification(
                                                title:
                                                'Otp for Login',
                                                body:
                                                'Login to your account with test OTP 123456');
                                            showOtpNotification(
                                                noti);
                                          }
                                          // setState(() {
                                          _resend = false;
                                          otpSent = true;
                                          resendTimer = 60;
                                          resend();
                                        } else {
                                          var val =
                                          await sendOTPtoMobile(
                                              (signIn == 1)
                                                  ? _mobile.text
                                                  : _email.text,
                                              countries[phcode][
                                              'dial_code']
                                                  .toString());
                                          if (val == 'success') {
                                            phoneAuthCheck = true;
                                            _resend = false;
                                            otpSent = true;
                                            resendTimer = 60;
                                            resend();
                                          } else {
                                            _error = val;
                                          }
                                        }
        
                                        // });
                                      } else {
                                        //  setState(() {
                                        _error =
                                        'Please enter valid mobile number';
                                        // });
                                      }
                                    } else {
                                      String pattern =
                                          r"^[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[A-Za-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?\.)+[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])*$";
                                      RegExp regex =
                                      RegExp(pattern);
                                      if (regex
                                          .hasMatch(_email.text)) {
                                        phoneAuthCheck = true;
                                        var val =
                                        await sendOTPtoEmail(
                                            _email.text);
                                        if (val == 'success') {
                                          _resend = false;
                                          otpSent = true;
                                          resendTimer = 60;
                                          resend();
                                        } else {
                                          _error = val;
                                        }
                                      } else {
                                        // setState(() {
                                        _error =
                                        'Please enter valid email  address';
                                        // });
                                      }
                                    }
                                  } else {
                                    _error = (isLoginemail == false)
                                        ? 'Mobile Number doesn\'t exists'
                                        : 'Email doesn\'t exists';
                                  }
                                }
                              },
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: media.width * 0.08,
                                    // color: Colors.red,
        
                                    child: Image.asset(
                                      "assets/icons/otpLoading.png",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(
                                    width: media.width * 0.02,
                                  ),
                                  MyText(
                                    text: "Get new code",
                                    size: font16Size,
                                    fontweight: FontWeight.w500,
                                    textAlign: TextAlign.center,
                                    color: normalTextColors,
                                  ),
                                ],
                              ),
                            )
                                : (otpSent == true)
                                ? MyText(
                              text: resendTimer.toString(),
                              // 'Resend OTP in $resendTimer',
                              size: font24Size,
                              fontweight: FontWeight.w600,
                              textAlign: TextAlign.center,
                              color: Color(0xffC6C6C6),
                            )
                                : Container(),
                          ),
                        SizedBox(
                          height: media.width * 0.025,
                        ),
                        if (_error != '')
                          Column(
                            children: [
                              Container(
                                // width: media.width*0.9,
                                  constraints: BoxConstraints(
                                      maxWidth: media.width * 0.9,
                                      minWidth: media.width * 0.5),
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(12),
                                      color: const Color(0xffFFFFFF)
                                          .withOpacity(0.5)),
                                  child: MyText(
                                    text: _error,
                                    size: media.width * fourteen,
                                    color: Colors.red,
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    fontweight: FontWeight.w500,
                                  )),
                              // SizedBox(
                              //   height: media.width * 0.020,
                              // ),
                            ],
                          ),
        
        
                        SizedBox(
                          height: isKeyboardVisible ?media.height * 0.27:media.height * 0.5,
                        ),
        
                        Button(
                          width: media.width,
                            borcolor: buttonColors,
                            color: buttonColors,
                            textcolor: headingColors,
                            onTap: () async {
                              setState(() {
                                _error = '';
                                loginLoading = true;
                              });
        
                              print("newPassword::- ${newPassword} signIn:-${signIn} mobileVerified ${mobileVerified}");
        
                              if (newPassword == true) {
                                if (_newPassword.text.length >= 8) {
                                  var val = await updatePassword(
                                      _email.text,
                                      _newPassword.text,
                                      isLoginemail);
                                  if (val == true) {
                                    withOtp = false;
                                    otpSent = false;
                                    _password.clear();
                                    _email.clear();
                                    forgotPassword = false;
                                    newPassword = false;
                                    showModalBottomSheet(
                                        context: context,
                                        // isScrollControlled: true,
                                        backgroundColor: page,
                                        builder: (context) {
                                          return Container(
                                            width: media.width,
                                            padding: EdgeInsets.all(
                                                media.width * 0.05),
                                            child: MyText(
                                              text: languages[
                                              choosenLanguage]
                                              [
                                              'text_password_update_successfully'],
                                              size: media.width *
                                                  fourteen,
                                              maxLines: 4,
                                              color: textColor,
                                            ),
                                          );
                                        });
                                  } else {
                                    _error = val.toString();
                                  }
                                } else {
                                  setState(() {
                                    _error =
                                    'Password must be 8 character length';
                                  });
                                }
                              } else if (signIn == 0) {
                                if (withOtp == true) {
                                  print("otpSent ${otpSent} withOtp ${withOtp}");
        
                                  if (otpSent == true) {
                                    if (_email.text.isNotEmpty
                                        &&
                                        _password.text.isNotEmpty &&
                                        _password.text.length ==
                                            6) {
                                      print("phoneAuthCheck ${phoneAuthCheck}");
                                      if (phoneAuthCheck == true) {
                                        if (isLoginemail == true) {
                                          // var val = await emailVerify(_email.text,_password.text);
                                          // if(val == 'success'){
                                          if (forgotPassword ==
                                              true) {
                                            var val =
                                            await emailVerify(
                                                _email.text,
                                                _password.text);
                                            if (val == 'success') {
                                              _password.clear();
                                              newPassword = true;
                                              showNewPassword =
                                              false;
                                            } else {
                                              _error = val;
                                            }
                                          } else {
                                            var val =
                                            await verifyUser(
                                                _email.text,
                                                (isLoginemail ==
                                                    true)
                                                    ? 1
                                                    : 0,
                                                _password.text,
                                                '',
                                                withOtp,
                                                forgotPassword,context);
        
                                            navigate(val);
                                          }
                                        } else {
                                          if (isCheckFireBaseOTP ==
                                              true) {
                                            try {
                                              PhoneAuthCredential
                                              credential =
                                              PhoneAuthProvider.credential(
                                                  verificationId:
                                                  verId,
                                                  smsCode:
                                                  _password
                                                      .text);
        
                                              // Sign the user in (or link) with the credential
                                              await FirebaseAuth
                                                  .instance
                                                  .signInWithCredential(
                                                  credential);
        
                                              String? bearerrrrr =
                                              await FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .getIdToken();
        
                                              var verify =
                                              await verifyUser(
                                                  _email.text,
                                                  0,
                                                  '',
                                                  '',
                                                  withOtp,
                                                  forgotPassword,context);
                                              if (forgotPassword ==
                                                  true) {
                                                if (verify ==
                                                    true) {
                                                  _password.clear();
                                                  newPassword =
                                                  true;
                                                  showNewPassword =
                                                  false;
                                                }
                                              } else {
                                                navigate(verify);
                                              }
        
                                              values = 0;
                                            } on FirebaseAuthException catch (error) {
                                              if (error.code ==
                                                  'invalid-verification-code') {
                                                setState(() {
                                                  _password.clear();
                                                  // otpNumber = '';
                                                  _error =
                                                  'Please enter correct Otp or resend';
                                                });
                                              }
                                            }
                                          } else {
                                            var val =
                                            await validateSmsOtp(
                                                (signIn == 1)
                                                    ? _mobile
                                                    .text
                                                    : _email
                                                    .text,
                                                _password.text);
                                            if (val == 'success') {
                                              var verify =
                                              await verifyUser(
                                                  _email.text,
                                                  0,
                                                  '',
                                                  '',
                                                  withOtp,
                                                  forgotPassword,context);
                                              if (forgotPassword ==
                                                  true) {
                                                if (verify ==
                                                    true) {
                                                  _password.clear();
                                                  newPassword =
                                                  true;
                                                  showNewPassword =
                                                  false;
                                                }
                                              } else {
                                                navigate(verify);
                                              }
                                            } else {
                                              _error =
                                                  val.toString();
                                            }
                                          }
                                        }
                                      } else {
                                        print("_password.text ${_password.text}");
                                    if (_formKey.currentState!.validate()) {
                                      if (_password.text ==
                                          '123456') {
                                        var val =
                                        await verifyUser(
                                            _email.text,
                                            (isLoginemail ==
                                                true)
                                                ? 1
                                                : 0,
                                            _password.text,
                                            '',
                                            withOtp,
                                            forgotPassword,context);
                                        if (forgotPassword ==
                                            true) {
                                          if (val == true) {
                                            _password.clear();
                                            newPassword = true;
                                            showNewPassword =
                                            false;
                                          }
                                        } else {
                                          navigate(val);
                                        }
                                      } else {
                                        _error =
                                        'Please enter correct otp';
                                      }
                                    }

                                      }
                                    } else {
                                      setState(() {
                                        if (_password
                                            .text.isEmpty) {
                                          _error =
                                          'Please enter otp';
                                        } else {
                                          _error =
                                          'Please enter correct otp';
                                        }
                                      });
                                    }
                                  } else if (withOtp == true) {
                                    var exist = true;
                                    if (forgotPassword == true) {
                                      var ver = await verifyUser(
                                          _email.text,
                                          (isLoginemail == true)
                                              ? 1
                                              : 0,
                                          _password.text,
                                          '',
                                          withOtp,
                                          forgotPassword,context);
                                      if (ver == true) {
                                        exist = true;
                                      } else {
                                        exist = false;
                                      }
                                    }
                                    if (exist == true) {
                                      if (isLoginemail == false) {
                                        String pattern =
                                            r'(^(?:[+0]9)?[0-9]{1,12}$)';
                                        RegExp regExp =
                                        RegExp(pattern);
                                        if (regExp.hasMatch(
                                            _email.text) &&
                                            _email.text.length <=
                                                countries[phcode][
                                                'dial_max_length'] &&
                                            _email.text.length >=
                                                countries[phcode][
                                                'dial_min_length']) {
                                          // setState(() {
                                          //   _error = '';
                                          //   loginLoading = true;
                                          // });
                                          if (isCheckFireBaseOTP) {
                                            var val =
                                            await otpCall();
        
                                            if (val.value == true) {
                                              await phoneAuth(
                                                  countries[phcode][
                                                  'dial_code'] +
                                                      _email.text);
                                              phoneAuthCheck = true;
                                              _resend = false;
                                              otpSent = true;
                                              resendTimer = 60;
                                              resend();
                                            } else {
                                              phoneAuthCheck =
                                              false;
                                              RemoteNotification noti =
                                              const RemoteNotification(
                                                  title:
                                                  'Otp for Login',
                                                  body:
                                                  'Login to your account with test OTP 123456');
                                              showOtpNotification(
                                                  noti);
                                            }
                                            // setState(() {
                                            _resend = false;
                                            otpSent = true;
                                            resendTimer = 60;
                                            resend();
                                          } else {
                                            var val = await sendOTPtoMobile(
                                                (signIn == 1)
                                                    ? _mobile.text
                                                    : _email.text,
                                                countries[phcode][
                                                'dial_code']
                                                    .toString());
                                            if (val == 'success') {
                                              phoneAuthCheck = true;
                                              _resend = false;
                                              otpSent = true;
                                              resendTimer = 60;
                                              resend();
                                            } else {
                                              _error = val;
                                            }
                                          }
        
                                          // });
                                        } else {
                                          //  setState(() {
                                          _error =
                                          'Please enter valid mobile number';
                                          // });
                                        }
                                      } else {
                                        String pattern =
                                            r"^[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[A-Za-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?\.)+[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])*$";
                                        RegExp regex =
                                        RegExp(pattern);
                                        if (regex.hasMatch(
                                            _email.text)) {
                                          phoneAuthCheck = true;
                                          var val =
                                          await sendOTPtoEmail(
                                              _email.text);
                                          if (val == 'success') {
                                            _resend = false;
                                            otpSent = true;
                                            resendTimer = 60;
                                            resend();
                                          } else {
                                            _error = val;
                                          }
                                          // setState(() {
                                          // _error = '';
                                          // });
                                        } else {
                                          // setState(() {
                                          _error =
                                          'Please enter valid Phone Number';
                                          // });
                                        }
                                      }
                                    } else {
                                      _error = (isLoginemail ==
                                          false)
                                          ? 'Mobile Number doesn\'t exists'
                                          : 'Email doesn\'t exists';
                                    }
                                  }
                                }
                                else {
                                  if (_password.text.isNotEmpty &&
                                      _password.text.length >= 8 &&
                                      _email.text.isNotEmpty) {
                                    String pattern =
                                        r'(^(?:[+0]9)?[0-9]{1,12}$)';
                                    RegExp regExp = RegExp(pattern);
                                    String pattern1 =
                                        r"^[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[A-Za-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?\.)+[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])*$";
                                    RegExp regex = RegExp(pattern1);
                                    if ((regExp.hasMatch(
                                        _email.text) &&
                                        _email.text.length <=
                                            countries[phcode][
                                            'dial_max_length'] &&
                                        _email.text.length >=
                                            countries[phcode][
                                            'dial_min_length'] &&
                                        isLoginemail ==
                                            false) ||
                                        (isLoginemail == true &&
                                            regex.hasMatch(
                                                _email.text))) {
                                      var val = await verifyUser(
                                          _email.text,
                                          (isLoginemail == true)
                                              ? 1
                                              : 0,
                                          _password.text,
                                          '',
                                          withOtp,
                                          forgotPassword,context);
                                      navigate(val);
                                    } else {
                                      if (isLoginemail == false) {
                                        _error =
                                        'Please enter valid mobile number';
                                      } else {
                                        _error =
                                        'please enter valid email  address';
                                      }
                                    }
                                  } else {
                                    setState(() {
                                      _error =
                                      'Password must be 8 character length';
                                    });
                                  }
                                }
                              } else {
                                if (mobileVerified == true) {
                                  dynamic val;
                                  if (email != _email.text) {
                                    val = await verifyUser(
                                        _mobile.text,
                                        0,
                                        _password.text,
                                        _email.text,
                                        withOtp,
                                        forgotPassword,context);
                                  } else {
                                    val = false;
                                  }
                                  if (val == false) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                            const AggreementPage()));
                                  } else {
                                    _error = val;
                                  }
                                }
                                else if (otpSent == false) {
                                  if (_name.text.isNotEmpty &&
                                      _email.text.isNotEmpty &&
                                      _mobile.text.isNotEmpty &&
                                      _password.text.length >= 8 &&
                                      gender.isNotEmpty &&
                                      gender != '') {
                                    // ef;
                                    String pattern =
                                        r'(^(?:[+0]9)?[0-9]{1,12}$)';
                                    RegExp regExp = RegExp(pattern);
                                    if (regExp.hasMatch(
                                        _mobile.text) &&
                                        _mobile.text.length <=
                                            countries[phcode][
                                            'dial_max_length'] &&
                                        _mobile.text.length >=
                                            countries[phcode][
                                            'dial_min_length']) {
                                      // fd;
                                      String pattern =
                                          r"^[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[A-Za-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?\.)+[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])*$";
                                      RegExp regex =
                                      RegExp(pattern);
                                      if (regex
                                          .hasMatch(_email.text)) {
                                        name = _name.text;
                                        email = _email.text;
                                        password = _password.text;
                                        phnumber = _mobile.text;
                                        var verify =
                                        await verifyUser(
                                            _mobile.text,
                                            0,
                                            '',
                                            _email.text,
                                            withOtp,
                                            forgotPassword,context);
                                        if (verify == false) {
                                          if (isCheckFireBaseOTP) {
                                            var val =
                                            await otpCall();
                                            if (val.value == true) {
                                              await phoneAuth(
                                                  countries[phcode][
                                                  'dial_code'] +
                                                      _mobile.text);
                                              phoneAuthCheck = true;
                                              _resend = false;
                                              otpSent = true;
                                              resendTimer = 60;
                                              resend();
                                            } else {
                                              phoneAuthCheck =
                                              false;
                                              RemoteNotification noti =
                                              const RemoteNotification(
                                                  title:
                                                  'Otp for Login',
                                                  body:
                                                  'Login to your account with test OTP 123456');
                                              showOtpNotification(
                                                  noti);
                                            }
                                            // setState(() {
                                            _resend = false;
                                            otpSent = true;
                                            resendTimer = 60;
                                            resend();
                                            Future.delayed(
                                                const Duration(
                                                    seconds: 1),
                                                    () {
                                                  _scroll.position
                                                      .moveTo(_scroll
                                                      .position
                                                      .maxScrollExtent);
                                                });
                                          } else {
                                            var val = await sendOTPtoMobile(
                                                (signIn == 1)
                                                    ? _mobile.text
                                                    : _email.text,
                                                countries[phcode][
                                                'dial_code']
                                                    .toString());
                                            if (val == 'success') {
                                              phoneAuthCheck = true;
                                              _resend = false;
                                              otpSent = true;
                                              resendTimer = 60;
                                              resend();
                                              Future.delayed(
                                                  const Duration(
                                                      seconds: 1),
                                                      () {
                                                    _scroll.position
                                                        .moveTo(_scroll
                                                        .position
                                                        .maxScrollExtent);
                                                  });
                                            } else {
                                              _error = val;
                                            }
                                          }
                                        } else {
                                          _error = verify;
                                        }
                                      } else {
                                        _error =
                                        'please enter valid email  address';
                                      }
                                    } else {
                                      _error =
                                      'please enter valid mobile number';
                                    }
                                  }
                                  else if (_password.text.length <
                                      8) {
                                    _error =
                                    'password length must be 8 characters';
                                  } else {
                                    _error =
                                    'please enter all fields to proceed';
                                  }
                                }
                                else {
                                  // iorejie
        
                                  if (_otp.text.isNotEmpty &&
                                      _otp.text.length == 6) {
                                    dynamic val;
                                    if (email != _email.text) {
                                      val = await verifyUser(
                                          _mobile.text,
                                          0,
                                          _password.text,
                                          _email.text,
                                          withOtp,
                                          forgotPassword,context);
                                    } else {
                                      val = false;
                                    }
                                    if (val == false) {
                                      if (phoneAuthCheck == true) {
                                        if (isCheckFireBaseOTP ==
                                            true) {
                                          try {
                                            PhoneAuthCredential
                                            credential =
                                            PhoneAuthProvider
                                                .credential(
                                                verificationId:
                                                verId,
                                                smsCode: _otp
                                                    .text);
        
                                            // Sign the user in (or link) with the credential
                                            await FirebaseAuth
                                                .instance
                                                .signInWithCredential(
                                                credential);
        
                                            String? bearerrrrr =
                                            await FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .getIdToken();
        
                                            mobileVerified = true;
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder:
                                                        (context) =>
                                                    const AggreementPage()));
        
                                            values = 0;
                                          } on FirebaseAuthException catch (error) {
                                            if (error.code ==
                                                'invalid-verification-code') {
                                              setState(() {
                                                _otp.clear();
                                                // otpNumber = '';
                                                _error =
                                                'Please enter correct Otp or resend';
                                              });
                                            }
                                          }
                                        } else {
                                          var val =
                                          await validateSmsOtp(
                                              (signIn == 1)
                                                  ? _mobile.text
                                                  : _email.text,
                                              _otp.text);
                                          if (val == 'success') {
                                            //                                       var verify = await verifyUser(_email.text,0,'','');
                                            // navigate(verify);
                                            mobileVerified = true;
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder:
                                                        (context) =>
                                                    const AggreementPage()));
                                          } else {
                                            _error = val.toString();
                                          }
                                        }
                                      } else {
                                        mobileVerified = true;
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                const AggreementPage()));
                                      }
                                    } else {
                                      _error = val;
                                    }
                                  } else {
                                    // setState(() {
                                    _error = 'Please enter otp';
                                    // });
                                  }
                                }
                              }
                              setState(() {
                                loginLoading = false;
                              });
                            },
        
                            text: (signIn == 0)
                                ? (withOtp == false)
                                ? languages[choosenLanguage]
                            ['text_sign_in']
                                : (otpSent == true)
                                ? "Done"
                                : "Next"
                                : (otpSent == false &&
                                mobileVerified == false)
                                ? languages[choosenLanguage]
                            ['text_verify_mobile']
                                : languages[choosenLanguage]
                            ['text_confirm']),
        
        
                        // SizedBox(height: media.width*0.01,),
        
                        SizedBox(
                          height: media.width * 0.030,
                        ),
        
                      ],
                    )
                  ],
                ),
              ),
          ),
        ),
      ),
    );
  }


}

class ShapePainter extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    path.lineTo(0, size.height);
    path.quadraticBezierTo(size.width * 0.05, size.height * 0.9,
        size.width * 0.2, size.height * 0.9);
    path.lineTo(size.width * 0.8, size.height * 0.9);
    path.quadraticBezierTo(
        size.width * 0.95, size.height * 0.9, size.width, size.height * 0.8);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class ShapePainterBottom extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, size.height * 0.5);
    path.quadraticBezierTo(size.width * 0.95, size.height * 0.25,
        size.width * 0.8, size.height * 0.25);
    path.lineTo(size.width * 0.2, size.height * 0.25);
    path.quadraticBezierTo(size.width * 0.05, size.height * 0.25, 0, 0);
    path.lineTo(0, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class CustomTimerPainter extends CustomPainter {
  CustomTimerPainter({
    required this.animation,
    required this.backgroundColor,
    required this.color,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color backgroundColor, color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(CustomTimerPainter oldDelegate) {
    return animation.value != oldDelegate.animation.value ||
        color != oldDelegate.color ||
        backgroundColor != oldDelegate.backgroundColor;
  }
}
