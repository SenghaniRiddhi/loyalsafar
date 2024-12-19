import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../styles/styles.dart';


class EditAddressScreen extends StatefulWidget {
  @override
  State<EditAddressScreen> createState() => _EditAddressScreenState();
}

class _EditAddressScreenState extends State<EditAddressScreen> {
  final LatLng _initialPosition = LatLng(37.7749, -122.4194);
  Set<Marker> _markers = {
    Marker(
      markerId: MarkerId('1'),
      position: LatLng(37.7749, -122.4194),
      infoWindow: InfoWindow(title: 'San Francisco'),
    ),
  };
  late GoogleMapController _mapController;

  LatLng _markerPosition = LatLng(37.7749, -122.4194); // Initial marker position
  late Marker _marker;

  @override
  void initState() {
    super.initState();
    _marker = Marker(
      markerId: MarkerId("moving_marker"),
      position: _markerPosition,
      draggable: false,
      infoWindow: InfoWindow(title: "Moving Marker"),
    );
  }

  void _moveMarker() {
    // Change the marker's position
    setState(() {
      _markerPosition = LatLng(_markerPosition.latitude + 0.01, _markerPosition.longitude + 0.01);
      _marker = Marker(
        markerId: MarkerId("moving_marker"),
        position: _markerPosition,
        draggable: false,
        infoWindow: InfoWindow(title: "Moving Marker"),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Address'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            // Handle back navigation
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Map placeholder

            Stack(
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.grey[300],
                  ),
                  child:  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _initialPosition,
                      zoom: 12,
                    ),
                    markers: {_marker},
                    onMapCreated: (controller) {
                      _mapController = controller;
                    },
                  ),
                ),

                Positioned(
                  bottom: 50,
                  left: 20,
                  child: FloatingActionButton(
                    onPressed: _moveMarker,
                    child: Icon(Icons.directions),
                  ),
                )
              ],
            ),

            const SizedBox(height: 24.0),

            // Save As options
            const Text(
              'SAVE AS',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AddressTypeButton(
                  label: 'Home',
                  icon: Icons.home,
                  isSelected: true,
                ),
                AddressTypeButton(
                  label: 'Work',
                  icon: Icons.work,
                  isSelected: false,
                ),
                AddressTypeButton(
                  label: 'Other',
                  icon: Icons.question_mark,
                  isSelected: false,
                ),
              ],
            ),
            const SizedBox(height: 24.0),

            // Address Line 1
            AddressInputField(
              label: 'Address line 1',
              hint: 'Oak St, Burlington, CO 80807, USA',
            ),
            const SizedBox(height: 16.0),

            // Area
            AddressInputField(
              label: 'Area',
              hint: 'Thornridge Cir',
            ),
            const SizedBox(height: 16.0),

            // City
            AddressInputField(
              label: 'City',
              hint: 'Burlington',
            ),
            const SizedBox(height: 24.0),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle save address
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
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
