import 'package:flutter/material.dart';

class PaymentMethodsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Methods'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Credit Cards',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: Image.asset('assets/mastercard.png', width: 40),
                title: const Text('•••• 5255'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    // Handle delete
                  },
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: Image.asset('assets/mastercard.png', width: 40),
                title: const Text('•••• 5255'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    // Handle delete
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Debit Card',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: Image.asset('assets/visa.png', width: 40),
                title: const Text('•••• 5255'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    // Handle delete
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle add payment method
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
