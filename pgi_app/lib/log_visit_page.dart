import 'package:flutter/material.dart';

class LogVisitPage extends StatefulWidget {
  final Map<String, String>? patient;

  const LogVisitPage({super.key, this.patient});

  @override
  State<LogVisitPage> createState() => _LogVisitPageState();
}

class _LogVisitPageState extends State<LogVisitPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  String? _gender;
  final _tempController = TextEditingController();
  final _mapController = TextEditingController();
  final _phController = TextEditingController();
  final _heartRateController = TextEditingController();
  final _respiratoryController = TextEditingController();
  final _sodiumController = TextEditingController();
  final _potassiumController = TextEditingController();
  final _creatinineController = TextEditingController();
  final _hematocritController = TextEditingController();
  final _gcsController = TextEditingController();
  final _apacheScoreController = TextEditingController();
  final _mortalityController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _tempController.dispose();
    _mapController.dispose();
    _phController.dispose();
    _heartRateController.dispose();
    _respiratoryController.dispose();
    _sodiumController.dispose();
    _potassiumController.dispose();
    _creatinineController.dispose();
    _hematocritController.dispose();
    _gcsController.dispose();
    _apacheScoreController.dispose();
    _mortalityController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Pre-fill name if patient data is provided
    if (widget.patient != null) {
      _nameController.text = widget.patient!['name'] ?? '';
    }
  }

  // ...existing code...
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Visit'),
        backgroundColor: const Color(0xFF0F172A),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.patient != null) ...[
                  Text(
                    'Patient: ${widget.patient!['name']} (ID: ${widget.patient!['id']})',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  // validator removed
                  readOnly: widget.patient != null,
                ),
                TextFormField(
                  controller: _ageController,
                  decoration: const InputDecoration(labelText: 'Age'),
                  keyboardType: TextInputType.number,
                  // validator removed
                ),
                DropdownButtonFormField<String>(
                  value: _gender,
                  decoration: const InputDecoration(labelText: 'Gender'),
                  items: ['Male', 'Female', 'Other']
                      .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                      .toList(),
                  onChanged: (value) => setState(() => _gender = value),
                  // validator removed
                ),
                TextFormField(
                  controller: _tempController,
                  decoration: const InputDecoration(
                    labelText: 'Temperature (°C)',
                  ),
                  keyboardType: TextInputType.number,
                  // validator removed
                ),
                TextFormField(
                  controller: _mapController,
                  decoration: const InputDecoration(labelText: 'MAP (mmHg)'),
                  keyboardType: TextInputType.number,
                  // validator removed
                ),
                TextFormField(
                  controller: _phController,
                  decoration: const InputDecoration(labelText: 'pH'),
                  keyboardType: TextInputType.number,
                  // validator removed
                ),
                TextFormField(
                  controller: _heartRateController,
                  decoration: const InputDecoration(
                    labelText: 'Heart Rate (bpm)',
                  ),
                  keyboardType: TextInputType.number,
                  // validator removed
                ),
                TextFormField(
                  controller: _respiratoryController,
                  decoration: const InputDecoration(
                    labelText: 'Respiratory Rate',
                  ),
                  keyboardType: TextInputType.number,
                  // validator removed
                ),
                TextFormField(
                  controller: _sodiumController,
                  decoration: const InputDecoration(
                    labelText: 'Sodium (mmol/L)',
                  ),
                  keyboardType: TextInputType.number,
                  // validator removed
                ),
                TextFormField(
                  controller: _potassiumController,
                  decoration: const InputDecoration(
                    labelText: 'Potassium (mmol/L)',
                  ),
                  keyboardType: TextInputType.number,
                  // validator removed
                ),
                TextFormField(
                  controller: _creatinineController,
                  decoration: const InputDecoration(
                    labelText: 'Creatinine (mg/dL)',
                  ),
                  keyboardType: TextInputType.number,
                  // validator removed
                ),
                TextFormField(
                  controller: _hematocritController,
                  decoration: const InputDecoration(
                    labelText: 'Hematocrit (%)',
                  ),
                  keyboardType: TextInputType.number,
                  // validator removed
                ),
                TextFormField(
                  controller: _gcsController,
                  decoration: const InputDecoration(labelText: 'GCS'),
                  keyboardType: TextInputType.number,
                  // validator removed
                ),
                TextFormField(
                  controller: _apacheScoreController,
                  decoration: const InputDecoration(labelText: 'APACHE Score'),
                  keyboardType: TextInputType.number,
                  // validator removed
                ),
                TextFormField(
                  controller: _mortalityController,
                  decoration: const InputDecoration(labelText: 'Mortality (%)'),
                  keyboardType: TextInputType.number,
                  // validator removed
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // No validation, just process data
                    final data = {
                      'name': _nameController.text,
                      'age': _ageController.text,
                      'gender': _gender,
                      'temp': _tempController.text,
                      'map': _mapController.text,
                      'ph': _phController.text,
                      'heartRate': _heartRateController.text,
                      'respiratory': _respiratoryController.text,
                      'sodium': _sodiumController.text,
                      'potassium': _potassiumController.text,
                      'creatinine': _creatinineController.text,
                      'hematocrit': _hematocritController.text,
                      'gcs': _gcsController.text,
                      'apacheScore': _apacheScoreController.text,
                      'mortality': _mortalityController.text,
                    };
                    // handling the data here (e.g., send to backend)
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Visit logged!')),
                    );
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
