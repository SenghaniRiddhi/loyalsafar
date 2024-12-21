import 'package:flutter/material.dart';
import 'package:flutter_user/functions/functions.dart';
import 'package:flutter_user/pages/loadingPage/loading.dart';
import 'package:flutter_user/pages/onTripPage/drop_loc_select.dart';
import 'package:flutter_user/styles/styles.dart';
import 'package:flutter_user/translations/translation.dart';
import 'package:flutter_user/widgets/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart';

import '../../widgets/appbar.dart';
import '../profile/adresses_screen.dart';

class FavAddressPage extends StatefulWidget {
  const FavAddressPage({super.key});

  @override
  State<FavAddressPage> createState() => _FavAddressPageState();
}

class _FavAddressPageState extends State<FavAddressPage> {
  TextEditingController newAddressController = TextEditingController();
  Location location = Location();
  bool _isLoading = false;

  List home = [];
  List work = [];
  List others = [];

  @override
  void initState() {
    getFavLocations();
    super.initState();
  }

  Future<void> getFavLocations() async {
    home.clear();
    work.clear();
    others.clear();
    for (var e in favAddress) {
      if (e["address_name"] == 'Work') {
        work.add(e);
      } else if (e["address_name"] == 'Home') {
        home.add(e);
      } else {
        others.add(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return Material(
      color: page,
      child: ValueListenableBuilder(
        valueListenable: valueNotifierBook.value,
        builder: (context, value, child) {
          return Directionality(
              textDirection: (languageDirection == 'rtl')
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: SafeArea(
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(media.width * 0.05,
                            0, media.width * 0.05, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                appBarWidget(context: context,
                                    onTaps: (){
                                      Navigator.pop(context);
                                    },
                                    backgroundIcon: Color(0xffECECEC), title: "",iconColors: iconGrayColors),



                              ],
                            ),
                            SizedBox(
                              height: media.width * 0.05,
                            ),
                            MyText(
                              text: "My Addresses",
                              size: font26Size,
                              color: headingColors,
                              fontweight: FontWeight.w800,
                            ),
                            SizedBox(
                              height: media.width * 0.05,
                            ),
                            (home.isEmpty)
                                ?SizedBox()
                                : AddressCard(
                                  icon: Icons.home_filled,
                                  label: home[0]
                                  ['address_name'],
                                  address: home[0]
                                  ['pick_address'],
                                  onEdit: () {

                                    // Handle edit for Home
                                  },
                                  onDelete: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return deleteDialoge(
                                            context, 0, home);
                                      },
                                    );
                                    // Handle delete for Home
                                  },
                                ),
                            (work.isEmpty)
                                ? SizedBox()
                                : AddressCard(
                              icon: Icons.work,
                              label:work[0]
                              ['address_name'],
                              address:work[0]
                              ['pick_address'],
                              onEdit: () {

                                // Handle edit for Home
                              },
                              onDelete: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return deleteDialoge(
                                        context, 0, work);
                                  },
                                );
                                // Handle delete for Home
                              },
                            ),

                            if (others.isNotEmpty)
                              SizedBox(
                                height: media.height * 0.8,
                                child: SingleChildScrollView(
                                  child: ListView.builder(
                                    itemCount: others.length,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: const EdgeInsets.only(bottom: 30),
                                    itemBuilder: (context, index) {
                                      return AddressCard(
                                          icon: Icons.question_mark,
                                          label:others[index]
                                          ['address_name'],
                                          address:others[index]
                                          ['pick_address'],
                                          onEdit: () {

                                            // Handle edit for Home
                                          },
                                          onDelete: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return deleteDialoge(
                                                    context,
                                                    index,
                                                    others);
                                              },
                                            );
                                            // Handle delete for others
                                          },
                                        );
                                    },
                                  ),
                                ),
                              )
                          ],
                        ),
                      ),
                    ),

                    if (others.length < 4)
                      Positioned(
                        bottom: 25,
                        left: 0,
                        right: 0,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              newAddressController.text = '';
                            });

                            // showDialog(
                            //   context: context,
                            //   builder: (context) {
                            //     return addDialoge(context);
                            //   },
                            // ).then((_) async {
                            //   await getFavLocations();
                            // });

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DropLocation(
                                            from: 'favourite',
                                            favName: '')))
                                .then((_) async {
                              await getFavLocations();
                            });
                          },
                          child: Center(
                            child: Container(
                              // margin: EdgeInsets.symmetric(vertical: 10),
                              padding: EdgeInsets.symmetric(vertical: 04,horizontal: 15),
                              decoration: BoxDecoration(
                                color: whiteColors,
                                borderRadius: BorderRadius.circular(18.0),
                                border: Border.all(
                                    color:
                                    borderLines.withOpacity(0.5)),
                                boxShadow: const [
                                  BoxShadow(
                                    spreadRadius: 0.5,
                                    blurRadius: 1,
                                    color: Colors.black12,
                                  )
                                ],
                                // border: Border.all(
                                //   color: const  Color(0xffeaeaea),
                                // )
                              ),
                              child: Wrap(
                                children: [
                                  Icon(Icons.add, color: Color(0xff141B34),size: 20,),
                                  SizedBox(width: 05,),
                                  MyText(text: "Add New",fontweight: FontWeight.w500, color: Color(0xff080204), size: font13Size),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                    (_isLoading == true)
                        ? const Positioned(child: Loading())
                        : Container(),
                  ],
                ),
              ));
        },
      ),
    );
  }

// REMOVE DIALOGE
  AlertDialog deleteDialoge(BuildContext context, int index, List addressList) {
    final media = MediaQuery.of(context).size;
    return AlertDialog(
      titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      contentPadding: const EdgeInsets.all(20),
      backgroundColor:
          (isDarkTheme == true) ? borderLines.withOpacity(0.5) : page,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: page,
              ),
              child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.cancel_outlined,
                    color: textColor,
                  ))),
        ],
      ),
      content: MyText(
        text: languages[choosenLanguage]['text_removeFav'],
        size: media.width * sixteen,
        fontweight: FontWeight.w600,
        textAlign: TextAlign.center,
      ),
      actions: [
        Button(
            onTap: () async {
              Navigator.pop(context);
              setState(() {
                _isLoading = true;
              });
              await removeFavAddress(addressList[index]['id']);
              // addressList.removeAt(index);
              await getFavLocations();
              setState(() {
                _isLoading = false;
              });
            },
            text: languages[choosenLanguage]['text_confirm'])
      ],
    );
  }

// ADD ADDRESS TYPE
  AlertDialog addDialoge(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return AlertDialog(
      titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      contentPadding: const EdgeInsets.all(20),
      backgroundColor:
          (isDarkTheme == true) ? borderLines.withOpacity(0.5) : page,
      title: Center(
        child: Text(
          languages[choosenLanguage]['text_add_new'],
          style: GoogleFonts.notoSans(
              fontSize: media.width * twenty,
              color: textColor,
              fontWeight: FontWeight.bold),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: newAddressController,
            autofocus: false,
            maxLines: 1,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              isDense: true,
              isCollapsed: true,
              contentPadding: const EdgeInsets.all(10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(color: textColor.withOpacity(0.3)),
              ),
              hintText: languages[choosenLanguage]['text_new_type_address'],
              hintStyle: GoogleFonts.notoSans(
                fontSize: media.width * twelve,
                color: textColor.withOpacity(0.4),
              ),
            ),
            style: GoogleFonts.notoSans(
                fontSize: media.width * fourteen,
                color: (isDarkTheme == true) ? Colors.white : textColor),
            onTap: () {},
          ),
        ],
      ),
      actions: [
        Button(
          onTap: () async {
            Navigator.pop(context);
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DropLocation(
                        from: 'favourite',
                        favName: newAddressController.text)));
            await getFavLocations();
          },
          text: 'Add',
          width: media.width * 0.25,
          height: media.width * 0.1,
        ),
      ],
    );
  }
}



class AddressCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String address;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AddressCard({
    Key? key,
    required this.icon,
    required this.label,
    required this.address,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: whiteColors,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
            color:
            borderLines.withOpacity(0.5)),
        boxShadow: const [
          BoxShadow(
            spreadRadius: 0.5,
            blurRadius: 1,
            color: Colors.black12,
          )
        ],
        // border: Border.all(
        //   color: const  Color(0xffeaeaea),
        // )
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: font24Size, color: Color(0xff000000)),
                const SizedBox(width: 12.0),
                MyText(text: label,
                    color: headingColors,
                    fontweight: FontWeight.w600,
                    size: font16Size),

                const Spacer(),

                GestureDetector(
                  onTap: onDelete,
                  child: CircleAvatar(
                    backgroundColor:  Color(0xffECECEC),
                    radius: 15,
                    child: Icon(
                      Icons.delete_rounded,
                      color: iconGrayColors,
                      size: 18,
                    ),
                  ),
                ),

                SizedBox(width: 10,),

                GestureDetector(
                  onTap: onEdit,
                  child: CircleAvatar(
                    backgroundColor:  Color(0xffECECEC),
                    radius: 15,
                    child: Icon(
                      Icons.edit,
                      color: iconGrayColors,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            MyText(text: address,
                color: Color(0xff575864),
                fontweight: FontWeight.w400,
                size: font16Size),

          ],
        ),
      ),
    );
  }
}