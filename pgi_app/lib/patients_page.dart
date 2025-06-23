import 'package:flutter/material.dart';

class PatientsPage extends StatelessWidget {
  const PatientsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isWideScreen = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: isWideScreen
          ? AppBar(
              backgroundColor: Colors.black,
              title: const Text(
                "All Patients",
                style: TextStyle(color: Colors.white),
              ),
              centerTitle: true,
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Patients Overview',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _patientCard('Aditi Sharma', 'Heart Issue'),
                  _patientCard('Rahul Verma', 'Diabetes'),
                  _patientCard('Simran Kaur', 'Cancer'),
                  _patientCard('Vikram Mehra', 'Hypertension'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _patientCard(String name, String condition) {
    return Card(
      color: Colors.white10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(
          name,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        subtitle: Container(
          margin: const EdgeInsets.only(top: 4),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color.fromARGB(51, 244, 67, 54),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            condition,
            style: const TextStyle(color: Colors.redAccent, fontSize: 12),
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white54),
        onTap: () {},
      ),
    );
  }
}
