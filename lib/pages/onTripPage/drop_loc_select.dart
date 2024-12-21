// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart' as geolocs;
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:uuid/uuid.dart';
import 'package:permission_handler/permission_handler.dart' as perm;

import '../../functions/functions.dart';
import '../../styles/styles.dart';
import '../../translations/translation.dart';
import '../../widgets/widgets.dart';
import '../NavigatorPages/pickcontacts.dart';
import '../loadingPage/loading.dart';
import '../login/login.dart';
import '../login/loginScreen.dart';
import '../noInternet/noInternet.dart';
import '../profile/edit_adresses_screen.dart';
import 'booking_confirmation.dart';
import 'map_page.dart';
import 'package:flutter_map/flutter_map.dart' as fm;
// ignore: depend_on_referenced_packages
import 'package:latlong2/latlong.dart' as fmlt;

// ignore: must_be_immutable
class DropLocation extends StatefulWidget {
  dynamic from;
  String? favName;
  DropLocation({super.key, this.from,
    this.favName
  });

  @override
  State<DropLocation> createState() => _DropLocationState();
}

class _DropLocationState extends State<DropLocation>
    with WidgetsBindingObserver {
  GoogleMapController? _controller;
  final fm.MapController _fmController = fm.MapController();
  late PermissionStatus permission;
  Location location = Location();
  String _state = '';
  bool _isLoading = false;
  ValueNotifier<String> cityNotifier = ValueNotifier<String>('');

  dynamic _sessionToken;
  LatLng _center = const LatLng(41.4219057, -102.0840772);
  LatLng _centerLocation = const LatLng(41.4219057, -102.0840772);
  TextEditingController search = TextEditingController();
  String favNameText = '';
  bool _locationDenied = false;
  bool favAddressAdd = false;
  bool _getDropDetails = false;
  TextEditingController buyerName = TextEditingController();
  TextEditingController buyerNumber = TextEditingController();
  TextEditingController instructions = TextEditingController();
  final _debouncer = Debouncer(milliseconds: 1000);
  bool useMyDetails = false;
  bool useMyAddress = false;
  TextEditingController newAddressController = TextEditingController();

  String addressLine="abc";
  String area="cdf";
  String city="dff";

  String selectedAddressType = "";

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _controller = controller;
      _controller?.setMapStyle(mapStyle);
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    dropAddressConfirmation = '';
    useMyDetails = false;

    getLocs();
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (isDarkTheme == true) {
      await rootBundle.loadString('assets/dark.json').then((value) {
        mapStyle = value;
      });
    } else {
      await rootBundle.loadString('assets/map_style_black.json').then((value) {
        mapStyle = value;
      });
    }
    if (state == AppLifecycleState.resumed) {
      if (_controller != null) {
        _controller?.setMapStyle(mapStyle);
        valueNotifierHome.incrementNotifier();
      }
      if (locationAllowed == true) {
        if (positionStream == null || positionStream!.isPaused) {
          positionStreamData();
        }
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _controller = null;

    super.dispose();
  }

  getLocs() async {
    permission = await location.hasPermission();

    if (permission == PermissionStatus.denied ||
        permission == PermissionStatus.deniedForever) {
      setState(() {
        _state = '3';
        _isLoading = false;
      });
    }
    else if (permission == PermissionStatus.granted ||
        permission == PermissionStatus.grantedLimited) {
      print("helooo::-");
      var locs = await geolocs.Geolocator.getLastKnownPosition();
      if (addressList.length != 2 && widget.from == null) {
        print("helooo 1234::-");
        if (locs != null) {
          setState(() {
            _center = LatLng(double.parse(locs.latitude.toString()),
                double.parse(locs.longitude.toString()));
            _centerLocation = LatLng(double.parse(locs.latitude.toString()),
                double.parse(locs.longitude.toString()));

          });
        } else {
          var loc = await geolocs.Geolocator.getCurrentPosition(
              desiredAccuracy: geolocs.LocationAccuracy.low);
          setState(() {
            _center = LatLng(double.parse(loc.latitude.toString()),
                double.parse(loc.longitude.toString()));
            _centerLocation = LatLng(double.parse(loc.latitude.toString()),
                double.parse(loc.longitude.toString()));

          });
        }
       ;
        setState(() {
          _center = addressList[0].latlng;
          dropAddressConfirmation = addressList[0].address;
          getAddressDetails(latitude: double.parse(locs!.latitude.toString()),
              longitude: double.parse(locs.longitude.toString()),
              addressLine: addressLine, area: area, city: city);
        });
      }
      else if (widget.from != null &&
          widget.from != 'add stop' &&
          widget.from != 'favourite') {
        setState(() {
          buyerName.text = addressList[widget.from].name.toString();
          buyerNumber.text = addressList[widget.from].number.toString();
          instructions.text = (addressList[widget.from].instructions != null)
              ? addressList[widget.from].instructions
              : '';
          _center = addressList[widget.from].latlng;
          _centerLocation = addressList[widget.from].latlng;
          dropAddressConfirmation = addressList[widget.from].address;
          getAddressDetails(latitude: double.parse(locs!.latitude.toString()),
              longitude: double.parse(locs.longitude.toString()),
              addressLine: addressLine, area: area, city: city);
        });
      }
      else if (widget.from != null && widget.from == 'favourite') {
        var loc = await geolocs.Geolocator.getCurrentPosition(
            desiredAccuracy: geolocs.LocationAccuracy.low);
        setState(() {
          _center = LatLng(double.parse(loc.latitude.toString()),
              double.parse(loc.longitude.toString()));
          _centerLocation = LatLng(double.parse(loc.latitude.toString()),
              double.parse(loc.longitude.toString()));
        });
        getAddressDetails(latitude: double.parse(locs!.latitude.toString()),
            longitude: double.parse(locs.longitude.toString()),
            addressLine: addressLine, area: area, city: city);
      }
      else if (widget.from == 'add stop') {
        if (locs != null) {
          setState(() {
            _center = LatLng(double.parse(locs.latitude.toString()),
                double.parse(locs.longitude.toString()));
            _centerLocation = LatLng(double.parse(locs.latitude.toString()),
                double.parse(locs.longitude.toString()));
          });
        } else {
          var loc = await geolocs.Geolocator.getCurrentPosition(
              desiredAccuracy: geolocs.LocationAccuracy.low);
          setState(() {
            _center = LatLng(double.parse(loc.latitude.toString()),
                double.parse(loc.longitude.toString()));
            _centerLocation = LatLng(double.parse(loc.latitude.toString()),
                double.parse(loc.longitude.toString()));
          });
        }
        setState(() {
          _center = addressList.firstWhere((e) => e.type == 'pickup').latlng;
          _centerLocation =
              addressList.firstWhere((e) => e.type == 'pickup').latlng;
          dropAddressConfirmation = addressList
              .firstWhere((element) => element.type == 'pickup')
              .address;
          getAddressDetails(latitude: double.parse(locs!.latitude.toString()),
              longitude: double.parse(locs.longitude.toString()),
              addressLine: addressLine, area: area, city: city);

          useMyAddress = true;
        });
      }
      else {
        setState(() {
          _center = addressList.firstWhere((e) => e.type == 'drop').latlng;
          _centerLocation =
              addressList.firstWhere((e) => e.type == 'drop').latlng;
          if (addressList.length >= 2) {
            dropAddressConfirmation = addressList
                .firstWhere((element) => element.type == 'drop')
                .address;
          }
          getAddressDetails(latitude: double.parse(locs!.latitude.toString()),
              longitude: double.parse(locs.longitude.toString()),
              addressLine: addressLine, area: area, city: city);
          useMyAddress = true;
        });
      }

      setState(() {
        _state = '3';
        _isLoading = false;
      });
    }
  }

  navigateLogout() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Loginscreen()),
        (route) => false);
  }

  popFunction() {
    if (_getDropDetails == true) {
      return false;
    } else {
      addressList.removeWhere((element) => element.id == 'drop');
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return PopScope(
      canPop: popFunction(),
      onPopInvoked: (did) {
        if (_getDropDetails) {
          setState(() {
            _getDropDetails = false;
          });
        }
      },
      child: Material(
        child: ValueListenableBuilder(
            valueListenable: valueNotifierHome.value,
            builder: (context, value, child) {
              return Directionality(
                textDirection: (languageDirection == 'rtl')
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                child: Container(
                  height: media.height * 1,
                  width: media.width * 1,
                  color: page,
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left:media.width * 0.04,right: media.width * 0.04,top:  media.width * 0.25),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: SizedBox(
                            height: media.height * 0.35,
                            width: media.width * 1,
                            child: Stack(
                              children: [
                                (_state == '3')
                                    ? (mapType == 'google')
                                        ? Stack(
                                          children: [
                                            GoogleMap(
                                                onMapCreated: _onMapCreated,
                                                 initialCameraPosition: CameraPosition(
                                                  target: _center,
                                                  zoom: 14.0,
                                                ),
                                                onCameraMove: (CameraPosition position) {
                                                  //pick current location
                                                  // setState(() {
                                                  _centerLocation = position.target;
                                                  // });
                                                },
                                                onCameraIdle: () async {
                                                  if (useMyAddress == false) {
                                                    var val = await geoCoding(
                                                        _centerLocation.latitude,
                                                        _centerLocation.longitude);
                                                    setState(() {
                                                      _center = _centerLocation;
                                                      dropAddressConfirmation = val;

                                                      getAddressDetails(latitude: _centerLocation.latitude,
                                                          longitude: _centerLocation.longitude,
                                                          addressLine: addressLine, area: area, city: city,cityNotifier: cityNotifier);
                                                    });
                                                  }
                                                  if (useMyAddress == true) {
                                                    setState(() {
                                                      useMyAddress = false;
                                                    });
                                                  }
                                                },
                                                minMaxZoomPreference:
                                                    const MinMaxZoomPreference(8.0, 20.0),
                                                myLocationButtonEnabled: false,
                                                buildingsEnabled: false,
                                                zoomControlsEnabled: false,
                                                myLocationEnabled: true,
                                              ),
                                            Positioned.fill(
                                              // top: 0,
                                              //   bottom: 0,
                                                child: Center(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      // SizedBox(
                                                      //   height: (media.height / 2) - media.width * 0.08,
                                                      // ),
                                                      Container(
                                                        child: Image.asset(
                                                          'assets/images/dropmarker.png',
                                                          // width: media.width * 0.1,
                                                          // height: media.width * 0.08,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                          ],
                                        )
                                        : fm.FlutterMap(
                                            mapController: _fmController,
                                            options: fm.MapOptions(
                                                onMapEvent: (v) async {
                                                  if (v.source ==
                                                          fm.MapEventSource
                                                              .nonRotatedSizeChange &&
                                                      addressList.isEmpty) {
                                                    _centerLocation = LatLng(
                                                        v.camera.center.latitude,
                                                        v.camera.center.longitude);
                                                    setState(() {});

                                                    var val = await geoCoding(
                                                        _centerLocation.latitude,
                                                        _centerLocation.longitude);
                                                    if (val != '') {
                                                      setState(() {
                                                        _center = _centerLocation;
                                                        dropAddressConfirmation = val;
                                                      });
                                                    }
                                                  }
                                                  if (v.source ==
                                                      fm.MapEventSource.dragEnd) {
                                                    _centerLocation = LatLng(
                                                        v.camera.center.latitude,
                                                        v.camera.center.longitude);

                                                    var val = await geoCoding(
                                                        _centerLocation.latitude,
                                                        _centerLocation.longitude);
                                                    if (val != '') {
                                                      setState(() {
                                                        _center = _centerLocation;
                                                        dropAddressConfirmation = val;
                                                      });
                                                    }
                                                  }
                                                },
                                                onPositionChanged: (p, l) async {
                                                  if (l == false) {
                                                    _centerLocation = LatLng(
                                                        p.center.latitude,
                                                        p.center.longitude);
                                                    setState(() {});

                                                    var val = await geoCoding(
                                                        _centerLocation.latitude,
                                                        _centerLocation.longitude);
                                                    if (val != '') {}
                                                  }
                                                },
                                                initialCenter: fmlt.LatLng(
                                                    center.latitude, center.longitude),
                                                initialZoom: 16,
                                                onTap: (P, L) {
                                                  setState(() {});
                                                }),
                                            children: [
                                              fm.TileLayer(
                                                // minZoom: 10,
                                                urlTemplate:
                                                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                                userAgentPackageName: 'com.example.app',
                                              ),
                                              const fm.RichAttributionWidget(
                                                attributions: [],
                                              ),
                                            ],
                                          )
                                    : (_state == '2')
                                        ? Container(
                                            height: media.height * 1,
                                            width: media.width * 1,
                                            alignment: Alignment.center,
                                            child: Container(
                                              padding:
                                                  EdgeInsets.all(media.width * 0.05),
                                              width: media.width * 0.6,
                                              height: media.width * 0.3,
                                              decoration: BoxDecoration(
                                                  color: page,
                                                  boxShadow: [
                                                    BoxShadow(
                                                        blurRadius: 5,
                                                        color: Colors.black
                                                            .withOpacity(0.1),
                                                        spreadRadius: 2)
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.circular(10)),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    languages[choosenLanguage]
                                                        ['text_loc_permission'],
                                                    style: GoogleFonts.notoSans(
                                                        fontSize: media.width * sixteen,
                                                        color: textColor,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                  Container(
                                                    alignment: Alignment.centerRight,
                                                    child: InkWell(
                                                      onTap: () async {
                                                        setState(() {
                                                          _state = '';
                                                        });
                                                        await location
                                                            .requestPermission();
                                                        getLocs();
                                                      },
                                                      child: Text(
                                                        languages[choosenLanguage]
                                                            ['text_ok'],
                                                        style: GoogleFonts.notoSans(
                                                            fontWeight: FontWeight.bold,
                                                            fontSize:
                                                                media.width * twenty,
                                                            color: buttonColor),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        : Container(),


                                Positioned(
                                  bottom: 10, // Adjust position as needed
                                  right: 10,
                                  child: InkWell(
                                    onTap: () async {
                                      if (locationAllowed == true) {
                                        if (currentLocation != null) {
                                          _controller?.animateCamera(
                                              CameraUpdate.newLatLngZoom(
                                                  currentLocation, 18.0));
                                          center = currentLocation;
                                        } else {
                                          _controller?.animateCamera(
                                              CameraUpdate.newLatLngZoom(
                                                  center, 18.0));
                                        }
                                      } else {
                                        if (serviceEnabled == true) {
                                          setState(() {
                                            _locationDenied = true;
                                          });
                                        } else {
                                          // await location.requestService();
                                          await geolocs.Geolocator
                                              .getCurrentPosition(
                                              desiredAccuracy: geolocs
                                                  .LocationAccuracy
                                                  .low);
                                          if (await geolocs
                                              .GeolocatorPlatform.instance
                                              .isLocationServiceEnabled()) {
                                            setState(() {
                                              _locationDenied = true;
                                            });
                                          }
                                        }
                                      }
                                    },
                                    child: Container(
                                      height: media.width * 0.1,
                                      width: media.width * 0.1,
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                blurRadius: 2,
                                                color: Colors.black
                                                    .withOpacity(0.2),
                                                spreadRadius: 2)
                                          ],
                                          color: page,
                                          borderRadius:
                                          BorderRadius.circular(
                                              media.width * 0.06)),
                                      child: Icon(Icons.my_location_sharp,
                                          color: textColor),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                          bottom: 0 + MediaQuery.of(context).viewInsets.bottom,
                          child: (_getDropDetails == false)
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      color: page,
                                      width: media.width * 1,
                                      padding:
                                          EdgeInsets.all(media.width * 0.05),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          MyText(text: 'SAVE AS', size: font13Size,
                                            fontweight: FontWeight.w500,color: Color(0xff4F4F4f),),

                                           SizedBox(height: 12.0),
                                          Row(

                                            children: [
                                              GestureDetector(
                                                onTap:(){
                                                  setState(() {
                                                    selectedAddressType = "Home";
                                                    widget.favName="Home";
                                                    favName = 'Home';
                                                    widget.from="favourite";
                                                  });
                                                },
                                                child: AddressTypeButton(
                                                  label: 'Home',
                                                  icon: Icons.home,
                                                  isSelected: selectedAddressType == "Home",
                                                ),
                                              ),
                                              SizedBox(width: 15,),
                                              GestureDetector(
                                                onTap: (){
                                                  setState(() {
                                                    widget.favName="Work";
                                                    selectedAddressType = "Work";
                                                    favName = 'Work';
                                                    widget.from="favourite";
                                                  });
                                                },
                                                child: AddressTypeButton(
                                                  label: 'Work',
                                                  icon: Icons.work,
                                                  isSelected: selectedAddressType == "Work",
                                                ),
                                              ),
                                              SizedBox(width: 15,),
                                              GestureDetector(
                                                onTap: (){
                                                  setState(() {
                                                    // widget.favName="abc";
                                                    favName = 'Others';
                                                    selectedAddressType = "Other";
                                                  });
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return addDialoge(context);
                                                    },
                                                  );
                                                  print("widget.favName ${widget.favName}");
                                                },
                                                child: AddressTypeButton(
                                                  label: 'Other',
                                                  icon: Icons.question_mark,
                                                  isSelected: selectedAddressType == "Other",
                                                ),
                                              ),
                                            ],
                                          ),

                                          const SizedBox(height: 24.0),
                                          Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  media.width * 0.05,
                                                  media.width * 0.01,
                                                  media.width * 0.03,
                                                  media.width * 0.01),
                                              // height: media.width * 0.1,
                                              width: media.width * 0.9,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: borderColors,
                                                    width: 1.5,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          media.width * 0.02),
                                                  color: page),
                                              alignment: Alignment.centerLeft,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  MyText(text: "Address line 1",
                                                    fontweight: FontWeight.w500,
                                                    size: font13Size,color: Color(0xff5C6266),),
                                                  SizedBox(
                                                      width:
                                                          media.width * 0.02),
                                                  (dropAddressConfirmation ==
                                                          '')
                                                      ? Text(
                                                          languages[
                                                                  choosenLanguage]
                                                              [
                                                              'text_pickdroplocation'],
                                                          style: GoogleFonts.notoSans(
                                                              fontSize: media
                                                                      .width *
                                                                  twelve,
                                                              color:
                                                                  hintColor),
                                                        )
                                                      : Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            SizedBox(
                                                              width: media
                                                                      .width *
                                                                  0.7,
                                                              child:
                                                              MyText(text: dropAddressConfirmation,
                                                                fontweight: FontWeight.w500,
                                                                size: font16Size,color: Color(0xff303030),
                                                                maxLines:
                                                                1,
                                                                overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                              ),
                                                            ),
                                                            // (favAddress.length <
                                                            //             4 &&
                                                            //         (widget.from !=
                                                            //             'favourite'))
                                                            //     ?
                                                            // InkWell(
                                                            //         onTap:
                                                            //             () async {
                                                            //           if (favAddress.where((element) => element['pick_address'] == dropAddressConfirmation).isEmpty) {
                                                            //             setState(() {
                                                            //               favSelectedAddress = dropAddressConfirmation;
                                                            //               favLat = _center.latitude;
                                                            //               favLng = _center.longitude;
                                                            //               favAddressAdd = true;
                                                            //             });
                                                            //           }
                                                            //         },
                                                            //         child:
                                                            //             Icon(
                                                            //           Icons.favorite_outline,
                                                            //           size:
                                                            //               media.width * 0.05,
                                                            //           color: favAddress.where((element) => element['pick_address'] == dropAddressConfirmation).isEmpty
                                                            //               ? (isDarkTheme == true)
                                                            //                   ? Colors.white
                                                            //                   : textColor
                                                            //               : buttonColor,
                                                            //         ),
                                                            //       )
                                                            //     : Container()
                                                          ],
                                                        ),
                                                ],
                                              )),
                                          SizedBox(
                                            height: media.height * 0.02,
                                          ),
                                          Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  media.width * 0.05,
                                                  media.width * 0.01,
                                                  media.width * 0.03,
                                                  media.width * 0.01),
                                              // height: media.width * 0.1,
                                              width: media.width * 0.9,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: borderColors,
                                                    width: 1.5,
                                                  ),
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      media.width * 0.02),
                                                  color: page),
                                              alignment: Alignment.centerLeft,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  MyText(text: "Area",
                                                    fontweight: FontWeight.w500,
                                                    size: font13Size,color: Color(0xff5C6266),),
                                                  (area == '')
                                                      ? Text(
                                                    languages[
                                                    choosenLanguage]
                                                    [
                                                    'text_pickdroplocation'],
                                                    style: GoogleFonts.notoSans(
                                                        fontSize: media
                                                            .width *
                                                            twelve,
                                                        color:
                                                        hintColor),
                                                  )
                                                      : Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      SizedBox(
                                                        width: media
                                                            .width *
                                                            0.7,
                                                        child: MyText(text: area,
                                                          fontweight: FontWeight.w500,
                                                          size: font16Size,color: Color(0xff303030),
                                                          maxLines:
                                                          1,
                                                          overflow:
                                                          TextOverflow
                                                              .ellipsis,
                                                          ),

                                                      ),

                                                    ],
                                                  ),
                                                ],
                                              )),
                                          SizedBox(
                                            height: media.height * 0.02,
                                          ),
                                          Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  media.width * 0.05,
                                                  media.width * 0.01,
                                                  media.width * 0.03,
                                                  media.width * 0.01),
                                              // height: media.width * 0.1,
                                              width: media.width * 0.9,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: borderColors,
                                                    width: 1.5,
                                                  ),
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      media.width * 0.02),
                                                  color: page),
                                              alignment: Alignment.centerLeft,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  MyText(text: "City",
                                                    fontweight: FontWeight.w500,
                                                    size: font13Size,color: Color(0xff5C6266),),
                                                  SizedBox(
                                                      width:
                                                      media.width * 0.02),
                                                  (city ==
                                                      '')
                                                      ? Text(
                                                    languages[
                                                    choosenLanguage]
                                                    [
                                                    'text_pickdroplocation'],
                                                    style: GoogleFonts.notoSans(
                                                        fontSize: media
                                                            .width *
                                                            twelve,
                                                        color:
                                                        hintColor),
                                                  )
                                                      : Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      SizedBox(
                                                        width: media
                                                            .width *
                                                            0.7,
                                                        child: ValueListenableBuilder<String>(
                                                          valueListenable: cityNotifier,
                                                          builder: (context, city, child) {
                                                            return MyText(text: city,
                                                              fontweight: FontWeight.w500,
                                                              size: font16Size,color: Color(0xff303030),
                                                              maxLines:
                                                              1,
                                                              overflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                            );

                                                          },
                                                        ),
                                                        // Text(
                                                        //   city,
                                                        //   style: GoogleFonts
                                                        //       .notoSans(
                                                        //     fontSize:
                                                        //     media.width *
                                                        //         twelve,
                                                        //     color:
                                                        //     textColor,
                                                        //   ),
                                                        //   maxLines:
                                                        //   1,
                                                        //   overflow:
                                                        //   TextOverflow
                                                        //       .ellipsis,
                                                        // ),
                                                      ),
                                                      (favAddress.length <
                                                          4 &&
                                                          (widget.from !=
                                                              'favourite'))
                                                          ? InkWell(
                                                        onTap:
                                                            () async {
                                                          if (favAddress.where((element) => element['pick_address'] == dropAddressConfirmation).isEmpty) {
                                                            setState(() {
                                                              favSelectedAddress = dropAddressConfirmation;
                                                              favLat = _center.latitude;
                                                              favLng = _center.longitude;
                                                              favAddressAdd = true;
                                                            });
                                                          }
                                                        },
                                                        child:
                                                        Icon(
                                                          Icons.favorite_outline,
                                                          size:
                                                          media.width * 0.05,
                                                          color: favAddress.where((element) => element['pick_address'] == dropAddressConfirmation).isEmpty
                                                              ? (isDarkTheme == true)
                                                              ? Colors.white
                                                              : textColor
                                                              : buttonColor,
                                                        ),
                                                      )
                                                          : Container()
                                                    ],
                                                  ),
                                                ],
                                              )),
                                          SizedBox(
                                            height: media.height * 0.04,
                                          ),
                                          Button(
                                            color: buttonColors,
                                              textcolor: Color(0xff030303),
                                              borcolor: buttonColors,
                                              onTap: () async {
                                                if (dropAddressConfirmation !=
                                                    '') {
                                                  //remove in envato
                                                  if (choosenTransportType ==
                                                          0 &&
                                                      widget.from == null) {
                                                    if (addressList
                                                        .where((element) =>
                                                            element.type ==
                                                            'drop')
                                                        .isEmpty) {
                                                      addressList.add(AddressList(
                                                          id: (addressList
                                                                      .length +
                                                                  1)
                                                              .toString(),
                                                          type: 'drop',
                                                          address:
                                                              dropAddressConfirmation,
                                                          latlng: _center,
                                                          pickup: false));
                                                    } else {
                                                      addressList
                                                              .firstWhere(
                                                                  (element) =>
                                                                      element
                                                                          .type ==
                                                                      'drop')
                                                              .address =
                                                          dropAddressConfirmation;
                                                      addressList
                                                          .firstWhere(
                                                              (element) =>
                                                                  element
                                                                      .type ==
                                                                  'drop')
                                                          .latlng = _center;
                                                    }
                                                  } else if (choosenTransportType ==
                                                          0 &&
                                                      widget.from != null) {
                                                    if (widget.from != null &&
                                                        widget.from !=
                                                            'add stop' &&
                                                        widget.from !=
                                                            'favourite') {
                                                      addressList[widget.from]
                                                          .name = '';
                                                      addressList[widget.from]
                                                          .number = '';
                                                      addressList[widget.from]
                                                              .address =
                                                          dropAddressConfirmation;
                                                      addressList[widget.from]
                                                          .latlng = _center;
                                                      addressList[widget.from]
                                                          .instructions = null;
                                                    } else if (widget.from ==
                                                        'add stop') {
                                                      var address = addressList[
                                                              addressList
                                                                      .length -
                                                                  1]
                                                          .address;
                                                      var type = addressList[
                                                              addressList
                                                                      .length -
                                                                  1]
                                                          .type;
                                                      var name = addressList[
                                                              addressList
                                                                      .length -
                                                                  1]
                                                          .name;
                                                      var number = addressList[
                                                              addressList
                                                                      .length -
                                                                  1]
                                                          .number;
                                                      var instruction =
                                                          addressList[addressList
                                                                      .length -
                                                                  1]
                                                              .instructions;
                                                      var pickup = addressList[
                                                              addressList
                                                                      .length -
                                                                  1]
                                                          .pickup;
                                                      var id = addressList[
                                                              addressList
                                                                      .length -
                                                                  1]
                                                          .id;
                                                      var latlng = addressList[
                                                              addressList
                                                                      .length -
                                                                  1]
                                                          .latlng;

                                                      addressList[addressList
                                                                      .length -
                                                                  1]
                                                              .id =
                                                          (addressList.length +
                                                                  1)
                                                              .toString();
                                                      addressList[addressList
                                                                  .length -
                                                              1]
                                                          .type = 'drop';
                                                      addressList[addressList
                                                                      .length -
                                                                  1]
                                                              .address =
                                                          dropAddressConfirmation;
                                                      addressList[addressList
                                                                  .length -
                                                              1]
                                                          .latlng = _center;
                                                      addressList[addressList
                                                                  .length -
                                                              1]
                                                          .name = '';
                                                      addressList[addressList
                                                                  .length -
                                                              1]
                                                          .number = '';
                                                      addressList[addressList
                                                                  .length -
                                                              1]
                                                          .instructions = null;
                                                      addressList[addressList
                                                                  .length -
                                                              1]
                                                          .pickup = false;

                                                      addressList.add(
                                                          AddressList(
                                                              id: id,
                                                              type: type,
                                                              address: address,
                                                              latlng: latlng,
                                                              name: name,
                                                              number: number,
                                                              instructions:
                                                                  instruction,
                                                              pickup: pickup));
                                                    } else if (widget.from ==
                                                        'favourite') {
                                                      setState(() {
                                                        _isLoading = true;
                                                        favSelectedAddress =
                                                            dropAddressConfirmation;
                                                        favLat =
                                                            _center.latitude;
                                                        favLng =
                                                            _center.longitude;
                                                      });
                                                      await addFavLocation(
                                                          favLat,
                                                          favLng,
                                                          favSelectedAddress,
                                                          widget.favName);
                                                      valueNotifierHome
                                                          .incrementNotifier();
                                                    }
                                                    Navigator.pop(
                                                        // ignore: use_build_context_synchronously
                                                        context,
                                                        true);
                                                  } else if (choosenTransportType ==
                                                      1) {
                                                    if (widget.from == null) {
                                                      if ((addressList
                                                          .where((element) =>
                                                              element.id == '2')
                                                          .isEmpty)) {
                                                        addressList.add(AddressList(
                                                            id: (addressList
                                                                        .length +
                                                                    1)
                                                                .toString(),
                                                            type: 'drop',
                                                            address:
                                                                dropAddressConfirmation,
                                                            latlng: _center,
                                                            instructions: null,
                                                            pickup: false));
                                                      } else {
                                                        addressList
                                                                .firstWhere(
                                                                    (element) =>
                                                                        element
                                                                            .id ==
                                                                        '2')
                                                                .address =
                                                            dropAddressConfirmation;
                                                        addressList
                                                            .firstWhere(
                                                                (element) =>
                                                                    element
                                                                        .id ==
                                                                    '2')
                                                            .latlng = _center;
                                                      }
                                                    }

                                                    if (recentSearchesList
                                                            .length >
                                                        3) {
                                                      recentSearchesList
                                                          .removeAt(0);
                                                    }

                                                    if (recentSearchesList.any(
                                                        (mapTested) =>
                                                            mapTested[
                                                                'address'] ==
                                                            addressList[1]
                                                                .address
                                                                .toString())) {
                                                    } else {
                                                      recentSearchesList.add({
                                                        'address':
                                                            addressList[1]
                                                                .address,
                                                        'id': addressList
                                                            .firstWhere(
                                                                (element) =>
                                                                    element
                                                                        .type ==
                                                                    'drop')
                                                            .id,
                                                        'type': addressList
                                                            .firstWhere(
                                                                (element) =>
                                                                    element
                                                                        .type ==
                                                                    'drop')
                                                            .type,
                                                        'pickup': addressList
                                                            .firstWhere(
                                                                (element) =>
                                                                    element
                                                                        .type ==
                                                                    'drop')
                                                            .pickup,
                                                        'latlng': [
                                                          addressList
                                                              .firstWhere(
                                                                  (element) =>
                                                                      element
                                                                          .type ==
                                                                      'drop')
                                                              .latlng
                                                              .latitude,
                                                          addressList
                                                              .firstWhere(
                                                                  (element) =>
                                                                      element
                                                                          .type ==
                                                                      'drop')
                                                              .latlng
                                                              .longitude,
                                                        ]
                                                      });
                                                      pref.setString(
                                                          'recentsearch',
                                                          jsonEncode(
                                                              recentSearchesList));
                                                    }
                                                    setState(() {
                                                      _getDropDetails = true;
                                                    });
                                                  }
                                                  if (addressList.length >= 2 &&
                                                      choosenTransportType ==
                                                          0 &&
                                                      widget.from == null) {
                                                    ismulitipleride = false;

                                                    if (recentSearchesList
                                                            .length >
                                                        3) {
                                                      recentSearchesList
                                                          .removeAt(0);
                                                    }

                                                    if (recentSearchesList.any(
                                                        (mapTested) =>
                                                            mapTested[
                                                                'address'] ==
                                                            addressList[1]
                                                                .address
                                                                .toString())) {
                                                    } else {
                                                      recentSearchesList.add({
                                                        'address':
                                                            addressList[1]
                                                                .address,
                                                        'id': addressList
                                                            .firstWhere(
                                                                (element) =>
                                                                    element
                                                                        .type ==
                                                                    'drop')
                                                            .id,
                                                        'type': addressList
                                                            .firstWhere(
                                                                (element) =>
                                                                    element
                                                                        .type ==
                                                                    'drop')
                                                            .type,
                                                        'pickup': addressList
                                                            .firstWhere(
                                                                (element) =>
                                                                    element
                                                                        .type ==
                                                                    'drop')
                                                            .pickup,
                                                        'latlng': [
                                                          addressList
                                                              .firstWhere(
                                                                  (element) =>
                                                                      element
                                                                          .type ==
                                                                      'drop')
                                                              .latlng
                                                              .latitude,
                                                          addressList
                                                              .firstWhere(
                                                                  (element) =>
                                                                      element
                                                                          .type ==
                                                                      'drop')
                                                              .latlng
                                                              .longitude
                                                        ],
                                                      });
                                                      pref.setString(
                                                          'recentsearch',
                                                          jsonEncode(
                                                                  recentSearchesList)
                                                              .toString());
                                                    }
                                                    var val = await Navigator
                                                        .pushReplacement(
                                                            // ignore: use_build_context_synchronously
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        BookingConfirmation()));
                                                    if (val) {
                                                      setState(() {});
                                                    }
                                                  }
                                                  if (addressList.length >= 2 &&
                                                      choosenTransportType ==
                                                          2 &&
                                                      widget.from == null) {
                                                    ismulitipleride = false;

                                                    if (recentSearchesList
                                                            .length >=
                                                        3) {
                                                      recentSearchesList
                                                          .removeAt(0);
                                                    }

                                                    if (recentSearchesList.any(
                                                        (mapTested) =>
                                                            mapTested[
                                                                'address'] ==
                                                            addressList[1]
                                                                .address
                                                                .toString())) {
                                                    } else {
                                                      recentSearchesList.add({
                                                        'address':
                                                            addressList[1]
                                                                .address,
                                                        'id': addressList
                                                            .firstWhere(
                                                                (element) =>
                                                                    element
                                                                        .type ==
                                                                    'drop')
                                                            .id,
                                                        'type': addressList
                                                            .firstWhere(
                                                                (element) =>
                                                                    element
                                                                        .type ==
                                                                    'drop')
                                                            .type,
                                                        'pickup': addressList
                                                            .firstWhere(
                                                                (element) =>
                                                                    element
                                                                        .type ==
                                                                    'drop')
                                                            .pickup,
                                                        'latlng': [
                                                          addressList
                                                              .firstWhere(
                                                                  (element) =>
                                                                      element
                                                                          .type ==
                                                                      'drop')
                                                              .latlng
                                                              .latitude,
                                                          addressList
                                                              .firstWhere(
                                                                  (element) =>
                                                                      element
                                                                          .type ==
                                                                      'drop')
                                                              .latlng
                                                              .longitude
                                                        ]
                                                      });
                                                      pref.setString(
                                                          'recentsearch',
                                                          jsonEncode(
                                                                  recentSearchesList)
                                                              .toString());
                                                    }
                                                    // ignore: use_build_context_synchronously
                                                    var val = await Navigator
                                                        .pushReplacement(
                                                            // ignore: use_build_context_synchronously
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        BookingConfirmation()));
                                                    if (val) {
                                                      setState(() {});
                                                    }
                                                  }
                                                }
                                              },
                                              text: languages[choosenLanguage]
                                                  ['text_confirm']),
                                          SizedBox(
                                            height: media.height * 0.06,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              : Container(
                                  height: media.height * 1,
                                  color: Colors.transparent.withOpacity(0.1),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        color: page,
                                        width: media.width * 1,
                                        padding:
                                            EdgeInsets.all(media.width * 0.05),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: media.width * 0.9,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    (widget.from.toString() !=
                                                            '1')
                                                        ? languages[
                                                                choosenLanguage]
                                                            [
                                                            'text_give_buyerdata']
                                                        : languages[
                                                                choosenLanguage]
                                                            [
                                                            'text_give_userdata'],
                                                    style: GoogleFonts.notoSans(
                                                        color: textColor,
                                                        fontSize: media.width *
                                                            sixteen,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  InkWell(
                                                      onTap: () async {
                                                        var nav = await Navigator
                                                            .push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            const PickContact(
                                                                              from: '2',
                                                                            )));
                                                        if (nav) {
                                                          setState(() {
                                                            buyerName.text =
                                                                pickedName;
                                                            buyerNumber.text =
                                                                pickedNumber;
                                                          });
                                                        }
                                                      },
                                                      child: Icon(
                                                          Icons
                                                              .contact_page_rounded,
                                                          color: textColor))
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: media.width * 0.025,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  useMyDetails = !useMyDetails;
                                                  if (useMyDetails == true) {
                                                    buyerName.text =
                                                        userDetails['name']
                                                            .toString();
                                                    buyerNumber.text =
                                                        userDetails['mobile']
                                                            .toString();
                                                  } else {
                                                    buyerName.text = '';
                                                    buyerNumber.text = '';
                                                  }
                                                });
                                              },
                                              child: Row(
                                                children: [
                                                  Container(
                                                    alignment: Alignment.center,
                                                    height: media.width * 0.05,
                                                    width: media.width * 0.05,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: textColor)),
                                                    child: useMyDetails
                                                        ? Icon(
                                                            Icons.done,
                                                            size: media.width *
                                                                0.04,
                                                            color: textColor,
                                                          )
                                                        : Container(),
                                                  ),
                                                  SizedBox(
                                                    width: media.width * 0.025,
                                                  ),
                                                  MyText(
                                                      text: languages[
                                                              choosenLanguage][
                                                          'text_use_my_name_number'],
                                                      size:
                                                          media.width * twelve)
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: media.width * 0.025,
                                            ),
                                            Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  media.width * 0.03,
                                                  (languageDirection == 'rtl')
                                                      ? media.width * 0.04
                                                      : 0,
                                                  media.width * 0.03,
                                                  media.width * 0.01),
                                              height: media.width * 0.1,
                                              width: media.width * 0.9,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.grey,
                                                    width: 1.5,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          media.width * 0.02),
                                                  color: page),
                                              child: TextField(
                                                onChanged: (val) {
                                                  setState(() {});
                                                },
                                                controller: buyerName,
                                                readOnly: (useMyDetails)
                                                    ? true
                                                    : false,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText:
                                                      languages[choosenLanguage]
                                                          ['text_name'],
                                                  hintStyle:
                                                      GoogleFonts.notoSans(
                                                          color: textColor
                                                              .withOpacity(0.3),
                                                          fontSize:
                                                              media.width *
                                                                  twelve),
                                                ),
                                                textAlignVertical:
                                                    TextAlignVertical.center,
                                                style: GoogleFonts.notoSans(
                                                    color: textColor,
                                                    fontSize:
                                                        media.width * twelve),
                                              ),
                                            ),
                                            SizedBox(
                                              height: media.width * 0.025,
                                            ),
                                            Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  media.width * 0.03,
                                                  (languageDirection == 'rtl')
                                                      ? media.width * 0.04
                                                      : 0,
                                                  media.width * 0.03,
                                                  media.width * 0.01),
                                              height: media.width * 0.1,
                                              width: media.width * 0.9,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.grey,
                                                    width: 1.5,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          media.width * 0.02),
                                                  color: page),
                                              child: TextField(
                                                onChanged: (val) {
                                                  setState(() {});
                                                },
                                                controller: buyerNumber,
                                                keyboardType:
                                                    TextInputType.number,
                                                readOnly: (useMyDetails)
                                                    ? true
                                                    : false,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  counterText: '',
                                                  hintText:
                                                      languages[choosenLanguage]
                                                          ['text_givenumber'],
                                                  hintStyle:
                                                      GoogleFonts.notoSans(
                                                          color: textColor
                                                              .withOpacity(0.3),
                                                          fontSize:
                                                              media.width *
                                                                  twelve),
                                                ),
                                                textAlignVertical:
                                                    TextAlignVertical.center,
                                                style: GoogleFonts.notoSans(
                                                    color: textColor,
                                                    fontSize:
                                                        media.width * twelve),
                                                maxLength: 20,
                                              ),
                                            ),
                                            SizedBox(
                                              height: media.width * 0.025,
                                            ),
                                            Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  media.width * 0.03,
                                                  (languageDirection == 'rtl')
                                                      ? media.width * 0.04
                                                      : 0,
                                                  media.width * 0.03,
                                                  media.width * 0.01),
                                              // height: media.width * 0.1,
                                              width: media.width * 0.9,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.grey,
                                                    width: 1.5,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          media.width * 0.02),
                                                  color: page),
                                              child: TextField(
                                                controller: instructions,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  counterText: '',
                                                  hintText:
                                                      languages[choosenLanguage]
                                                          ['text_instructions'],
                                                  hintStyle:
                                                      GoogleFonts.notoSans(
                                                          color: textColor
                                                              .withOpacity(0.3),
                                                          fontSize:
                                                              media.width *
                                                                  twelve),
                                                ),
                                                textAlignVertical:
                                                    TextAlignVertical.center,
                                                style: GoogleFonts.notoSans(
                                                    color: textColor,
                                                    fontSize:
                                                        media.width * twelve),
                                                maxLines: 4,
                                                minLines: 2,
                                              ),
                                            ),
                                            SizedBox(
                                              height: media.width * 0.03,
                                            ),
                                            Button(
                                              onTap: () async {
                                                if (widget.from != null &&
                                                    widget.from != 'add stop') {
                                                  addressList[widget.from]
                                                      .name = buyerName.text;
                                                  addressList[widget.from]
                                                          .number =
                                                      buyerNumber.text;
                                                  addressList[widget.from]
                                                          .address =
                                                      dropAddressConfirmation;
                                                  addressList[widget.from]
                                                      .latlng = _center;
                                                  addressList[widget.from]
                                                          .instructions =
                                                      (instructions
                                                              .text.isNotEmpty)
                                                          ? instructions.text
                                                          : null;
                                                } else if (widget.from ==
                                                        'add stop' &&
                                                    buyerName.text.isNotEmpty &&
                                                    buyerNumber
                                                        .text.isNotEmpty) {
                                                  var address = addressList[
                                                          addressList.length -
                                                              1]
                                                      .address;
                                                  var type = addressList[
                                                          addressList.length -
                                                              1]
                                                      .type;
                                                  var name = addressList[
                                                          addressList.length -
                                                              1]
                                                      .name;
                                                  var number = addressList[
                                                          addressList.length -
                                                              1]
                                                      .number;
                                                  var instruction = addressList[
                                                          addressList.length -
                                                              1]
                                                      .instructions;
                                                  var pickup = addressList[
                                                          addressList.length -
                                                              1]
                                                      .pickup;
                                                  var id = addressList[
                                                          addressList.length -
                                                              1]
                                                      .id;
                                                  var latlng = addressList[
                                                          addressList.length -
                                                              1]
                                                      .latlng;

                                                  addressList[addressList
                                                                  .length -
                                                              1]
                                                          .id =
                                                      (addressList.length + 1)
                                                          .toString();
                                                  addressList[
                                                          addressList.length -
                                                              1]
                                                      .type = 'drop';
                                                  addressList[addressList
                                                                  .length -
                                                              1]
                                                          .address =
                                                      dropAddressConfirmation;
                                                  addressList[
                                                          addressList.length -
                                                              1]
                                                      .latlng = _center;
                                                  addressList[
                                                          addressList.length -
                                                              1]
                                                      .name = buyerName.text;
                                                  addressList[addressList
                                                                  .length -
                                                              1]
                                                          .number =
                                                      buyerNumber.text;
                                                  addressList[addressList
                                                                  .length -
                                                              1]
                                                          .instructions =
                                                      (instructions
                                                              .text.isNotEmpty)
                                                          ? instructions.text
                                                          : null;
                                                  addressList[
                                                          addressList.length -
                                                              1]
                                                      .pickup = false;

                                                  addressList.add(AddressList(
                                                      id: id,
                                                      type: type,
                                                      address: address,
                                                      latlng: latlng,
                                                      name: name,
                                                      number: number,
                                                      instructions: instruction,
                                                      pickup: pickup));
                                                } else if (widget.from ==
                                                    null) {
                                                  if (buyerName
                                                          .text.isNotEmpty &&
                                                      buyerNumber
                                                          .text.isNotEmpty) {
                                                    addressList
                                                            .firstWhere(
                                                                (e) =>
                                                                    e.type ==
                                                                    'pickup')
                                                            .name =
                                                        userDetails['name'];
                                                    addressList
                                                            .firstWhere(
                                                                (e) =>
                                                                    e.type ==
                                                                    'pickup')
                                                            .number =
                                                        userDetails['mobile'];
                                                    addressList
                                                        .firstWhere((e) =>
                                                            e.type == 'drop')
                                                        .name = buyerName.text;
                                                    addressList
                                                            .firstWhere(
                                                                (e) =>
                                                                    e.type ==
                                                                    'drop')
                                                            .number =
                                                        buyerNumber.text;
                                                    addressList
                                                            .firstWhere(
                                                                (e) =>
                                                                    e.type ==
                                                                    'drop')
                                                            .instructions =
                                                        (instructions.text
                                                                .isNotEmpty)
                                                            ? instructions.text
                                                            : null;
                                                  }
                                                }

                                                if (addressList.length >= 2 &&
                                                    buyerName.text.isNotEmpty &&
                                                    buyerNumber
                                                        .text.isNotEmpty &&
                                                    widget.from == null) {
                                                  ismulitipleride = false;

                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              BookingConfirmation()));
                                                } else if (addressList.length >=
                                                        2 &&
                                                    buyerName.text.isNotEmpty &&
                                                    buyerNumber
                                                        .text.isNotEmpty &&
                                                    widget.from != null) {
                                                  Navigator.pop(context, true);
                                                } else if (addressList.length ==
                                                        1 &&
                                                    widget.from.toString() ==
                                                        '1' &&
                                                    buyerName.text.isNotEmpty &&
                                                    buyerNumber
                                                        .text.isNotEmpty &&
                                                    widget.from != null) {
                                                  Navigator.pop(context, true);
                                                }
                                              },
                                              text: languages[choosenLanguage]
                                                  ['text_confirm'],
                                              color:
                                                  (buyerName.text.isNotEmpty &&
                                                          buyerNumber
                                                              .text.isNotEmpty)
                                                      // ? buttonColor
                                                      ? Colors.black
                                                      : Colors.grey,
                                              borcolor:
                                                  (buyerName.text.isNotEmpty &&
                                                          buyerNumber
                                                              .text.isNotEmpty)
                                                      // ? buttonColor
                                                      ? Colors.black
                                                      : Colors.grey,
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )),

                      //autofill address
                      Positioned(
                          top: 0,
                          child: Container(
                            padding: EdgeInsets.fromLTRB(
                                media.width * 0.05,
                                MediaQuery.of(context).padding.top + 12.5,
                                media.width * 0.05,
                                0),
                            width: media.width * 1,
                            height: (addAutoFill.isNotEmpty)
                                ? media.width * 1.3
                                : null,
                            color: (addAutoFill.isEmpty)
                                ? Colors.transparent
                                : page,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [

                                InkWell(
                                  onTap: () {
                                    if (_getDropDetails == false ||
                                        choosenTransportType == 0) {
                                      Navigator.pop(context);
                                    } else {
                                      setState(() {
                                        _getDropDetails = false;
                                      });
                                    }
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: Color(0xffECECEC),
                                    radius: 18,
                                    child: Padding(
                                      padding:  EdgeInsets.only(left: 09),
                                      child: Icon(
                                        Icons.arrow_back_ios,
                                        color: iconGrayColors,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                MyText(text: "Add Address",size: font18Size,
                                  fontweight: FontWeight.w600,
                                  color: headingColors,
                                ),
                                SizedBox(width: media.width*0.05,)
                              ],
                            ),
                          )),

                      // //fav address
                      // (favAddressAdd == true)
                      //     ? Positioned(
                      //         top: 0,
                      //         child: Container(
                      //           height: media.height * 1,
                      //           width: media.width * 1,
                      //           color: Colors.transparent.withOpacity(0.6),
                      //           child: Column(
                      //             mainAxisAlignment: MainAxisAlignment.center,
                      //             children: [
                      //               SizedBox(
                      //                 width: media.width * 0.9,
                      //                 child: Row(
                      //                   mainAxisAlignment:
                      //                       MainAxisAlignment.end,
                      //                   children: [
                      //                     Container(
                      //                       height: media.width * 0.1,
                      //                       width: media.width * 0.1,
                      //                       decoration: BoxDecoration(
                      //                           shape: BoxShape.circle,
                      //                           color: page),
                      //                       child: InkWell(
                      //                         onTap: () {
                      //                           setState(() {
                      //                             favName = '';
                      //                             favAddressAdd = false;
                      //                           });
                      //                         },
                      //                         child: const Icon(
                      //                             Icons.cancel_outlined),
                      //                       ),
                      //                     ),
                      //                   ],
                      //                 ),
                      //               ),
                      //               SizedBox(
                      //                 height: media.width * 0.05,
                      //               ),
                      //               Container(
                      //                 padding:
                      //                     EdgeInsets.all(media.width * 0.05),
                      //                 width: media.width * 0.9,
                      //                 decoration: BoxDecoration(
                      //                     borderRadius:
                      //                         BorderRadius.circular(12),
                      //                     color: page),
                      //                 child: Column(
                      //                   children: [
                      //                     Text(
                      //                       languages[choosenLanguage]
                      //                           ['text_saveaddressas'],
                      //                       style: GoogleFonts.notoSans(
                      //                           fontSize: media.width * sixteen,
                      //                           color: textColor,
                      //                           fontWeight: FontWeight.w600),
                      //                     ),
                      //                     SizedBox(
                      //                       height: media.width * 0.025,
                      //                     ),
                      //                     Text(
                      //                       favSelectedAddress,
                      //                       style: GoogleFonts.notoSans(
                      //                           fontSize: media.width * twelve,
                      //                           color: textColor),
                      //                     ),
                      //                     SizedBox(
                      //                       height: media.width * 0.025,
                      //                     ),
                      //                     Row(
                      //                       mainAxisAlignment:
                      //                           MainAxisAlignment.spaceBetween,
                      //                       children: [
                      //                         InkWell(
                      //                           onTap: () {
                      //                             FocusManager
                      //                                 .instance.primaryFocus
                      //                                 ?.unfocus();
                      //                             setState(() {
                      //                               favName = 'Home';
                      //                             });
                      //                           },
                      //                           child: Container(
                      //                             padding: EdgeInsets.all(
                      //                                 media.width * 0.01),
                      //                             child: Row(
                      //                               children: [
                      //                                 Container(
                      //                                   height:
                      //                                       media.height * 0.05,
                      //                                   width:
                      //                                       media.width * 0.05,
                      //                                   decoration: BoxDecoration(
                      //                                       shape:
                      //                                           BoxShape.circle,
                      //                                       border: Border.all(
                      //                                           color: Colors
                      //                                               .black,
                      //                                           width: 1.2)),
                      //                                   alignment:
                      //                                       Alignment.center,
                      //                                   child:
                      //                                       (favName == 'Home')
                      //                                           ? Container(
                      //                                               height: media
                      //                                                       .width *
                      //                                                   0.03,
                      //                                               width: media
                      //                                                       .width *
                      //                                                   0.03,
                      //                                               decoration:
                      //                                                   const BoxDecoration(
                      //                                                 shape: BoxShape
                      //                                                     .circle,
                      //                                                 color: Colors
                      //                                                     .black,
                      //                                               ),
                      //                                             )
                      //                                           : Container(),
                      //                                 ),
                      //                                 SizedBox(
                      //                                   width:
                      //                                       media.width * 0.01,
                      //                                 ),
                      //                                 Text(languages[
                      //                                         choosenLanguage]
                      //                                     ['text_home'])
                      //                               ],
                      //                             ),
                      //                           ),
                      //                         ),
                      //                         InkWell(
                      //                           onTap: () {
                      //                             FocusManager
                      //                                 .instance.primaryFocus
                      //                                 ?.unfocus();
                      //                             setState(() {
                      //                               favName = 'Work';
                      //                             });
                      //                           },
                      //                           child: Container(
                      //                             padding: EdgeInsets.all(
                      //                                 media.width * 0.01),
                      //                             child: Row(
                      //                               children: [
                      //                                 Container(
                      //                                   height:
                      //                                       media.height * 0.05,
                      //                                   width:
                      //                                       media.width * 0.05,
                      //                                   decoration: BoxDecoration(
                      //                                       shape:
                      //                                           BoxShape.circle,
                      //                                       border: Border.all(
                      //                                           color: Colors
                      //                                               .black,
                      //                                           width: 1.2)),
                      //                                   alignment:
                      //                                       Alignment.center,
                      //                                   child:
                      //                                       (favName == 'Work')
                      //                                           ? Container(
                      //                                               height: media
                      //                                                       .width *
                      //                                                   0.03,
                      //                                               width: media
                      //                                                       .width *
                      //                                                   0.03,
                      //                                               decoration:
                      //                                                   const BoxDecoration(
                      //                                                 shape: BoxShape
                      //                                                     .circle,
                      //                                                 color: Colors
                      //                                                     .black,
                      //                                               ),
                      //                                             )
                      //                                           : Container(),
                      //                                 ),
                      //                                 SizedBox(
                      //                                   width:
                      //                                       media.width * 0.01,
                      //                                 ),
                      //                                 Text(languages[
                      //                                         choosenLanguage]
                      //                                     ['text_work'])
                      //                               ],
                      //                             ),
                      //                           ),
                      //                         ),
                      //                         InkWell(
                      //                           onTap: () {
                      //                             FocusManager
                      //                                 .instance.primaryFocus
                      //                                 ?.unfocus();
                      //                             setState(() {
                      //                               favName = 'Others';
                      //                             });
                      //                           },
                      //                           child: Container(
                      //                             padding: EdgeInsets.all(
                      //                                 media.width * 0.01),
                      //                             child: Row(
                      //                               children: [
                      //                                 Container(
                      //                                   height:
                      //                                       media.height * 0.05,
                      //                                   width:
                      //                                       media.width * 0.05,
                      //                                   decoration: BoxDecoration(
                      //                                       shape:
                      //                                           BoxShape.circle,
                      //                                       border: Border.all(
                      //                                           color: Colors
                      //                                               .black,
                      //                                           width: 1.2)),
                      //                                   alignment:
                      //                                       Alignment.center,
                      //                                   child: (favName ==
                      //                                           'Others')
                      //                                       ? Container(
                      //                                           height: media
                      //                                                   .width *
                      //                                               0.03,
                      //                                           width: media
                      //                                                   .width *
                      //                                               0.03,
                      //                                           decoration:
                      //                                               const BoxDecoration(
                      //                                             shape: BoxShape
                      //                                                 .circle,
                      //                                             color: Colors
                      //                                                 .black,
                      //                                           ),
                      //                                         )
                      //                                       : Container(),
                      //                                 ),
                      //                                 SizedBox(
                      //                                   width:
                      //                                       media.width * 0.01,
                      //                                 ),
                      //                                 Text(languages[
                      //                                         choosenLanguage]
                      //                                     ['text_others'])
                      //                               ],
                      //                             ),
                      //                           ),
                      //                         ),
                      //                       ],
                      //                     ),
                      //                     (favName == 'Others')
                      //                         ? Container(
                      //                             padding: EdgeInsets.all(
                      //                                 media.width * 0.025),
                      //                             decoration: BoxDecoration(
                      //                                 borderRadius:
                      //                                     BorderRadius.circular(
                      //                                         12),
                      //                                 border: Border.all(
                      //                                     color: borderLines,
                      //                                     width: 1.2)),
                      //                             child: TextField(
                      //                               decoration: InputDecoration(
                      //                                   border:
                      //                                       InputBorder.none,
                      //                                   hintText: languages[
                      //                                           choosenLanguage]
                      //                                       [
                      //                                       'text_enterfavname'],
                      //                                   hintStyle: GoogleFonts
                      //                                       .notoSans(
                      //                                           fontSize: media
                      //                                                   .width *
                      //                                               twelve,
                      //                                           color:
                      //                                               hintColor)),
                      //                               maxLines: 1,
                      //                               onChanged: (val) {
                      //                                 setState(() {
                      //                                   favNameText = val;
                      //                                 });
                      //                               },
                      //                             ),
                      //                           )
                      //                         : Container(),
                      //                     SizedBox(
                      //                       height: media.width * 0.05,
                      //                     ),
                      //                     Button(
                      //                         onTap: () async {
                      //                           if (favName == 'Others' &&
                      //                               favNameText != '') {
                      //                             setState(() {
                      //                               _isLoading = true;
                      //                             });
                      //                             var val =
                      //                                 await addFavLocation(
                      //                                     favLat,
                      //                                     favLng,
                      //                                     favSelectedAddress,
                      //                                     favNameText);
                      //                             setState(() {
                      //                               _isLoading = false;
                      //                               if (val == true) {
                      //                                 favLat = '';
                      //                                 favLng = '';
                      //                                 favSelectedAddress = '';
                      //                                 favNameText = '';
                      //                                 favName = 'Home';
                      //                                 favAddressAdd = false;
                      //                               } else if (val ==
                      //                                   'logout') {
                      //                                 navigateLogout();
                      //                               }
                      //                             });
                      //                           } else if (favName == 'Home' ||
                      //                               favName == 'Work') {
                      //                             setState(() {
                      //                               _isLoading = true;
                      //                             });
                      //                             var val =
                      //                                 await addFavLocation(
                      //                                     favLat,
                      //                                     favLng,
                      //                                     favSelectedAddress,
                      //                                     favName);
                      //                             setState(() {
                      //                               _isLoading = false;
                      //                               if (val == true) {
                      //                                 favLat = '';
                      //                                 favLng = '';
                      //                                 favSelectedAddress = '';
                      //                                 favNameText = '';
                      //                                 favName = 'Home';
                      //                                 favAddressAdd = false;
                      //                               } else if (val ==
                      //                                   'logout') {
                      //                                 navigateLogout();
                      //                               }
                      //                             });
                      //                           }
                      //                         },
                      //                         text: languages[choosenLanguage]
                      //                             ['text_confirm'])
                      //                   ],
                      //                 ),
                      //               )
                      //             ],
                      //           ),
                      //         ))
                      //     : Container(),

                      (_locationDenied == true)
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
                                              _locationDenied = false;
                                            });
                                          },
                                          child: Container(
                                            height: media.height * 0.05,
                                            width: media.height * 0.05,
                                            decoration: BoxDecoration(
                                              color: page,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(Icons.cancel,
                                                color: buttonColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: media.width * 0.025),
                                  Container(
                                    padding: EdgeInsets.all(media.width * 0.05),
                                    width: media.width * 0.9,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: page,
                                        boxShadow: [
                                          BoxShadow(
                                              blurRadius: 2.0,
                                              spreadRadius: 2.0,
                                              color:
                                                  Colors.black.withOpacity(0.2))
                                        ]),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                            width: media.width * 0.8,
                                            child: Text(
                                              languages[choosenLanguage]
                                                  ['text_open_loc_settings'],
                                              style: GoogleFonts.notoSans(
                                                  fontSize:
                                                      media.width * sixteen,
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
                                                  await perm.openAppSettings();
                                                },
                                                child: Text(
                                                  languages[choosenLanguage]
                                                      ['text_open_settings'],
                                                  style: GoogleFonts.notoSans(
                                                      fontSize:
                                                          media.width * sixteen,
                                                      color: buttonColor,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                )),
                                            InkWell(
                                                onTap: () async {
                                                  setState(() {
                                                    _locationDenied = false;
                                                    _isLoading = true;
                                                  });

                                                  getLocs();
                                                },
                                                child: Text(
                                                  languages[choosenLanguage]
                                                      ['text_done'],
                                                  style: GoogleFonts.notoSans(
                                                      fontSize:
                                                          media.width * sixteen,
                                                      color: buttonColor,
                                                      fontWeight:
                                                          FontWeight.w600),
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
                      (_isLoading == true)
                          ? const Positioned(child: Loading())
                          : Container(),
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
              );
            }),
      ),
    );
  }
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
            onTap: () {

              },
          ),
        ],
      ),
      actions: [
        Button(
          color: buttonColors,
          borcolor: buttonColors,
          textcolor: headingColors,
          onTap: () async {
            Navigator.pop(context);
            setState(() {
              widget.favName = newAddressController.text; // Update directly
            });
            },
          text: 'Add',
          width: media.width * 0.25,
          height: media.width * 0.1,
        ),
      ],
    );
  }
}


class AddressTypeButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;

  const AddressTypeButton({
    Key? key,
    required this.label,
    required this.icon,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: isSelected ? Color(0xffECECEC):whiteColors),
        color: isSelected ?whiteColors:Color(0xffECECEC),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 07),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Icon(icon, color:  headingColors),
            const SizedBox(width: 8.0),
            Text(
              label,
              style: TextStyle(
                fontSize: 14.0,
                color:  headingColors,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddressInputField extends StatelessWidget {
  final String label;
  final String hint;

  const AddressInputField({
    Key? key,
    required this.label,
    required this.hint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8.0),
        TextFormField(
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
          ),
        ),
      ],
    );
  }
}