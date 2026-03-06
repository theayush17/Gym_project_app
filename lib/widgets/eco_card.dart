import 'package:flutter/material.dart';

class EcoCard extends StatelessWidget {
  final String title;
  final IconData icon;

  const EcoCard({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40),
          const SizedBox(height: 10),
          Text(title),
        ],
      ),
    );
  }
}