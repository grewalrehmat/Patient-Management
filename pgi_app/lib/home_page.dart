import 'package:flutter/material.dart';
import 'top_panel.dart';

class HomePage extends StatelessWidget {
  final VoidCallback? onShowAllTapped;

  const HomePage({super.key, this.onShowAllTapped});

  @override
  Widget build(BuildContext context) {
    final bool isWideScreen = MediaQuery.of(context).size.width > 800;

    final Widget content = SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          const Text(
            'Hello, Yuvraj',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),

          // Stat Boxes
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _statBox('Total Patients', '52', isWideScreen),
              _statBox('Pending Reports', '13', isWideScreen),
            ],
          ),
          const SizedBox(height: 24),

          if (isWideScreen) ...[
            const Text(
              'Today\'s Appointments',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            _appointmentCard('Rakesh Gupta', '10:30 AM'),
            _appointmentCard('Meena Joshi', '11:00 AM'),
            const SizedBox(height: 24),
          ],

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Patients',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              TextButton(
                onPressed: onShowAllTapped,
                child: const Text(
                  'Show All',
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          _patientCard('Aditi Sharma', 'Heart Issue'),
          _patientCard('Rahul Verma', 'Diabetes'),
        ],
      ),
    );

    return Container(
      color: const Color(0xFF0F172A),
      child: isWideScreen
          ? Column(
              children: [
                const TopPanel(),
                Expanded(child: content),
              ],
            )
          : content,
    );
  }

  Widget _statBox(String label, String count, bool isWide) {
    return Container(
      width: isWide ? 200 : double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(38, 33, 150, 243),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            count,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _patientCard(String name, String condition) {
    return Card(
      color: const Color(0x1AFFFFFF),
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

  Widget _appointmentCard(String name, String time) {
    return Card(
      color: Colors.white10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const Icon(Icons.calendar_today, color: Colors.blueAccent),
        title: Text(name, style: const TextStyle(color: Colors.white)),
        subtitle: Text(time, style: const TextStyle(color: Colors.white70)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white54),
      ),
    );
  }
}
