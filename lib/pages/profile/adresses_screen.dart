import 'package:flutter/material.dart';
import 'package:flutter_user/pages/profile/edit_adresses_screen.dart';

class AddressesScreen extends StatefulWidget {
  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Addresses'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            // Handle back navigation
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
            ElevatedButton.icon(
              onPressed: () {
                // Handle adding a new address
              },
              icon: const Icon(Icons.add),
              label: const Text('Add New'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
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
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 24.0, color: Colors.black87),
                const SizedBox(width: 12.0),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: onDelete,
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: onEdit,
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              address,
              style: const TextStyle(
                fontSize: 14.0,
                color: Colors.grey,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
