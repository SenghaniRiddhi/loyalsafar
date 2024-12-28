// ignore_for_file: no_leading_underscores_for_local_identifiers, unrelated_type_equality_checks

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_user/functions/notifications.dart';
import 'package:flutter_user/pages/login/registerScreen.dart';
import 'package:flutter_user/translations/translation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../pages/NavigatorPages/editprofile.dart';
import '../pages/NavigatorPages/history.dart';
import '../pages/NavigatorPages/historydetails.dart';
import '../pages/loadingPage/loadingpage.dart';
import '../pages/login/login.dart';
import '../pages/onTripPage/booking_confirmation.dart';
import '../pages/onTripPage/map_page.dart';
import '../pages/onTripPage/review_page.dart';
import '../pages/referralcode/referral_code.dart';
import '../styles/styles.dart';

//languages code
dynamic phcode;
dynamic countyCode;
dynamic platform;
dynamic pref;
String isActive = '';
double duration = 30.0;
var audio = 'audio/notification_sound.mp3';
bool internet = true;
int waitingTime = 0;
String gender = '';
String packageName = 'com.loyalsafar';
String signKey = '';

//base url
//base url
String url =
    'https://loyalsafar.com/'; //add '/' at the end of the url as 'https://url.com/'
String mapkey =
    (platform == TargetPlatform.android) ? 'AIzaSyAxHr3V6Ts4omGvkxH28Ge-atsZOHQ6fXY' : 'AIzaSyAxHr3V6Ts4omGvkxH28Ge-atsZOHQ6fXY';

String mapType = 'google';

//check internet connection

checkInternetConnection() {
  Connectivity().onConnectivityChanged.listen((connectionState) {
    if (connectionState == ConnectivityResult.none) {
      internet = false;
      valueNotifierHome.incrementNotifier();
      valueNotifierBook.incrementNotifier();
    } else {
      internet = true;
      valueNotifierHome.incrementNotifier();
      valueNotifierBook.incrementNotifier();
    }
  });
}

Future<void> getAddressDetails({required double latitude,required double longitude ,
  required String addressLine,required String area,required String city ,  ValueNotifier<String>? cityNotifier }) async {
  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks[0];

      cityNotifier?.value = "${place.locality!+"," + place.country!}" ?? '';
        addressLine = place.street ?? ''; // Street name or detailed address
        area = place.subLocality ?? '';   // Area or neighborhood
        city = place.country!;

          // City name

      print('Address Line: $addressLine');
      print('Area: $area');
      print('City: $city');
    }
  } catch (e) {
    print('Error: $e');
  }
}

getDetailsOfDevice() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    internet = false;
  } else {
    internet = true;
  }
  try {
    darktheme();

    pref = await SharedPreferences.getInstance();
  } catch (e) {
    debugPrint(e.toString());
  }
}

darktheme() async {
  if (isDarkTheme == true) {
    page = Colors.black;
    textColor = Colors.white;
    buttonColor = Colors.white;
    loaderColor = Colors.white;
    hintColor = Colors.white.withOpacity(0.3);
  } else {
    page = Colors.white;
    textColor = Colors.black;
    buttonColor = theme;
    loaderColor = theme;
    hintColor = const Color(0xff12121D).withOpacity(0.3);
  }
  boxshadow = BoxShadow(
      blurRadius: 2, color: textColor.withOpacity(0.2), spreadRadius: 2);

  if (isDarkTheme == true) {
    await rootBundle.loadString('assets/dark.json').then((value) {
      mapStyle = value;
    });
  } else {
    await rootBundle.loadString('assets/map_style_black.json').then((value) {
      mapStyle = value;
    });
  }
  valueNotifierHome.incrementNotifier();
}

// dynamic timerLocation;
dynamic locationAllowed;

bool positionStreamStarted = false;
StreamSubscription<Position>? positionStream;

LocationSettings locationSettings = (platform == TargetPlatform.android)
    ? AndroidSettings(
  accuracy: LocationAccuracy.high,
  distanceFilter: 100,
)
    : AppleSettings(
  accuracy: LocationAccuracy.high,
  activityType: ActivityType.otherNavigation,
  distanceFilter: 100,
);

positionStreamData() {
  positionStream =
      Geolocator.getPositionStream(locationSettings: locationSettings)
          .handleError((error) {
        positionStream = null;
        positionStream?.cancel();
      }).listen((Position? position) {
        if (position != null) {
          currentLocation = LatLng(position.latitude, position.longitude);
        } else {
          positionStream!.cancel();
        }
      });
}

//validate email already exist

validateEmail(email) async {
  dynamic result;
  try {
    var response = await http.post(
        Uri.parse('${url}api/v1/user/validate-mobile'),
        body: (values == 0) ? {'mobile': email} : {'email': email});
    print("validate-mobile::- ${Uri.parse('${url}api/v1/user/validate-mobile')}  statusCode:- ${response.statusCode}");
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['success'] == true) {
        result = 'success';
      } else {
        debugPrint(response.body);
        result = languages[choosenLanguage]['text_email_already_taken'];
      }
    } else if (response.statusCode == 422) {
      debugPrint(response.body);
      var error = jsonDecode(response.body)['errors'];
      result = error[error.keys.toList()[0]]
          .toString()
          .replaceAll('[', '')
          .replaceAll(']', '')
          .toString();
    } else {
      debugPrint(response.body);
      result = jsonDecode(response.body)['message'];
    }
    return result;
  } catch (e) {
    if (e is SocketException) {
      internet = false;
    }
  }
}

//language code
var choosenLanguage = '';
var languageDirection = '';

List languagesCode = [
  {'name': 'Amharic', 'code': 'am'},
  {'name': 'Arabic', 'code': 'ar'},
  {'name': 'Basque', 'code': 'eu'},
  {'name': 'Bengali', 'code': 'bn'},
  {'name': 'English (UK)', 'code': 'en-GB'},
  {'name': 'Portuguese (Brazil)', 'code': 'pt-BR'},
  {'name': 'Bulgarian', 'code': 'bg'},
  {'name': 'Catalan', 'code': 'ca'},
  {'name': 'Cherokee', 'code': 'chr'},
  {'name': 'Croatian', 'code': 'hr'},
  {'name': 'Czech', 'code': 'cs'},
  {'name': 'Danish', 'code': 'da'},
  {'name': 'Dutch', 'code': 'nl'},
  {'name': 'English (US)', 'code': 'en'},
  {'name': 'Estonian', 'code': 'et'},
  {'name': 'Filipino', 'code': 'fil'},
  {'name': 'Finnish', 'code': 'fi'},
  {'name': 'French', 'code': 'fr'},
  {'name': 'German', 'code': 'de'},
  {'name': 'Greek', 'code': 'el'},
  {'name': 'Gujarati', 'code': 'gu'},
  {'name': 'Hebrew', 'code': 'iw'},
  {'name': 'Hindi', 'code': 'hi'},
  {'name': 'Hungarian', 'code': 'hu'},
  {'name': 'Icelandic', 'code': 'is'},
  {'name': 'Indonesian', 'code': 'id'},
  {'name': 'Italian', 'code': 'it'},
  {'name': 'Japanese', 'code': 'ja'},
  {'name': 'Kannada', 'code': 'kn'},
  {'name': 'Korean', 'code': 'ko'},
  {'name': 'Latvian', 'code': 'lv'},
  {'name': 'Lithuanian', 'code': 'lt'},
  {'name': 'Malay', 'code': 'ms'},
  {'name': 'Malayalam', 'code': 'ml'},
  {'name': 'Marathi', 'code': 'mr'},
  {'name': 'Norwegian', 'code': 'no'},
  {'name': 'Polish', 'code': 'pl'},
  {
    'name': 'Portuguese (Portugal)',
    'code': 'pt' //pt-PT
  },
  {'name': 'Romanian', 'code': 'ro'},
  {'name': 'Russian', 'code': 'ru'},
  {'name': 'Serbian', 'code': 'sr'},
  {
    'name': 'Chinese (PRC)',
    'code': 'zh' //zh-CN
  },
  {'name': 'Slovak', 'code': 'sk'},
  {'name': 'Slovenian', 'code': 'sl'},
  {'name': 'Spanish', 'code': 'es'},
  {'name': 'Swahili', 'code': 'sw'},
  {'name': 'Swedish', 'code': 'sv'},
  {'name': 'Tamil', 'code': 'ta'},
  {'name': 'Telugu', 'code': 'te'},
  {'name': 'Thai', 'code': 'th'},
  {'name': 'Chinese (Taiwan)', 'code': 'zh-TW'},
  {'name': 'Turkish', 'code': 'tr'},
  {'name': 'Urdu', 'code': 'ur'},
  {'name': 'Ukrainian', 'code': 'uk'},
  {'name': 'Vietnamese', 'code': 'vi'},
  {'name': 'Welsh', 'code': 'cy'},
];

//getting country code

List countries = [];
getCountryCode() async {
  dynamic result;
  try {
    final response = await http.get(Uri.parse('${url}api/v1/countries-new'));
    print("countries-new::- ${Uri.parse('${url}api/v1/countries-new')}  statusCode:- ${response.statusCode}");
    if (response.statusCode == 200) {
      countries = jsonDecode(response.body)['data']['countries']['data'];

      phcode =
      (countries.where((element) => element['default'] == true).isNotEmpty)
          ? countries.indexWhere((element) => element['default'] == true)
          : 0;
      result = 'success';
    } else {
      debugPrint(response.body);
      result = 'error';
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
      result = 'no internet';
    }
  }
  return result;
}

//login firebase

String userUid = '';
var verId = '';
int? resendTokenId;
bool phoneAuthCheck = false;
dynamic credentials;

phoneAuth(String phone) async {
  try {
    credentials = null;
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        credentials = credential;
        valueNotifierHome.incrementNotifier();
      },
      forceResendingToken: resendTokenId,
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          debugPrint('The provided phone number is not valid.');
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
        verId = verificationId;
        resendTokenId = resendToken;
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  } catch (e) {
    if (e is SocketException) {
      internet = false;
    }
  }
}

//get local bearer token

String lastNotification = '';
List recentSearchesList = [];

getLocalData() async {
  dynamic result;
  bearerToken.clear;
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    internet = false;
  } else {
    internet = true;
  }
  try {
    if (pref.containsKey('lastNotification')) {
      lastNotification = pref.getString('lastNotification');
    }
    if (pref.containsKey('autoAddress')) {
      var val = pref.getString('autoAddress');
      storedAutoAddress = jsonDecode(val);
    }
    if (pref.containsKey('outstationpush')) {
      outStationDriver = await loadListFromPrefs();
    }

    if (pref.containsKey('choosenLanguage')) {
      choosenLanguage = pref.getString('choosenLanguage');
      languageDirection = pref.getString('languageDirection');
      if (choosenLanguage.isNotEmpty) {
        if (pref.containsKey('Bearer')) {
          var tokens = pref.getString('Bearer');
          if (tokens != null) {
            bearerToken.add(BearerClass(type: 'Bearer', token: tokens));
            var responce = await getUserDetails();
            if (responce == true) {
              result = '3';
            } else {
              result = '2';
            }
          } else {
            result = '2';
          }
        } else {
          result = '2';
        }
      } else {
        result = '1';
      }
    } else {
      result = '1';
    }
    if (pref.containsKey('isDarkTheme')) {
      isDarkTheme = pref.getBool('isDarkTheme');
      if (isDarkTheme == true) {
        page = Colors.black;
        textColor = Colors.white;
        buttonColor = Colors.white;
        loaderColor = Colors.white;
        hintColor = Colors.white.withOpacity(0.3);
      } else {
        page = Colors.white;
        textColor = Colors.black;
        buttonColor = theme;
        loaderColor = theme;
        hintColor = const Color(0xff12121D).withOpacity(0.3);
      }
      boxshadow = BoxShadow(
          blurRadius: 2, color: textColor.withOpacity(0.2), spreadRadius: 2);
      if (isDarkTheme == true) {
        mapStyle = await rootBundle.loadString('assets/dark.json');
      } else {
        mapStyle = await rootBundle.loadString('assets/map_style_black.json');
      }
    }
    if (pref.containsKey('recentsearch')) {
      var val = pref.getString('recentsearch');
      recentSearchesList = jsonDecode(val);
      // print(';jhvhjvjkbkj');
      // printWrapped(jsonDecode(val).toString());
    }
  } catch (e) {
    if (e is SocketException) {
      result = 'no internet';
      internet = false;
    }
  }
  return result;
}

//register user

List<BearerClass> bearerToken = <BearerClass>[];

registerUser() async {
  bearerToken.clear();
  dynamic result;
  try {
    var token = await FirebaseMessaging.instance.getToken();
    var fcm = token.toString();
    final response =
    http.MultipartRequest('POST', Uri.parse('${url}api/v1/user/register'));

    response.headers.addAll({'Content-Type': 'application/json'});
    if (proImageFile1 != null) {
      response.files.add(
          await http.MultipartFile.fromPath('profile_picture', proImageFile1));
    }
    response.fields.addAll({
      "name": name,
      "mobile": phnumber,
      "email": email,
      "password": password,
      "device_token": fcm,
      "country": countries[phcode]['dial_code'],
      "login_by": (platform == TargetPlatform.android) ? 'android' : 'ios',
      'lang': choosenLanguage,
      'gender': (gender == 'male')
          ? 'male'
          : (gender == 'female')
          ? 'female'
          : 'others',
    });
    var request = await response.send();
    var respon = await http.Response.fromStream(request);
    // print(choosenLanguage.toString());
    print("countries-new::- ${Uri.parse('${url}api/v1/user/register')}  statusCode:- ${request.statusCode}");
    if (request.statusCode == 200) {
      var jsonVal = jsonDecode(respon.body);
      // if (ischeckownerordriver == 'driver') {
      //   platforms.invokeMethod('login');
      // }
      bearerToken.add(BearerClass(
          type: jsonVal['token_type'].toString(),
          token: jsonVal['access_token'].toString()));
      pref.setString('Bearer', bearerToken[0].token);
      await getUserDetails();
      if (platform == TargetPlatform.android && package != null) {
        await FirebaseDatabase.instance
            .ref()
            .update({'user_package_name': package.packageName.toString()});
      } else if (package != null) {
        await FirebaseDatabase.instance
            .ref()
            .update({'user_bundle_id': package.packageName.toString()});
      }
      result = 'true';
    } else if (respon.statusCode == 422) {
      debugPrint(respon.body);
      var error = jsonDecode(respon.body)['errors'];
      result = error[error.keys.toList()[0]]
          .toString()
          .replaceAll('[', '')
          .replaceAll(']', '')
          .toString();
    } else {
      debugPrint(respon.body);
      result = jsonDecode(respon.body)['message'];
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
      result = 'no internet';
    }
  }
  return result;
}

registerData({required String name ,required String lastName ,
  required String email ,required String mobile ,required String country}) async {
  bearerToken.clear();
  dynamic result;
  try {
    var token = await FirebaseMessaging.instance.getToken();
    var fcm = token.toString();
    final response =
    http.MultipartRequest('POST', Uri.parse('${url}api/v1/user/register'));

    response.headers.addAll({'Content-Type': 'application/json'});
    // if (proImageFile1 != null) {
    //   response.files.add(
    //       await http.MultipartFile.fromPath('profile_picture', proImageFile1));
    // }
    response.fields.addAll({
      "name": name,
      "last_name":lastName,
      "mobile": mobile,
      "email": email,
      // "password": password,
      "device_token": fcm,
      "country": countries[phcode]['dial_code'],
      "login_by": (platform == TargetPlatform.android) ? 'android' : 'ios',
      'lang': choosenLanguage,
      // 'gender': (gender == 'male')
      //     ? 'male'
      //     : (gender == 'female')
      //     ? 'female'
      //     : 'others',
    });
    var request = await response.send();
    var respon = await http.Response.fromStream(request);
    // print(choosenLanguage.toString());
    print("countries-new::- ${Uri.parse('${url}api/v1/user/register')}  statusCode:- ${request.statusCode}");
    if (request.statusCode == 200) {
      var jsonVal = jsonDecode(respon.body);
      // if (ischeckownerordriver == 'driver') {
      //   platforms.invokeMethod('login');
      // }
      bearerToken.add(BearerClass(
          type: jsonVal['token_type'].toString(),
          token: jsonVal['access_token'].toString()));
      pref.setString('Bearer', bearerToken[0].token);
      await getUserDetails();
      if (platform == TargetPlatform.android && package != null) {
        await FirebaseDatabase.instance
            .ref()
            .update({'user_package_name': package.packageName.toString()});
      } else if (package != null) {
        await FirebaseDatabase.instance
            .ref()
            .update({'user_bundle_id': package.packageName.toString()});
      }
      result = 'true';
    } else if (respon.statusCode == 422) {
      debugPrint(respon.body);
      var error = jsonDecode(respon.body)['errors'];
      result = error[error.keys.toList()[0]]
          .toString()
          .replaceAll('[', '')
          .replaceAll(']', '')
          .toString();
    } else {
      debugPrint(respon.body);
      result = jsonDecode(respon.body)['message'];
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
      result = 'no internet';
    }
  }
  return result;
}
//update referral code

updateReferral() async {
  dynamic result;
  try {
    var response =
    await http.post(Uri.parse('${url}api/v1/update/user/referral'),
        headers: {
          'Authorization': 'Bearer ${bearerToken[0].token}',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({"refferal_code": referralCode}));
    print("referral::- ${Uri.parse('${url}api/v1/update/user/referral')}  statusCode:- ${response.statusCode}");
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['success'] == true) {
        result = 'true';
      } else {
        debugPrint(response.body);
        result = 'false';
      }
    } else if (response.statusCode == 401) {
      result = 'logout';
    } else {
      debugPrint(response.body);
      result = 'false';
    }
    return result;
  } catch (e) {
    if (e is SocketException) {
      internet = false;
    }
  }
}

//call firebase otp

otpCall() async {
  dynamic result;
  try {
    var otp = await FirebaseDatabase.instance.ref().child('call_FB_OTP').get();
    print("otp call::- ${otp}");
    result = otp;
  } catch (e) {
    if (e is SocketException) {
      internet = false;
      result = 'no Internet';
      valueNotifierHome.incrementNotifier();
    }
  }
  return result;
}

// verify user already exist

verifyUser(String number, int login, String password, String email, isOtp,
    forgot,BuildContext context) async {
  dynamic val;
  try {
    var response = await http.post(
        Uri.parse('${url}api/v1/user/validate-mobile-for-login'),
        body: (number != '' && email != '')
            ? {"mobile": number, "email": email}
            : (login == 0)
            ? {
          "mobile": number,
        }
            : {
          "email": number,
        });

    print("validate-mobile-for-login::- ${Uri.parse('${url}api/v1/user/validate-mobile-for-login')} "
        " statusCode:- ${response.statusCode}");
    if (response.statusCode == 200) {
      val = jsonDecode(response.body)['success'];
      print("val::- ${val} ");
      if (val == true) {
        if ((number != '' && email != '') || forgot == true) {
          if (forgot == true) {
            val = true;
          } else if (jsonDecode(response.body)['message'] == 'email_exists') {
            val = 'Email Already Exists';
          } else if (jsonDecode(response.body)['message'] == 'mobile_exists') {
            val = 'Mobile Already Exists';
          } else {
            val = 'Email and Mobile Already Exists';
          }
        } else {
          var check = await userLogin(number, login, password, isOtp);
          if (check == true) {
            var uCheck = await getUserDetails();
            val = uCheck;
          } else {
            val = check;
          }
        }
      } else {
        val = false;
        Navigator.push(context,
            MaterialPageRoute(builder: (context)=>Registerscreen(countryCode: "",numbers: number,)));
        print("hello");
      }
    } else if (response.statusCode == 422) {
      debugPrint(response.body);
      var error = jsonDecode(response.body)['errors'];
      val = error[error.keys.toList()[0]]
          .toString()
          .replaceAll('[', '')
          .replaceAll(']', '')
          .toString();
    } else {
      debugPrint(response.body);
      val = jsonDecode(response.body)['message'];
    }
  } catch (e) {
    if (e is SocketException) {
      val = 'no internet';
      internet = false;
    }
  }
  return val;
}

acceptRequest(body) async {
  dynamic result;
  try {
    var response =
    await http.post(Uri.parse('${url}api/v1/request/respond-for-bid'),
        headers: {
          'Authorization': 'Bearer ${bearerToken[0].token}',
          'Content-Type': 'application/json',
        },
        body: body);
    print("respond-for-bid::- ${Uri.parse('${url}api/v1/request/respond-for-bid')} "
        " statusCode:- ${response.statusCode}");
    if (response.statusCode == 200) {
      ismulitipleride = true;
      await getUserDetails(id: userRequestData['id']);
      result = 'success';
    } else if (response.statusCode == 401) {
      result = 'logout';
    } else {
      debugPrint(response.body);
      valueNotifierBook.incrementNotifier();

      result = false;
    }
    return result;
  } catch (e) {
    if (e is SocketException) {
      internet = false;
    }
  }
}

updatePassword(email, password, loginby) async {
  dynamic result;

  try {
    var response =
    await http.post(Uri.parse('${url}api/v1/user/update-password'), body: {
      if (loginby == true) 'email': email,
      if (loginby == false) 'mobile': email,
      'password': password
    });

    print("update-password::- ${Uri.parse('${url}api/v1/user/update-password')} "
        " statusCode:- ${response.statusCode}");

    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['success'] == true) {
        result = true;
      } else {
        result = jsonDecode(response.body)['message'];
      }
    } else if (response.statusCode == 401) {
      result = 'logout';
    } else {
      debugPrint(response.body);
      result = false;
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
      result = 'no internet';
    }
  }
  return result;
}

//user login
userLogin(number, login, password, isOtp) async {
  bearerToken.clear();
  dynamic result;
  try {
    var token = await FirebaseMessaging.instance.getToken();
    var fcm = token.toString();
    var response = await http.post(Uri.parse('${url}api/v1/user/login'),
        headers: {
          'Content-Type': 'application/json',
        },

        body: (isOtp == false)
            ? jsonEncode({
          if (login == 0) "mobile": number,
          if (login == 1) "email": number,
          'password': password,
          'device_token': fcm,
          "login_by":
          (platform == TargetPlatform.android) ? 'android' : 'ios',
        })
            : (login == 0)
            ? jsonEncode({
          "mobile": number,
          'device_token': fcm,
          "login_by": (platform == TargetPlatform.android)
              ? 'android'
              : 'ios',
        })
            : jsonEncode({
          "email": number,
          "otp": password,
          'device_token': fcm,
          "login_by": (platform == TargetPlatform.android)
              ? 'android'
              : 'ios',
        }));
    print("login::- ${Uri.parse('${url}api/v1/user/login')} "
        " statusCode:- ${response.statusCode}");
    if (response.statusCode == 200) {
      var jsonVal = jsonDecode(response.body);
      bearerToken.add(BearerClass(
          type: jsonVal['token_type'].toString(),
          token: jsonVal['access_token'].toString()));
      result = true;
      pref.setString('Bearer', bearerToken[0].token);
      package = await PackageInfo.fromPlatform();
      if (platform == TargetPlatform.android && package != null) {
        await FirebaseDatabase.instance
            .ref()
            .update({'user_package_name': package.packageName.toString()});
      } else if (package != null) {
        await FirebaseDatabase.instance
            .ref()
            .update({'user_bundle_id': package.packageName.toString()});
      }
    } else if (response.statusCode == 422) {
      debugPrint(response.body);
      var error = jsonDecode(response.body)['errors'];
      result = error[error.keys.toList()[0]]
          .toString()
          .replaceAll('[', '')
          .replaceAll(']', '')
          .toString();
    } else {
      debugPrint(response.body);
      result = false;
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
      result = 'no internet';
    }
  }
  return result;
}

Map<String, dynamic> userDetails = {};
List favAddress = [];
List tripStops = [];
List banners = [];
bool ismulitipleride = false;
bool polyGot = false;
bool changeBound = false;
//user current state

getUserDetails({id}) async {
  dynamic result;
  try {
    var response = await http.get(
      (ismulitipleride)
          ? Uri.parse('${url}api/v1/user?current_ride=$id')
          : Uri.parse('${url}api/v1/user'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${bearerToken[0].token}'
      },
    );
    print("token::- ${bearerToken[0].token}");
    print("user::- ${Uri.parse('${url}api/v1/user')} "
        "statusCode:- ${response.statusCode}");
    print("current_ride::- ${Uri.parse('${url}api/v1/user?current_ride=$id')} "
        "statusCode:- ${response.statusCode}");

    if (response.statusCode == 200) {
      userDetails =
      Map<String, dynamic>.from(jsonDecode(response.body)['data']);

      favAddress = userDetails['favouriteLocations']['data'];
      sosData = userDetails['sos']['data'];
      if (mapType == '') {
        mapType = userDetails['map_type'];
      }
      if (outStationPushStream == null) {
        outStationPush();
      }
      if (userDetails['bannerImage']['data'].toString().startsWith('{')) {
        banners.clear();
        banners.add(userDetails['bannerImage']['data']);
      } else {
        banners = userDetails['bannerImage']['data'];
      }
      if (userDetails['onTripRequest'] != null) {
        addressList.clear();
        if (userRequestData.isEmpty ||
            userRequestData['accepted_at'] !=
                userDetails['onTripRequest']['data']['accepted_at']) {
          polyline.clear();
          fmpoly.clear();
        } else if (userRequestData.isEmpty ||
            userRequestData['is_driver_arrived'] !=
                userDetails['onTripRequest']['data']['is_driver_arrived']) {
          polyline.clear();
          fmpoly.clear();
        }

        userRequestData = userDetails['onTripRequest']['data'];
        if (userRequestData['is_driver_arrived'] == 1 && polyline.isEmpty) {
          polyGot = true;
          getPolylines('', '', '', '');
          changeBound = true;
        }
        if (userRequestData['transport_type'] == 'taxi') {
          choosenTransportType = 0;
        } else {
          choosenTransportType = 1;
        }
        tripStops =
        userDetails['onTripRequest']['data']['requestStops']['data'];
        addressList.add(AddressList(
            id: '1',
            type: 'pickup',
            address: userRequestData['pick_address'],
            latlng: LatLng(
                userRequestData['pick_lat'], userRequestData['pick_lng']),
            name: userRequestData['pickup_poc_name'],
            pickup: true,
            number: userRequestData['pickup_poc_mobile'],
            instructions: userRequestData['pickup_poc_instruction']));
        if (tripStops.isNotEmpty) {
          for (var i = 0; i < tripStops.length; i++) {
            addressList.add(AddressList(
                id: (i + 2).toString(),
                type: 'drop',
                pickup: false,
                address: tripStops[i]['address'],
                latlng:
                LatLng(tripStops[i]['latitude'], tripStops[i]['longitude']),
                name: tripStops[i]['poc_name'],
                number: tripStops[i]['poc_mobile'],
                instructions: tripStops[i]['poc_instruction']));
          }
        } else if (userDetails['onTripRequest']['data']['is_rental'] != true &&
            userRequestData['drop_lat'] != null) {
          addressList.add(AddressList(
              id: '2',
              type: 'drop',
              pickup: false,
              address: userRequestData['drop_address'],
              latlng: LatLng(
                  userRequestData['drop_lat'], userRequestData['drop_lng']),
              name: userRequestData['drop_poc_name'],
              number: userRequestData['drop_poc_mobile'],
              instructions: userRequestData['drop_poc_instruction']));
        }
        // if (userRequestData['accepted_at'] != null) {
        //   getCurrentMessages();
        // }
        if (userRequestData.isNotEmpty) {
          if (rideStreamUpdate == null ||
              rideStreamUpdate?.isPaused == true ||
              rideStreamStart == null ||
              rideStreamStart?.isPaused == true) {
            streamRide();
          }
        } else {
          if (rideStreamUpdate != null ||
              rideStreamUpdate?.isPaused == false ||
              rideStreamStart != null ||
              rideStreamStart?.isPaused == false) {
            rideStreamUpdate?.cancel();
            rideStreamUpdate = null;
            rideStreamStart?.cancel();
            rideStreamStart = null;
          }
        }
        valueNotifierHome.incrementNotifier();
        valueNotifierBook.incrementNotifier();
      } else if (userDetails['metaRequest'] != null) {
        addressList.clear();
        userRequestData = userDetails['metaRequest']['data'];
        tripStops = userDetails['metaRequest']['data']['requestStops']['data'];
        addressList.add(AddressList(
            id: '1',
            type: 'pickup',
            address: userRequestData['pick_address'],
            pickup: true,
            latlng: LatLng(
                userRequestData['pick_lat'], userRequestData['pick_lng']),
            name: userRequestData['pickup_poc_name'],
            number: userRequestData['pickup_poc_mobile'],
            instructions: userRequestData['pickup_poc_instruction']));

        if (tripStops.isNotEmpty) {
          for (var i = 0; i < tripStops.length; i++) {
            addressList.add(AddressList(
                id: (i + 2).toString(),
                type: 'drop',
                pickup: false,
                address: tripStops[i]['address'],
                latlng:
                LatLng(tripStops[i]['latitude'], tripStops[i]['longitude']),
                name: tripStops[i]['poc_name'],
                number: tripStops[i]['poc_mobile'],
                instructions: tripStops[i]['poc_instruction']));
          }
        } else if (userDetails['metaRequest']['data']['is_rental'] != true &&
            userRequestData['drop_lat'] != null) {
          addressList.add(AddressList(
              id: '2',
              type: 'drop',
              address: userRequestData['drop_address'],
              pickup: false,
              latlng: LatLng(
                  userRequestData['drop_lat'], userRequestData['drop_lng']),
              name: userRequestData['drop_poc_name'],
              number: userRequestData['drop_poc_mobile'],
              instructions: userRequestData['drop_poc_instruction']));
        }
        if (polyline.isEmpty) {
          polyGot = true;
          getPolylines('', '', '', '');
          changeBound = true;
        }

        if (userRequestData['transport_type'] == 'taxi') {
          choosenTransportType = 0;
        } else {
          choosenTransportType = 1;
        }

        if (requestStreamStart == null ||
            requestStreamStart?.isPaused == true ||
            requestStreamEnd == null ||
            requestStreamEnd?.isPaused == true) {
          streamRequest();
        }
        valueNotifierHome.incrementNotifier();
        valueNotifierBook.incrementNotifier();
      } else {
        chatList.clear();
        if (userRequestData.isNotEmpty) {
          polyline.clear();
          fmpoly.clear();
        }
        userRequestData = {};

        requestStreamStart?.cancel();
        requestStreamEnd?.cancel();
        rideStreamUpdate?.cancel();
        rideStreamStart?.cancel();
        requestStreamEnd = null;
        requestStreamStart = null;
        rideStreamUpdate = null;
        rideStreamStart = null;
        valueNotifierHome.incrementNotifier();
        valueNotifierBook.incrementNotifier();
      }
      if (userDetails['active'] == false) {
        isActive = 'false';
      } else {
        isActive = 'true';
      }
      result = true;
    } else if (response.statusCode == 401) {
      result = 'logout';
    } else {
      debugPrint(response.body);
      result = false;
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
    }
  }
  return result;
}

class BearerClass {
  final String type;
  final String token;
  BearerClass({required this.type, required this.token});

  BearerClass.fromJson(Map<String, dynamic> json)
      : type = json['type'],
        token = json['token'];

  Map<String, dynamic> toJson() => {'type': type, 'token': token};
}

Map<String, dynamic> driverReq = {};

class ValueNotifying {
  ValueNotifier value = ValueNotifier(0);

  void incrementNotifier() {
    value.value++;
  }
}

ValueNotifying valueNotifier = ValueNotifying();

class ValueNotifyingHome {
  ValueNotifier value = ValueNotifier(0);

  void incrementNotifier() {
    value.value++;
  }
}

class ValueNotifyingChat {
  ValueNotifier value = ValueNotifier(0);

  void incrementNotifier() {
    value.value++;
  }
}

class ValueNotifyingKey {
  ValueNotifier value = ValueNotifier(0);

  void incrementNotifier() {
    value.value++;
  }
}

class ValueNotifyingNotification {
  ValueNotifier value = ValueNotifier(0);

  void incrementNotifier() {
    value.value++;
  }
}

class ValueNotifyingLogin {
  ValueNotifier value = ValueNotifier(0);

  void incrementNotifier() {
    value.value++;
  }
}

ValueNotifyingHome valueNotifierHome = ValueNotifyingHome();
ValueNotifyingChat valueNotifierChat = ValueNotifyingChat();
ValueNotifyingKey valueNotifierKey = ValueNotifyingKey();
ValueNotifyingNotification valueNotifierNotification =
ValueNotifyingNotification();
ValueNotifyingLogin valueNotifierLogin = ValueNotifyingLogin();
ValueNotifyingTimer valueNotifierTimer = ValueNotifyingTimer();

class ValueNotifyingTimer {
  ValueNotifier value = ValueNotifier(0);

  void incrementNotifier() {
    value.value++;
  }
}

class ValueNotifyingBook {
  ValueNotifier value = ValueNotifier(0);

  void incrementNotifier() {
    value.value++;
  }
}

ValueNotifyingBook valueNotifierBook = ValueNotifyingBook();

//sound
AudioCache audioPlayer = AudioCache();
AudioPlayer audioPlayers = AudioPlayer();

//get reverse geo coding

var pickupAddress = '';
var dropAddress = '';

geoCoding(double lat, double lng) async {
  dynamic result;
  try {
    http.Response val;

    if (mapType == 'google') {
      if (Platform.isAndroid) {
        val = await http.get(
            Uri.parse(
                'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$mapkey'),
            headers: {
              'X-Android-Package': packageName,
              'X-Android-Cert': signKey
            });
      } else {
        val = await http.get(
            Uri.parse(
                'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$mapkey'),
            headers: {'X-IOS-Bundle-Identifier': packageName});
      }
    } else {
      val = await http.get(
        Uri.parse(
            'https://nominatim.openstreetmap.org/reverse?lat=$lat&lon=$lng&format=json'),
      );
    }
    print("geocode::- ${Uri.parse('https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$mapkey')}"
        "statusCode:- ${val.statusCode}");
    if (val.statusCode == 200) {
      if (mapType == 'google') {
        result = jsonDecode(val.body)['results'][0]['formatted_address'];
      } else {
        result = jsonDecode(val.body)['display_name'].toString();
      }
      return result;
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
      result = 'no internet';
    }
  }
  return result;
}
//contact us
ContactUsData({required String subject ,required String email ,
  required String des ,required String? files,required BuildContext context}) async {
  dynamic result;
  try {

    final request = http.MultipartRequest('POST', Uri.parse('${url}api/v1/contact-us/store'));
    request.fields['subject'] = subject;
     request.fields['email'] = email;
     request.fields['description'] = des;

    if (files != null) {
      request.files.add(await http.MultipartFile.fromPath('file', files));
    }

    final response = await request.send();

    print("contact-us ${Uri.parse('${url}api/v1/contact-us/store')}"
        " statusCode:- ${response.statusCode}");
    final responseBody = await response.stream.bytesToString();
    final decodedResponse = jsonDecode(responseBody);
    if (response.statusCode == 200) {
      if (decodedResponse['success'] == true) {
       print("success data ${decodedResponse['data  ']}");
        result = 'success';
        Navigator.pop(context);
      } else {
        debugPrint("Failed response: $responseBody");
        result = 'failed';
      }
    } else if (response.statusCode == 401) {
      result = 'logout';
    } else if (response.statusCode == 422) {
      debugPrint("Failed response: $responseBody");
      var error = decodedResponse['errors'];
      result = error[error.keys.toList()[0]]
          .toString()
          .replaceAll('[', '')
          .replaceAll(']', '')
          .toString();
    } else {
      debugPrint("else response: $responseBody");
      result = decodedResponse['message'];
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
      result = 'no internet';
    }
  }
  return result;
}

//lang
getlangid() async {
  dynamic result;
  try {
    var response =
    await http.post(Uri.parse('${url}api/v1/user/update-my-lang'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${bearerToken[0].token}',
        },
        body: jsonEncode({"lang": choosenLanguage}));
    print("update-my-lang::- ${Uri.parse('${url}api/v1/user/update-my-lang')}"
        "statusCode:- ${response.statusCode}");
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['success'] == true) {
        result = 'success';
      } else {
        debugPrint(response.body);
        result = 'failed';
      }
    } else if (response.statusCode == 401) {
      result = 'logout';
    } else if (response.statusCode == 422) {
      debugPrint(response.body);
      var error = jsonDecode(response.body)['errors'];
      result = error[error.keys.toList()[0]]
          .toString()
          .replaceAll('[', '')
          .replaceAll(']', '')
          .toString();
    } else {
      debugPrint(response.body);
      result = jsonDecode(response.body)['message'];
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
      result = 'no internet';
    }
  }
  return result;
}

//get address auto fill data
List storedAutoAddress = [];
List addAutoFill = [];

getAutocomplete(input, sessionToken, lat, lng) async {
  try {
    addAutoFill.clear();
    if (mapType == 'google') {
      http.Response val;
      if (Platform.isAndroid) {
        val = await http.get(
            Uri.parse(
                'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$mapkey&location=$lat%2C$lng&radius=10000&sessionToken=$sessionToken'),
            headers: {
              'X-Android-Package': packageName,
              'X-Android-Cert': signKey
            });
      } else {
        val = await http.get(
            Uri.parse(
                'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$mapkey&location=$lat%2C$lng&radius=10000&sessionToken=$sessionToken'),
            headers: {'X-IOS-Bundle-Identifier': packageName});
      }
      print("getAutocomplete::- ${Uri.parse(
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$mapkey&location=$lat%2C$lng&radius=10000&sessionToken=$sessionToken')}"
          "statusCode:- ${val.statusCode}");

      if (val.statusCode == 200) {
        var result = jsonDecode(val.body);
        for (var element in result['predictions']) {
          addAutoFill.add({
            'place': element['place_id'],
            'description': element['description'],
            'lat': '',
            'lon': ''
          });
          if (storedAutoAddress
              .where((element) => element['place'] == element['place_id'])
              .isEmpty) {
            storedAutoAddress.add({
              'place': element['place_id'],
              'description': element['description'],
              'lat': '',
              'lon': ''
            });
          }
        }
      }

      pref.setString('autoAddress', jsonEncode(storedAutoAddress).toString());
    } else {
      var result = await http.get(Uri.parse(
          'https://nominatim.openstreetmap.org/search?q=$input&format=json'));
      for (var element in jsonDecode(result.body)) {
        addAutoFill.add({
          'place': element['place_id'],
          'description': element['display_name'],
          'secondary': '',
          'lat': element['lat'],
          'lon': element['lon']
        });
      }
    }
    valueNotifierHome.incrementNotifier();
  } catch (e) {
    if (e is SocketException) {
      internet = false;
    }
  }
}

geoCodingForLatLng(id, sessionToken) async {
  try {
    http.Response val;
    if (Platform.isAndroid) {
      val = await http.get(
          Uri.parse(
              'https://maps.googleapis.com/maps/api/place/details/json?placeid=$id&key=$mapkey&sessionToken=$sessionToken'),
          headers: {
            'X-Android-Package': packageName,
            'X-Android-Cert': signKey
          });
    } else {
      val = await http.get(
          Uri.parse(
              'https://maps.googleapis.com/maps/api/place/details/json?placeid=$id&key=$mapkey&sessionToken=$sessionToken'),
          headers: {'X-IOS-Bundle-Identifier': packageName});
    }
    print("geoCodingForLatLng::- ${Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?placeid=$id&key=$mapkey&sessionToken=$sessionToken')}"
        "statusCode:- ${val.statusCode}");

    if (val.statusCode == 200) {
      var result = jsonDecode(val.body)['result']['geometry']['location'];
      return result;
    }
  } catch (e) {
    debugPrint(e.toString());
  }
}

//pickup drop address list

class AddressList {
  String address;
  LatLng latlng;
  String id;
  dynamic type;
  dynamic name;
  dynamic number;
  dynamic instructions;
  bool pickup;

  AddressList(
      {required this.id,
        required this.address,
        required this.latlng,
        required this.pickup,
        this.type,
        this.name,
        this.number,
        this.instructions});

  toJson() {}
}

//get polylines
String polyString = '';
List<LatLng> polyList = [];

getPolylines(plat, plng, dlat, dlng) async {
  polyList.clear();
  String pickLat = '';
  String pickLng = '';
  String dropLat = '';

  String dropLng = '';
  if (plat == '' && dlat == '') {
    if (userRequestData.isEmpty ||
        userRequestData['poly_line'] == null ||
        userRequestData['poly_line'] == '') {
      for (var i = 1; i < addressList.length; i++) {
        pickLat = addressList[i - 1].latlng.latitude.toString();
        pickLng = addressList[i - 1].latlng.longitude.toString();
        dropLat = addressList[i].latlng.latitude.toString();
        dropLng = addressList[i].latlng.longitude.toString();
        try {
          http.Response value;

          if (Platform.isAndroid) {
            value = await http.get(
                Uri.parse(
                    'https://maps.googleapis.com/maps/api/directions/json?origin=$pickLat%2C$pickLng&destination=$dropLat%2C$dropLng&avoid=ferries|indoor&alternatives=true&mode=driving&key=$mapkey'),
                headers: {
                  'X-Android-Package': packageName,
                  'X-Android-Cert': signKey
                });
          } else {
            value = await http.get(
                Uri.parse(
                    'https://maps.googleapis.com/maps/api/directions/json?origin=$pickLat%2C$pickLng&destination=$dropLat%2C$dropLng&avoid=ferries|indoor&alternatives=true&mode=driving&key=$mapkey'),
                headers: {'X-IOS-Bundle-Identifier': packageName});
          }

          print("getPolylines::- ${Uri.parse(
              'https://maps.googleapis.com/maps/api/directions/json?origin=$pickLat%2C$pickLng&destination=$dropLat%2C$dropLng&avoid=ferries|indoor&alternatives=true&mode=driving&key=$mapkey')}"
              "statusCode:- ${value.statusCode}");
          if (value.statusCode == 200) {
            var steps = jsonDecode(value.body)['routes'][0]['overview_polyline']
            ['points'];

            if (i == 1) {
              polyString = steps;
            } else {
              polyString = '${polyString}poly$steps';
            }
            // printWrapped(jsonEncode(polyString2));

            decodeEncodedPolyline(steps);
          }
        } catch (e) {
          if (e is SocketException) {
            internet = false;
          }
        }
      }
    } else {
      List poly = userRequestData['poly_line'].toString().split('poly');
      for (var i = 0; i < poly.length; i++) {
        decodeEncodedPolyline(poly[i]);
      }
    }
  } else {
    try {
      http.Response value;

      if (Platform.isAndroid) {
        value = await http.get(
            Uri.parse(
                'https://maps.googleapis.com/maps/api/directions/json?origin=$plat%2C$plng&destination=$dlat%2C$dlng&avoid=ferries|indoor&alternatives=true&mode=driving&key=$mapkey'),
            headers: {
              'X-Android-Package': packageName,
              'X-Android-Cert': signKey
            });
      } else {
        value = await http.get(
            Uri.parse(
                'https://maps.googleapis.com/maps/api/directions/json?origin=$plat%2C$plng&destination=$dlat%2C$dlng&avoid=ferries|indoor&alternatives=true&mode=driving&key=$mapkey'),
            headers: {'X-IOS-Bundle-Identifier': packageName});
      }
      if (value.statusCode == 200) {
        var steps =
        jsonDecode(value.body)['routes'][0]['overview_polyline']['points'];

        // printWrapped(steps.toString());
        polyString = steps;
        decodeEncodedPolyline(steps);
      } else {}
    } catch (e) {
      if (e is SocketException) {
        internet = false;
      }
    }
  }
  polyGot = false;
  return polyList;
}

class RouteInfo {
  final int distance;
  final String summary;
  final List steps;

  RouteInfo({
    required this.distance,
    required this.summary,
    required this.steps,
  });
}

//polyline decode

Set<Polyline> polyline = {};

List<PointLatLng> decodeEncodedPolyline(String encoded) {
  List<PointLatLng> poly = [];
  int index = 0, len = encoded.length;
  int lat = 0, lng = 0;
  polyline.clear();

  while (index < len) {
    int b, shift = 0, result = 0;
    do {
      b = encoded.codeUnitAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);
    int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
    lat += dlat;

    shift = 0;
    result = 0;
    do {
      b = encoded.codeUnitAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);
    int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
    lng += dlng;
    LatLng p = LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble());
    polyList.add(p);
  }
  // print(polyList.toString());

  polyline.add(
    Polyline(
        polylineId: const PolylineId('1'),
        color: Colors.blue,
        visible: true,
        width: 4,
        points: polyList),
  );

  valueNotifierBook.incrementNotifier();
  return poly;
}

class PointLatLng {
  /// Creates a geographical location specified in degrees [latitude] and
  /// [longitude].
  ///
  const PointLatLng(double latitude, double longitude)
  // ignore: unnecessary_null_comparison
      : assert(latitude != null),
  // ignore: unnecessary_null_comparison
        assert(longitude != null),
  // ignore: unnecessary_this, prefer_initializing_formals
        this.latitude = latitude,
  // ignore: unnecessary_this, prefer_initializing_formals
        this.longitude = longitude;

  /// The latitude in degrees.
  final double latitude;

  /// The longitude in degrees
  final double longitude;

  @override
  String toString() {
    return "lat: $latitude / longitude: $longitude";
  }
}

//get goods list
List goodsTypeList = [];

getGoodsList() async {
  dynamic result;
  goodsTypeList.clear();
  try {
    var response = await http.get(Uri.parse('${url}api/v1/common/goods-types'));
    print("goods-types::- ${Uri.parse('${url}api/v1/common/goods-types')}"
        "statusCode:- ${response.statusCode}");
    if (response.statusCode == 200) {
      goodsTypeList = jsonDecode(response.body)['data'];
      valueNotifierBook.incrementNotifier();
      result = 'success';
    } else {
      debugPrint(response.body);
      result = 'false';
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
      result = 'no internet';
    }
  }
  return result;
}

//drop stops list
List<DropStops> dropStopList = <DropStops>[];

class DropStops {
  String order;
  double latitude;
  double longitude;
  String? pocName;
  String? pocNumber;
  dynamic pocInstruction;
  String address;

  DropStops(
      {required this.order,
        required this.latitude,
        required this.longitude,
        this.pocName,
        this.pocNumber,
        this.pocInstruction,
        required this.address});

  Map<String, dynamic> toJson() => {
    'order': order,
    'latitude': latitude,
    'longitude': longitude,
    'poc_name': pocName,
    'poc_mobile': pocNumber,
    'poc_instruction': pocInstruction,
    'address': address,
  };
}

List etaDetails = [];

//eta request

etaRequest({transport, outstation}) async {
  etaDetails.clear();
  dynamic result;
  try {
    var response = await http.post(Uri.parse('${url}api/v1/request/eta'),
        headers: {
          'Authorization': 'Bearer ${bearerToken[0].token}',
          'Content-Type': 'application/json',
        },
        body: (addressList
            .where((element) => element.type == 'drop')
            .isNotEmpty &&
            dropStopList.isEmpty)
            ? jsonEncode({
          'pick_lat': (userRequestData.isNotEmpty)
              ? userRequestData['pick_lat']
              : addressList
              .firstWhere((e) => e.type == 'pickup')
              .latlng
              .latitude,
          'pick_lng': (userRequestData.isNotEmpty)
              ? userRequestData['pick_lng']
              : addressList
              .firstWhere((e) => e.type == 'pickup')
              .latlng
              .longitude,
          'drop_lat': (userRequestData.isNotEmpty)
              ? userRequestData['drop_lat']
              : addressList
              .lastWhere((e) => e.type == 'drop')
              .latlng
              .latitude,
          'drop_lng': (userRequestData.isNotEmpty)
              ? userRequestData['drop_lng']
              : addressList
              .lastWhere((e) => e.type == 'drop')
              .latlng
              .longitude,
          'ride_type': 1,
          'transport_type': (transport == null)
              ? (choosenTransportType == 0)
              ? 'taxi'
              : 'delivery'
              : transport,
          'is_outstation': outstation
        })
            : (dropStopList.isNotEmpty &&
            addressList
                .where((element) => element.type == 'drop')
                .isNotEmpty)
            ? jsonEncode({
          'pick_lat': (userRequestData.isNotEmpty)
              ? userRequestData['pick_lat']
              : addressList
              .firstWhere((e) => e.type == 'pickup')
              .latlng
              .latitude,
          'pick_lng': (userRequestData.isNotEmpty)
              ? userRequestData['pick_lng']
              : addressList
              .firstWhere((e) => e.type == 'pickup')
              .latlng
              .longitude,
          'drop_lat': (userRequestData.isNotEmpty)
              ? userRequestData['drop_lat']
              : addressList
              .lastWhere((e) => e.type == 'drop')
              .latlng
              .latitude,
          'drop_lng': (userRequestData.isNotEmpty)
              ? userRequestData['drop_lng']
              : addressList
              .lastWhere((e) => e.type == 'drop')
              .latlng
              .longitude,
          'stops': jsonEncode(dropStopList),
          'ride_type': 1,
          'transport_type':
          (choosenTransportType == 0) ? 'taxi' : 'delivery',
          'is_outstation': outstation
        })
            : jsonEncode({
          'pick_lat': (userRequestData.isNotEmpty)
              ? userRequestData['pick_lat']
              : addressList
              .firstWhere((e) => e.type == 'pickup')
              .latlng
              .latitude,
          'pick_lng': (userRequestData.isNotEmpty)
              ? userRequestData['pick_lng']
              : addressList
              .firstWhere((e) => e.type == 'pickup')
              .latlng
              .longitude,
          'ride_type': 1,
          'transport_type':
          (choosenTransportType == 0) ? 'taxi' : 'delivery',
          'is_outstation': outstation
        }));

    print("token::- ${bearerToken[0].token}");
    print("drop::- ${addressList
        .where((element) => element.type == 'drop')
        .isNotEmpty} dropStopList::- ${dropStopList.isEmpty}");

    print("is_outstation:${outstation}  ride_type:${1}  transport_type:${transport == null}  ${choosenTransportType == 0}");

    print("userRequestData.isNotEmpty ${userRequestData.isNotEmpty}");
    print("pick_lat:${addressList
        .firstWhere((e) => e.type == 'pickup')
        .latlng
        .latitude}  pick_lng:${addressList
        .firstWhere((e) => e.type == 'pickup')
        .latlng
        .longitude}");
    print("drop_lat: ${addressList
        .lastWhere((e) => e.type == 'drop')
        .latlng
        .latitude}  drop_lng: ${addressList
        .lastWhere((e) => e.type == 'drop')
        .latlng
        .longitude}");
    print("eta::- ${Uri.parse('${url}api/v1/request/eta')}"
        " statusCode:- ${response.statusCode}");
    if (response.statusCode == 200) {
      etaDetails = jsonDecode(response.body)['data'];
      choosenVehicle = (etaDetails
          .where((element) => element['is_default'] == true)
          .isNotEmpty)
          ? etaDetails.indexWhere((element) => element['is_default'] == true)
          : 0;
      result = true;
      valueNotifierBook.incrementNotifier();
      valueNotifierHome.incrementNotifier();
    } else if (response.statusCode == 401) {
      result = 'logout';
    } else {
      debugPrint(response.body);
      if (jsonDecode(response.body)['message'] ==
          "service not available with this location") {
        serviceNotAvailable = true;
      }
      result = false;
    }
    return result;
  } catch (e) {
    if (e is SocketException) {
      internet = false;
    }
  }
}

etaRequestWithPromo({outstation}) async {
  dynamic result;
  // etaDetails.clear();
  try {
    var response = await http.post(Uri.parse('${url}api/v1/request/eta'),
        headers: {
          'Authorization': 'Bearer ${bearerToken[0].token}',
          'Content-Type': 'application/json',
        },
        body: (addressList
            .where((element) => element.type == 'drop')
            .isNotEmpty &&
            dropStopList.isEmpty)
            ? jsonEncode({
          'pick_lat': addressList
              .firstWhere((e) => e.type == 'pickup')
              .latlng
              .latitude,
          'pick_lng': addressList
              .firstWhere((e) => e.type == 'pickup')
              .latlng
              .longitude,
          'drop_lat': addressList
              .firstWhere((e) => e.type == 'drop')
              .latlng
              .latitude,
          'drop_lng': addressList
              .firstWhere((e) => e.type == 'drop')
              .latlng
              .longitude,
          'ride_type': 1,
          'promo_code': promoCode,
          'transport_type':
          (choosenTransportType == 0) ? 'taxi' : 'delivery',
          'is_outstation': outstation
        })
            : (dropStopList.isNotEmpty &&
            addressList
                .where((element) => element.type == 'drop')
                .isNotEmpty)
            ? jsonEncode({
          'pick_lat': addressList
              .firstWhere((e) => e.type == 'pickup')
              .latlng
              .latitude,
          'pick_lng': addressList
              .firstWhere((e) => e.type == 'pickup')
              .latlng
              .longitude,
          'drop_lat': addressList
              .firstWhere((e) => e.type == 'drop')
              .latlng
              .latitude,
          'drop_lng': addressList
              .firstWhere((e) => e.type == 'drop')
              .latlng
              .longitude,
          'stops': jsonEncode(dropStopList),
          'ride_type': 1,
          'promo_code': promoCode,
          'transport_type':
          (choosenTransportType == 0) ? 'taxi' : 'delivery',
          'is_outstation': outstation
        })
            : jsonEncode({
          'pick_lat': addressList
              .firstWhere((e) => e.type == 'pickup')
              .latlng
              .latitude,
          'pick_lng': addressList
              .firstWhere((e) => e.type == 'pickup')
              .latlng
              .longitude,
          'ride_type': 1,
          'promo_code': promoCode,
          'transport_type':
          (choosenTransportType == 0) ? 'taxi' : 'delivery',
          'is_outstation': outstation
        }));
    print("etaRequestWithPromo::- ${Uri.parse('${url}api/v1/request/eta')}"
        "statusCode:- ${response.statusCode}");
    if (response.statusCode == 200) {
      etaDetails = jsonDecode(response.body)['data'];
      promoCode = '';
      promoStatus = 1;
      valueNotifierBook.incrementNotifier();
    } else if (response.statusCode == 401) {
      result = 'logout';
    } else {
      debugPrint(response.body);
      promoStatus = 2;
      // promoCode = '';
      couponerror = true;
      valueNotifierBook.incrementNotifier();

      result = false;
    }
    return result;
  } catch (e) {
    if (e is SocketException) {
      internet = false;
    }
  }
}

//rental eta request

rentalEta() async {
  dynamic result;
  try {
    var response =
    await http.post(Uri.parse('${url}api/v1/request/list-packages'),
        headers: {
          'Authorization': 'Bearer ${bearerToken[0].token}',
          'Content-Type': 'application/json',
        },

        body: jsonEncode({
          'pick_lat': (userRequestData.isNotEmpty)
              ? userRequestData['pick_lat']
              : addressList
              .firstWhere((e) => e.type == 'pickup')
              .latlng
              .latitude,
          'pick_lng': (userRequestData.isNotEmpty)
              ? userRequestData['pick_lng']
              : addressList
              .firstWhere((e) => e.type == 'pickup')
              .latlng
              .longitude,
          'transport_type':
          (choosenTransportType == 0) ? 'taxi' : 'delivery'
        }));

    print("token::- ${bearerToken[0].token}");
    print("userRequestData.isNotEmpty ${userRequestData.isNotEmpty}  transport_type:${(choosenTransportType == 0)}");
    print("pick_lat: ${addressList
        .firstWhere((e) => e.type == 'pickup')
        .latlng
        .latitude} pick_lng:${addressList
        .firstWhere((e) => e.type == 'pickup')
        .latlng
        .longitude}");
    print("list-packages::- ${Uri.parse('${url}api/v1/request/list-packages')}"
        " statusCode:- ${response.statusCode}");
    if (response.statusCode == 200) {
      etaDetails = jsonDecode(response.body)['data'];
      rentalOption = etaDetails[0]['typesWithPrice']['data'];
      rentalChoosenOption = 0;
      choosenVehicle = 0;
      result = true;
      valueNotifierBook.incrementNotifier();
      // printWrapped('rental eta ' + response.body);
    } else if (response.statusCode == 401) {
      result = 'logout';
    } else {
      result = false;
    }
    return result;
  } catch (e) {
    if (e is SocketException) {
      internet = false;
    }
  }
}

bool couponerror = false;
rentalRequestWithPromo() async {
  dynamic result;
  try {
    var response = await http.post(
        Uri.parse('${url}api/v1/request/list-packages'),
        headers: {
          'Authorization': 'Bearer ${bearerToken[0].token}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'pick_lat':
          addressList.firstWhere((e) => e.type == 'pickup').latlng.latitude,
          'pick_lng': addressList
              .firstWhere((e) => e.type == 'pickup')
              .latlng
              .longitude,
          'ride_type': 1,
          'promo_code': promoCode,
          'transport_type': (choosenTransportType == 0) ? 'taxi' : 'delivery'
        }));

    print("rentalRequestWithPromo::- ${Uri.parse('${url}api/v1/request/list-packages')}"
        "statusCode:- ${response.statusCode}");
    if (response.statusCode == 200) {
      etaDetails = jsonDecode(response.body)['data'];
      rentalOption = etaDetails[0]['typesWithPrice']['data'];
      rentalChoosenOption = 0;
      promoCode = '';
      promoStatus = 1;
      valueNotifierBook.incrementNotifier();
    } else if (response.statusCode == 401) {
      result = 'logout';
    } else {
      debugPrint(response.body);
      promoStatus = 2;
      couponerror = true;
      // promoCode = '';
      valueNotifierBook.incrementNotifier();

      result = false;
    }
    return result;
  } catch (e) {
    if (e is SocketException) {
      internet = false;
    }
  }
}

//calculate distance

calculateDistance(lat1, lon1, lat2, lon2) {
  var p = 0.017453292519943295;
  var a = 0.5 -
      cos((lat2 - lat1) * p) / 2 +
      cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
  var val = (12742 * asin(sqrt(a))) * 1000;
  return val;
}

Map<String, dynamic> userRequestData = {};

//create request
String tripError = '';
createRequest(value, api) async {
  waitingTime = 0;
  dynamic result;
  try {
    var response = await http.post(Uri.parse('$url$api'),
        headers: {
          'Authorization': 'Bearer ${bearerToken[0].token}',
          'Content-Type': 'application/json',
        },
        body: value);
    print("body::- ${value}");
    print("createRequest::- ${Uri.parse('$url$api')}"
        " statusCode:- ${response.statusCode}");
    if (response.statusCode == 200) {
      userRequestData = jsonDecode(response.body)['data'];
      streamRequest();
      result = 'success';
      valueNotifierBook.incrementNotifier();
    } else if (response.statusCode == 401) {
      result = 'logout';
    } else {
      debugPrint(response.body);
      if (jsonDecode(response.body)['message'] == 'no drivers available') {
        noDriverFound = true;
      } else {
        tripError = jsonDecode(response.body)['message'].toString();
        tripReqError = true;
      }

      result = 'failure';
      valueNotifierBook.incrementNotifier();
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
      result = 'no internet';
      valueNotifierBook.incrementNotifier();
    }
  }
  return result;
}

//create request

createRequestLater(val, api) async {
  dynamic result;
  waitingTime = 0;
  try {
    var response = await http.post(Uri.parse('$url$api'),
        headers: {
          'Authorization': 'Bearer ${bearerToken[0].token}',
          'Content-Type': 'application/json',
        },
        body: val);
    print("createRequestLater::- ${Uri.parse('$url$api')}"
        "statusCode:- ${response.statusCode}");
    if (response.statusCode == 200) {
      result = 'success';
      userRequestData = jsonDecode(response.body)['data'];
      streamRequest();
      valueNotifierBook.incrementNotifier();
    } else if (response.statusCode == 401) {
      result = 'logout';
    } else {
      debugPrint(response.body);
      if (jsonDecode(response.body)['message'] == 'no drivers available') {
        noDriverFound = true;
      } else {
        tripReqError = true;
      }

      result = 'failure';
      valueNotifierBook.incrementNotifier();
    }
  } catch (e) {
    if (e is SocketException) {
      result = 'no internet';
      internet = false;
    }
  }
  return result;
}

//create request with promo code

createRequestLaterPromo() async {
  dynamic result;
  waitingTime = 0;
  try {
    var response = await http.post(Uri.parse('${url}api/v1/request/create'),
        headers: {
          'Authorization': 'Bearer ${bearerToken[0].token}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'pick_lat':
          addressList.firstWhere((e) => e.id == 'pickup').latlng.latitude,
          'pick_lng':
          addressList.firstWhere((e) => e.id == 'pickup').latlng.longitude,
          'drop_lat':
          addressList.firstWhere((e) => e.id == 'drop').latlng.latitude,
          'drop_lng':
          addressList.firstWhere((e) => e.id == 'drop').latlng.longitude,
          'vehicle_type': etaDetails[choosenVehicle]['zone_type_id'],
          'ride_type': 1,
          'payment_opt': (etaDetails[choosenVehicle]['payment_type']
              .toString()
              .split(',')
              .toList()[payingVia] ==
              'card')
              ? 0
              : (etaDetails[choosenVehicle]['payment_type']
              .toString()
              .split(',')
              .toList()[payingVia] ==
              'cash')
              ? 1
              : 2,
          'pick_address':
          addressList.firstWhere((e) => e.id == 'pickup').address,
          'drop_address': addressList.firstWhere((e) => e.id == 'drop').address,
          'promocode_id': etaDetails[choosenVehicle]['promocode_id'],
          'trip_start_time': choosenDateTime.toString().substring(0, 19),
          'is_later': true,
          'request_eta_amount': etaDetails[choosenVehicle]['total']
        }));

    print("createRequestLaterPromo::- ${Uri.parse('${url}api/v1/request/create')}"
        "statusCode:- ${response.statusCode}");
    if (response.statusCode == 200) {
      myMarkers.clear();
      streamRequest();
      valueNotifierBook.incrementNotifier();
      result = 'success';
    } else if (response.statusCode == 401) {
      result = 'logout';
    } else {
      debugPrint(response.body);
      if (jsonDecode(response.body)['message'] == 'no drivers available') {
        noDriverFound = true;
      } else {
        tripReqError = true;
      }

      result = 'failure';
      valueNotifierBook.incrementNotifier();
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
      result = 'no internet';
    }
  }

  return result;
}

//create rental request

createRentalRequest() async {
  dynamic result;
  try {
    var response = await http.post(Uri.parse('${url}api/v1/request/create'),
        headers: {
          'Authorization': 'Bearer ${bearerToken[0].token}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'pick_lat':
          addressList.firstWhere((e) => e.id == 'pickup').latlng.latitude,
          'pick_lng':
          addressList.firstWhere((e) => e.id == 'pickup').latlng.longitude,
          'vehicle_type': rentalOption[choosenVehicle]['zone_type_id'],
          'ride_type': 1,
          'payment_opt': (rentalOption[choosenVehicle]['payment_type']
              .toString()
              .split(',')
              .toList()[payingVia] ==
              'card')
              ? 0
              : (rentalOption[choosenVehicle]['payment_type']
              .toString()
              .split(',')
              .toList()[payingVia] ==
              'cash')
              ? 1
              : 2,
          'pick_address':
          addressList.firstWhere((e) => e.id == 'pickup').address,
          'request_eta_amount': rentalOption[choosenVehicle]['fare_amount'],
          'rental_pack_id': etaDetails[rentalChoosenOption]['id']
        }));

    print("createRentalRequest::- ${Uri.parse('${url}api/v1/request/create')}"
        "statusCode:- ${response.statusCode}");
    if (response.statusCode == 200) {
      userRequestData = jsonDecode(response.body)['data'];
      streamRequest();
      result = 'success';

      valueNotifierBook.incrementNotifier();
    } else if (response.statusCode == 401) {
      result = 'logout';
    } else {
      debugPrint(response.body);
      if (jsonDecode(response.body)['message'] == 'no drivers available') {
        noDriverFound = true;
      } else {
        tripReqError = true;
      }

      result = 'failure';
      valueNotifierBook.incrementNotifier();
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
      result = 'no internet';
      valueNotifierBook.incrementNotifier();
    }
  }
  return result;
}

createRentalRequestWithPromo() async {
  dynamic result;
  try {
    var response = await http.post(Uri.parse('${url}api/v1/request/create'),
        headers: {
          'Authorization': 'Bearer ${bearerToken[0].token}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'pick_lat':
          addressList.firstWhere((e) => e.id == 'pickup').latlng.latitude,
          'pick_lng':
          addressList.firstWhere((e) => e.id == 'pickup').latlng.longitude,
          'vehicle_type': rentalOption[choosenVehicle]['zone_type_id'],
          'ride_type': 1,
          'payment_opt': (rentalOption[choosenVehicle]['payment_type']
              .toString()
              .split(',')
              .toList()[payingVia] ==
              'card')
              ? 0
              : (rentalOption[choosenVehicle]['payment_type']
              .toString()
              .split(',')
              .toList()[payingVia] ==
              'cash')
              ? 1
              : 2,
          'pick_address':
          addressList.firstWhere((e) => e.id == 'pickup').address,
          'promocode_id': rentalOption[choosenVehicle]['promocode_id'],
          'request_eta_amount': rentalOption[choosenVehicle]['fare_amount'],
          'rental_pack_id': etaDetails[rentalChoosenOption]['id']
        }));

    print("createRentalRequestWithPromo::- ${Uri.parse('${url}api/v1/request/create')}"
        "statusCode:- ${response.statusCode}");
    if (response.statusCode == 200) {
      userRequestData = jsonDecode(response.body)['data'];
      streamRequest();
      result = 'success';
      valueNotifierBook.incrementNotifier();
    } else if (response.statusCode == 401) {
      result = 'logout';
    } else {
      debugPrint(response.body);
      if (jsonDecode(response.body)['message'] == 'no drivers available') {
        noDriverFound = true;
      } else {
        debugPrint(response.body);
        tripReqError = true;
      }

      result = 'failure';
      valueNotifierBook.incrementNotifier();
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
      result = 'no internet';
    }
  }
  return result;
}

createRentalRequestLater() async {
  dynamic result;
  try {
    var response = await http.post(Uri.parse('${url}api/v1/request/create'),
        headers: {
          'Authorization': 'Bearer ${bearerToken[0].token}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'pick_lat':
          addressList.firstWhere((e) => e.id == 'pickup').latlng.latitude,
          'pick_lng':
          addressList.firstWhere((e) => e.id == 'pickup').latlng.longitude,
          'vehicle_type': rentalOption[choosenVehicle]['zone_type_id'],
          'ride_type': 1,
          'payment_opt': (rentalOption[choosenVehicle]['payment_type']
              .toString()
              .split(',')
              .toList()[payingVia] ==
              'card')
              ? 0
              : (rentalOption[choosenVehicle]['payment_type']
              .toString()
              .split(',')
              .toList()[payingVia] ==
              'cash')
              ? 1
              : 2,
          'pick_address':
          addressList.firstWhere((e) => e.id == 'pickup').address,
          'trip_start_time': choosenDateTime.toString().substring(0, 19),
          'is_later': true,
          'request_eta_amount': rentalOption[choosenVehicle]['fare_amount'],
          'rental_pack_id': etaDetails[rentalChoosenOption]['id']
        }));

    print("createRentalRequestLater::- ${Uri.parse('${url}api/v1/request/create')}"
        "statusCode:- ${response.statusCode}");

    if (response.statusCode == 200) {
      result = 'success';
      streamRequest();
      valueNotifierBook.incrementNotifier();
    } else if (response.statusCode == 401) {
      result = 'logout';
    } else {
      debugPrint(response.body);
      if (jsonDecode(response.body)['message'] == 'no drivers available') {
        noDriverFound = true;
      } else {
        tripReqError = true;
      }

      result = 'failure';
      valueNotifierBook.incrementNotifier();
    }
  } catch (e) {
    if (e is SocketException) {
      result = 'no internet';
      internet = false;
    }
  }
  return result;
}

createRentalRequestLaterPromo() async {
  dynamic result;
  try {
    var response = await http.post(Uri.parse('${url}api/v1/request/create'),
        headers: {
          'Authorization': 'Bearer ${bearerToken[0].token}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'pick_lat':
          addressList.firstWhere((e) => e.id == 'pickup').latlng.latitude,
          'pick_lng':
          addressList.firstWhere((e) => e.id == 'pickup').latlng.longitude,
          'vehicle_type': rentalOption[choosenVehicle]['zone_type_id'],
          'ride_type': 1,
          'payment_opt': (rentalOption[choosenVehicle]['payment_type']
              .toString()
              .split(',')
              .toList()[payingVia] ==
              'card')
              ? 0
              : (rentalOption[choosenVehicle]['payment_type']
              .toString()
              .split(',')
              .toList()[payingVia] ==
              'cash')
              ? 1
              : 2,
          'pick_address':
          addressList.firstWhere((e) => e.id == 'pickup').address,
          'promocode_id': rentalOption[choosenVehicle]['promocode_id'],
          'trip_start_time': choosenDateTime.toString().substring(0, 19),
          'is_later': true,
          'request_eta_amount': rentalOption[choosenVehicle]['fare_amount'],
          'rental_pack_id': etaDetails[rentalChoosenOption]['id'],
        }));

    print("createRentalRequestLaterPromo::- ${Uri.parse('${url}api/v1/request/create')}"
        "statusCode:- ${response.statusCode}");

    if (response.statusCode == 200) {
      myMarkers.clear();
      streamRequest();
      valueNotifierBook.incrementNotifier();
      result = 'success';
    } else if (response.statusCode == 401) {
      result = 'logout';
    } else {
      debugPrint(response.body);
      if (jsonDecode(response.body)['message'] == 'no drivers available') {
        noDriverFound = true;
      } else {
        debugPrint(response.body);
        tripReqError = true;
      }

      result = 'failure';
      valueNotifierBook.incrementNotifier();
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
      result = 'no internet';
    }
  }

  return result;
}

List<RequestCreate> createRequestList = <RequestCreate>[];

class RequestCreate {
  dynamic pickLat;
  dynamic pickLng;
  dynamic dropLat;
  dynamic dropLng;
  dynamic vehicleType;
  dynamic rideType;
  dynamic paymentOpt;
  dynamic pickAddress;
  dynamic dropAddress;
  dynamic promoCodeId;

  RequestCreate(
      {this.pickLat,
        this.pickLng,
        this.dropLat,
        this.dropLng,
        this.vehicleType,
        this.rideType,
        this.paymentOpt,
        this.pickAddress,
        this.dropAddress,
        this.promoCodeId});

  Map<String, dynamic> toJson() => {
    'pick_lat': pickLat,
    'pick_lng': pickLng,
    'drop_lat': dropLat,
    'drop_lng': dropLng,
    'vehicle_type': vehicleType,
    'ride_type': rideType,
    'payment_opt': paymentOpt,
    'pick_address': pickAddress,
    'drop_address': dropAddress,
    'promocode_id': promoCodeId
  };
}

//user cancel request

cancelRequest() async {
  dynamic result;
  try {
    var response = await http.post(Uri.parse('${url}api/v1/request/cancel'),
        headers: {
          'Authorization': 'Bearer ${bearerToken[0].token}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'request_id': userRequestData['id']}));
    print("token:-- ${bearerToken[0].token}");
    print("request_id::- ${userRequestData['id']}");
    print("cancel::- ${Uri.parse('${url}api/v1/request/cancel')}");
    if (response.statusCode == 200) {
      userCancelled = true;
      if (userRequestData['is_bid_ride'] == 1) {
        FirebaseDatabase.instance
            .ref('bid-meta/${userRequestData["id"]}')
            .remove();
      }
      // FirebaseDatabase.instance
      //     .ref('requests')
      //     .child(userRequestData['id'])
      //     .update({'cancelled_by_user': true});
      userRequestData = {};
      if (requestStreamStart?.isPaused == false ||
          requestStreamEnd?.isPaused == false) {
        requestStreamStart?.cancel();
        requestStreamEnd?.cancel();
        requestStreamStart = null;
        requestStreamEnd = null;
      }
      result = 'success';
      valueNotifierBook.incrementNotifier();
    } else if (response.statusCode == 401) {
      result = 'logout';
    } else {
      debugPrint(response.body);
      result = 'failed';
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
    }
  }
  return result;
}

cancelLaterRequest(val) async {
  dynamic result;
  try {
    var response = await http.post(Uri.parse('${url}api/v1/request/cancel'),
        headers: {
          'Authorization': 'Bearer ${bearerToken[0].token}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'request_id': val}));
    print("val::- ${val}");
    print("cancelLaterRequest::- ${Uri.parse('${url}api/v1/request/cancel')}"
        " statusCode:- ${response.statusCode}");
    if (response.statusCode == 200) {
      userRequestData = {};
      if (requestStreamStart?.isPaused == false ||
          requestStreamEnd?.isPaused == false) {
        requestStreamStart?.cancel();
        requestStreamEnd?.cancel();
        requestStreamStart = null;
        requestStreamEnd = null;
      }
      result = 'success';
      valueNotifierBook.incrementNotifier();
    } else if (response.statusCode == 401) {
      result = 'logout';
    } else {
      result = 'failed';
      debugPrint(response.body);
    }
    return result;
  } catch (e) {
    if (e is SocketException) {
      internet = false;
    }
  }
}

//user cancel request with reason

cancelRequestWithReason(reason) async {
  dynamic result;
  try {
    var response = await http.post(Uri.parse('${url}api/v1/request/cancel'),
        headers: {
          'Authorization': 'Bearer ${bearerToken[0].token}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
            {'request_id': userRequestData['id'], 'reason': reason}));
    print("cancelRequestWithReason::- ${Uri.parse('${url}api/v1/request/cancel')}"
        "statusCode:- ${response.statusCode}");
    if (response.statusCode == 200) {
      cancelRequestByUser = true;
      // FirebaseDatabase.instance
      //     .ref('requests/${userRequestData['id']}')
      //     .update({'cancelled_by_user': true});
      userRequestData = {};
      if (rideStreamUpdate?.isPaused == false ||
          rideStreamStart?.isPaused == false) {
        rideStreamUpdate?.cancel();
        rideStreamUpdate = null;
        rideStreamStart?.cancel();
        rideStreamStart = null;
      }
      await getUserDetails();
      result = 'success';
      valueNotifierBook.incrementNotifier();
    } else if (response.statusCode == 401) {
      result = 'logout';
    } else {
      result = 'failed';
      debugPrint(response.body);
    }
    return result;
  } catch (e) {
    if (e is SocketException) {
      internet = false;
    }
  }
}

//making call to user

makingPhoneCall(phnumber) async {
  var mobileCall = 'tel:$phnumber';
  // ignore: deprecated_member_use
  if (await canLaunch(mobileCall)) {
    // ignore: deprecated_member_use
    await launch(mobileCall);
  } else {
    throw 'Could not launch $mobileCall';
  }
}

//cancellation reason
List cancelReasonsList = [];
cancelReason(reason) async {
  dynamic result;
  try {
    var response = await http.get(
      Uri.parse(
          '${url}api/v1/common/cancallation/reasons?arrived=$reason&transport_type=${userRequestData['transport_type']}'),
      headers: {
        'Authorization': 'Bearer ${bearerToken[0].token}',
        'Content-Type': 'application/json',
      },
    );

    print("cancelReason::- ${Uri.parse('${url}api/v1/common/cancallation/reasons?arrived=$reason&transport_type=${userRequestData['transport_type']}')}"
        "statusCode:- ${response.statusCode}");
    if (response.statusCode == 200) {
      cancelReasonsList = jsonDecode(response.body)['data'];
      result = true;
    } else if (response.statusCode == 401) {
      result = 'logout';
    } else {
      debugPrint(response.body);
      result = false;
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
      result = 'no internet';
    }
  }
  return result;
}

List<CancelReasonJson> cancelJson = <CancelReasonJson>[];

class CancelReasonJson {
  dynamic requestId;
  dynamic reason;

  CancelReasonJson({this.requestId, this.reason});

  Map<String, dynamic> toJson() {
    return {'request_id': requestId, 'reason': reason};
  }
}

//add user rating

userRating() async {
  dynamic result;
  try {
    var response = await http.post(Uri.parse('${url}api/v1/request/rating'),
        headers: {
          'Authorization': 'Bearer ${bearerToken[0].token}',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          'request_id': userRequestData['id'],
          'rating': review,
          'comment': feedback
        }));
    print("rating::- ${Uri.parse('${url}api/v1/request/rating')}  statusCode:- ${response.statusCode}");
    if (response.statusCode == 200) {
      ismulitipleride = false;
      await getUserDetails();
      result = true;
    } else if (response.statusCode == 401) {
      result = 'logout';
    } else {
      debugPrint(response.body);
      result = false;
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
      result = 'no internet';
    }
  }
  return result;
}

//class for realtime database driver data

class NearByDriver {
  double bearing;
  String g;
  String id;
  List l;
  String updatedAt;

  NearByDriver(
      {required this.bearing,
        required this.g,
        required this.id,
        required this.l,
        required this.updatedAt});

  factory NearByDriver.fromJson(Map<String, dynamic> json) {
    return NearByDriver(
        id: json['id'],
        bearing: json['bearing'],
        g: json['g'],
        l: json['l'],
        updatedAt: json['updated_at']);
  }
}

//add favourites location

addFavLocation(lat, lng, add, name) async {
  dynamic result;
  try {
    var response = await http.post(
        Uri.parse('${url}api/v1/user/add-favourite-location'),
        headers: {
          'Authorization': 'Bearer ${bearerToken[0].token}',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          'pick_lat': lat,
          'pick_lng': lng,
          'pick_address': add,
          'address_name': name
        }));

    print("token::- ${bearerToken[0].token}");
    print("url::- ${Uri.parse('${url}api/v1/user/add-favourite-location')} "
        "body::- pick_lat:${lat} pick_lng:${lng} pick_address:${add} address_name:${name}"
        "token::- ${bearerToken[0].token} ");
    print("response.statusCode ${response.statusCode} body::- ${response.body}");
    if (response.statusCode == 200) {
      result = true;
      await getUserDetails();
      valueNotifierHome.incrementNotifier();
    } else if (response.statusCode == 401) {
      result = 'logout';
    } else {
      debugPrint(response.body);
      result = false;
    }
    return result;
  } catch (e) {
    if (e is SocketException) {
      internet = false;
    }
  }
}

//sos data
List sosData = [];

getSosData(lat, lng) async {
  dynamic result;
  try {
    var response = await http.get(
      Uri.parse('${url}api/v1/common/sos/list/$lat/$lng'),
      headers: {
        'Authorization': 'Bearer ${bearerToken[0].token}',
        'Content-Type': 'application/json'
      },
    );

    print("getSosData::- ${Uri.parse('${url}api/v1/common/sos/list/$lat/$lng')}"
        "statusCode:- ${response.statusCode}");

    if (response.statusCode == 200) {
      sosData = jsonDecode(response.body)['data'];
      result = 'success';
      valueNotifierBook.incrementNotifier();
    } else if (response.statusCode == 401) {
      result = 'logout';
    } else {
      debugPrint(response.body);
      result = 'failure';
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
      result = 'no internet';
    }
  }
  return result;
}

//sos admin notification

notifyAdmin() async {
  var db = FirebaseDatabase.instance.ref();
  try {
    await db.child('SOS/${userRequestData['id']}').update({
      "is_driver": "0",
      "is_user": "1",
      "req_id": userRequestData['id'],
      "serv_loc_id": userRequestData['service_location_id'],
      "updated_at": ServerValue.timestamp
    });
  } catch (e) {
    if (e is SocketException) {
      internet = false;
    }
  }
  return true;
}

//get current ride messages

List chatList = [];

getCurrentMessages() async {
  dynamic result;
  try {
    var response = await http.get(
      Uri.parse('${url}api/v1/request/chat-history/${userRequestData['id']}'),
      headers: {
        'Authorization': 'Bearer ${bearerToken[0].token}',
        'Content-Type': 'application/json'
      },
    );
    print("chat-history::- ${Uri.parse('${url}api/v1/request/chat-history/${userRequestData['id']}')}"
        "statusCode:- ${response.statusCode}");
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['success'] == true) {
        if (chatList.where((element) => element['from_type'] == 2).length !=
            jsonDecode(response.body)['data']
                .where((element) => element['from_type'] == 2)
                .length) {}
        chatList = jsonDecode(response.body)['data'];
        messageSeen();

        valueNotifierBook.incrementNotifier();
      }
      result = 'success';
    } else if (response.statusCode == 401) {
      result = 'logout';
    } else {
      result = 'failed';
      debugPrint(response.body);
    }
    return result;
  } catch (e) {
    if (e is SocketException) {
      internet = false;
    }
  }
}

//send chat

sendMessage(chat) async {
  dynamic result;
  try {
    var response = await http.post(Uri.parse('${url}api/v1/request/send'),
        headers: {
          'Authorization': 'Bearer ${bearerToken[0].token}',
          'Content-Type': 'application/json'
        },
        body:
        jsonEncode({'request_id': userRequestData['id'], 'message': chat}));
    print("sendMessage::- ${Uri.parse('${url}api/v1/request/send}')}"
        "statusCode:- ${response.statusCode}");
    if (response.statusCode == 200) {
      await getCurrentMessages();
      FirebaseDatabase.instance
          .ref('requests/${userRequestData['id']}')
          .update({'message_by_user': chatList.length});
      result = 'success';
    } else if (response.statusCode == 401) {
      result = 'logout';
    } else {
      result = 'failed';
      debugPrint(response.body);
    }
    return result;
  } catch (e) {
    if (e is SocketException) {
      internet = false;
    }
  }
}

//message seen

messageSeen() async {
  var response = await http.post(Uri.parse('${url}api/v1/request/seen'),
      headers: {
        'Authorization': 'Bearer ${bearerToken[0].token}',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({'request_id': userRequestData['id']}));
  print("messageSeen::- ${Uri.parse('${url}api/v1/request/seen')}"
      "statusCode:- ${response.statusCode}");
  if (response.statusCode == 200) {
    // getCurrentMessages();
  } else {
    debugPrint(response.body);
  }
}

//admin chat

dynamic chatStream;
String unSeenChatCount = '0';
streamAdminchat() async {
  chatStream = FirebaseDatabase.instance
      .ref()
      .child(
      'chats/${(adminChatList.length > 2) ? userDetails['chat_id'] : chatid}')
      .onValue
      .listen((event) async {
    var value =
    Map<String, dynamic>.from(jsonDecode(jsonEncode(event.snapshot.value)));
    if (value['to_id'].toString() == userDetails['id'].toString()) {
      adminChatList.add(jsonDecode(jsonEncode(event.snapshot.value)));
    }
    value.clear();
    if (adminChatList.isNotEmpty) {
      unSeenChatCount =
          adminChatList[adminChatList.length - 1]['count'].toString();
      if (unSeenChatCount == 'null') {
        unSeenChatCount = '0';
      }
    }
    valueNotifierChat.incrementNotifier();
  });
}

//admin chat

List adminChatList = [];
dynamic isnewchat = 1;
dynamic chatid;
getadminCurrentMessages() async {
  dynamic result;
  try {
    var response = await http.get(
      Uri.parse('${url}api/v1/request/admin-chat-history'),
      headers: {
        'Authorization': 'Bearer ${bearerToken[0].token}',
        'Content-Type': 'application/json'
      },
    );
    print("admin-chat-history::- ${Uri.parse('${url}api/v1/request/admin-chat-history')}"
        " statusCode:- ${response.statusCode}");
    if (response.statusCode == 200) {
      adminChatList.clear();
      isnewchat = jsonDecode(response.body)['data']['new_chat'];
      adminChatList = jsonDecode(response.body)['data']['chats'];
      if (adminChatList.isNotEmpty) {
        chatid = adminChatList[0]['chat_id'];
      }
      if (adminChatList.isNotEmpty && chatStream == null) {
        streamAdminchat();
      }
      unSeenChatCount = '0';
      result = 'success';
    } else if (response.statusCode == 401) {
      result = 'logout';
    } else {
      result = 'failed';
      debugPrint(response.body);
    }
    return result;
  } catch (e) {
    if (e is SocketException) {
      internet = false;
    }
  }
}

sendadminMessage(chat) async {
  dynamic result;
  try {
    var response =
    await http.post(Uri.parse('${url}api/v1/request/send-message'),
        headers: {
          'Authorization': 'Bearer ${bearerToken[0].token}',
          'Content-Type': 'application/json'
        },
        body: (isnewchat == 1)
            ? jsonEncode({'new_chat': isnewchat, 'message': chat})
            : jsonEncode({
          'new_chat': 0,
          'message': chat,
          'chat_id': chatid,
        }));
    print("isnewchat ${(isnewchat == 1)}");
    print("message:${chat} chat_id:${chatid}");
    print("send-message::- ${Uri.parse('${url}api/v1/request/send-message')}"
        " statusCode:- ${response.statusCode}");
    if (response.statusCode == 200) {
      chatid = jsonDecode(response.body)['data']['chat_id'];
      adminChatList.add({
        'chat_id': chatid,
        'message': jsonDecode(response.body)['data']['message'],
        'from_id': userDetails['id'],
        'to_id': jsonDecode(response.body)['data']['to_id'],
        'user_timezone': jsonDecode(response.body)['data']['user_timezone']
      });
      isnewchat = 0;
      if (adminChatList.isNotEmpty && chatStream == null) {
        streamAdminchat();
      }
      unSeenChatCount = '0';
      result = 'success';
    } else if (response.statusCode == 401) {
      result = 'logout';
    } else {
      result = 'failed';
      debugPrint(response.body);
    }
    return result;
  } catch (e) {
    if (e is SocketException) {
      internet = false;
    }
  }
}

adminmessageseen() async {
  dynamic result;
  try {
    var response = await http.get(
      Uri.parse(
          '${url}api/v1/request/update-notification-count?chat_id=$chatid'),
      headers: {
        'Authorization': 'Bearer ${bearerToken[0].token}',
        'Content-Type': 'application/json',
      },
    );
    print("adminmessageseen::- ${Uri.parse('${url}api/v1/request/update-notification-count?chat_id=$chatid')}"
        "statusCode:- ${response.statusCode}");
    if (response.statusCode == 200) {
      result = true;
    } else if (response.statusCode == 401) {
      result = 'logout';
    } else {
      debugPrint(response.body);
      result = false;
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
      result = 'no internet';
    }
  }
  return result;
}

//add sos

addSos(name, number) async {
  dynamic result;
  try {
    var response = await http.post(Uri.parse('${url}api/v1/common/sos/store'),
        headers: {
          'Authorization': 'Bearer ${bearerToken[0].token}',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({'name': name, 'number': number}));
    print("addSos::- ${Uri.parse('${url}api/v1/common/sos/store')}"
        "statusCode:- ${response.statusCode}");
    if (response.statusCode == 200) {
      await getUserDetails();
      result = 'success';
    } else if (response.statusCode == 401) {
      result = 'logout';
    } else {
      debugPrint(response.body);
      result = 'failure';
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
      result = 'no internet';
    }
  }
  return result;
}

//remove sos

deleteSos(id) async {
  dynamic result;
  try {
    var response = await http
        .post(Uri.parse('${url}api/v1/common/sos/delete/$id'), headers: {
      'Authorization': 'Bearer ${bearerToken[0].token}',
      'Content-Type': 'application/json'
    });
    print("deleteSos::- ${Uri.parse('${url}api/v1/common/sos/delete/$id')}"
        "statusCode:- ${response.statusCode}");
    if (response.statusCode == 200) {
      await getUserDetails();
      result = 'success';
    } else if (response.statusCode == 401) {
      result = 'logout';
    } else {
      debugPrint(response.body);
      result = 'failure';
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
      result = 'no internet';
    }
  }
  return result;
}

//open url in browser

openBrowser(browseUrl) async {
  // ignore: deprecated_member_use
  if (await canLaunch(browseUrl)) {
    // ignore: deprecated_member_use
    await launch(browseUrl);
  } else {
    throw 'Could not launch $browseUrl';
  }
}

//get faq
List faqData = [];
Map<String, dynamic> myFaqPage = {};

getFaqData(lat, lng) async {
  dynamic result;
  try {
    var response = await http
        .get(Uri.parse('${url}api/v1/common/faq/list/$lat/$lng'), headers: {
      'Authorization': 'Bearer ${bearerToken[0].token}',
      'Content-Type': 'application/json'
    });
    print("getFaqData::- ${Uri.parse('${url}api/v1/common/faq/list/$lat/$lng')}"
        " statusCode:- ${response.statusCode}");
    if (response.statusCode == 200) {
      faqData = jsonDecode(response.body)['data'];
      myFaqPage = jsonDecode(response.body)['meta'];
      valueNotifierBook.incrementNotifier();
      result = 'success';
    } else if (response.statusCode == 401) {
      result = 'logout';
    } else {
      debugPrint(response.body);
      result = 'failure';
    }
  } catch (e) {
    if (e is SocketException) {
      result = 'no internet';
      internet = false;
    }
  }
  return result;
}

getFaqPages(id) async {
  dynamic result;
  try {
    var response =
    await http.get(Uri.parse('${url}api/v1/common/faq/list/$id'), headers: {
      'Authorization': 'Bearer ${bearerToken[0].token}',
      'Content-Type': 'application/json'
    });
    print("getFaqPages::- ${Uri.parse('${url}api/v1/common/faq/list/$id')}"
        "statusCode:- ${response.statusCode}");
    if (response.statusCode == 200) {
      var val = jsonDecode(response.body)['data'];
      val.forEach((element) {
        faqData.add(element);
      });
      myFaqPage = jsonDecode(response.body)['meta'];
      valueNotifierHome.incrementNotifier();
      result = 'success';
    } else if (response.statusCode == 401) {
      result = 'logout';
    } else {
      debugPrint(response.body);
      result = 'failure';
    }
  } catch (e) {
    if (e is SocketException) {
      result = 'no internet';
      internet = false;
    }
    return result;
  }
}

//remove fav address

removeFavAddress(id) async {
  dynamic result;
  try {
    var response = await http.get(
        Uri.parse('${url}api/v1/user/delete-favourite-location/$id'),
        headers: {
          'Authorization': 'Bearer ${bearerToken[0].token}',
          'Content-Type': 'application/json'
        });
    print("removeFavAddress::- ${Uri.parse('${url}api/v1/user/delete-favourite-location/$id')}"
        "statusCode:- ${response.statusCode}");
    if (response.statusCode == 200) {
      await getUserDetails();
      result = 'success';
    } else if (response.statusCode == 401) {
      result = 'logout';
    } else {
      debugPrint(response.body);
      result = 'failure';
    }
  } catch (e) {
    if (e is SocketException) {
      result = 'no internet';
      internet = false;
    }
  }
  return result;
}

//get user referral

Map<String, dynamic> myReferralCode = {};
getReferral() async {
  dynamic result;
  try {
    var response =
    await http.get(Uri.parse('${url}api/v1/get/referral'), headers: {
      'Authorization': 'Bearer ${bearerToken[0].token}',
      'Content-Type': 'application/json'
    });
    print("getReferral::- ${Uri.parse('${url}api/v1/get/referral')}"
        " statusCode:- ${response.statusCode}");
    if (response.statusCode == 200) {
      result = 'success';
      myReferralCode = jsonDecode(response.body)['data'];
      valueNotifierBook.incrementNotifier();
    } else if (response.statusCode == 401) {
      result = 'logout';
    } else {
      debugPrint(response.body);
      result = 'failure';
    }
  } catch (e) {
    if (e is SocketException) {
      result = 'no internet';
      internet = false;
    }
  }
  return result;
}

//user logout

userLogout() async {
  dynamic result;
  try {
    var response = await http.post(Uri.parse('${url}api/v1/logout'), headers: {
      'Authorization': 'Bearer ${bearerToken[0].token}',
      'Content-Type': 'application/json'
    });
    print("userLogout::- ${Uri.parse('${url}api/v1/logout')}"
        "statusCode:- ${response.statusCode}");
    if (response.statusCode == 200) {
      pref.remove('Bearer');

      result = 'success';
    } else if (response.statusCode == 401) {
      result = 'logout';
    } else {
      debugPrint(response.body);
      result = 'failure';
    }
  } catch (e) {
    if (e is SocketException) {
      result = 'no internet';
      internet = false;
    }
  }
  return result;
}

//request history
List myHistory = [];
Map<String, dynamic> myHistoryPage = {};

String historyFiltter = 'is_completed=1';
getHistory() async {
  dynamic result;
  try {
    // ignore: prefer_typing_uninitialized_variables
    var response;
    if (historyFiltter == '') {
      response = await http.get(
          Uri.parse('${url}api/v1/request/history?on_trip=0'),
          headers: {'Authorization': 'Bearer ${bearerToken[0].token}'});
    } else {
      response = await http.get(
          Uri.parse('${url}api/v1/request/history?$historyFiltter'),
          headers: {'Authorization': 'Bearer ${bearerToken[0].token}'});
    }

    print("token::- ${bearerToken[0].token}");
    print("getHistory::- ${Uri.parse('${url}api/v1/request/history?on_trip=0')}"
        " statusCode:- ${response.statusCode}");
    if (response.statusCode == 200) {
      myHistory = jsonDecode(response.body)['data'];
      myHistoryPage = jsonDecode(response.body)['meta'];
      result = 'success';
      valueNotifierBook.incrementNotifier();
    } else if (response.statusCode == 401) {
      result = 'logout';
    } else {
      debugPrint(response.body);
      result = 'failure';
      valueNotifierBook.incrementNotifier();
    }
    myHistory.removeWhere((element) => element.isEmpty);
  } catch (e) {
    if (e is SocketException) {
      result = 'no internet';

      internet = false;
      valueNotifierBook.incrementNotifier();
    }
  }
  return result;
}

getHistoryPages(id) async {
  dynamic result;

  try {
    var response = await http.get(Uri.parse('${url}api/v1/request/history?$id'),
        headers: {'Authorization': 'Bearer ${bearerToken[0].token}'});
    print("getHistoryPages::- ${Uri.parse('${url}api/v1/request/history?$id')}"
        " statusCode:- ${response.statusCode}");
    if (response.statusCode == 200) {
      List list = jsonDecode(response.body)['data'];
      // ignore: avoid_function_literals_in_foreach_calls
      list.forEach((element) {
        myHistory.add(element);
      });
      myHistoryPage = jsonDecode(response.body)['meta'];
      result = 'success';
      valueNotifierBook.incrementNotifier();
    } else if (response.statusCode == 401) {
      result = 'logout';
    } else {
      debugPrint(response.body);
      result = 'failure';
      valueNotifierBook.incrementNotifier();
    }
    myHistory.removeWhere((element) => element.isEmpty);
  } catch (e) {
    if (e is SocketException) {
      result = 'no internet';

      internet = false;
      valueNotifierBook.incrementNotifier();
    }
  }
  return result;
}

//get wallet history

Map<String, dynamic> walletBalance = {};
Map<String, dynamic> paymentGateways = {};
List walletHistory = [];
Map<String, dynamic> walletPages = {};

getWalletHistory() async {
  dynamic result;
  try {
    var response = await http.get(
        Uri.parse('${url}api/v1/payment/wallet/history'),
        headers: {'Authorization': 'Bearer ${bearerToken[0].token}'});
    print("getWalletHistory::- ${Uri.parse('${url}api/v1/payment/wallet/history')}"
        "statusCode:- ${response.statusCode}");
    if (response.statusCode == 200) {
      walletBalance = jsonDecode(response.body);
      walletHistory = walletBalance['wallet_history']['data'];
      walletPages = walletBalance['wallet_history']['meta']['pagination'];
      paymentGateways = walletBalance['payment_gateways'];
      result = 'success';
      valueNotifierBook.incrementNotifier();
    } else if (response.statusCode == 401) {
      result = 'logout';
    } else {
      debugPrint(response.body);
      result = 'failure';
      valueNotifierBook.incrementNotifier();
    }
    walletHistory.removeWhere((element) => element.isEmpty);
  } catch (e) {
    if (e is SocketException) {
      internet = false;
      result = 'no internet';
      valueNotifierBook.incrementNotifier();
    }
  }
  return result;
}

getWalletHistoryPage(page) async {
  dynamic result;
  try {
    var response = await http.get(
        Uri.parse('${url}api/v1/payment/wallet/history?page=$page'),
        headers: {'Authorization': 'Bearer ${bearerToken[0].token}'});
    print("getWalletHistoryPage::- ${Uri.parse('${url}api/v1/payment/wallet/history?page=$page')}"
        "statusCode:- ${response.statusCode}");
    if (response.statusCode == 200) {
      walletBalance = jsonDecode(response.body);
      List list = walletBalance['wallet_history']['data'];
      // ignore: avoid_function_literals_in_foreach_calls
      list.forEach((element) {
        walletHistory.add(element);
      });
      walletPages = walletBalance['wallet_history']['meta']['pagination'];
      result = 'success';
      valueNotifierBook.incrementNotifier();
    } else if (response.statusCode == 401) {
      result = 'logout';
    } else {
      debugPrint(response.body);
      result = 'failure';
      valueNotifierBook.incrementNotifier();
    }
    walletHistory.removeWhere((element) => element.isEmpty);
  } catch (e) {
    if (e is SocketException) {
      internet = false;
      result = 'no internet';
      valueNotifierBook.incrementNotifier();
    }
  }
  return result;
}

//get client token for braintree

getClientToken() async {
  dynamic result;
  try {
    var response = await http.get(
        Uri.parse('${url}api/v1/payment/client/token'),
        headers: {'Authorization': 'Bearer ${bearerToken[0].token}'});
    print("getClientToken::- ${Uri.parse('${url}api/v1/payment/client/token')}"
        "statusCode:- ${response.statusCode}");
    if (response.statusCode == 200) {
      result = 'success';
    } else if (response.statusCode == 401) {
      result = 'logout';
    } else {
      debugPrint(response.body);
      result = 'failure';
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
      result = 'no internet';
    }
  }
  return result;
}

//stripe payment

Map<String, dynamic> stripeToken = {};

getStripePayment(money) async {
  dynamic results;
  try {
    var response =
    await http.post(Uri.parse('${url}api/v1/payment/stripe/intent'),
        headers: {
          'Authorization': 'Bearer ${bearerToken[0].token}',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({'amount': money}));
    print("getStripePayment::- ${Uri.parse('${url}api/v1/payment/stripe/intent')}"
        "statusCode:- ${response.statusCode}");
    if (response.statusCode == 200) {
      results = 'success';
      stripeToken = jsonDecode(response.body)['data'];
    } else if (response.statusCode == 401) {
      results = 'logout';
    } else {
      debugPrint(response.body);
      results = 'failure';
    }
  } catch (e) {
    if (e is SocketException) {
      results = 'no internet';
      internet = false;
    }
  }
  return results;
}

//stripe add money

addMoneyStripe(amount, nonce) async {
  dynamic result;
  try {
    var response = await http.post(
        Uri.parse('${url}api/v1/payment/stripe/add/money'),
        headers: {
          'Authorization': 'Bearer ${bearerToken[0].token}',
          'Content-Type': 'application/json'
        },

        body: jsonEncode(
            {'amount': amount, 'payment_nonce': nonce, 'payment_id': nonce}));
    print("addMoneyStripe::- ${Uri.parse('${url}api/v1/payment/stripe/add/money')}"
        "statusCode:- ${response.statusCode}");
    if (response.statusCode == 200) {
      await getWalletHistory();
      await getUserDetails();
      result = 'success';
    } else if (response.statusCode == 401) {
      result = 'logout';
    } else {
      debugPrint(response.body);
      result = 'failure';
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
      result = 'no internet';
    }
  }
  return result;
}

//stripe pay money

payMoneyStripe(nonce) async {
  dynamic result;
  try {
    var response = await http.post(
        Uri.parse('${url}api/v1/payment/stripe/make-payment-for-ride'),
        headers: {
          'Authorization': 'Bearer ${bearerToken[0].token}',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(
            {'request_id': userRequestData['id'], 'payment_id': nonce}));
    print("payMoneyStripe::- ${Uri.parse('${url}api/v1/payment/stripe/make-payment-for-ride')}"
        "statusCode:- ${response.statusCode}");
    if (response.statusCode == 200) {
      result = 'success';
    } else if (response.statusCode == 401) {
      result = 'logout';
    } else {
      debugPrint(response.body);
      result = 'failure';
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
      result = 'no internet';
    }
  }
  return result;
}

//paystack payment
Map<String, dynamic> paystackCode = {};

getPaystackPayment(body) async {
  dynamic results;
  paystackCode.clear();
  try {
    var response =
    await http.post(Uri.parse('${url}api/v1/payment/paystack/initialize'),
        headers: {
          'Authorization': 'Bearer ${bearerToken[0].token}',
          'Content-Type': 'application/json'
        },
        body: body);
    print("getPaystackPayment::- ${Uri.parse('${url}api/v1/payment/paystack/initialize')}"
        "statusCode:- ${response.statusCode}");
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['status'] == false) {
        results = jsonDecode(response.body)['message'];
      } else {
        results = 'success';
        paystackCode = jsonDecode(response.body)['data'];
      }
    } else if (response.statusCode == 401) {
      results = 'logout';
    } else {
      debugPrint(response.body);
      results = jsonDecode(response.body)['message'];
    }
  } catch (e) {
    if (e is SocketException) {
      results = 'no internet';
      internet = false;
    }
  }
  return results;
}

addMoneyPaystack(amount, nonce) async {
  dynamic result;
  try {
    var response = await http.post(
        Uri.parse('${url}api/v1/payment/paystack/add-money'),
        headers: {
          'Authorization': 'Bearer ${bearerToken[0].token}',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(
            {'amount': amount, 'payment_nonce': nonce, 'payment_id': nonce}));
    print("addMoneyPaystack::- ${Uri.parse('${url}api/v1/payment/paystack/add-money')}"
        "statusCode:- ${response.statusCode}");
    if (response.statusCode == 200) {
      await getWalletHistory();
      await getUserDetails();
      paystackCode.clear();
      result = 'success';
    } else if (response.statusCode == 401) {
      result = 'logout';
    } else {
      debugPrint(response.body);
      result = 'failure';
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
      result = 'no internet';
    }
  }
  return result;
}

//flutterwave

addMoneyFlutterwave(amount, nonce) async {
  dynamic result;
  try {
    var response = await http.post(
        Uri.parse('${url}api/v1/payment/flutter-wave/add-money'),
        headers: {
          'Authorization': 'Bearer ${bearerToken[0].token}',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(
            {'amount': amount, 'payment_nonce': nonce, 'payment_id': nonce}));
    print("addMoneyFlutterwave::- ${Uri.parse('${url}api/v1/payment/flutter-wave/add-money')}"
        "statusCode:- ${response.statusCode}");
    if (response.statusCode == 200) {
      await getWalletHistory();
      await getUserDetails();
      result = 'success';
    } else if (response.statusCode == 401) {
      result = 'logout';
    } else {
      debugPrint(response.body);
      result = 'failure';
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
      result = 'no internet';
    }
  }
  return result;
}

//razorpay

addMoneyRazorpay(amount, nonce) async {
  dynamic result;
  try {
    var response = await http.post(
        Uri.parse('${url}api/v1/payment/razerpay/add-money'),
        headers: {
          'Authorization': 'Bearer ${bearerToken[0].token}',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(
            {'amount': amount, 'payment_nonce': nonce, 'payment_id': nonce}));
    print("addMoneyRazorpay::- ${Uri.parse('${url}api/v1/payment/razerpay/add-money')}"
        "statusCode:- ${response.statusCode}");
    if (response.statusCode == 200) {
      await getWalletHistory();
      await getUserDetails();
      result = 'success';
    } else if (response.statusCode == 401) {
      result = 'logout';
    } else {
      debugPrint(response.body);
      result = 'failure';
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
      result = 'no internet';
    }
  }
  return result;
}

//cashfree

Map<String, dynamic> cftToken = {};

getCfToken(money, currency) async {
  cftToken.clear();
  cfSuccessList.clear();
  dynamic result;
  try {
    var response = await http.post(
        Uri.parse('${url}api/v1/payment/cashfree/generate-cftoken'),
        headers: {
          'Authorization': 'Bearer ${bearerToken[0].token}',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({'order_amount': money, 'order_currency': currency}));
    print("getCfToken::- ${Uri.parse('${url}api/v1/payment/cashfree/generate-cftoken')}"
        "statusCode:- ${response.statusCode}");
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['status'] == 'OK') {
        cftToken = jsonDecode(response.body);
        result = 'success';
      } else {
        debugPrint(response.body);
        result = 'failure';
      }
    } else if (response.statusCode == 401) {
      result = 'logout';
    } else {
      debugPrint(response.body);
      result = 'failure';
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
      result = 'no internet';
    }
  }
  return result;
}

Map<String, dynamic> cfSuccessList = {};

cashFreePaymentSuccess() async {
  dynamic result;
  try {
    var response = await http.post(
        Uri.parse('${url}api/v1/payment/cashfree/add-money-to-wallet-webhooks'),
        headers: {
          'Authorization': 'Bearer ${bearerToken[0].token}',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          'orderId': cfSuccessList['orderId'],
          'orderAmount': cfSuccessList['orderAmount'],
          'referenceId': cfSuccessList['referenceId'],
          'txStatus': cfSuccessList['txStatus'],
          'paymentMode': cfSuccessList['paymentMode'],
          'txMsg': cfSuccessList['txMsg'],
          'txTime': cfSuccessList['txTime'],
          'signature': cfSuccessList['signature']
        }));
    print("cashFreePaymentSuccess::- ${Uri.parse('${url}api/v1/payment/cashfree/add-money-to-wallet-webhooks')}"
        "statusCode:- ${response.statusCode}");
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['success'] == true) {
        result = 'success';
        await getWalletHistory();
        await getUserDetails();
      } else {
        debugPrint(response.body);
        result = 'failure';
      }
    } else if (response.statusCode == 401) {
      result = 'logout';
    } else {
      debugPrint(response.body);
      result = 'failure';
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
      result = 'no internet';
    }
  }
  return result;
}

//edit user profile

updateProfile(name, email, usergender) async {
  dynamic result;
  try {
    var response = http.MultipartRequest(
      'POST',
      Uri.parse('${url}api/v1/user/profile'),
    );
    response.headers
        .addAll({'Authorization': 'Bearer ${bearerToken[0].token}'});

    if (profileImageFile != null) {
      response.files.add(await http.MultipartFile.fromPath(
          'profile_picture', profileImageFile));
    }
    response.fields['email'] = email;
    response.fields['name'] = name;
    response.fields['gender'] = (gender == 'male')
        ? 'male'
        : (gender == 'female')
        ? 'female'
        : 'others';
    var request = await response.send();
    var respon = await http.Response.fromStream(request);
    final val = jsonDecode(respon.body);
    print("cashFreePaymentSuccess::- ${Uri.parse('${url}api/v1/user/profile')}"
        "statusCode:- ${request.statusCode}");
    if (request.statusCode == 200) {
      result = 'success';
      if (val['success'] == true) {
        await getUserDetails();
      }
    } else if (request.statusCode == 401) {
      result = 'logout';
    } else if (request.statusCode == 422) {
      debugPrint(respon.body);
      var error = jsonDecode(respon.body)['errors'];
      result = error[error.keys.toList()[0]]
          .toString()
          .replaceAll('[', '')
          .replaceAll(']', '')
          .toString();
    } else {
      debugPrint(val);
      result = jsonDecode(respon.body)['message'];
    }
  } catch (e) {
    if (e is SocketException) {
      result = 'no internet';
    }
  }
  return result;
}

updateProfileWithoutImage(name, email, usergender) async {
  dynamic result;
  try {
    var response = http.MultipartRequest(
      'POST',
      Uri.parse('${url}api/v1/user/profile'),
    );
    response.headers
        .addAll({'Authorization': 'Bearer ${bearerToken[0].token}'});
    response.fields['email'] = email;
    response.fields['name'] = name;
    response.fields['gender'] = (gender == 'male')
        ? 'male'
        : (gender == 'female')
        ? 'female'
        : 'others';
    var request = await response.send();
    var respon = await http.Response.fromStream(request);
    final val = jsonDecode(respon.body);
    print("updateProfileWithoutImage::- ${Uri.parse('${url}api/v1/user/profile')}"
        "statusCode:- ${request.statusCode}");
    if (request.statusCode == 200) {
      result = 'success';
      if (val['success'] == true) {
        await getUserDetails();
      }
    } else if (request.statusCode == 401) {
      result = 'logout';
    } else if (request.statusCode == 422) {
      debugPrint(respon.body);
      var error = jsonDecode(respon.body)['errors'];
      result = error[error.keys.toList()[0]]
          .toString()
          .replaceAll('[', '')
          .replaceAll(']', '')
          .toString();
    } else {
      debugPrint(val);
      result = jsonDecode(respon.body)['message'];
    }
  } catch (e) {
    if (e is SocketException) {
      result = 'no internet';
    }
  }
  return result;
}

//internet true
internetTrue() {
  internet = true;
  valueNotifierHome.incrementNotifier();
}

//make complaint

List generalComplaintList = [];
getGeneralComplaint(type) async {
  dynamic result;
  try {
    var response = await http.get(
      Uri.parse('${url}api/v1/common/complaint-titles?complaint_type=$type'),
      headers: {'Authorization': 'Bearer ${bearerToken[0].token}'},
    );
    print("getGeneralComplaint::- ${Uri.parse('${url}api/v1/common/complaint-titles?complaint_type=$type')}"
        " statusCode:- ${response.statusCode}");
    if (response.statusCode == 200) {
      generalComplaintList = jsonDecode(response.body)['data'];
      result = 'success';
    } else if (response.statusCode == 401) {
      result = 'logout';
    } else {
      debugPrint(response.body);
      result = 'failed';
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
      result = 'no internet';
    }
  }
  return result;
}

makeGeneralComplaint(complaintDesc) async {
  dynamic result;
  try {
    var response =
    await http.post(Uri.parse('${url}api/v1/common/make-complaint'),
        headers: {
          'Authorization': 'Bearer ${bearerToken[0].token}',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          'complaint_title_id': generalComplaintList[complaintType]['id'],
          'description': complaintDesc,
        }));

    print("make-complaint_title_id: ${generalComplaintList[complaintType]['id']} description: ${complaintDesc}");
    print("makeGeneralComplaint::- ${Uri.parse('${url}api/v1/common/make-complaint')}"
        " statusCode:- ${response.statusCode}");
    if (response.statusCode == 200) {
      result = 'success';
    } else if (response.statusCode == 401) {
      result = 'logout';
    } else {
      debugPrint(response.body);
      result = 'failed';
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
      result = 'no internet';
    }
  }
  return result;
}

makeRequestComplaint() async {
  dynamic result;
  try {
    var response =
    await http.post(Uri.parse('${url}api/v1/common/make-complaint'),
        headers: {
          'Authorization': 'Bearer ${bearerToken[0].token}',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          'complaint_title_id': generalComplaintList[complaintType]['id'],
          'description': complaintDesc,
          'request_id': myHistory[selectedHistory]['id']
        }));
    print("makeRequestComplaint::- ${Uri.parse('${url}api/v1/common/make-complaint')}"
        "statusCode:- ${response.statusCode}");
    if (response.statusCode == 200) {
      result = 'success';
    } else if (response.statusCode == 401) {
      result = 'logout';
    } else {
      debugPrint(response.body);
      result = 'failed';
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
      result = 'no internet';
    }
  }
  return result;
}

//requestStream
StreamSubscription<DatabaseEvent>? requestStreamStart;
StreamSubscription<DatabaseEvent>? requestStreamEnd;
bool userCancelled = false;

streamRequest() {
  requestStreamEnd?.cancel();
  requestStreamStart?.cancel();
  rideStreamUpdate?.cancel();
  rideStreamStart?.cancel();
  requestStreamStart = null;
  requestStreamEnd = null;
  rideStreamUpdate = null;
  rideStreamStart = null;

  requestStreamStart = FirebaseDatabase.instance
      .ref('request-meta')
      .child(userRequestData['id'])
      .onChildRemoved
      .handleError((onError) {
    requestStreamStart?.cancel();
  }).listen((event) async {
    ismulitipleride = true;
    getUserDetails(id: userRequestData['id']);
    requestStreamEnd?.cancel();
    requestStreamStart?.cancel();
  });
}

StreamSubscription<DatabaseEvent>? rideStreamStart;

StreamSubscription<DatabaseEvent>? rideStreamUpdate;

streamRide() {
  waitingTime = 0;
  requestStreamEnd?.cancel();
  requestStreamStart?.cancel();
  rideStreamUpdate?.cancel();
  rideStreamStart?.cancel();
  requestStreamStart = null;
  requestStreamEnd = null;
  rideStreamUpdate = null;
  rideStreamStart = null;
  rideStreamUpdate = FirebaseDatabase.instance
      .ref('requests/${userRequestData['id']}')
      .onChildChanged
      .handleError((onError) {
    rideStreamUpdate?.cancel();
  }).listen((DatabaseEvent event) async {
    if (event.snapshot.key.toString() == 'modified_by_driver') {
      ismulitipleride = true;
      getUserDetails(id: userRequestData['id']);
    } else if (event.snapshot.key.toString() == 'message_by_driver') {
      getCurrentMessages();
    } else if (event.snapshot.key.toString() == 'cancelled_by_driver') {
      requestCancelledByDriver = true;
      ismulitipleride = true;
      // getUserDetails(id: userRequestData['id']);
      getUserDetails();
    } else if (event.snapshot.key.toString() == 'total_waiting_time') {
      var val = event.snapshot.value.toString();
      waitingTime = int.parse(val);
      valueNotifierBook.incrementNotifier();
    } else if (event.snapshot.key.toString() == 'is_accept') {
      getUserDetails(id: userRequestData['id']);
    }
  });

  rideStreamStart = FirebaseDatabase.instance
      .ref('requests/${userRequestData['id']}')
      .onChildAdded
      .handleError((onError) {
    rideStreamStart?.cancel();
  }).listen((DatabaseEvent event) async {
    // if (event.snapshot.key.toString() == 'message_by_driver') {
    //   getCurrentMessages();
    // } else
    if (event.snapshot.key.toString() == 'cancelled_by_driver') {
      requestCancelledByDriver = true;
      ismulitipleride = true;
      // getUserDetails(id: userRequestData['id']);
      getUserDetails();
    } else if (event.snapshot.key.toString() == 'modified_by_driver') {
      ismulitipleride = true;
      getUserDetails(id: userRequestData['id']);
    } else if (event.snapshot.key.toString() == 'total_waiting_time') {
      var val = event.snapshot.value.toString();
      waitingTime = int.parse(val);
      valueNotifierBook.incrementNotifier();
    } else if (event.snapshot.key.toString() == 'is_accept') {
      getUserDetails(id: userRequestData['id']);
    }
  });
}

userDelete() async {
  dynamic result;
  try {
    var response = await http
        .post(Uri.parse('${url}api/v1/user/delete-user-account'), headers: {
      'Authorization': 'Bearer ${bearerToken[0].token}',
      'Content-Type': 'application/json'
    });
    print("userDelete::- ${Uri.parse('${url}api/v1/user/delete-user-account')}"
        "statusCode:- ${response.statusCode}");
    if (response.statusCode == 200) {
      pref.remove('Bearer');

      result = 'success';
    } else if (response.statusCode == 401) {
      result = 'logout';
    } else {
      debugPrint(response.body);
      result = 'failure';
    }
  } catch (e) {
    if (e is SocketException) {
      result = 'no internet';
      internet = false;
    }
  }
  return result;
}

//request notification
List notificationHistory = [];
Map<String, dynamic> notificationHistoryPage = {};

getnotificationHistory() async {
  dynamic result;

  try {
    var response = await http.get(
        Uri.parse('${url}api/v1/notifications/get-notification'),
        headers: {'Authorization': 'Bearer ${bearerToken[0].token}'});
    print("getnotificationHistory::- ${Uri.parse('${url}api/v1/notifications/get-notification')}"
        "statusCode:- ${response.statusCode}");
    if (response.statusCode == 200) {
      notificationHistory = jsonDecode(response.body)['data'];
      notificationHistoryPage = jsonDecode(response.body)['meta'];
      result = 'success';
      valueNotifierHome.incrementNotifier();
    } else if (response.statusCode == 401) {
      result = 'logout';
    } else {
      debugPrint(response.body);
      result = 'failure';
      valueNotifierHome.incrementNotifier();
    }
    notificationHistory.removeWhere((element) => element.isEmpty);
  } catch (e) {
    if (e is SocketException) {
      result = 'no internet';

      internet = false;
      valueNotifierHome.incrementNotifier();
    }
  }
  return result;
}

getNotificationPages(id) async {
  dynamic result;

  try {
    var response = await http.get(
        Uri.parse('${url}api/v1/notifications/get-notification?$id'),
        headers: {'Authorization': 'Bearer ${bearerToken[0].token}'});
    print("getNotificationPages::- ${Uri.parse('${url}api/v1/notifications/get-notification?$id')}"
        "statusCode:- ${response.statusCode}");
    if (response.statusCode == 200) {
      List list = jsonDecode(response.body)['data'];
      // ignore: avoid_function_literals_in_foreach_calls
      list.forEach((element) {
        notificationHistory.add(element);
      });
      notificationHistoryPage = jsonDecode(response.body)['meta'];
      result = 'success';
      valueNotifierHome.incrementNotifier();
    } else if (response.statusCode == 401) {
      result = 'logout';
    } else {
      debugPrint(response.body);
      result = 'failure';
      valueNotifierHome.incrementNotifier();
    }
  } catch (e) {
    if (e is SocketException) {
      result = 'no internet';

      internet = false;
      valueNotifierHome.incrementNotifier();
    }
  }
  return result;
}

//delete notification
deleteNotification(id) async {
  dynamic result;

  try {
    var response = await http.get(
        Uri.parse('${url}api/v1/notifications/delete-notification/$id'),
        headers: {'Authorization': 'Bearer ${bearerToken[0].token}'});
    print("deleteNotification::- ${Uri.parse('${url}api/v1/notifications/delete-notification/$id')}"
        "statusCode:- ${response.statusCode}");
    if (response.statusCode == 200) {
      result = 'success';
      valueNotifierHome.incrementNotifier();
    } else if (response.statusCode == 401) {
      result = 'logout';
    } else {
      debugPrint(response.body);
      result = 'failure';
      valueNotifierHome.incrementNotifier();
    }
  } catch (e) {
    if (e is SocketException) {
      result = 'no internet';

      internet = false;
      valueNotifierHome.incrementNotifier();
    }
  }
  return result;
}

sharewalletfun({mobile, role, amount}) async {
  dynamic result;
  try {
    var response = await http.post(
        Uri.parse('${url}api/v1/payment/wallet/transfer-money-from-wallet'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${bearerToken[0].token}',
        },
        body: jsonEncode({'mobile': mobile, 'role': role, 'amount': amount}));
    print("token::- ${bearerToken[0].token}");
    print("sharewalletfun::- ${Uri.parse('${url}api/v1/payment/wallet/transfer-money-from-wallet')}"
        " statusCode:- ${response.statusCode}");
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['success'] == true) {
        result = 'success';
      } else {
        debugPrint(response.body);
        result = 'failed';
      }
    } else if (response.statusCode == 401) {
      result = 'logout';
    } else {
      debugPrint(response.body);
      result = jsonDecode(response.body)['message'];
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
      result = 'no internet';
    }
  }
  return result;
}

sendOTPtoEmail(String email) async {
  dynamic result;
  try {
    var response = await http
        .post(Uri.parse('${url}api/v1/send-mail-otp'), body: {'email': email});
    print("sendOTPtoEmail::- ${Uri.parse('${url}api/v1/send-mail-otp')}"
        "statusCode:- ${response.statusCode}");
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['success'] == true) {
        result = 'success';
      } else {
        debugPrint(response.body);
        result = 'failed';
      }
    } else if (response.statusCode == 422) {
      debugPrint(response.body);
      var error = jsonDecode(response.body)['errors'];
      result = error[error.keys.toList()[0]]
          .toString()
          .replaceAll('[', '')
          .replaceAll(']', '')
          .toString();
    } else {
      result = 'Something went wrong';
    }
    return result;
  } catch (e) {
    if (e is SocketException) {
      internet = false;
    }
  }
}

emailVerify(String email, otpNumber) async {
  dynamic val;
  try {
    var response = await http.post(Uri.parse('${url}api/v1/validate-email-otp'),
        body: {"email": email, "otp": otpNumber});
    print("emailVerify::- ${Uri.parse('${url}api/v1/validate-email-otp')}"
        "statusCode:- ${response.statusCode}");
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['success'] == true) {
        val = 'success';
      } else {
        debugPrint(response.body);
        val = 'failed';
      }
    } else if (response.statusCode == 422) {
      debugPrint(response.body);
      var error = jsonDecode(response.body)['errors'];
      val = error[error.keys.toList()[0]]
          .toString()
          .replaceAll('[', '')
          .replaceAll(']', '')
          .toString();
    } else {
      val = 'Something went wrong';
    }
    return val;
  } catch (e) {
    if (e is SocketException) {
      internet = false;
    }
  }
}

paymentMethod(payment) async {
  dynamic result;
  try {
    var response =
    await http.post(Uri.parse('${url}api/v1/request/user/payment-method'),
        headers: {
          'Authorization': 'Bearer ${bearerToken[0].token}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'request_id': userRequestData['id'],
          'payment_opt': (payment == 'card')
              ? 0
              : (payment == 'cash')
              ? 1
              : (payment == 'wallet')
              ? 2
              : 4
        }));
    print("paymentMethod::- ${Uri.parse('${url}api/v1/request/user/payment-method')}"
        "statusCode:- ${response.statusCode}");

    if (response.statusCode == 200) {
      FirebaseDatabase.instance
          .ref('requests')
          .child(userRequestData['id'])
          .update({'modified_by_user': ServerValue.timestamp});
      ismulitipleride = true;
      await getUserDetails(id: userRequestData['id']);
      result = 'success';
      valueNotifierBook.incrementNotifier();
    } else if (response.statusCode == 401) {
      result = 'logout';
    } else {
      debugPrint(response.body);
      result = 'failed';
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
    }
  }
  return result;
}

String isemailmodule = '1';
bool isCheckFireBaseOTP = true;
getemailmodule() async {
  dynamic res;
  try {
    final response = await http.get(
      Uri.parse('${url}api/v1/common/modules'),
    );

    print("getemailmodule::- ${Uri.parse('${url}api/v1/common/modules')} "
        "statusCode:- ${response.statusCode}");

    if (response.statusCode == 200) {
      isemailmodule = jsonDecode(response.body)['enable_email_otp'];
      isCheckFireBaseOTP = jsonDecode(response.body)['firebase_otp_enabled'];

      res = 'success';
    } else {
      debugPrint(response.body);
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
      res = 'no internet';
    }
  }

  return res;
}

sendOTPtoMobile(String mobile, String countryCode) async {
  dynamic result;
  try {
    var response = await http.post(Uri.parse('${url}api/v1/mobile-otp'),
        body: {'mobile': mobile, 'country_code': countryCode});

    print("sendOTPtoMobile::- ${Uri.parse('${url}api/v1/mobile-otp')}"
        "statusCode:- ${response.statusCode}");
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['success'] == true) {
        result = 'success';
      } else {
        debugPrint(response.body);
        result = 'something went wrong';
      }
    } else if (response.statusCode == 422) {
      debugPrint(response.body);
      var error = jsonDecode(response.body)['errors'];
      result = error[error.keys.toList()[0]]
          .toString()
          .replaceAll('[', '')
          .replaceAll(']', '')
          .toString();
    } else {
      result = 'something went wrong';
    }
    return result;
  } catch (e) {
    if (e is SocketException) {
      internet = false;
    }
  }
}

validateSmsOtp(String mobile, String otp) async {
  dynamic result;
  try {
    var response = await http.post(Uri.parse('${url}api/v1/validate-otp'),
        body: {'mobile': mobile, 'otp': otp});

    print("validateSmsOtp::- ${Uri.parse('${url}api/v1/validate-otp')}"
        "statusCode:- ${response.statusCode}");
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['success'] == true) {
        result = 'success';
      } else {
        debugPrint(response.body);
        result = 'something went wrong';
      }
    } else if (response.statusCode == 422) {
      debugPrint(response.body);
      var error = jsonDecode(response.body)['errors'];
      result = error[error.keys.toList()[0]]
          .toString()
          .replaceAll('[', '')
          .replaceAll(']', '')
          .toString();
    } else {
      result = 'something went wrong';
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
    }
  }
  return result;
}

List outStationList = [];
outStationListFun() async {
  dynamic result;
  try {
    final response = await http.get(
        Uri.parse('${url}api/v1/request/outstation_rides'),
        headers: {'Authorization': 'Bearer ${bearerToken[0].token}'});
    print("outStationListFun::- ${Uri.parse('${url}api/v1/request/outstation_rides')}"
        "statusCode:- ${response.statusCode}");
    if (response.statusCode == 200) {
      outStationList = jsonDecode(response.body)['data'];
      result = 'success';
      valueNotifierBook.incrementNotifier();
    } else if (response.statusCode == 401) {
      result = 'logout';
    } else {
      debugPrint(response.body);
      result = 'failure';
      valueNotifierBook.incrementNotifier();
    }
    outStationList.removeWhere((element) => element.isEmpty);
  } catch (e) {
    if (e is SocketException) {
      result = 'no internet';

      internet = false;
      valueNotifierBook.incrementNotifier();
    }
  }

  return result;
}

List loginImages = [];
getLandingImages() async {
  dynamic result;
  try {
    final response = await http.get(Uri.parse('${url}api/v1/countries-new'));
    print("getLandingImages::- ${Uri.parse('${url}api/v1/countries-new')} "
        "statusCode:- ${response.statusCode}");
    if (response.statusCode == 200) {
      countries = jsonDecode(response.body)['data']['countries']['data'];
      loginImages.clear();
      List _images = jsonDecode(response.body)['data']['onboarding']['data'];
      for (var element in _images) {
        if (element['screen'] == 'user') {
          loginImages.add(element);
        }
      }
      phcode =
      (countries.where((element) => element['default'] == true).isNotEmpty)
          ? countries.indexWhere((element) => element['default'] == true)
          : 0;
      result = 'success';
    } else {
      debugPrint(response.body);
      result = 'error';
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
      result = 'no internet';
    }
  }
  return result;
}

Future<void> saveListToPrefs(List<dynamic> list) async {
  final prefs = await SharedPreferences.getInstance();
  // Serialize the list to JSON
  final jsonString = json.encode(list);
  // Save the JSON string to shared preferences
  await prefs.setString('outstationpush', jsonString);
}

// Define a function to load the list from shared preferences
Future<List<dynamic>> loadListFromPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  // Get the JSON string from shared preferences
  final jsonString = prefs.getString('outstationpush');
  if (jsonString != null) {
    // Parse the JSON string back into a list
    final List<dynamic> list = json.decode(jsonString);
    return list;
  }
  // Return an empty list if no data was found in shared preferences
  return [];
}

List outStationDriver = [];

//push notification
dynamic outStationPushStream;
outStationPush() async {
  outStationPushStream = FirebaseDatabase.instance
      .ref()
      .child('bid-meta')
      .orderByChild('user_id')
      .equalTo(userDetails['id'].toString())
      .onValue
      .listen((event) async {
    if (jsonDecode(jsonEncode(event.snapshot.value)) != null) {
      Map rides = jsonDecode(jsonEncode(event.snapshot.value));
      rides.forEach((key, value) {
        if (value['drivers'] != null) {
          Map drivers = value['drivers'];
          drivers.forEach((k, v) {
            if (outStationDriver
                .where((e) => e['id'] == key && e['driver'] == k)
                .isEmpty) {
              outStationDriver
                  .add({'id': key, 'driver': k, 'price': v['price']});
              saveListToPrefs(outStationDriver);
              // pref.setString('outstationpush', json.encode(outStationDriver));
              RemoteNotification noti = RemoteNotification(
                  title: languages[choosenLanguage]['text_got_new_driver'],
                  body:
                  '${v['driver_name']} ${languages[choosenLanguage]['text_bid_ride_amount_of']} ${v['price']}');
              showRideNotification(noti);
            }
          });
        }
      });
    }
  });
}
