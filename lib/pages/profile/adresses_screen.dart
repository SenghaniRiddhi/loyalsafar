import 'package:flutter/material.dart';
import 'package:flutter_user/pages/profile/edit_adresses_screen.dart';

import '../../styles/styles.dart';
import '../../widgets/appbar.dart';
import '../../widgets/widgets.dart';

class AddressesScreen extends StatefulWidget {
  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: whiteColors,
      // appBar: AppBar(
      //   title: const Text('My Addresses'),
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back),
      //     onPressed: () {
      //       Navigator.pop(context);
      //       // Handle back navigation
      //     },
      //   ),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height:media.width * 0.01 ,),

            appBarWidget(context: context,
                onTaps: (){
                  Navigator.pop(context);
                },
                backgroundIcon: Color(0xffECECEC), title: "",iconColors: iconGrayColors),

            SizedBox(height:media.width * 0.04,),
            MyText(
              text: "My Addresses",
              size: font26Size,
              color: headingColors,
              fontweight: FontWeight.w800,
            ),
            Expanded(
              child: ListView(
                children: [
                  // Home Address
                  AddressCard(
                    icon: Icons.home,
                    label: 'Home',
                    address:
                    '1901 Thornridge Cir. Shiloh\nOak St, Burlington, CO 80807, USA',
                    onEdit: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>
                          EditAddressScreen()));
                      // Handle edit for Home
                    },
                    onDelete: () {
                      // Handle delete for Home
                    },
                  ),
                  // Work Address
                  AddressCard(
                    icon: Icons.work,
                    label: 'Work',
                    address:
                    '1901 Thornridge Cir. Shiloh\nOak St, Burlington, CO 80807, USA',
                    onEdit: () {
                      // Handle edit for Work
                    },
                    onDelete: () {
                      // Handle delete for Work
                    },
                  ),
                  // Other Address
                  AddressCard(
                    icon: Icons.question_mark,
                    label: 'Other',
                    address:
                    '1901 Thornridge Cir. Shiloh\nOak St, Burlington, CO 80807, USA',
                    onEdit: () {
                      // Handle edit for Other
                    },
                    onDelete: () {
                      // Handle delete for Other
                    },
                  ),
                ],
              ),
            ),
            // Add New Button

            Center(
              child: Container(

                decoration: BoxDecoration(
                  color: whiteColors,
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(
                    width: 2,
                    color: const  Color(0xffeaeaea),
                  )
                ),
                child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 10,vertical: 06),
                  child: Wrap(
                    direction: Axis.horizontal,
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    children: [
                      Icon(Icons.add,color: Color(0xff141B34),),
                      MyText(text: "Add New", size: font16Size,
                        fontweight: FontWeight.w500,color: Color(0xff080204),)
                    ],
                  ),
                ),
              ),
            ),


          ],
        ),
      ),
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
