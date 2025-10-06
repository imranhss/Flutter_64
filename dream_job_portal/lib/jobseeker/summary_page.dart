import 'package:flutter/material.dart';

class JobSeekerSummary extends StatelessWidget {
  final Map<String, dynamic>? summary;

  const JobSeekerSummary({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    if (summary == null) {
      return const Scaffold(
        body: Center(child: Text('No summary data available')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Seeker Summary'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              summary!['description'] ?? 'No description available',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Text('Father: ${summary!['fatherName'] ?? 'N/A'}'),
            Text('Mother: ${summary!['motherName'] ?? 'N/A'}'),
            Text('Nationality: ${summary!['nationality'] ?? 'N/A'}'),
            Text('Religion: ${summary!['religion'] ?? 'N/A'}'),
            Text('Blood Group: ${summary!['bloodGroup'] ?? 'N/A'}'),
            Text('Height: ${summary!['height'] ?? 'N/A'}'),
            Text('Weight: ${summary!['weight'] ?? 'N/A'}'),
            Text('NID: ${summary!['nid'] ?? 'N/A'}'),
          ],
        ),
      ),
    );
  }
}
