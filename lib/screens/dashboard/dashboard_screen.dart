import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  String fullName = "";
  String subscription = "";

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {

    final uid = FirebaseAuth.instance.currentUser!.uid;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    if (doc.exists) {

      setState(() {
        fullName = doc.data()?['fullName'] ?? "";
        subscription = doc.data()?['subscription'] ?? "Free";
      });

    }
  }

  String getGreeting() {

    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) return "Good Morning";
    if (hour >= 12 && hour < 17) return "Good Afternoon";
    if (hour >= 17 && hour < 21) return "Good Evening";

    return "Good Night";
  }

  String getCurrentDate() {
    return DateFormat('EEEE, MMMM d, y').format(DateTime.now());
  }

  Color getAvatarColor(String name) {

    List<Color> colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.indigo,
      Colors.pink,
    ];

    if (name.isEmpty) return Colors.grey;

    int index = name.codeUnitAt(0) % colors.length;

    return colors[index];
  }

  /// Notice popup
  void showNoticePopup(DocumentSnapshot doc) {

    showDialog(
      context: context,
      builder: (_) {

        return AlertDialog(

          title: Text(doc['title']),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(doc['description'] ?? "No description available"),

              const SizedBox(height: 10),

              if (doc['date'] != null)
                Text(
                  DateFormat('MMM d, yyyy').format(
                    (doc['date'] as Timestamp).toDate(),
                  ),
                  style: const TextStyle(color: Colors.grey),
                ),

            ],
          ),

          actions: [

            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            )

          ],
        );

      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFFF4F6FA),

      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [

              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF6A5ACD),
                      Color(0xFF7B68EE),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      fullName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      FirebaseAuth.instance.currentUser?.email ?? "",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),

                  ],
                ),
              ),

              const SizedBox(height: 20),

              ListTile(
                leading: const Icon(Icons.help_outline),
                title: const Text("Help & Support"),
                onTap: () {},
              ),

              ListTile(
                leading: const Icon(Icons.language),
                title: const Text("Website"),
                subtitle: const Text("www.yourgymbrand.com"),
                onTap: () {},
              ),

              ListTile(
                leading: const Icon(Icons.system_update),
                title: Row(
                  children: const [
                    Text("Check for Updates"),
                    SizedBox(width: 8),
                    Chip(
                      label: Text(
                        "new",
                        style: TextStyle(fontSize: 10),
                      ),
                      padding: EdgeInsets.zero,
                    )
                  ],
                ),
                onTap: () {},
              ),

              const Spacer(),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(

                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: const Color(0xFF6A5ACD),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),

                    icon: const Icon(Icons.logout),

                    label: const Text("Signout"),

                    onPressed: () async {

                      await FirebaseAuth.instance.signOut();

                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/login',
                            (route) => false,
                      );

                    },
                  ),
                ),
              ),

              const SizedBox(height: 15),

              const Text(
                "App Version: 2.1.0",
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 20),

            ],
          ),
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: SingleChildScrollView(

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Builder(
                      builder: (context) => GestureDetector(
                        onTap: () {
                          Scaffold.of(context).openDrawer();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(
                                blurRadius: 10,
                                color: Colors.black12,
                              )
                            ],
                          ),
                          child: const Icon(Icons.menu),
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/profile');
                      },
                      child: CircleAvatar(
                        radius: 22,
                        backgroundColor: getAvatarColor(fullName),
                        child: Text(
                          fullName.isNotEmpty
                              ? fullName[0].toUpperCase()
                              : "?",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                  ],
                ),

                const SizedBox(height: 25),

                Text(
                  "Hey! $fullName",
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  getGreeting(),
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black54,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  getCurrentDate(),
                  style: const TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 30),

                /// Subscription Card
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF1B3C73),
                        Color(0xFF3A7BD5),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          const Text(
                            "Subscription",
                            style: TextStyle(color: Colors.white70),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            "$subscription Plan",
                            style: const TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                        ],
                      ),

                      const Icon(
                        Icons.workspace_premium,
                        color: Colors.white,
                        size: 40,
                      )

                    ],
                  ),
                ),

                const SizedBox(height: 25),

                const Text(
                  "Notices",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                /// Notice Cards
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('notices')
                      .orderBy('date', descending: true)
                      .limit(3)
                      .snapshots(),
                  builder: (context, snapshot) {

                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    var notices = snapshot.data!.docs;

                    return Column(
                      children: notices.map((doc) {

                        return GestureDetector(

                          onTap: () => showNoticePopup(doc),

                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),

                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: const [
                                BoxShadow(
                                  blurRadius: 8,
                                  color: Colors.black12,
                                )
                              ],
                            ),

                            child: Row(
                              children: [

                                const Icon(
                                  Icons.campaign,
                                  color: Colors.blue,
                                ),

                                const SizedBox(width: 12),

                                Expanded(
                                  child: Text(
                                    doc['title'],
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),

                                const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: Colors.grey,
                                )

                              ],
                            ),
                          ),
                        );

                      }).toList(),
                    );
                  },
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}