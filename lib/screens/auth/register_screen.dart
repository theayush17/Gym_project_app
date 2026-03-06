import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final fullNameController = TextEditingController();
  final ageController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String gender = "Male";
  String level = "Beginner";

  Future<void> register() async {

    if (passwordController.text != confirmPasswordController.text) {
      showError("Passwords do not match");
      return;
    }

    try {

      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      String uid = userCredential.user!.uid;

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        "fullName": fullNameController.text.trim(),
        "age": ageController.text.trim(),
        "mobile": mobileController.text.trim(),
        "gender": gender,
        "level": level,
        "email": emailController.text.trim(),
        "role": "user",
      });

      Navigator.pushReplacementNamed(context, '/dashboard');

    } on FirebaseAuthException catch (e) {
      showError(e.message ?? "Registration failed");
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Account")),
      body: SingleChildScrollView(
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

            const SizedBox(height: 15),

            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),

            const SizedBox(height: 15),

            TextField(
              controller: confirmPasswordController,
              decoration: const InputDecoration(labelText: "Confirm Password"),
              obscureText: true,
            ),

            const SizedBox(height: 25),

            ElevatedButton(
              onPressed: register,
              child: const Text("Register & Continue"),
            ),
          ],
        ),
      ),
    );
  }
}