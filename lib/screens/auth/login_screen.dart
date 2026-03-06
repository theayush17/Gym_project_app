import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool hidePassword = true;

  @override
  void initState() {
    super.initState();
    loadSavedEmail();
  }

  /// LOAD SAVED EMAIL
  Future<void> loadSavedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedEmail = prefs.getString("saved_email");

    if (savedEmail != null) {
      emailController.text = savedEmail;
    }
  }

  /// SAVE EMAIL
  Future<void> saveEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("saved_email", email);
  }

  /// EMAIL LOGIN
  Future<void> login() async {
    try {

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await saveEmail(emailController.text.trim());

      Navigator.pushReplacementNamed(context, '/dashboard');

    } on FirebaseAuthException catch (e) {

      if (e.code == 'user-not-found') {
        showError("Please register first!");
      } else if (e.code == 'wrong-password') {
        showError("Incorrect password");
      } else {
        showError(e.message ?? "Login failed");
      }
    }
  }

  /// GOOGLE LOGIN
  Future<void> signInWithGoogle() async {
    try {

      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

      String uid = userCredential.user!.uid;

      var doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (!doc.exists) {

        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .set({
          "fullName": userCredential.user!.displayName ?? "",
          "email": userCredential.user!.email,
          "role": "user",
          "subscription": "Free"
        });

      }

      await saveEmail(userCredential.user!.email ?? "");

      Navigator.pushReplacementNamed(context, '/dashboard');

    } catch (e) {
      showError("Google Sign-In failed");
    }
  }

  /// APPLE LOGIN
  Future<void> signInWithApple() async {

    try {

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(oauthCredential);

      String uid = userCredential.user!.uid;

      var doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (!doc.exists) {

        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .set({
          "fullName": appleCredential.givenName ?? "",
          "email": appleCredential.email ?? "",
          "role": "user",
          "subscription": "Free"
        });

      }

      await saveEmail(userCredential.user!.email ?? "");

      Navigator.pushReplacementNamed(context, '/dashboard');

    } catch (e) {
      showError("Apple Sign-In failed");
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
      body: SafeArea(

        child: SingleChildScrollView(

          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),

            child: Column(

              children: [

                const SizedBox(height: 100),

                const Text(
                  "Welcome Back 👋",
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 30),

                /// EMAIL
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: "Email"),
                ),

                const SizedBox(height: 20),

                /// PASSWORD
                TextField(
                  controller: passwordController,
                  obscureText: hidePassword,
                  decoration: InputDecoration(
                    labelText: "Password",
                    suffixIcon: IconButton(
                      icon: Icon(
                          hidePassword
                              ? Icons.visibility_off
                              : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          hidePassword = !hidePassword;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// LOGIN BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: login,
                    child: const Text("Login"),
                  ),
                ),

                const SizedBox(height: 10),

                /// ADMIN LOGIN
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/adminLogin');
                  },
                  child: const Text(
                    "Admin Login",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),

                /// REGISTER
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: const Text("Register"),
                ),

                const SizedBox(height: 20),

                Row(
                  children: const [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text("OR"),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),

                const SizedBox(height: 20),

                /// GOOGLE SIGN IN
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: signInWithGoogle,
                    icon: const Icon(Icons.g_mobiledata, size: 30),
                    label: const Text("Sign in with Google"),
                  ),
                ),

                const SizedBox(height: 15),

                /// APPLE SIGN IN
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: signInWithApple,
                    icon: const Icon(Icons.apple),
                    label: const Text("Sign in with Apple"),
                  ),
                ),

                const SizedBox(height: 40),

              ],
            ),
          ),
        ),
      ),
    );
  }
}