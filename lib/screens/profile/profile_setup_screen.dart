import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {

  final fullNameController = TextEditingController();
  final ageController = TextEditingController();
  final mobileController = TextEditingController();

  String gender = "Male";
  String level = "Beginner";

  Future<void> saveProfile() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        "fullName": fullNameController.text.trim(),
        "age": ageController.text.trim(),
        "mobile": mobileController.text.trim(),
        "gender": gender,
        "level": level,
        "role": "user",
      });

      Navigator.pushReplacementNamed(context, '/dashboard');

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving profile: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Complete Your Profile")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            TextField(
              controller: fullNameController,
              decoration: const InputDecoration(labelText: "Full Name"),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: ageController,
              decoration: const InputDecoration(labelText: "Age"),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: mobileController,
              decoration: const InputDecoration(labelText: "Mobile Number"),
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField(
              value: gender,
              items: const [
                DropdownMenuItem(value: "Male", child: Text("Male")),
                DropdownMenuItem(value: "Female", child: Text("Female")),
              ],
              onChanged: (value) {
                setState(() {
                  gender = value!;
                });
              },
              decoration: const InputDecoration(labelText: "Gender"),
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField(
              value: level,
              items: const [
                DropdownMenuItem(value: "Beginner", child: Text("Beginner")),
                DropdownMenuItem(value: "Intermediate", child: Text("Intermediate")),
              ],
              onChanged: (value) {
                setState(() {
                  level = value!;
                });
              },
              decoration: const InputDecoration(labelText: "Gym Level"),
            ),

            const SizedBox(height: 25),

            ElevatedButton(
              onPressed: saveProfile,
              child: const Text("Save & Continue"),
            ),
          ],
        ),
      ),
    );
  }
}