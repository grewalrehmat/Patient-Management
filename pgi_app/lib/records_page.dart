import 'package:flutter/material.dart';

import 'log_visit_page.dart';

class RecordsPage extends StatefulWidget {
  const RecordsPage({super.key});

  @override
  State<RecordsPage> createState() => _RecordsPageState();
}

class _RecordsPageState extends State<RecordsPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> _patients = [
    {
      'name': 'Aditi Sharma',
      'id': 'P1001',
      'phone': '9876543210',
      'condition': 'Heart Issue',
    },
    {
      'name': 'Rahul Verma',
      'id': 'P1002',
      'phone': '9988776655',
      'condition': 'Diabetes',
    },
    {
      'name': 'Simran Kaur',
      'id': 'P1003',
      'phone': '9123456780',
      'condition': 'Cancer',
    },
    {
      'name': 'Vikram Mehra',
      'id': 'P1004',
      'phone': '9001234567',
      'condition': 'Hypertension',
    },
  ];

  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final bool isWideScreen = MediaQuery.of(context).size.width > 800;

    final query = _searchQuery.toLowerCase();
    final filteredPatients = _patients.where((patient) {
      return patient['name']!.toLowerCase().contains(query) ||
          patient['id']!.toLowerCase().contains(query) ||
          patient['phone']!.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: isWideScreen ? const Color(0xFF0F172A) : Colors.black,
        title: const Text(
          "All Patient Records",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: isWideScreen ? 0 : 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search by name, patient ID or phone number...',
                hintStyle: const TextStyle(color: Colors.white70),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
            ),
            const SizedBox(height: 16),

            Expanded(
              child: filteredPatients.isEmpty
                  ? const Center(
                      child: Text(
                        'No matching records found',
                        style: TextStyle(color: Colors.white54),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredPatients.length,
                      itemBuilder: (context, index) {
                        final patient = filteredPatients[index];
                        return Card(
                          color: Colors.white10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            title: Text(
                              patient['name']!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(
                                  "ID: ${patient['id']} • Phone: ${patient['phone']}",
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.redAccent.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    patient['condition']!,
                                    style: const TextStyle(
                                      color: Colors.redAccent,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white54,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      LogVisitPage(patient: patient),
                                ),
                              );
                            },
                          ),
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
