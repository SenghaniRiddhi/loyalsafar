import 'package:flutter/material.dart';


class EditAddressScreen extends StatefulWidget {
  @override
  State<EditAddressScreen> createState() => _EditAddressScreenState();
}

class _EditAddressScreenState extends State<EditAddressScreen> {
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
                  child: const Center(
                    child: Text(
                      'Map View',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: FloatingActionButton.small(
                    onPressed: () {
                      // Handle map location refresh
                    },
                    child: const Icon(Icons.my_location, size: 20),
                  ),
                ),
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
    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: isSelected ? Colors.lightGreen : Colors.grey[300],
          child: Icon(icon, color: isSelected ? Colors.white : Colors.black54),
        ),
        const SizedBox(height: 8.0),
        Text(
          label,
          style: TextStyle(
            fontSize: 14.0,
            color: isSelected ? Colors.lightGreen : Colors.grey[700],
          ),
        ),
      ],
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
