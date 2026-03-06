import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'config/routes.dart';
import 'screens/auth/login_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/admin/admin_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EcoGym',
      routes: AppRoutes.routes,
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {

        /// WAITING STATE
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        /// NOT LOGGED IN
        if (!snapshot.hasData) {
          return const LoginScreen();
        }

        final uid = snapshot.data!.uid;

        /// FETCH USER DOCUMENT
        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .get(),

          builder: (context, userDoc) {

            /// LOADING USER DATA
            if (userDoc.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            /// USER DOCUMENT DOES NOT EXIST (REMOVED BY ADMIN)
            if (!userDoc.hasData || !userDoc.data!.exists) {

              FirebaseAuth.instance.signOut();

              return const LoginScreen();
            }

            final data = userDoc.data!.data() as Map<String, dynamic>;

            /// ADMIN LOGIN
            if (data['role'] == 'admin') {
              return const AdminDashboard();
            }

            /// NORMAL USER LOGIN
            return const DashboardScreen();

          },
        );

      },
    );
  }
}