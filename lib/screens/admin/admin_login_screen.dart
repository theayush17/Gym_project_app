import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool hidePassword = true;

  Future<void> loginAdmin() async {

    try {

      final credential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final uid = credential.user!.uid;

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      /// Check if Firestore user exists
      if (!doc.exists) {
        showError("User data not found");
        await FirebaseAuth.instance.signOut();
        return;
      }

      final data = doc.data() as Map<String, dynamic>;

      /// Check admin role
      if (data['role'] != "admin") {

        showError("This account is not an admin");

        await FirebaseAuth.instance.signOut();
        return;
      }

      /// Open Admin Dashboard and remove previous pages
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/adminDashboard',
        (route) => false,
      );

    } on FirebaseAuthException catch (e) {

      if (e.code == 'user-not-found') {
        showError("Admin account not found");
      }
      else if (e.code == 'wrong-password') {
        showError("Incorrect password");
      }
      else {
        showError("Admin login failed");
      }

    } catch (e) {
      showError("Something went wrong");
    }

  }

  void showError(String message) {

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
      ),
    );

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Admin Login"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            const SizedBox(height: 30),

            /// EMAIL
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Admin Email",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            /// PASSWORD
            TextField(
              controller: passwordController,
              obscureText: hidePassword,
              decoration: InputDecoration(
                labelText: "Password",
                border: const OutlineInputBorder(),

                suffixIcon: IconButton(
                  icon: Icon(
                    hidePassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      hidePassword = !hidePassword;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// LOGIN BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,

              child: ElevatedButton(
                onPressed: loginAdmin,
                child: const Text(
                  "Login",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),

          ],

        ),
      ),
    );
  }
}