import 'package:flutter/material.dart';



class AlertsPage extends StatelessWidget {
  final List<Map<String, dynamic>> alerts = [
    {
      "title": "Your Taxi Has Arrived!",
      "message": "Please proceed to the pickup point and look for the vehicle.",
      "time": "2:00 pm",
      "icon": Icons.directions_car,
      "iconColor": Colors.blue,
    },
    {
      "title": "Upcoming Ride Reminder",
      "message": "Please ensure you're ready at the pickup location. Safe travels!",
      "time": "4:00 pm",
      "icon": Icons.notifications,
      "iconColor": Colors.grey,
    },
    {
      "title": "Payment Receipt",
      "message": "Your payment receipt for the recent ride is now available.",
      "time": "4:30 pm",
      "icon": Icons.receipt_long,
      "iconColor": Colors.green,
    },
    {
      "title": "Ride Cancelled",
      "message":
      "Your ride has been canceled as per your request. No charges will be applied to your account.",
      "time": "2 min",
      "icon": Icons.cancel,
      "iconColor": Colors.red,
    },
    {
      "section": "Yesterday",
    },
    {
      "title": "Trip Completed",
      "message": "Your trip has been successfully completed.",
      "time": "9:00 am",
      "icon": Icons.check_circle,
      "iconColor": Colors.green,
    },
    {
      "title": "Special offer",
      "message":
      "We have a special offer just for you. Enjoy a 50% discount on your next ride.",
      "time": "10:00 am",
      "icon": Icons.percent,
      "iconColor": Colors.orange,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Alerts"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: ListView.builder(
        itemCount: alerts.length,
        itemBuilder: (context, index) {
          final item = alerts[index];

          if (item.containsKey("section")) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                item["section"]!,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
            );
          }

          return ListTile(
            leading: CircleAvatar(
              backgroundColor: item["iconColor"]!.withOpacity(0.2),
              child: Icon(item["icon"], color: item["iconColor"]),
            ),
            title: Text(item["title"]!),
            subtitle: Text(item["message"]!),
            trailing: Text(
              item["time"]!,
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.timeline), label: "Activity"),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "Alerts"),
          BottomNavigationBarItem(icon: Icon(Icons.help), label: "Help"),
        ],
      ),
    );
  }
}
