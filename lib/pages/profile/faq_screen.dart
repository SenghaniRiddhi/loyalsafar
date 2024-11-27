import 'package:flutter/material.dart';

import 'faq_deatils_screen.dart';

class FAQScreen extends StatelessWidget {
  final List<Map<String, String>> faqs = [
    {'question': 'How can I pay for my ride?'},
    {'question': 'How do I change my password?'},
    {'question': 'What should I do if I need to cancel my ride?'},
    {'question': 'How are fares calculated in the cab app?'},
    {'question': 'What is a Loyal Safar app?'},
    {'question': 'Cancellation Charges'},
  ];

  void _navigateToFAQDetails(BuildContext context, String question) {
    // Navigate to the FAQ details screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FAQDetailScreen(question: question),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FAQ'S"),
        leading: BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'How can we help you?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: faqs.length,
                itemBuilder: (context, index) {
                  final faq = faqs[index];
                  return ListTile(
                    title: Text(faq['question']!),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () => _navigateToFAQDetails(context, faq['question']!),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FAQDetailScreen extends StatelessWidget {
  final String question;

  FAQDetailScreen({required this.question});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQ Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>FAQDetailsScreen()));
              },
              child: Text(
                question,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'This is the answer or details for the selected FAQ. You can replace this text with the actual FAQ content.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
