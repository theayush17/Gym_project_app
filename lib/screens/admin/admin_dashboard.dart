import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {

  String searchQuery = "";
  String filter = "All";

  /// REMOVE MEMBER FROM FIRESTORE
  Future<void> removeMember(String uid) async {

    try {

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .delete();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Member removed successfully"),
        ),
      );

    } catch (e) {

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error removing member: $e"),
        ),
      );

    }

  }

  /// CONFIRMATION DIALOG
  void confirmRemoveMember(String uid) {

    showDialog(
      context: context,
      builder: (context) {

        return AlertDialog(

          title: const Text("Remove Member"),

          content: const Text(
              "Are you sure you want to remove this member?"
          ),

          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),

            TextButton(

              onPressed: () async {

                Navigator.pop(context);
                await removeMember(uid);

              },

              child: const Text(
                "Remove",
                style: TextStyle(color: Colors.red),
              ),

            ),

          ],

        );

      },
    );

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFFF4F6FA),

      /// SIDEBAR
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [

              const UserAccountsDrawerHeader(
                accountName: Text("Gym Owner"),
                accountEmail: Text("Admin Panel"),
              ),

              ListTile(
                leading: const Icon(Icons.people),
                title: const Text("All Members"),
                onTap: () {
                  Navigator.pop(context);
                },
              ),

              const Spacer(),

              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text("Logout"),
                onTap: () {

                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );

                },
              ),

            ],
          ),
        ),
      ),

      body: SafeArea(

        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(

            children: [

              /// HEADER
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

                  const Text(
                    "All Members",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/profile');
                    },
                    child: const CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.pink,
                      child: Text(
                        "G",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),

                ],
              ),

              const SizedBox(height: 20),

              /// SEARCH BAR
              TextField(

                decoration: InputDecoration(
                  hintText: "Search by name or mobile",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                onChanged: (value) {
                  setState(() {
                    searchQuery = value.toLowerCase();
                  });
                },

              ),

              const SizedBox(height: 10),

              /// FILTER BUTTON
              Align(
                alignment: Alignment.centerRight,

                child: PopupMenuButton(

                  icon: const Icon(Icons.filter_list),

                  onSelected: (value) {
                    setState(() {
                      filter = value.toString();
                    });
                  },

                  itemBuilder: (context) => [

                    const PopupMenuItem(
                      value: "All",
                      child: Text("All Members"),
                    ),

                    const PopupMenuItem(
                      value: "Subscribed",
                      child: Text("Subscribed"),
                    ),

                    const PopupMenuItem(
                      value: "Unsubscribed",
                      child: Text("Unsubscribed"),
                    ),

                  ],

                ),

              ),

              const SizedBox(height: 10),

              /// MEMBERS LIST
              Expanded(

                child: StreamBuilder<QuerySnapshot>(

                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .snapshots(),

                  builder: (context, snapshot) {

                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (!snapshot.hasData) {
                      return const Center(
                        child: Text("No members found"),
                      );
                    }

                    var users = snapshot.data!.docs;

                    /// FILTER USERS
                    users = users.where((doc) {

                      final data = doc.data() as Map<String, dynamic>;

                      /// REMOVE ADMIN FROM MEMBER LIST
                      if (data['role'] == 'admin') {
                        return false;
                      }

                      String name =
                      (data['fullName'] ?? "").toLowerCase();

                      String mobile =
                      (data['mobile'] ?? "").toLowerCase();

                      String subscription =
                          data['subscription'] ?? "Free";

                      bool matchesSearch =
                          name.contains(searchQuery) ||
                              mobile.contains(searchQuery);

                      bool matchesFilter = true;

                      if (filter == "Subscribed") {
                        matchesFilter =
                            subscription == "Premium";
                      }

                      if (filter == "Unsubscribed") {
                        matchesFilter =
                            subscription != "Premium";
                      }

                      return matchesSearch && matchesFilter;

                    }).toList();

                    if (users.isEmpty) {
                      return const Center(
                        child: Text("No members found"),
                      );
                    }

                    return ListView.builder(

                      itemCount: users.length,

                      itemBuilder: (context, index) {

                        final data =
                        users[index].data()
                        as Map<String, dynamic>;

                        String uid = users[index].id;

                        String name =
                            data['fullName'] ?? "Unknown";

                        String email =
                            data['email'] ?? "";

                        String mobile =
                            data['mobile'] ?? "";

                        return ListTile(

                          leading: const CircleAvatar(
                            child: Icon(Icons.person),
                          ),

                          title: Text(name),

                          subtitle: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [

                              Text(email),
                              Text(mobile),

                            ],
                          ),

                          /// THREE DOT MENU
                          trailing: PopupMenuButton(

                            itemBuilder: (context) => [

                              const PopupMenuItem(
                                value: "details",
                                child: Text("View Details"),
                              ),

                              const PopupMenuItem(
                                value: "remove",
                                child: Text(
                                  "Remove Member",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),

                            ],

                            onSelected: (value) {

                              if (value == "details") {

                                Navigator.pushNamed(
                                  context,
                                  '/memberDetails',
                                  arguments: {
                                    ...data,
                                    "uid": uid
                                  },
                                );

                              }

                              if (value == "remove") {

                                confirmRemoveMember(uid);

                              }

                            },

                          ),

                        );

                      },

                    );

                  },

                ),

              ),

            ],

          ),

        ),

      ),

    );

  }

}