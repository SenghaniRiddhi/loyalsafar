import 'package:flutter/material.dart';
import 'package:flutter_user/pages/NavigatorPages/makecomplaintdetails.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../functions/functions.dart';
import '../../styles/styles.dart';
import '../../translations/translation.dart';
import '../../widgets/appbar.dart';
import '../../widgets/success_dialog_content.dart';
import '../../widgets/widgets.dart';
import '../loadingPage/loading.dart';
import '../noInternet/noInternet.dart';
import '../profile/setting_screen.dart';

class MakeComplaint extends StatefulWidget {
  const MakeComplaint({super.key});

  @override
  State<MakeComplaint> createState() => _MakeComplaintState();
}

int complaintType = 0;

class _MakeComplaintState extends State<MakeComplaint> {
  bool isShimmer = true;
  String? selectedComplaint;
  String complaintDesc = '';
  String _error = '';
  bool _success = false;
  bool _isLoading = false;

  TextEditingController complaintText = TextEditingController();

  @override
  void initState() {
    getData();
    shimmer = AnimationController.unbounded(vsync: MyTickerProvider())
      ..repeat(min: -0.5, max: 1.5, period: const Duration(milliseconds: 1000));
    super.initState();
  }

  getData() async {
    setState(() {
      complaintType = 0;
      // complaintDesc = '';
      generalComplaintList = [];
    });

    var res = await getGeneralComplaint("general");
    if (res == 'success') {
      setState(() {
        isShimmer = false;
        if (generalComplaintList.isNotEmpty) {
          complaintType = 0;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return PopScope(
      canPop: true,
      // onWillPop: () async {
      //   Navigator.pop(context, false);
      //   return true;
      // },
      child: Material(
        child: Directionality(
          textDirection: (languageDirection == 'rtl')
              ? TextDirection.rtl
              : TextDirection.ltr,
          child: Stack(
            children: [
              Container(
                height: media.height * 1,
                width: media.width * 1,
                color: page,
                padding: EdgeInsets.only(
                    left: media.width * 0.05, right: media.width * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SizedBox(
                    //     height: MediaQuery.of(context).padding.top +
                    //         media.width * 0.0),
                    appBarWidget(
                      onTaps: (){
                        Navigator.pop(context);
                      },
                        context: context,
                        backgroundIcon: Color(0xffECECEC),
                        title: "",
                        iconColors: iconGrayColors),

                    SizedBox(
                      height: media.width * 0.03,
                    ),
                    (generalComplaintList.isNotEmpty)
                        ? Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        width: media.width * 0.8,
                                        height: media.height * 0.12,
                                        child: Image.asset(
                                          'assets/icons/raiseComplaints.png',
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      SizedBox(height: media.height * 0.04),
                                      MyText(
                                        text: "Raise Complaints",
                                        size: font22Size,
                                        color: Color(0xff303030),
                                        fontweight: FontWeight.w700,
                                      ),
                                      SizedBox(height: media.height * 0.01),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: media.width * 0.07),
                                        child: MyText(
                                          text:
                                              "Please raise your concern which you faced in the ride.",
                                          size: font16Size,
                                          textAlign: TextAlign.center,
                                          color: normalText1Colors,
                                          fontweight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20),
                                // Column(
                                //   children: generalComplaintList
                                //       .asMap()
                                //       .map((i, value) {
                                //         return MapEntry(
                                //           i,
                                //           InkWell(
                                //             onTap: () {
                                //               Navigator.push(
                                //                   context,
                                //                   MaterialPageRoute(
                                //                       builder: (context) =>
                                //                           MakeComplaintsDetails(
                                //                             i: i,
                                //                           )));
                                //             },
                                //             child: Container(
                                //               width: media.width * 1,
                                //               margin: EdgeInsets.only(
                                //                   top: media.width * 0.02,
                                //                   bottom: media.width * 0.02),
                                //               padding: EdgeInsets.only(
                                //                   bottom: media.width * 0.05),
                                //               decoration: BoxDecoration(
                                //                 border: Border(
                                //                     bottom: BorderSide(
                                //                         width: 1,
                                //                         color: borderLines
                                //                             .withOpacity(0.5))),
                                //                 color: page,
                                //               ),
                                //               child: Column(
                                //                 children: [
                                //                   SizedBox(
                                //                     width: media.width * 0.9,
                                //                     child: Row(
                                //                       crossAxisAlignment:
                                //                           CrossAxisAlignment
                                //                               .end,
                                //                       mainAxisAlignment:
                                //                           MainAxisAlignment
                                //                               .spaceBetween,
                                //                       children: [
                                //                         SizedBox(
                                //                             // color: Colors.red,
                                //                             width: media.width *
                                //                                 0.8,
                                //                             child: Text(
                                //                               generalComplaintList[
                                //                                           i]
                                //                                       ['title']
                                //                                   .toString(),
                                //                               maxLines: 1,
                                //                               style: GoogleFonts.poppins(
                                //                                   fontSize: media
                                //                                           .width *
                                //                                       sixteen,
                                //                                   fontWeight:
                                //                                       FontWeight
                                //                                           .w500,
                                //                                   color:
                                //                                       textColor),
                                //                             )),
                                //                         RotatedBox(
                                //                             quarterTurns: 0,
                                //                             child: Icon(
                                //                               Icons
                                //                                   .arrow_forward_ios_sharp,
                                //                               color:
                                //                                   loaderColor,
                                //                             ))
                                //                       ],
                                //                     ),
                                //                   ),
                                //                 ],
                                //               ),
                                //             ),
                                //           ),
                                //         );
                                //       })
                                //       .values
                                //       .toList(),
                                // ),

                                DropdownButtonFormField<String>(
                                  value: selectedComplaint,
                                  hint: Text(
                                    "Select Reason",
                                    style: GoogleFonts.poppins(
                                        fontSize: media.width * 0.04,
                                        color: Color(0xff5C6266),
                                        fontWeight: FontWeight.w500),
                                  ),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(
                                              0xff5C6266) // Color for the enabled border
                                          ),
                                      borderRadius: BorderRadius.circular(
                                          media.width * 0.02),
                                    ),
                                  ),
                                  items: generalComplaintList.map((item) {
                                    return DropdownMenuItem<String>(
                                      value: item['title'].toString(),
                                      child: Text(
                                        item['title'].toString(),
                                        style: GoogleFonts.poppins(
                                          fontSize: media.width * 0.04,
                                          color: Colors.black,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedComplaint =
                                          value; // Update the selected value
                                    });
                                    // Navigate to details page based on selected item

                                    final selectedIndex = generalComplaintList
                                        .indexWhere((element) =>
                                            element['title'] == value);

                                    // if (selectedIndex != -1) {
                                    //   Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //       builder: (context) => MakeComplaintsDetails(
                                    //         i: selectedIndex,
                                    //       ),
                                    //     ),
                                    //   );
                                    // }
                                  },
                                  // underline: Container(
                                  //   height: 1,
                                  //   color: Colors.grey,
                                  // ),
                                  icon:
                                      Icon(Icons.keyboard_arrow_down_outlined),
                                  isExpanded: true,
                                ),
                                SizedBox(
                                  height: media.width * 0.05,
                                ),
                                Container(
                                  width: media.width * 0.9,
                                  padding: EdgeInsets.symmetric(
                                      vertical: media.width * 0.01,
                                      horizontal: media.width * 0.05),
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Color(0xffD9D9D9)),
                                      borderRadius: BorderRadius.circular(
                                          media.width * 0.02)),
                                  child: TextField(
                                    controller: complaintText,
                                    minLines: 5,
                                    maxLines: 5,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(
                                        color: Color(0xff5C6266),
                                      ),
                                      // GoogleFonts.notoSans(
                                      //   color: textColor.withOpacity(0.4),
                                      //   fontSize: media.width * fourteen,
                                      // ),
                                      hintText: languages[choosenLanguage]
                                          ['text_complaint_2'],
                                    ),
                                    onChanged: (val) {
                                      complaintDesc = val;
                                      if (val.length >= 10 && _error != '') {
                                        setState(() {
                                          _error = '';
                                        });
                                      }
                                    },
                                    style:
                                        GoogleFonts.notoSans(color: textColor),
                                  ),
                                ),
                                if (_error != '')
                                  Container(
                                    width: media.width * 0.8,
                                    padding: EdgeInsets.only(
                                        top: media.width * 0.02,
                                        bottom: media.width * 0.01),
                                    child: MyText(
                                      text: _error,
                                      size: media.width * fourteen,
                                      color: Colors.red,
                                    ),
                                  ),
                                SizedBox(
                                  height: media.width * 0.5,
                                ),
                                Button(
                                  color: buttonColors,
                                  textcolor: Colors.black,
                                  borcolor: Colors.white,
                                  onTap: () async {
                                    if (complaintText.text.length >= 10) {
                                      setState(() {
                                        _isLoading = true;
                                      });
                                      dynamic result;

                                      result = await makeGeneralComplaint(
                                          complaintDesc);

                                      setState(() {
                                        if (result == 'success') {
                                          _success = true;

                                          showDialog(
                                            context: context,
                                            builder: (context) =>
                                                SuccessDialogContent(
                                                    image: '',
                                                    title: '''Complaint Sent''',
                                                    description:
                                                        'Thank you for submitting your complaint regarding your recent car ride.'),
                                          );
                                        }

                                        _isLoading = false;
                                      });
                                    } else {
                                      setState(() {
                                        _error = languages[choosenLanguage]
                                            ['text_complaint_text_error'];
                                      });
                                    }
                                  },
                                  text: languages[choosenLanguage]
                                      ['text_submit'],
                                ),
                              ],
                            ),
                          )
                        : (isShimmer)
                            ? Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      for (var i = 0; i <= 20; i++)
                                        AnimatedBuilder(
                                            animation: shimmer,
                                            builder: (context, widget) {
                                              return ShaderMask(
                                                blendMode: BlendMode.srcATop,
                                                shaderCallback: (bounds) {
                                                  return LinearGradient(
                                                          colors: shaderColor,
                                                          stops: shaderStops,
                                                          begin: shaderBegin,
                                                          end: shaderEnd,
                                                          tileMode:
                                                              TileMode.clamp,
                                                          transform:
                                                              SlidingGradientTransform(
                                                                  slidePercent:
                                                                      shimmer
                                                                          .value))
                                                      .createShader(bounds);
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      width: media.width * 0.75,
                                                      height: media.width * 0.1,
                                                      margin: EdgeInsets.only(
                                                          top: media.width *
                                                              0.02,
                                                          bottom: media.width *
                                                              0.02),
                                                      padding: EdgeInsets.only(
                                                          bottom: media.width *
                                                              0.05),
                                                      decoration: BoxDecoration(
                                                        border: Border(
                                                            bottom: BorderSide(
                                                                width: 1,
                                                                color: borderLines
                                                                    .withOpacity(
                                                                        0.5))),
                                                      ),
                                                      child: Container(
                                                        height:
                                                            media.width * 0.05,
                                                        width:
                                                            media.width * 0.75,
                                                        color: hintColor,
                                                      ),
                                                    ),
                                                    Icon(
                                                      Icons
                                                          .arrow_forward_ios_sharp,
                                                      color: loaderColor,
                                                    )
                                                  ],
                                                ),
                                              );
                                            })
                                    ],
                                  ),
                                ),
                              )
                            : Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                              ),
                  ],
                ),
              ),

              //loader
              (_isLoading == true)
                  ? const Positioned(top: 0, child: Loading())
                  : Container(),

              //no internet
              (internet == false)
                  ? Positioned(
                      top: 0,
                      child: NoInternet(
                        onTap: () {
                          internetTrue();
                        },
                      ))
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
