import 'package:flutter/material.dart';
import 'package:flutter_user/pages/login/login.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../functions/functions.dart';
import '../../styles/styles.dart';
import '../../translations/translation.dart';
import '../../widgets/widgets.dart';
import '../loadingPage/loading.dart';
import '../login/loginScreen.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool isLoading = false;
  bool error = false;
  dynamic notificationid;
  dynamic _shimmer;
  @override
  void initState() {
    getdata(0);
    _shimmer = AnimationController.unbounded(vsync: MyTickerProvider())
      ..repeat(min: -0.5, max: 1.5, period: const Duration(milliseconds: 1000));
    super.initState();
  }

  @override
  void dispose() {
    _shimmer.dispose();
    super.dispose();
  }

  getdata(from) async {
    if (from == 0) {
      if (notificationHistory.isEmpty) {
        for (var i = 0; i < 10; i++) {
          notificationHistory.add({});
        }
      }
    }
    var val = await getnotificationHistory();
    if (val == 'success') {
      isLoading = false;
    } else {
      isLoading = true;
    }
  }

  navigateLogout() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Loginscreen()));
  }

  bool showinfo = false;
  int? showinfovalue;

  bool showToastbool = false;

  showToast() async {
    setState(() {
      showToastbool = true;
    });
    Future.delayed(const Duration(seconds: 1), () async {
      setState(() {
        showToastbool = false;
        // Navigator.pop(context, true);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Material(
        child: ValueListenableBuilder(
            valueListenable: valueNotifierHome.value,
            builder: (context, value, child) {
              return Directionality(
                textDirection: (languageDirection == 'rtl')
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                child: Stack(children: [
                  Container(
                    height: media.height * 1,
                    width: media.width * 1,
                    color: (notificationHistory.isEmpty)
                        ? (!isDarkTheme)
                            ? Colors.white
                            : Colors.black
                        : page,

                    child: Column(
                      children: [
                        SizedBox(height: MediaQuery.of(context).padding.top),
                        Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(media.width * 0.05,
                                  media.width * 0.05, media.width * 0.05, 0),
                              width: media.width * 1,
                              alignment: Alignment.topLeft,
                              child: MyText(
                                text: "Alerts",
                                color: headingColors,
                                size: font26Size,
                                fontweight: FontWeight.w700,
                              ),
                            ),

                            // Positioned(
                            //     child: InkWell(
                            //         onTap: () async {
                            //           Navigator.pop(context);
                            //         },
                            //         child: Icon(Icons.arrow_back_ios,
                            //             color: textColor)))
                          ],
                        ),
                        // SizedBox(height: MediaQuery.of(context).padding.top),
                        Divider(color: dividerColors,),
                        SizedBox(height: MediaQuery.of(context).size.height*0.02),

                        Expanded(
                            child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: [

                              //wallet history
                              (notificationHistory.isNotEmpty)
                                  ? Column(
                                      children: [
                                        Column(
                                          children: notificationHistory
                                              .asMap()
                                              .map((i, value) {
                                                return MapEntry(
                                                    i,
                                                    (notificationHistory[i]
                                                            .isEmpty)
                                                        ? AnimatedBuilder(
                                                            animation: _shimmer,
                                                            builder: (context,
                                                                widget) {
                                                              return ShaderMask(
                                                                  blendMode:
                                                                      BlendMode
                                                                          .srcATop,
                                                                  shaderCallback:
                                                                      (bounds) {
                                                                    return LinearGradient(
                                                                            colors:
                                                                                shaderColor,
                                                                            stops:
                                                                                shaderStops,
                                                                            begin:
                                                                                shaderBegin,
                                                                            end:
                                                                                shaderEnd,
                                                                            tileMode:
                                                                                TileMode.clamp,
                                                                            transform: SlidingGradientTransform(slidePercent: _shimmer.value))
                                                                        .createShader(bounds);
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    margin: EdgeInsets.all(
                                                                        media.width *
                                                                            0.03),
                                                                    padding: EdgeInsets.all(
                                                                        media.width *
                                                                            0.03),
                                                                    decoration: BoxDecoration(
                                                                        color:
                                                                            page,
                                                                        borderRadius:
                                                                            BorderRadius.circular(media.width *
                                                                                0.02)),
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        SizedBox(
                                                                          height:
                                                                              media.width * 0.02,
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            Container(
                                                                              height: media.width * 0.05,
                                                                              width: media.width * 0.05,
                                                                              decoration: BoxDecoration(shape: BoxShape.circle, color: hintColor.withOpacity(0.5)),
                                                                            ),
                                                                            SizedBox(
                                                                              width: media.width * 0.05,
                                                                            ),
                                                                            Expanded(
                                                                              child: Container(
                                                                                height: media.width * 0.05,
                                                                                color: hintColor.withOpacity(0.5),
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              width: media.width * 0.05,
                                                                            ),
                                                                            Container(
                                                                              height: media.width * 0.05,
                                                                              width: media.width * 0.05,
                                                                              decoration: BoxDecoration(shape: BoxShape.circle, color: hintColor.withOpacity(0.5)),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              media.width * 0.03,
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            Container(
                                                                              height: media.width * 0.05,
                                                                              width: media.width * 0.05,
                                                                              decoration: BoxDecoration(shape: BoxShape.circle, color: hintColor.withOpacity(0.5)),
                                                                            ),
                                                                            SizedBox(
                                                                              width: media.width * 0.05,
                                                                            ),
                                                                            Expanded(
                                                                              child: Container(
                                                                                height: media.width * 0.05,
                                                                                color: hintColor.withOpacity(0.5),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ));
                                                            })
                                                        : InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                showinfovalue =
                                                                    i;
                                                                showinfo = true;
                                                              });
                                                            },
                                                            child: Container(
                                                              margin: EdgeInsets.only(
                                                                  top: media
                                                                          .width *
                                                                      0.01,
                                                                  bottom: media
                                                                          .width *
                                                                      0.02),
                                                              width:
                                                                  media.width *
                                                                      0.9,

                                                              decoration: BoxDecoration(
                                                                  color: page),
                                                              child: Column(
                                                                children: [
                                                                  Row(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [

                                                                      notificationHistory[i]
                                                                      ['image'] != null?
                                                                      CircleAvatar(
                                                                        radius: 30,
                                                                        backgroundImage: NetworkImage(
                                                                          notificationHistory[i]['image'],
                                                                        ),
                                                                        backgroundColor: Colors.transparent, // Optional, makes the background clear
                                                                      ):CircleAvatar(
                                                                        radius: 30,
                                                                        backgroundColor: Color(
                                                                            0xffeeebeb),
                                                                        child: Icon(Icons.notifications,color: iconColors,),
                                                                      ),
                                                                      // Container(
                                                                      //     height: media.width *
                                                                      //         0.1067,
                                                                      //     width: media.width *
                                                                      //         0.1067,
                                                                      //     decoration: BoxDecoration(
                                                                      //         borderRadius: BorderRadius.circular(
                                                                      //             10),
                                                                      //         color: const Color(0xff000000).withOpacity(
                                                                      //             0.05)),
                                                                      //     alignment: Alignment
                                                                      //         .center,
                                                                      //     child:
                                                                      //         const Icon(Icons.notifications)),
                                                                      SizedBox(
                                                                        width: media.width *
                                                                            0.045,
                                                                      ),
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [

                                                                          Container(
                                                                            width: media.width * 0.70,
                                                                            child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                              SizedBox(
                                                                                  width: media.width * 0.50,
                                                                                  child: MyText(
                                                                                    text: notificationHistory[i]['title'].toString(),
                                                                                    size: media.width * fourteen,
                                                                                    fontweight: FontWeight.w600,
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                    maxLines: 2,
                                                                                  )),

                                                                              Container(
                                                                                  alignment: Alignment.centerRight,
                                                                                  // width: media.width * 0.15,
                                                                                  child: IconButton(
                                                                                    onPressed: () {
                                                                                      setState(() {
                                                                                        error = true;
                                                                                        notificationid = notificationHistory[i]['id'];
                                                                                      });
                                                                                    },
                                                                                    icon: const Icon(Icons.delete_outline,size: 25,),
                                                                                  ))
                                                                            ],),
                                                                          ),

                                                                          SizedBox(
                                                                            height:
                                                                                media.width * 0.01,
                                                                          ),
                                                                          SizedBox(
                                                                              width: media.width * 0.70,
                                                                              child: MyText(
                                                                                text: notificationHistory[i]['body'].toString(),
                                                                                size: font14Size,
                                                                                color: Color(0xff484848),
                                                                                fontweight: FontWeight.w400,
                                                                              )),
                                                                          SizedBox(
                                                                            height:
                                                                                media.width * 0.02,
                                                                          ),
                                                                          SizedBox(
                                                                              width: media.width * 0.55,
                                                                              child: MyText(
                                                                                text: notificationHistory[i]['converted_created_at'].toString(),
                                                                                size: font14Size,
                                                                                color: Color(0xff919191),
                                                                                fontweight: FontWeight.w400,
                                                                                overflow: TextOverflow.ellipsis,
                                                                              )),
                                                                        ],
                                                                      ),

                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height: media
                                                                            .width *
                                                                        0.02,
                                                                  ),

                                                                  Divider(color: dividerColors,),

                                                                ],
                                                              ),
                                                            ),
                                                          ));
                                              })
                                              .values
                                              .toList(),
                                        ),
                                        (notificationHistoryPage[
                                                    'pagination'] !=
                                                null)
                                            ? (notificationHistoryPage[
                                                            'pagination']
                                                        ['current_page'] <
                                                    notificationHistoryPage[
                                                            'pagination']
                                                        ['total_pages'])
                                                ? InkWell(
                                                    onTap: () async {
                                                      setState(() {
                                                        isLoading = true;
                                                      });
                                                      var val =
                                                          await getNotificationPages(
                                                              'page=${notificationHistoryPage['pagination']['current_page'] + 1}');
                                                      if (val == 'logout') {
                                                        navigateLogout();
                                                      }
                                                      setState(() {
                                                        isLoading = false;
                                                      });
                                                    },
                                                    child: Container(
                                                      padding: EdgeInsets.all(
                                                          media.width * 0.025),
                                                      margin: EdgeInsets.only(
                                                          bottom: media.width *
                                                              0.05),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color: page,
                                                          border: Border.all(
                                                              color:
                                                                  borderLines,
                                                              width: 1.2)),
                                                      child: Text(
                                                        languages[
                                                                choosenLanguage]
                                                            ['text_loadmore'],
                                                        style: GoogleFonts
                                                            .notoSans(
                                                                fontSize: media
                                                                        .width *
                                                                    sixteen,
                                                                color:
                                                                    textColor),
                                                      ),
                                                    ),
                                                  )
                                                : Container()
                                            : Container()
                                      ],
                                    )
                                  : SizedBox(
                                      height: media.height * 0.6,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: media.width * 0.2,
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            height: media.width * 0.6,
                                            width: media.width * 0.6,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage((isDarkTheme)
                                                        ? 'assets/images/nodatafounddark.gif'
                                                        : 'assets/images/nodatafound.gif'),
                                                    fit: BoxFit.contain)),
                                          ),
                                          SizedBox(
                                            width: media.width * 0.6,
                                            child: MyText(
                                                text: languages[choosenLanguage]
                                                    ['text_noDataFound'],
                                                textAlign: TextAlign.center,
                                                fontweight: FontWeight.w800,
                                                size: media.width * sixteen),
                                          ),
                                        ],
                                      ),
                                    )
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),
                  (showinfo == true)
                      ? Positioned(
                          top: 0,
                          child: Container(
                            height: media.height * 1,
                            width: media.width * 1,
                            color: Colors.transparent.withOpacity(0.6),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: media.width * 0.9,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                          height: media.height * 0.1,
                                          width: media.width * 0.1,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: borderLines
                                                      .withOpacity(0.5)),
                                              shape: BoxShape.circle,
                                              color: page),
                                          child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  showinfo = false;
                                                  showinfovalue = null;
                                                });
                                              },
                                              child: Icon(
                                                Icons.cancel_outlined,
                                                color: textColor,
                                              ))),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(media.width * 0.05),
                                  width: media.width * 0.9,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: borderLines.withOpacity(0.5)),
                                      borderRadius: BorderRadius.circular(12),
                                      color: page),
                                  child: Column(
                                    children: [
                                      MyText(
                                        text:
                                            notificationHistory[showinfovalue!]
                                                    ['title']
                                                .toString(),
                                        size: media.width * sixteen,
                                        fontweight: FontWeight.w600,
                                      ),
                                      SizedBox(
                                        height: media.width * 0.05,
                                      ),
                                      MyText(
                                        text:
                                            notificationHistory[showinfovalue!]
                                                    ['body']
                                                .toString(),
                                        size: media.width * fourteen,
                                        color: hintColor,
                                      ),
                                      SizedBox(
                                        height: media.width * 0.05,
                                      ),
                                      if (notificationHistory[showinfovalue!]
                                              ['image'] !=
                                          null)
                                        Image.network(
                                          notificationHistory[showinfovalue!]
                                              ['image'],
                                          height: media.width * 0.4,
                                          width: media.width * 0.4,
                                          fit: BoxFit.contain,
                                        )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ))
                      : Container(),
                  (error == true)
                      ? Positioned(
                          top: 0,
                          child: Container(
                            height: media.height * 1,
                            width: media.width * 1,
                            color: Colors.transparent.withOpacity(0.6),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(media.width * 0.05),
                                  width: media.width * 0.9,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: borderLines.withOpacity(0.5)),
                                      borderRadius: BorderRadius.circular(12),
                                      color: page),
                                  child: Column(
                                    children: [
                                      MyText(
                                        text: languages[choosenLanguage]
                                            ['text_delete_notification'],
                                        size: media.width * sixteen,
                                        fontweight: FontWeight.w600,
                                      ),
                                      SizedBox(
                                        height: media.width * 0.05,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Button(
                                            onTap: () async {
                                              setState(() {
                                                error = false;
                                                notificationid = null;
                                              });
                                            },
                                            text: languages[choosenLanguage]
                                                ['text_no'],
                                            width: media.width * 0.3,
                                          ),
                                          Button(
                                            onTap: () async {
                                              setState(() {
                                                isLoading = true;
                                              });
                                              var result =
                                                  await deleteNotification(
                                                      notificationid);
                                              if (result == 'success') {
                                                setState(() {
                                                  getdata(1);
                                                  error = false;
                                                  isLoading = false;
                                                  showToast();
                                                });
                                              }
                                            },
                                            text: languages[choosenLanguage]
                                                ['text_yes'],
                                            width: media.width * 0.3,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ))
                      : Container(),
                  (isLoading == true)
                      ? const Positioned(top: 0, child: Loading())
                      : Container(),
                  (showToastbool == true)
                      ? Positioned(
                          bottom: media.height * 0.2,
                          left: media.width * 0.2,
                          right: media.width * 0.2,
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(media.width * 0.025),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.transparent.withOpacity(0.6)),
                            child: MyText(
                              text: languages[choosenLanguage]
                                  ['text_notification_deleted'],
                              size: media.width * twelve,
                              color: topBar,
                            ),
                          ))
                      : Container()
                ]),
              );
            }));
  }
}
