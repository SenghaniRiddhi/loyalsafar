import 'package:flutter/material.dart';
import '../../functions/functions.dart';
import '../../styles/styles.dart';
import '../../translations/translation.dart';
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
    'en': 'assets/flags/usa.png', // English - USA flag
    'ar': 'assets/flags/saudi_arabia.png', // Arabic - Saudi Arabia flag
    'ur': 'assets/flags/pakistan.png', // Urdu - Pakistan flag
    'iw': 'assets/flags/israel.png', // Hebrew - Israel flag
    'fr': 'assets/flags/france.png', // French - France flag
    // Add more languages and their respective flag assets
  };

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Material(
        child: Directionality(
      textDirection:
          (languageDirection == 'rtl') ? TextDirection.rtl : TextDirection.ltr,
      child: Container(
        padding: EdgeInsets.fromLTRB(media.width * 0.05, media.width * 0.05,
            media.width * 0.05, media.width * 0.05),
        height: media.height * 1,
        width: media.width * 1,
        color: page,
        child: Column(
          children: [

            SizedBox(
              height: media.width * 0.05,
            ),
            SizedBox(
              width: media.width * 0.9,
              height: media.height * 0.16,
              child: Image.asset(
                'assets/images/selectLanguage.png',
                fit: BoxFit.contain,
              ),
            ),
            Container(
              height: media.width * 0.11 + MediaQuery.of(context).padding.top,
              width: media.width * 1,
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              color: topBar,
              child: Stack(
                children: [
                  Container(
                    height: media.width * 0.11,
                    width: media.width * 1,
                    alignment: Alignment.center,
                    child: MyText(
                      text: (choosenLanguage.isEmpty)
                          ? 'Choose Language'
                          : languages[choosenLanguage]['text_choose_language'],
                      size: media.width * sixteen,
                      fontweight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: media.width * 0.1,
            ),
            //languages list
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
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
                                              border: Border.all(color: Colors.black),
                                              image: DecorationImage(
                                                image: AssetImage(
                                                  languageFlags[i] ??
                                                      'assets/images/call.png'
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
                                            size: media.width * sixteen,
                                          ),
                                        ],
                                      ),

                                      Container(
                                        height: media.width * 0.05,
                                        width: media.width * 0.05,

                                        alignment: Alignment.center,
                                        child: (choosenLanguage == i)
                                            ? Icon(Icons.arrow_forward_ios_outlined,color: Color(0xff222222), )
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
            const SizedBox(height: 20),
            //button
            (choosenLanguage != '')
                ? Button(
                    onTap: () async {
                      await getlangid();
                      pref.setString('languageDirection', languageDirection);
                      pref.setString('choosenLanguage', choosenLanguage);
                      navigate();
                    },
                    text: languages[choosenLanguage]['text_confirm'])
                : Container(),
          ],
        ),
      ),
    ));
  }
}
