import 'package:flutter/material.dart';


class SelectContactScreen extends StatefulWidget {
  @override
  _SelectContactScreenState createState() => _SelectContactScreenState();
}

class _SelectContactScreenState extends State<SelectContactScreen> {
  // Sample contact data
  final List<Map<String, dynamic>> _allContacts = [
    {'name': 'Cody Fisher', 'phone': '(308) 555-0121', 'selected': true},
    {'name': 'Wade Warren', 'phone': '(303) 555-0105', 'selected': true},
    {'name': 'Courtney Henry', 'phone': '(252) 555-0126', 'selected': true},
    {'name': 'Brooklyn Simmons', 'phone': '(405) 555-0128', 'selected': true},
    {'name': 'Dianne Russell', 'phone': '(302) 555-0107', 'selected': false},
    {'name': 'Jacob Jones', 'phone': '(208) 555-0112', 'selected': false},
    {'name': 'Annette Black', 'phone': '(270) 555-0117', 'selected': false},
    {'name': 'Cameron Williamson', 'phone': '(671) 555-0110', 'selected': false},
  ];

  List<Map<String, dynamic>> _filteredContacts = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initially, show all contacts
    _filteredContacts = List.from(_allContacts);
  }

  void _filterContacts(String query) {
    final lowerCaseQuery = query.toLowerCase();
    setState(() {
      _filteredContacts = _allContacts.where((contact) {
        final name = contact['name']!.toLowerCase();
        return name.contains(lowerCaseQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Contact'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Done',
              style: TextStyle(color: Colors.green, fontSize: 16),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search Contact',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
              ),
              onChanged: _filterContacts,
            ),
          ),
          Expanded(
            child: _filteredContacts.isEmpty
                ? Center(
              child: Text(
                'No contacts available',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            )
                : ListView.builder(
              itemCount: _filteredContacts.length,
              itemBuilder: (context, index) {
                final contact = _filteredContacts[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      contact['name']!.substring(0, 2),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(contact['name']),
                  subtitle: Text(contact['phone']),
                  trailing: Checkbox(
                    value: contact['selected'],
                    onChanged: (value) {
                      setState(() {
                        contact['selected'] = value!;
                      });
                    },
                    shape: const CircleBorder(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
