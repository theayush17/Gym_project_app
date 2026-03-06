import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MemberDetailsScreen extends StatefulWidget {
  const MemberDetailsScreen({super.key});

  @override
  State<MemberDetailsScreen> createState() => _MemberDetailsScreenState();
}

class _MemberDetailsScreenState extends State<MemberDetailsScreen> {

  int selectedMonths = 1;

  Future<void> activateMembership(
      String uid,
      DateTime? expiryDate,
      ) async {

    DateTime now = DateTime.now();

    /// CHECK IF ALREADY ACTIVE
    if (expiryDate != null && expiryDate.isAfter(now)) {

      int remainingMonths =
          ((expiryDate.difference(now).inDays) / 30).ceil();

      ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(
          content: Text(
              "Already activated for $remainingMonths month(s)."),
          backgroundColor: Colors.orange,
        ),

      );

      return;
    }

    /// ACTIVATE MEMBERSHIP
    DateTime expiry =
    DateTime(now.year, now.month + selectedMonths, now.day);

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({

      "subscription": "Premium",
      "expiryDate": expiry,

    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Membership Activated")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    final data =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    String uid = data['uid'];

    String name = data['fullName'] ?? "";
    String email = data['email'] ?? "";
    String mobile = data['mobile'] ?? "";

    String age = data['age']?.toString() ?? "N/A";
    String gender = data['gender'] ?? "N/A";
    String level = data['level'] ?? "N/A";

    String subscription = data['subscription'] ?? "Free";

    DateTime? expiryDate;

    if (data['expiryDate'] != null) {
      expiryDate = (data['expiryDate'] as Timestamp).toDate();
    }

    return Scaffold(

      appBar: AppBar(
        title: const Text("Member Details"),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(

            children: [

              /// MEMBER INFO
              Expanded(
                child: SingleChildScrollView(

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [

                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text("Email: $email"),
                      Text("Mobile: $mobile"),

                      const SizedBox(height: 10),

                      Text("Age: $age"),
                      Text("Gender: $gender"),
                      Text("Workout Level: $level"),

                      const SizedBox(height: 20),

                      Text(
                        "Subscription: $subscription",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: subscription == "Premium"
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),

                      if (expiryDate != null) ...[

                        const SizedBox(height: 5),

                        Text(
                          "Expires on: ${expiryDate.day}-${expiryDate.month}-${expiryDate.year}",
                          style: const TextStyle(
                              color: Colors.grey),
                        ),

                      ],

                      const SizedBox(height: 30),

                      /// MONTH SELECTOR
                      Row(
                        children: [

                          const Text(
                            "Activate for:",
                            style: TextStyle(fontSize: 16),
                          ),

                          const SizedBox(width: 10),

                          DropdownButton<int>(

                            value: selectedMonths,

                            items: List.generate(
                              12,
                                  (index) => DropdownMenuItem(
                                value: index + 1,
                                child: Text("${index + 1} Months"),
                              ),
                            ),

                            onChanged: (value) {
                              setState(() {
                                selectedMonths = value!;
                              });
                            },

                          ),

                        ],
                      ),

                    ],
                  ),
                ),
              ),

              /// ACTIVATE BUTTON
              SafeArea(
                child: SizedBox(

                  width: double.infinity,
                  height: 50,

                  child: ElevatedButton(

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),

                    onPressed: () {
                      activateMembership(
                        uid,
                        expiryDate,
                      );
                    },

                    child: const Text(
                      "Activate Membership",
                      style: TextStyle(fontSize: 16),
                    ),

                  ),

                ),
              ),

            ],

          ),
        ),
      ),
    );
  }
}