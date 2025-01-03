import 'package:flutter/material.dart';
import 'package:flutter_user/pages/login/login.dart';
import 'package:flutter_user/translations/translation.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../functions/functions.dart';
import '../../styles/styles.dart';
import '../../widgets/appbar.dart';
import '../../widgets/bottom_sheet_content.dart';
import '../../widgets/widgets.dart';
import '../loadingPage/loading.dart';
import '../login/loginScreen.dart';
import '../profile/selectContact.dart';
import 'pickcontacts.dart';

class Sos extends StatefulWidget {
  const Sos({super.key});

  @override
  State<Sos> createState() => _SosState();
}

class _SosState extends State<Sos> {
  bool _isDeleting = false;
  bool _isLoading = false;
  String _deleteId = '';

  navigateLogout() {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Loginscreen()),
          (route) => false);
    });
  }

  String getInitials(String fullName) {
    // Split the name by spaces
    List<String> words = fullName.split(' ');

    // Extract the first character from each word, convert to uppercase
    String initials = words.map((word) => word[0].toUpperCase()).join();

    return initials;
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return PopScope(
      canPop: true,
      child: Material(
        child: ValueListenableBuilder(
            valueListenable: valueNotifierHome.value,
            builder: (context, value, child) {
              return Directionality(
                textDirection: (languageDirection == 'rtl')
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                child: Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          left: media.width * 0.03, right: media.width * 0.03),
                      height: media.height * 1,
                      width: media.width * 1,
                      color: (isDarkTheme)
                          ? (sosData
                                  .where((element) =>
                                      element['user_type'] != 'admin')
                                  .isEmpty)
                              ? Colors.black
                              : page
                          : Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                              height: media.width * 0.12),
                          Stack(
                            children: [
                              // Container(
                              //   padding:
                              //       EdgeInsets.only(bottom: media.width * 0.05),
                              //   width: media.width * 1,
                              //   alignment: Alignment.center,
                              //   child: MyText(
                              //     text: languages[choosenLanguage]['text_sos'],
                              //     size: media.width * twenty,
                              //     fontweight: FontWeight.w600,
                              //   ),
                              // ),
                              Positioned(
                                  child: appBarWithoutHeightWidget(context: context,
                                      onTaps: (){
                                        Navigator.pop(context, true);
                                      },
                                      backgroundIcon: Color(0xffECECEC), title: "",iconColors: iconGrayColors),

                              )
                            ],
                          ),
                          (sosData
                              .where((element) =>
                          element['user_type'] != 'admin')
                              .isNotEmpty)?
                          Column(children: [
                            SizedBox(
                              height: media.width * 0.03,
                            ),
                            Center(
                                child: Container(
                                  height: media.width * 0.3,
                                  width: media.width * 0.3,
                                  child: Image.asset("assets/icons/emergencyContact.png",fit: BoxFit.cover,),
                                )
                            ),


                            Center(
                              child: MyText(
                                text: 'Set Emergency Contact',
                                size: font22Size,
                                fontweight: FontWeight.w700,
                                textAlign: TextAlign.center,
                                color: Color(0xff303030),
                              ),
                            ),

                            SizedBox(
                              height: media.width * 0.03,
                            ),

                            Center(
                              child: Padding(
                                padding:  EdgeInsets.symmetric(horizontal: media.width * 0.04),
                                child: MyText(
                                  text: '''Please enter your emergency contact numbers so that you can be called instantly during any services
                            ''',
                                  size: font16Size,
                                  fontweight: FontWeight.w400,
                                  textAlign: TextAlign.center,
                                  color: normalText1Colors,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: media.width * 0.02,
                            ),
                          ],):SizedBox(),

                          Expanded(
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                children: [
                                  (sosData
                                      .where((element) =>
                                  element['user_type'] != 'admin')
                                      .isNotEmpty)?
                                  Divider(color: Color(0xffEBEBEB),):SizedBox(),
                                  SizedBox(
                                    height: media.width * 0.025,
                                  ),
                                  (sosData
                                          .where((element) =>
                                              element['user_type'] != 'admin')
                                          .isNotEmpty)
                                      ? Column(
                                          children: sosData
                                              .asMap()
                                              .map((i, value) {
                                                return MapEntry(
                                                    i,
                                                    (sosData[i]['user_type'] !=
                                                            'admin')
                                                        ? Container(
                                                      padding: EdgeInsets.symmetric(vertical: media
                                                                      .width *
                                                                  0.02),
                                                            // padding: EdgeInsets
                                                            //     .all(media
                                                            //             .width *
                                                            //         0.02),
                                                            decoration: BoxDecoration(
                                                                // border: Border.all(
                                                                //     color:
                                                                //         hintColor)
                                                            ),
                                                            margin: EdgeInsets.only(
                                                                bottom: media
                                                                        .width *
                                                                    0.02),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Container(
                                                                  height: media.width * 0.13,
                                                                  width: media.width * 0.13,
                                                                  decoration: BoxDecoration(
                                                                    shape: BoxShape.circle,
                                                                    color: normalText1Colors,
                                                                  ),
                                                                  alignment: Alignment.center,
                                                                  child: MyText(
                                                                    text: getInitials(sosData[i]['name']
                                                                        .toString()),

                                                                    size: font16Size,
                                                                    fontweight: FontWeight.w600,
                                                                    color: whiteColors,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: media
                                                                          .width *
                                                                      0.05,
                                                                ),
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    SizedBox(
                                                                      width: media.width * 0.6,
                                                                      child:
                                                                          MyText(text: sosData[i]['name'],
                                                                            size: font16Size,
                                                                            fontweight: FontWeight.w600,
                                                                            color: Color(0xff303030),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: media
                                                                              .width *
                                                                          0.01,
                                                                    ),
                                                                    MyText(
                                                                      text: sosData[i]['number'],
                                                                      size: font16Size,
                                                                      fontweight: FontWeight.w400,
                                                                      color: Color(0xff697176),
                                                                    ),
                                                                    SizedBox(
                                                                      height: media
                                                                              .width *
                                                                          0.01,
                                                                    ),
                                                                  ],
                                                                ),
                                                                InkWell(
                                                                    onTap: () {

                                                                      showDialog(
                                                                          context: context,
                                                                          builder: (context) =>
                                                                          Dialog(
                                                                            backgroundColor: Colors.white,
                                                                            shape: RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(16),
                                                                            ),
                                                                            child: Padding(
                                                                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                                                                              child: Column(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                children: [
                                                                                  SizedBox(height: media.width*0.03),
                                                                                  Container(
                                                                                      width: media.width*0.15,
                                                                                      height: media.width*0.15,
                                                                                      child: Image.asset('assets/icons/remove.png'.toString(),fit: BoxFit.cover,)),
                                                                                  const SizedBox(height: 05),
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                    child: MyText(text: 'Remove?',
                                                                                        textAlign: TextAlign.center,
                                                                                      size: font24Size,
                                                                                        fontweight: FontWeight.w800,
                                                                                        color: headingColors
                                                                                    )

                                                                                  ),
                                                                                  const SizedBox(height: 8),
                                                                                  Padding(
                                                                                    padding:  EdgeInsets.symmetric(horizontal: media.width*0.04),
                                                                                    child: MyText(text: '''Are you sire do you want to remove from emergency Contact list''',
                                                                                        textAlign: TextAlign.center,
                                                                                        size: font16Size,
                                                                                        fontweight: FontWeight.w400,
                                                                                        color: headingColors
                                                                                    )

                                                                                  ),
                                                                                  const SizedBox(height: 35),
                                                                                  Padding(
                                                                                    padding:  EdgeInsets.symmetric(horizontal: media.width*0.04),
                                                                                    child: SizedBox(
                                                                                      width: double.infinity,
                                                                                      child: ElevatedButton(
                                                                                        style: ElevatedButton.styleFrom(
                                                                                          backgroundColor: iconColors,
                                                                                          shape: RoundedRectangleBorder(
                                                                                            borderRadius: BorderRadius.circular(10),
                                                                                          ),
                                                                                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                                                                        ),
                                                                                        onPressed: () async{

                                                                                            setState(() {
                                                                                              _deleteId =
                                                                                              sosData[i]['id'];

                                                                                            });

                                                                                            var val =
                                                                                                await deleteSos(_deleteId);
                                                                                            if (val == 'success') {
                                                                                              setState(() {
                                                                                                Navigator.pop(context);
                                                                                              });
                                                                                            } else if (val == 'logout') {
                                                                                              navigateLogout();
                                                                                            }




                                                                                        },
                                                                                        child: MyText(text: 'Yes,Remove',
                                                                                            textAlign: TextAlign.center,
                                                                                            size: font18Size,
                                                                                            fontweight: FontWeight.w600,
                                                                                            color: Colors.white
                                                                                        )

                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(height: media.width*0.05),
                                                                                  Padding(
                                                                                    padding:  EdgeInsets.symmetric(horizontal: media.width*0.04),
                                                                                    child: SizedBox(
                                                                                      width: double.infinity,
                                                                                      child: ElevatedButton(

                                                                                        style: ElevatedButton.styleFrom(
                                                                                          backgroundColor: Colors.white,
                                                                                          shape: RoundedRectangleBorder(
                                                                                            borderRadius: BorderRadius.circular(10),
                                                                                          ),
                                                                                          side:  BorderSide(
                                                                                            color: Color(0xffC6C6C6), // Set your border color
                                                                                          ),
                                                                                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                                                                        ),
                                                                                        onPressed: () {
                                                                                          Navigator.pop(context);
                                                                                          // Handle account deactivation
                                                                                        },
                                                                                        child:  MyText(text: 'Cancel',
                                                                                            textAlign: TextAlign.center,
                                                                                            size: font16Size,
                                                                                            fontweight: FontWeight.w700,
                                                                                            color:Color(0xff5E5E5E)
                                                                                        )

                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(height: media.width*0.03),

                                                                                ],
                                                                              ),
                                                                            ),

                                                                          )
                                                                      );
                                                                      },
                                                                    child: Icon(
                                                                        Icons.remove_circle_outline_rounded,
                                                                        size: 25,
                                                                        color: Color(0xffFF176B)))
                                                              ],
                                                            ),
                                                          )
                                                        : Container());
                                              })
                                              .values
                                              .toList(),
                                        )
                                      : Container(
                                        height:media.height*0.7 ,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                        SizedBox(
                                          height: media.width * 0.03,
                                        ),
                                        Container(
                                          height: media.width * 0.3,
                                          width: media.width * 0.3,
                                          child: Image.asset("assets/icons/emergencyContact.png",fit: BoxFit.cover,),
                                        ),
                                        MyText(
                                          text: 'Set Emergency Contact',
                                          size: font22Size,
                                          fontweight: FontWeight.w700,
                                          textAlign: TextAlign.center,
                                          color: Color(0xff303030),
                                        ),

                                        SizedBox(
                                          height: media.width * 0.03,
                                        ),
                                        Padding(
                                          padding:  EdgeInsets.symmetric(horizontal: media.width * 0.04),
                                          child: MyText(
                                            text: '''Please enter your emergency contact numbers so that you can be called instantly during any services
                                                                    ''',
                                            size: font16Size,
                                            fontweight: FontWeight.w400,
                                            textAlign: TextAlign.center,
                                            color: normalText1Colors,
                                          ),
                                        ),
                                          (sosData
                                              .where((element) =>
                                          element['user_type'] != 'admin')
                                              .length <
                                              4 || sosData
                                              .where((element) =>
                                          element['user_type'] != 'admin')
                                              .isNotEmpty)
                                              ?
                                          GestureDetector(
                                            onTap: () async {

                                              var nav = await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                      const PickContact(
                                                        from: '1',
                                                      )));

                                              // var nav = await Navigator.push(
                                              //     context,
                                              //     MaterialPageRoute(
                                              //         builder: (context) =>
                                              //          SelectContactScreen(
                                              //           // from: '1',
                                              //         )));

                                              if (nav) {
                                                setState(() {});
                                              }
                                            },
                                            child: Container(
                                              // width: (widget.width != null) ? widget.width : media.width * 0.9,
                                                padding: EdgeInsets.symmetric(horizontal: media.width * 0.035,
                                                    vertical: media.width * 0.025),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(12.0),
                                                  color:buttonColors ,
                                                ),

                                                child: Wrap(
                                                  children: [
                                                    Icon(Icons.person_add_alt_1,size: 20,color: Color(0xff080204),),
                                                    SizedBox(width: 10,),
                                                    MyText(text: "Add Contact",size:font13Size,
                                                      fontweight: FontWeight.w500,color: Color(0xff080204),),
                                                  ],
                                                )

                                            ),
                                          ):SizedBox(),
                                            ],
                                     ),
                                      ),

                                ],
                              ),
                            ),
                          ),

                          //add sos button
                          (sosData
                                      .where((element) =>
                                          element['user_type'] != 'admin')
                                      .length <
                                  4 && sosData
                              .where((element) =>
                          element['user_type'] != 'admin')
                              .isNotEmpty)
                              ? Center(
                                child: GestureDetector(
                                  onTap: () async {
                                    // var nav = await Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             SelectContactScreen(
                                    //               // from: '1',
                                    //             )));
                                var nav = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                        const PickContact(
                                          from: '1',
                                        )));
                                if (nav) {
                                  setState(() {});
                                }
                                                            },
                                  child: Container(
                                 // width: (widget.width != null) ? widget.width : media.width * 0.9,
                                  padding: EdgeInsets.symmetric(horizontal: media.width * 0.035,
                                      vertical: media.width * 0.025),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.0),
                                    color:buttonColors ,
                                  ),

                                  child: Wrap(
                                    children: [
                                      Icon(Icons.person_add_alt_1,size: 20,color: Color(0xff080204),),
                                      SizedBox(width: 10,),
                                      MyText(text: "Add Contact",size:font13Size,
                                        fontweight: FontWeight.w500,color: Color(0xff080204),),
                                    ],
                                  )

                                                            ),
                                ),
                              ) : Container(),
                          SizedBox(
                            height: media.height * 0.04,
                          ),
                        ],

                      ),
                    ),



                    //loader
                    (_isLoading == true)
                        ? const Positioned(top: 0, child: Loading())
                        : Container()
                  ],
                ),
              );
            }),
      ),
    );
  }
}
