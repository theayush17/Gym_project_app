import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AllMembersScreen extends StatelessWidget {
  const AllMembersScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("All Members"),
      ),

      body: StreamBuilder<QuerySnapshot>(

        stream: FirebaseFirestore.instance
            .collection('users')
            .snapshots(),

        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No members found"));
          }

          final users = snapshot.data!.docs;

          return ListView.builder(

            itemCount: users.length,

            itemBuilder: (context, index) {

              final user = users[index].data() as Map<String, dynamic>;

              /// SAFE DATA FETCHING
              String fullName = user['fullName'] ?? "Unknown";
              String email = user['email'] ?? "";
              String subscription = user['subscription'] ?? "Free";

              return ListTile(

                leading: const CircleAvatar(
                  child: Icon(Icons.person),
                ),

                title: Text(fullName),

                subtitle: Text(email),

                trailing: Text(
                  subscription == "Premium"
                      ? "Subscribed"
                      : "Not Subscribed",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: subscription == "Premium"
                        ? Colors.green
                        : Colors.red,
                  ),
                ),

              );

            },

          );

        },

      ),

    );
  }
}