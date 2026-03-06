import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  String level = "Beginner";

  bool editEmail = false;
  bool editPhone = false;
  bool editLevel = false;

  bool showOldPassword = false;
  bool showNewPassword = false;
  bool showConfirmPassword = false;

  String originalEmail = "";
  String originalPhone = "";
  String originalLevel = "";

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  /// Load user data
  Future<void> loadUser() async {

    final uid = FirebaseAuth.instance.currentUser!.uid;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    if (doc.exists) {

      nameController.text = doc['fullName'] ?? "";
      emailController.text = FirebaseAuth.instance.currentUser?.email ?? "";
      phoneController.text = doc['mobile'] ?? "";
      level = doc['level'] ?? "Beginner";

      originalEmail = emailController.text;
      originalPhone = phoneController.text;
      originalLevel = level;

      setState(() {});
    }
  }

  /// Update profile
  Future<void> updateProfile() async {

    String newEmail = emailController.text.trim();
    String newPhone = phoneController.text.trim();

    if (newEmail.isEmpty || newPhone.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All fields are required")),
      );

      return;
    }

    if (newEmail == originalEmail &&
        newPhone == originalPhone &&
        level == originalLevel) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No changes made")),
      );

      return;
    }

    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({
      "mobile": newPhone,
      "level": level,
    });

    if (newEmail != originalEmail) {
      await FirebaseAuth.instance.currentUser!.updateEmail(newEmail);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile Updated")),
    );

    setState(() {
      editEmail = false;
      editPhone = false;
      editLevel = false;

      originalEmail = newEmail;
      originalPhone = newPhone;
      originalLevel = level;
    });
  }

  /// Change password
  Future<void> changePassword() async {

    TextEditingController oldPassController = TextEditingController();
    TextEditingController newPassController = TextEditingController();
    TextEditingController confirmPassController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {

            bool showOldPassword = false;
            bool showNewPassword = false;
            bool showConfirmPassword = false;

            return AlertDialog(
              title: const Text("Change Password"),

              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  TextField(
                    controller: oldPassController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Old Password",
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: newPassController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "New Password",
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: confirmPassController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Confirm Password",
                    ),
                  ),

                ],
              ),

              actions: [

                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),

                TextButton(
                  child: const Text("Update"),
                  onPressed: () async {

                    String oldPassword = oldPassController.text.trim();
                    String newPassword = newPassController.text.trim();
                    String confirmPassword = confirmPassController.text.trim();

                    if (oldPassword.isEmpty &&
                        newPassword.isEmpty &&
                        confirmPassword.isEmpty) {

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Nothing to update")),
                      );
                      return;
                    }

                    if (oldPassword.isEmpty ||
                        newPassword.isEmpty ||
                        confirmPassword.isEmpty) {

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("All fields required")),
                      );
                      return;
                    }

                    if (newPassword != confirmPassword) {

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Passwords do not match")),
                      );
                      return;
                    }

                    try {

                      User user = FirebaseAuth.instance.currentUser!;

                      AuthCredential credential =
                      EmailAuthProvider.credential(
                        email: user.email!,
                        password: oldPassword,
                      );

                      await user.reauthenticateWithCredential(credential);

                      await user.updatePassword(newPassword);

                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Password Updated Successfully"),
                        ),
                      );

                    } catch (e) {

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Old password is incorrect"),
                        ),
                      );

                    }

                  },
                )

              ],
            );
          },
        );
      },
    );
  }

  /// Forgot password
  Future<void> forgotPassword() async {

    String email = FirebaseAuth.instance.currentUser?.email ?? "";

    if (email.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No email found for this account"),
        ),
      );

      return;
    }

    try {

      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Password reset link sent to $email",
          ),
        ),
      );

    } on FirebaseAuthException catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? "Failed to send reset email"),
        ),
      );

    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("My Profile"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: SingleChildScrollView(

          child: Column(
            children: [

              /// FULL NAME
              TextField(
                controller: nameController,
                enabled: false,
                decoration: const InputDecoration(
                  labelText: "Full Name",
                ),
              ),

              const SizedBox(height: 20),

              /// EMAIL
              Stack(
                alignment: Alignment.centerRight,
                children: [

                  TextField(
                    controller: emailController,
                    enabled: editEmail,
                    decoration: const InputDecoration(
                      labelText: "Email",
                    ),
                  ),

                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      setState(() {
                        editEmail = true;
                      });
                    },
                  )

                ],
              ),

              const SizedBox(height: 20),

              /// MOBILE
              Stack(
                alignment: Alignment.centerRight,
                children: [

                  TextField(
                    controller: phoneController,
                    enabled: editPhone,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: "Mobile Number",
                    ),
                  ),

                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      setState(() {
                        editPhone = true;
                      });
                    },
                  )

                ],
              ),

              const SizedBox(height: 20),

              /// LEVEL
              Stack(
                alignment: Alignment.centerRight,
                children: [

                  editLevel
                      ? DropdownButtonFormField<String>(
                    value: level,
                    items: const [
                      DropdownMenuItem(
                        value: "Beginner",
                        child: Text("Beginner"),
                      ),
                      DropdownMenuItem(
                        value: "Intermediate",
                        child: Text("Intermediate"),
                      ),
                      DropdownMenuItem(
                        value: "Advanced",
                        child: Text("Advanced"),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        level = value!;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: "Workout Level",
                    ),
                  )
                      : TextField(
                    enabled: false,
                    decoration: InputDecoration(
                      labelText: "Workout Level",
                      hintText: level,
                    ),
                  ),

                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      setState(() {
                        editLevel = true;
                      });
                    },
                  )

                ],
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: updateProfile,
                  child: const Text("Update Profile"),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: changePassword,
                  child: const Text("Change Password"),
                ),
              ),

              const SizedBox(height: 10),

              TextButton(
                onPressed: forgotPassword,
                child: const Text("Forgot Password?"),
              ),

            ],
          ),
        ),
      ),
    );
  }
}