import 'package:flutter/material.dart';

class FAQDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("FAQ Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                "What is a Loyal Safar app?",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              // Description
              Text(
                "An aligned social app is a type of social media platform that focuses on connecting individuals who share similar values, interests, and goals. Unlike traditional social media platforms that cater to a broad audience, aligned social apps aim to create a more targeted and personalized experience for users.",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              // Images
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Image.asset('assets/image1.jpg', fit: BoxFit.cover),
                  Image.asset('assets/image2.jpg', fit: BoxFit.cover),
                  Image.asset('assets/image3.jpg', fit: BoxFit.cover),
                  Image.asset('assets/image4.jpg', fit: BoxFit.cover),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
