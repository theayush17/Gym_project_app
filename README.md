# 🏋️ Gym Management Mobile Application

This Gym_project_app is a **Flutter-based gym management mobile app** designed to help gym owners efficiently manage members, subscriptions, and membership data.

The application integrates **Firebase Authentication** for secure login and **Cloud Firestore** for storing user and membership information.

---

# 📱 App Features

## 👤 User Features

* User Registration
* Secure Login System
* Google Sign-In Authentication
* Password Reset / Forgot Password
* User Profile Management
* Membership Status Display
* Dashboard with Greeting System
* Subscription Expiry Tracking

---

## 🛠 Admin Features

* Admin Login Panel
* View All Registered Members
* Search Members by Name or Mobile Number
* Filter Members by Subscription Status
* View Detailed Member Information
* Activate Membership Plans
* Membership Expiry Tracking
* Remove Members from the System

---

# ⚙️ Tech Stack

### Frontend

* Flutter
* Dart

### Backend

* Firebase Authentication
* Cloud Firestore

### Tools

* Android Studio
* Git
* GitHub

---

# 🗄 Database Structure

The application stores user data in **Cloud Firestore**.

Example structure:

```
users
   uid
      fullName
      age
      gender
      mobile
      email
      level
      role
      subscription
      expiryDate
```

### Roles

```
role = user
role = admin
```

Admins have access to the **admin dashboard**.

---

# 📂 Project Structure

```
lib
 ├── config
 │    routes.dart
 │
 ├── screens
 │    ├── auth
 │    │    login_screen.dart
 │    │    register_screen.dart
 │    │
 │    ├── dashboard
 │    │    dashboard_screen.dart
 │    │
 │    ├── profile
 │    │    profile_screen.dart
 │    │
 │    └── admin
 │         admin_dashboard.dart
 │         member_details_screen.dart
 │
 └── main.dart
```

---

# 🔐 Authentication System

EcoGym uses **Firebase Authentication** to provide secure login.

Supported login methods:

* Email & Password
* Google Sign-In
* Password Reset

---

# 📦 Installation

Clone the repository:

```
git clone https://github.com/yourusername/EcoGym-App.git
```

Navigate to the project folder:

```
cd EcoGym-App
```

Install dependencies:

```
flutter pub get
```

Run the application:

```
flutter run
```

---

# 📥 Download APK

[Download OffGym v1.0 APK](https://github.com/theayush17/Gym_project_app/releases/download/v1.0/OffGym-v1.0.apk)

The APK file can also be downloaded from the **Releases section** of this repository.

---

# 🔮 Future Improvements

Planned improvements include:

* Automatic Membership Expiry System
* Gym Attendance Tracking
* Push Notifications
* Admin Analytics Dashboard
* QR Code Based Gym Check-in

---

# 👨‍💻 Author

**Ayush Kumar Singh**

Flutter Developer | Frontend Developer

---

# ⭐ Support

If you like this project, consider giving it a **star ⭐ on GitHub**.
