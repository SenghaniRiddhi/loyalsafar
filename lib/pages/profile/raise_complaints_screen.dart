import 'package:flutter/material.dart';

class RaiseComplaintsScreen extends StatefulWidget {
  @override
  _RaiseComplaintsScreenState createState() => _RaiseComplaintsScreenState();
}

class _RaiseComplaintsScreenState extends State<RaiseComplaintsScreen> {
  String? _selectedReason;
  final _experienceController = TextEditingController();

  void _submitComplaint() {
    // Implement complaint submission logic
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Raise Complaints'),
        leading: BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Icon(Icons.directions_car, size: 48, color: Colors.blue),
                  Text(
                    'Raise Complaints',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Please raise your concern which you faced in the ride.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedReason,
              onChanged: (value) {
                setState(() {
                  _selectedReason = value;
                });
              },
              decoration: InputDecoration(labelText: 'Select Reason', border: OutlineInputBorder()),
              items: [
                DropdownMenuItem(value: 'Driver Issue', child: Text('Driver Issue')),
                DropdownMenuItem(value: 'Vehicle Issue', child: Text('Vehicle Issue')),
                DropdownMenuItem(value: 'Payment Issue', child: Text('Payment Issue')),
                DropdownMenuItem(value: 'Other', child: Text('Other')),
              ],
            ),
            SizedBox(height: 16),
            TextField(
              controller: _experienceController,
              maxLines: 4,
              decoration: InputDecoration(labelText: 'Share your experience...', border: OutlineInputBorder()),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _submitComplaint,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreen,
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
