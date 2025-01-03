import 'dart:math';
import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_user/pages/profile/profile_screen.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:uuid/uuid.dart';
import '../../widgets/appbar.dart';

import '../NavigatorPages/activitiesScreen.dart';
import '../login/login.dart';
import '../onTripPage/booking_confirmation.dart';

import '../onTripPage/map_page.dart';
import '../profile/HomeScreen.dart';
import '../../styles/styles.dart';

import '../../widgets/widgets.dart';
import '../loadingPage/loading.dart';
import '../../functions/geohash.dart';
import '../navDrawer/nav_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../noInternet/noInternet.dart';
import 'package:location/location.dart';
import '../../functions/functions.dart';
import '../../functions/notifications.dart';
import '../../translations/translation.dart';
import '../NavigatorPages/notification.dart';
import 'package:latlong2/latlong.dart' as fmlt;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_map/flutter_map.dart' as fm;
import 'package:geolocator/geolocator.dart' as geolocs;
import 'package:vector_math/vector_math.dart' as vector;
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';





class CustomBottomNavExample extends StatefulWidget {
  @override
  _CustomBottomNavExampleState createState() => _CustomBottomNavExampleState();
}

class _CustomBottomNavExampleState extends State<CustomBottomNavExample> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    ActivitiesScreen(),
    NotificationPage(),
    Center(child: Text('Help Page')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Custom BottomNavigationBar'),
      // ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ],
        ),
      // padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home, "Home", 0),
            _buildNavItem(Icons.history, "Activity", 1),
            _buildNavItem(Icons.notifications, "Alerts", 2),
            _buildNavItem(Icons.help, "Help", 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          isSelected ? Container(
            height: 4,
            width: 55,
            color: buttonColors,
          ):Container(
            height: 4,
            width: 55,
            color: Colors.transparent,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 08),
            child: Column(
              children: [
                Icon(
                  icon,
                  color: isSelected ? Color(0xff0F0F0F) : Color(0xffA6A8B9),
                  size: isSelected ? 30 : 24,
                ),
                const SizedBox(height: 5),
                MyText(text: label, size: font14Size,
                  color: isSelected ? Color(0xff0F0F0F) : Color(0xffA6A8B9),fontweight: FontWeight.w500,),

              ],
            ),
          ),

        ],
      ),
    );
  }
}


class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final _mapMarkerSC = StreamController<List<Marker>>();
  Stream<List<Marker>> get carMarkerStream => _mapMarkerSC.stream;
  dynamic _controller;
  LatLng _centerLocation = const LatLng(41.4219057, -102.0840772);
  dynamic _lastCenter;
  bool ischanged = false;
  Location location = Location();
  dynamic pinLocationIcon;
  dynamic deliveryIcon;
  dynamic bikeIcon;
  dynamic userLocationIcon;
  late geolocs.LocationPermission permission;
  int gettingPerm = 0;
  String state = '';
  bool _loading = false;

  int _selectedIndex = 0;





  @override
  void initState() {

    getLocs();
    getWalletHistory();
    super.initState();
  }

  getLocs() async {
    if (signKey == '' || packageName == '') {
      PackageInfo buildKeys = await PackageInfo.fromPlatform();
      signKey = buildKeys.buildSignature;
      packageName = buildKeys.packageName;
    }
    // myBearings.clear;
    addressList.clear();
    serviceEnabled = await location.serviceEnabled();
    polyline.clear();
    final Uint8List markerIcon =
    await getBytesFromAsset('assets/images/top-taxi.png', 40);
    pinLocationIcon = BitmapDescriptor.fromBytes(markerIcon);
    final Uint8List deliveryIcons =
    await getBytesFromAsset('assets/images/deliveryicon.png', 40);
    deliveryIcon = BitmapDescriptor.fromBytes(deliveryIcons);
    final Uint8List bikeIcons =
    await getBytesFromAsset('assets/images/bike.png', 40);
    bikeIcon = BitmapDescriptor.fromBytes(bikeIcons);

    permission = await geolocs.GeolocatorPlatform.instance.checkPermission();

    if (permission == geolocs.LocationPermission.denied ||
        permission == geolocs.LocationPermission.deniedForever ||
        serviceEnabled == false) {
      gettingPerm++;

      if (gettingPerm > 1 || locationAllowed == false) {
        state = '3';
        locationAllowed = false;
      } else {
        state = '2';
      }
      _loading = false;
      setState(() {});
    } else {
      var locs = await geolocs.Geolocator.getLastKnownPosition();
      if (locs != null) {
        setState(() {
          center = LatLng(double.parse(locs.latitude.toString()),
              double.parse(locs.longitude.toString()));
          _centerLocation = LatLng(double.parse(locs.latitude.toString()),
              double.parse(locs.longitude.toString()));
          currentLocation = LatLng(double.parse(locs.latitude.toString()),
              double.parse(locs.longitude.toString()));
          _lastCenter = _centerLocation;
        });
      } else {
        var loc = await geolocs.Geolocator.getCurrentPosition(
            desiredAccuracy: geolocs.LocationAccuracy.low);
        setState(() {
          center = LatLng(double.parse(loc.latitude.toString()),
              double.parse(loc.longitude.toString()));
          _centerLocation = LatLng(double.parse(loc.latitude.toString()),
              double.parse(loc.longitude.toString()));
          currentLocation = LatLng(double.parse(loc.latitude.toString()),
              double.parse(loc.longitude.toString()));
          _lastCenter = _centerLocation;
        });
      }

// _centerLocation = center;
      _lastCenter = _centerLocation;

      setState(() {
        locationAllowed = true;
        state = '3';
        _loading = false;
      });
      if (locationAllowed == true) {
        if (positionStream == null || positionStream!.isPaused) {
          positionStreamData();
        }
      }
    }
    // fdbfun();
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _controller = controller;
      _controller?.setMapStyle(mapStyle);
    });
  }

  @override
  Widget build(BuildContext context) {

    var media = MediaQuery.of(context).size;

    return Scaffold(
     backgroundColor: whiteColors,
      // appBar: AppBar(
      //   backgroundColor: whiteColors,
      //   elevation: 0,
      //   leading: Icon(Icons.menu, color: Colors.black),
      //   actions: [
      //     Padding(
      //       padding: const EdgeInsets.only(right: 16.0),
      //       child: Icon(Icons.account_circle, color: Colors.black),
      //     ),
      //   ],
      // ),
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.only(top: media.height*0.07,right: media.width*0.05,
              left: media.width*0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyText(text: "Good Morning", size: font15Size,
                        fontweight: FontWeight.w400,color: Color(0xff000000),),
                      SizedBox(height: media.height*0.001),
                      MyText(text: userDetails['name'], size: font24Size,fontweight: FontWeight.w700,
                          color: Color(0xff343434)),
                    ],
                  ),
                  userProfile(context:context),

                ],
              ),


              SizedBox(height: media.height*0.020),

              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Maps()));
                },
                child: Container(

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5), // Shadow color
                        spreadRadius: 2, // How much the shadow spreads
                        blurRadius: 2, // How soft or sharp the shadow is
                        offset: Offset(0, 1), // Horizontal and vertical offset
                      ),
                    ],

                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.location_on),
                      hintText: "Where to?",
                      hintStyle: TextStyle(
                        color: Color(0xff494949),
                        fontWeight: FontWeight.w600,
                        fontSize: font16Size,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none, // No border since it's inside the shadowed container
                      ),
                      filled: true, // Ensures the background color of the TextField is visible
                      fillColor: whiteColors, // Background color of the TextField
                    ),
                  ),
                ),
              ),
              SizedBox(height: media.height*0.017),

              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                shrinkWrap: true,
                childAspectRatio:4/3,
                physics: NeverScrollableScrollPhysics(),
                children: [

                  _buildOptionCard(
                      context,
                      "Rent",
                      "assets/icons/rentHome.png",
                      (){
                        isRentalRide = false;
                        print("choosenTransportType ${choosenTransportType}");
                        if (choosenTransportType != 0) {
                          setState(() {
                            choosenTransportType = 0;
                            // isRentalRide = false;
                            myMarkers.clear();
                          });
                        }
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Maps()));

                      }
                  ),

                  _buildOptionCard(
                      context,
                      "Ride",
                      "assets/icons/rideHome.png",
                          (){
                           isRentalRide = false;
                            print("choosenTransportType ${choosenTransportType}");
                            if (choosenTransportType != 1) {
                              setState(() {
                                choosenTransportType = 1;
                                print("choosenTransportType::- ${choosenTransportType}");
                                // isRentalRide = false;
                                myMarkers.clear();
                                // print('object ' + transportType.toString());
                              });
                            }
                           Navigator.push(context, MaterialPageRoute(builder: (context)=>Maps()));
                      }
                  ),
                  _buildOptionCard(
                      context,
                      "Delivery",
                      "assets/icons/deliveryHome.png",
                          (){

                            addressList.removeWhere((element) => element.type == 'drop');
                            isRentalRide = true;

                            if (userDetails['enable_modules_for_applications'] == 'taxi') {
                              choosenTransportType = 0;
                              ismulitipleride = false;
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BookingConfirmation(
                                        type: 1,
                                      )),
                                      (route) => false);
                            } else if (userDetails['enable_modules_for_applications'] == 'delivery') {
                              choosenTransportType = 1;
                              ismulitipleride = false;
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BookingConfirmation(
                                        type: 1,
                                      )),
                                      (route) => false);
                            } else {
                              if (choosenTransportType != 3) {
                                setState(() {
                                  choosenTransportType = 3;
                                  // _isbottom = 0;
                                  myMarkers.clear();
                                });
                              }
                            }
                      }
                  ),
                ],
              ),

              SizedBox(height: media.height*0.035),
              MyText(text: "Explore around you", size: font16Size,
                fontweight: FontWeight.w500,color: Color(0xff494949),),

              SizedBox(height: media.height*0.020),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey[200],
                ),
                child: Center(
                  child: StreamBuilder<
                      List<Marker>>(
                      stream:
                      carMarkerStream,
                      builder: (context,
                          snapshot) {
                        return Stack(
                          children: [
                            GoogleMap(
                              onMapCreated:
                              _onMapCreated,
                              compassEnabled:
                              false,
                              initialCameraPosition:
                              CameraPosition(
                                target:
                                center,
                                zoom: 15.0,
                              ),
                              onCameraMove:
                                  (CameraPosition
                              position) async {
                                if (addressList
                                    .isEmpty) {
                                } else {
                                  _centerLocation =
                                      position
                                          .target;
                                }
                              },
                              onCameraIdle:
                                  () async {
                                var val = await geoCoding(
                                    _centerLocation
                                        .latitude,
                                    _centerLocation
                                        .longitude);
                                setState(
                                        () {
                                      if (addressList
                                          .where((element) =>
                                      element.type ==
                                          'pickup')
                                          .isNotEmpty) {
                                        var add = addressList.firstWhere((element) =>
                                        element.type ==
                                            'pickup');
                                        add.address =
                                            val;
                                        add.latlng = LatLng(
                                            _centerLocation.latitude,
                                            _centerLocation.longitude);
                                      } else {
                                        addressList.add(AddressList(
                                            id:
                                            '1',
                                            type:
                                            'pickup',
                                            address:
                                            val,
                                            pickup:
                                            true,
                                            latlng:
                                            LatLng(_centerLocation.latitude, _centerLocation.longitude),
                                            name: userDetails['name'],
                                            number: userDetails['mobile']));
                                      }
                                    });
                                _lastCenter =
                                    _centerLocation;
                                ischanged =
                                false;
                                setState(
                                        () {});
                              },
                              minMaxZoomPreference:
                              const MinMaxZoomPreference(
                                  8.0,
                                  20.0),
                              myLocationButtonEnabled:
                              false,
                              markers: Set<
                                  Marker>.from(
                                  myMarkers),
                              buildingsEnabled:
                              false,
                              zoomControlsEnabled:
                              false,
                              myLocationEnabled:
                              true,
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
                        );
                      }),
                ),
              ),

              SizedBox(height:media.height*0.05),
            ],
          ),
        ),
      ),

    );
  }

  Widget _buildOptionCard(BuildContext context, String title, String images,Function() onTaps) {
    return GestureDetector(
      onTap:onTaps,
      child: Container(
        // width: 200,
        height: 50,
        // width: MediaQuery.of(context).size.width*0.40,
        // height:  MediaQuery.of(context).size.width*0.20,
        // padding: EdgeInsets.symmetric(vertical: 12,horizontal: 05),
        decoration: BoxDecoration(
          color: Color(0xffF0F0F0),

          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(images),
            SizedBox(height: 8),
            MyText(text: title, size: font14Size,fontweight: FontWeight.w500,
              color: Color(0xff000000),textAlign: TextAlign.center,),

          ],
        ),
      ),
    );
  }
}


