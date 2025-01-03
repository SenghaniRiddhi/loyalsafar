import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_user/pages/login/login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../functions/functions.dart';
import '../../styles/styles.dart';
import '../../translations/translation.dart';
import '../../widgets/appbar.dart';
import '../../widgets/widgets.dart';
import '../login/loginScreen.dart';
import '../noInternet/nointernet.dart';

class PickContact extends StatefulWidget {
  final String from;
  const PickContact({super.key, required this.from});

  @override
  State<PickContact> createState() => _PickContactState();
}

List contacts = [];
String pickedName = '';
String pickedNumber = '';

class _PickContactState extends State<PickContact> {
  bool _isLoading = false;
  bool _contactDenied = false;
  bool _noPermission = false;
  final TextEditingController _searchController = TextEditingController();

  List<dynamic>  filteredContacts = [];

  @override
  void initState() {
    getContact();
    shimmer = AnimationController.unbounded(vsync: MyTickerProvider())
      ..repeat(min: -0.5, max: 1.5, period: const Duration(milliseconds: 1000));

    super.initState();
  }

//get contact permission
  getContactPermission() async {
    var status = await Permission.contacts.status;
    return status;
  }

//fetch contact data
  getContact() async {
    if (contacts.isEmpty) {
      var permission = await getContactPermission();
      if (permission == PermissionStatus.granted) {
        if (mounted) {
          setState(() {
            _isLoading = true;
          });
        }

        Iterable<Contact> contactsList = await ContactsService.getContacts();

        // ignore: avoid_function_literals_in_foreach_calls

        contactsList.forEach((contact) {
          contact.phones!.toSet().forEach((phone) {

            contacts.add({
              'name': contact.displayName ?? contact.givenName,
              'phone': phone.value
            });
            filteredContacts.add({
              'name': contact.displayName ?? contact.givenName,
              'phone': phone.value
            });
            // setState(() {
            //   filteredContacts=contacts;
            // });

          });
        });
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _noPermission = true;
          _isLoading = false;
        });
      }
    }
  }

  //navigate pop

  pop() {
    Navigator.pop(context, true);
  }

  navigateLogout() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Loginscreen()));
  }

  void _filterContacts(String query) {
    final lowerCaseQuery = query.toLowerCase();
    setState(() {
      filteredContacts = contacts.where((contact) {
        final name = contact['name']!.toLowerCase();
        return name.contains(lowerCaseQuery);
      }).toList();
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
                    left: media.width * 0.03, right: media.width * 0.03),
                child: Column(children: [
                  // SizedBox(
                  //     height: MediaQuery.of(context).padding.top +
                  //         media.width * 0.05),
                  Stack(
                    children: [

                      Positioned(
                          child: Padding(
                            padding:  EdgeInsets.only(top: media.width * 0.12),
                            child: Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [

                               appBarWithoutHeightWidget(context: context,
                                onTaps: (){
                                  Navigator.pop(context, true);
                                },
                                backgroundIcon: Color(0xffECECEC), title: "",iconColors: iconGrayColors),

                               MyText(text: (widget.from == '1')
                                   ? "Select Contact"
                                   : languages[choosenLanguage]['text_pick_contact'],
                                 fontweight: FontWeight.w600,
                                 size: font18Size,color: headingColors,),


                            InkWell(
                                onTap: () async{
                                  if (!_isLoading) {
                                    contacts.clear();
                                    // setState(() {
                                    //   _isLoading = true;
                                    // });
                                    var val =
                                        await addSos(pickedName, pickedNumber);
                                    if (val == 'success') {
                                      pop();
                                    } else if (val == 'logout') {
                                      navigateLogout();
                                    }
                                    // setState(() {
                                    //   _isLoading = false;
                                    // });
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 05,horizontal: 15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    color: buttonColors
                                  ),
                                    child: MyText(text: "Done",
                                      fontweight: FontWeight.w500,
                                      size: font13Size,color: Color(0xff080204),))
                            ),
                                                    ],
                                                  ),
                          ))
                    ],
                  ),
                  SizedBox(
                    height: media.width * 0.06,
                  ),
                  TextFormField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      prefixIcon:  Icon(Icons.search,color: Color(0xff4F4F4F),size: 25,),
                      hintText: 'Search Contact',
                      hintStyle: GoogleFonts.inter(
                        color: Color(0xff494949),
                        fontSize: font14Size,
                        fontWeight: FontWeight.w400
                      ),
                      fillColor: Color(0xffF7F7F7),
                      filled: true, // Enable the fill color
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0), // Adjust corner radius
                        borderSide: BorderSide.none, // Remove border outline
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
                    ),
                    onChanged: _filterContacts,
                  ),
                  SizedBox(
                    height: media.width * 0.02,
                  ),
                  Divider(color: Color(0xffEBEBEB),),
                  SizedBox(
                    height: media.width * 0.02,
                  ),
                  filteredContacts.isEmpty
                      ?SizedBox():
                  Container(
                    alignment: Alignment.topLeft,
                    child: MyText(text: "${contacts.length} Contacts",
                      fontweight: FontWeight.w600,
                      size: font16Size,color: Color(0xff919191),),
                  ),
                  SizedBox(
                    height: media.width * 0.02,
                  ),
                  Expanded(
                    child: (contacts.isNotEmpty)
                        ? SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child:
                            filteredContacts.isEmpty
                                ? Center(
                              child: Text(
                                'No contacts available',
                                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                              ),
                            ):
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: filteredContacts
                                  .asMap()
                                  .map((i, value) {
                                    return
                                      MapEntry(
                                        i,
                                        (sosData
                                                .map((e) => e['number'])
                                                .toString()
                                                .replaceAll(' ', '')
                                                .contains(filteredContacts[i]['phone']
                                                    .toString()
                                                    .replaceAll(' ', '')))
                                            ? Container()
                                            : Container(
                                                padding: EdgeInsets.all(
                                                    media.width * 0.025),
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      pickedName =
                                                      filteredContacts[i]['name'];
                                                      pickedNumber =
                                                      filteredContacts[i]['phone'];
                                                    });
                                                  },
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
                                                          text: getInitials(filteredContacts[i]['name']
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
                                                            MyText(text: filteredContacts[i]['name'],
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
                                                            text: filteredContacts[i]['phone'],
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
                                                      Container(
                                                        height: media.width * 0.06,
                                                        width: media.width * 0.06,
                                                        decoration: BoxDecoration(
                                                            shape:
                                                            BoxShape.circle,
                                                            color: (pickedName ==
                                                                filteredContacts[i]
                                                                ['name'])
                                                                ? Colors.black:Colors.white,
                                                            border: Border.all(
                                                                color:
                                                                textColor,
                                                                width: 1.2)
                                                        ),
                                                        alignment:
                                                        Alignment.center,
                                                        child: (pickedName ==
                                                            filteredContacts[i]
                                                            ['name'])
                                                            ? Center(child: Icon(Icons.check,color: Colors.white,size: 17,))
                                                            : Container(),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ));
                                  })
                                  .values
                                  .toList(),
                            ),
                          )
                        : (_isLoading)
                            ? Container(
                                width: media.width * 1,
                                height: media.height * 1,
                                color: page,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      for (var i = 0; i < 10; i++)
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
                                                  child: Container(
                                                    padding: EdgeInsets.all(
                                                        media.width * 0.03),
                                                    decoration: BoxDecoration(
                                                        color: page,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(media
                                                                        .width *
                                                                    0.02)),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Container(
                                                                  height: media
                                                                          .width *
                                                                      0.05,
                                                                  width: media
                                                                          .width *
                                                                      0.6,
                                                                  color: hintColor
                                                                      .withOpacity(
                                                                          0.5),
                                                                ),
                                                                SizedBox(
                                                                  height: media
                                                                          .width *
                                                                      0.03,
                                                                ),
                                                                Container(
                                                                  height: media
                                                                          .width *
                                                                      0.05,
                                                                  width: media
                                                                          .width *
                                                                      0.4,
                                                                  color: hintColor
                                                                      .withOpacity(
                                                                          0.5),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              width:
                                                                  media.width *
                                                                      0.03,
                                                            ),
                                                            Container(
                                                              height:
                                                                  media.width *
                                                                      0.08,
                                                              width:
                                                                  media.width *
                                                                      0.08,
                                                              decoration:
                                                                  BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: hintColor
                                                                    .withOpacity(
                                                                        0.5),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ));
                                            })
                                    ],
                                  ),
                                ),
                              )
                            : (!_isLoading)
                                ? SizedBox(
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
                                : Container(),
                  ),
                  // (pickedName != '')
                  //     ? Container(
                  //         padding: EdgeInsets.only(
                  //             top: media.width * 0.05,
                  //             bottom: media.width * 0.05),
                  //         child: Button(
                  //             onTap: () async {
                  //               if (!_isLoading) {
                  //                 contacts.clear();
                  //                 setState(() {
                  //                   _isLoading = true;
                  //                 });
                  //                 var val =
                  //                     await addSos(pickedName, pickedNumber);
                  //                 if (val == 'success') {
                  //                   pop();
                  //                 } else if (val == 'logout') {
                  //                   navigateLogout();
                  //                 }
                  //                 setState(() {
                  //                   _isLoading = false;
                  //                 });
                  //               }
                  //             },
                  //             color: (_isLoading) ? Colors.grey : textColor,
                  //             text: languages[choosenLanguage]['text_confirm']),
                  //       )
                  //     : Container()
                ]),
              ),

              (_noPermission == true)
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
                                  borderRadius: BorderRadius.circular(12),
                                  color: page),
                              child: Column(
                                children: [
                                  Text(
                                    languages[choosenLanguage]
                                        ['text_contact_permission'],
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.notoSans(
                                        fontSize: media.width * sixteen,
                                        color: textColor,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: media.width * 0.05,
                                  ),
                                  Button(
                                      onTap: () async {
                                        var status =
                                            await Permission.contacts.request();
                                        setState(() {
                                          _isLoading = true;
                                          _noPermission = false;
                                        });
                                        if (status ==
                                            PermissionStatus.granted) {
                                          getContact();
                                        } else {
                                          _contactDenied = true;
                                          _isLoading = false;
                                        }
                                      },
                                      text: languages[choosenLanguage]
                                          ['text_continue'])
                                ],
                              ),
                            )
                          ],
                        ),
                      ))
                  : Container(),

              //permission denied error
              (_contactDenied == true)
                  ? Positioned(
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
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _contactDenied = false;
                                    });
                                    Navigator.pop(context, true);
                                  },
                                  child: Container(
                                    height: media.width * 0.1,
                                    width: media.width * 0.1,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color:
                                                borderLines.withOpacity(0.5)),
                                        shape: BoxShape.circle,
                                        color: page),
                                    child: const Icon(Icons.cancel_outlined),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: media.width * 0.05,
                          ),
                          Container(
                            padding: EdgeInsets.all(media.width * 0.05),
                            width: media.width * 0.9,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: borderLines.withOpacity(0.5)),
                                borderRadius: BorderRadius.circular(12),
                                color: page,
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 2.0,
                                      spreadRadius: 2.0,
                                      color: Colors.black.withOpacity(0.2))
                                ]),
                            child: Column(
                              children: [
                                SizedBox(
                                    width: media.width * 0.8,
                                    child: Text(
                                      languages[choosenLanguage]
                                          ['text_open_contact_setting'],
                                      style: GoogleFonts.notoSans(
                                          fontSize: media.width * sixteen,
                                          color: textColor,
                                          fontWeight: FontWeight.w600),
                                    )),
                                SizedBox(height: media.width * 0.05),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                        onTap: () async {
                                          await openAppSettings();
                                        },
                                        child: Text(
                                          languages[choosenLanguage]
                                              ['text_open_settings'],
                                          style: GoogleFonts.notoSans(
                                              fontSize: media.width * sixteen,
                                              color: buttonColor,
                                              fontWeight: FontWeight.w600),
                                        )),
                                    InkWell(
                                        onTap: () async {
                                          setState(() {
                                            _contactDenied = false;
                                          });
                                          getContact();
                                        },
                                        child: Text(
                                          languages[choosenLanguage]
                                              ['text_done'],
                                          style: GoogleFonts.notoSans(
                                              fontSize: media.width * sixteen,
                                              color: buttonColor,
                                              fontWeight: FontWeight.w600),
                                        ))
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ))
                  : Container(),
              //loader
              Container(),

              //no internet
              (internet == false)
                  ? Positioned(
                      top: 0,
                      child: NoInternet(
                        onTap: () {
                          setState(() {
                            internetTrue();
                          });
                        },
                      ))
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
