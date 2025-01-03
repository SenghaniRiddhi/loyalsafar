import 'package:flutter/material.dart';

import '../../styles/styles.dart';
import '../../widgets/widgets.dart';
import '../navDrawer/nav_drawer.dart';
import 'history.dart';
import 'outstation.dart';

class ActivitiesScreen extends StatefulWidget {
  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  bool isScheduleSelected = true; // Initial state
  bool isPastSelected = false;

  void toggleSelection(String button) {
    setState(() {
      if (button == 'Schedule') {
        isScheduleSelected = true;
        isPastSelected = false;
      } else if (button == 'Past') {
        isScheduleSelected = false;
        isPastSelected = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: whiteColors,
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: Colors.white,
      //   title: Text(
      //     'Activities',
      //     style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      //   ),
      //   centerTitle: true,
      //   leading: IconButton(
      //     icon: Icon(Icons.arrow_back, color: Colors.black),
      //     onPressed: () {}, // Add navigation logic here
      //   ),
      // ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height:media.width * 0.06 ,),
          Container(
            padding: EdgeInsets.fromLTRB(media.width * 0.05,
                media.width * 0.05, media.width * 0.05, 0),
            width: media.width * 1,
            alignment: Alignment.topLeft,
            child: MyText(
              text: "Activities",
              color: headingColors,
              size: font26Size,
              fontweight: FontWeight.w700,
            ),
          ),
          SizedBox(height:media.width * 0.03 ,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: media.width * 0.05),
            child: Row(
             // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ToggleButton(label: 'Schedule', isSelected: isScheduleSelected,
                   onTaps: () => toggleSelection('Schedule')),
                SizedBox(width: media.width * 0.02,),
                ToggleButton(
                  label: 'Past',
                  isSelected: isPastSelected,
                  onTaps: () => toggleSelection('Past'),
                ),
                SizedBox(width: media.width * 0.02,),
                ToggleButton(
                  label: 'ride',
                  isSelected: isPastSelected,
                  onTaps: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>History()));
                    // Navigator.push(context, MaterialPageRoute(builder: (context)=>OutStationRides()));

                  },
                ),
                // Container(
                //   padding: EdgeInsets.symmetric(horizontal: 16,),
                //   height: media.height * 0.045,
                //   width: media.width * 0.45,
                //   decoration: BoxDecoration(
                //     // color: isSelected ? Colors.black : Colors.white,
                //     borderRadius: BorderRadius.circular(25),
                //     border: Border.all(color: Colors.grey[300]!),
                //   ),
                //   child: DropdownButton<String>(
                //     value: 'Ride',
                //     isExpanded: true,
                //     icon: Icon(Icons.keyboard_arrow_down),
                //     items: ['Ride', 'Rent','Delivery']
                //         .map((value) => DropdownMenuItem(
                //       value: value,
                //       child: MyText(text: value,
                //         size: font14Size,color: Color(0xff080204),
                //         fontweight: FontWeight.w400,)
                //
                //     ))
                //         .toList(),
                //     onChanged: (value) {}, // Handle dropdown selection
                //     underline: SizedBox.shrink(),
                //   ),
                // ),
              ],
            ),
          ),
          SizedBox(height:media.width * 0.03 ,),
          Divider(color: dividerColors,),
          SizedBox(height: media.width * 0.35),
          Center(
            child: Column(
              children: [
                Image.asset(
                  'assets/icons/ride.png', // Add your image asset here
                  height: 150,
                ),
                SizedBox(height: 16),
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: media.width * 0.08),
                  child: MyText(text: "You don’t have any ride planned.",
                    textAlign: TextAlign.center,
                      size: font22Size,color: Color(0xff030303),
                    fontweight: FontWeight.w400,),
                ),

                SizedBox(height: 24),

                Button(
                  textcolor: whiteColors,
                    width: media.width * 0.3,
                    fontweight: FontWeight.w600,
                    color: Colors.black,
                    borderRadius:
                    8,
                    height:
                    media.width *
                        0.1,
                    onTap:
                        () async {

                    },
                    text:'Ride Now'),

              ],
            ),
          ),
        ],
      ),

    );
  }
}


class ToggleButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  Function() onTaps;

  ToggleButton({required this.label, required this.isSelected,required this.onTaps});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTaps,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xff000000) :  Color(0xffe7e6e6),
          borderRadius: BorderRadius.circular(20),
          // border: Border.all(color: Colors.grey[300]!),
        ),
        child:MyText(text:label ,fontweight:FontWeight.w400,
          size: font14Size,color: isSelected ? whiteColors :  Color(0xff080204),),
      ),
    );
  }
}