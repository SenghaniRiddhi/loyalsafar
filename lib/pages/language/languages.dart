import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../functions/functions.dart';
import '../../styles/styles.dart';
import '../../translations/translation.dart';
import '../../widgets/appbar.dart';
import '../../widgets/widgets.dart';
import '../login/login.dart';

class Languages extends StatefulWidget {
  const Languages({super.key});

  @override
  State<Languages> createState() => _LanguagesState();
}

class _LanguagesState extends State<Languages> {
  @override
  void initState() {
    choosenLanguage = 'en';
    languageDirection = 'ltr';
    super.initState();
  }

//navigate
  navigate() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Login()));
  }

  final Map<String, String> languageFlags = {
    'en': 'assets/icons/united-states-of-america.png',
    'es': 'assets/icons/spain.png',
    'fr': 'assets/icons/france.png',
    'it': 'assets/icons/italy.png',
    'de': 'assets/icons/germany.png',
    'hi': 'assets/icons/india.png',
    'ar': 'assets/icons/united-arab-emirates.png',
    'pt': 'assets/icons/portugal.png',
    'ru': 'assets/icons/russia.png',
    // Add more languages and their respective flag assets
  };

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(

      body: SingleChildScrollView(
        child: Container(
          color: page,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              appBarWidget(context: context,
                  backgroundIcon: Colors.grey[200]!, title: "", showTitle: false),

              Material(
                  child: Directionality(
                textDirection:
                    (languageDirection == 'rtl') ? TextDirection.rtl : TextDirection.ltr,
                child: Container(
                  height: media.height * 1,
                  width: media.width * 1,
                  color: page,

                  child: Column(
                    children: [
                      SizedBox(
                        width: media.width * 0.8,
                        height: media.height * 0.12,
                        child: Image.asset(
                          'assets/icons/languageIcons.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      Container(
                        height: media.width * 0.11 ,
                        width: media.width * 1,
                        // padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                        color: topBar,
                        child: Stack(
                          children: [
                            Container(
                              height: media.width * 0.11,
                              width: media.width * 1,
                              alignment: Alignment.center,
                              child: Text(
                                (choosenLanguage.isEmpty)
                                    ? 'Choose Language'
                                    : languages[choosenLanguage]['text_choose_language'],
                                style:  GoogleFonts.inter(
                                  fontSize: font18Size,
                                  color: headingColors,
                                  fontWeight: FontWeight.w600,
                                ) ,

                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(),
                      // SizedBox(
                      //   height: media.width * 0.1,
                      // ),
                      //languages list
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(media.width * 0.05, 0,
                              media.width * 0.05, 0),
                          child: Column(
                            children: languages
                                .map((i, value) => MapEntry(
                                i,
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      choosenLanguage = i;
                                      if (choosenLanguage == 'ar' ||
                                          choosenLanguage == 'ur' ||
                                          choosenLanguage == 'iw') {
                                        languageDirection = 'rtl';
                                      } else {
                                        languageDirection = 'ltr';
                                      }
                                    });
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(media.width * 0.025),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  height: media.width * 0.07,
                                                  width: media.width * 0.07,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    // border: Border.all(color: Colors.black),
                                                    image: DecorationImage(
                                                      image: AssetImage(
                                                          languageFlags[i] ??
                                                              'assets/icons/france.png'
                                                        //'assets/flags/default.png', // Default flag if not found
                                                      ),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: media.width * 0.05,),
                                                MyText(
                                                  text: languagesCode
                                                      .firstWhere(
                                                          (e) => e['code'] == i)['name']
                                                      .toString(),
                                                  size: font16Size,
                                                  color: headingColors,
                                                  fontweight: FontWeight.w500,
                                                ),
                                              ],
                                            ),

                                            Container(
                                              height: media.width * 0.05,
                                              width: media.width * 0.05,
                                              alignment: Alignment.center,
                                              child: (choosenLanguage == i)
                                                  ? Icon(Icons.check,color: Color(0xff222222), )
                                                  : Container(),
                                            )
                                          ],
                                        ),
                                      ),
                                      Divider(),
                                    ],
                                  ),
                                )))
                                .values
                                .toList(),
                          ),
                        ),
                      ),
                      // const SizedBox(height: 20),
                      //button
                      // (choosenLanguage != '')
                      //     ? Button(
                      //         onTap: () async {
                      //           await getlangid();
                      //           pref.setString('languageDirection', languageDirection);
                      //           pref.setString('choosenLanguage', choosenLanguage);
                      //           navigate();
                      //         },
                      //         text: languages[choosenLanguage]['text_confirm'])
                      //     : Container(),
                    ],
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: ()async{
          await getlangid();
          pref.setString('languageDirection', languageDirection);
          pref.setString('choosenLanguage', choosenLanguage);
          navigate();
        },
        child: Container(
          color: buttonColors,
          width: media.width,
          height: media.height*0.1,
          alignment: Alignment.topCenter,
          padding: EdgeInsets.all(20),
          child: MyText(
            text: "Done",
            size: font18Size,
            color: Color(0xff030303),
            fontweight: FontWeight.w600,
          ),

        ),
      ),
    );
  }
}
