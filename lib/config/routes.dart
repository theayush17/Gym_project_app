import 'package:flutter/material.dart';

import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/profile/profile_screen.dart';

import '../screens/admin/admin_login_screen.dart';
import '../screens/admin/admin_dashboard.dart';
import '../screens/admin/all_members_screen.dart';
import '../screens/admin/member_details_screen.dart';

class AppRoutes {

  static final Map<String, WidgetBuilder> routes = {

    '/login': (context) => const LoginScreen(),
    '/register': (context) => const RegisterScreen(),
    '/dashboard': (context) => const DashboardScreen(),
    '/profile': (context) => const ProfileScreen(),

    '/adminLogin': (context) => const AdminLoginScreen(),
    '/adminDashboard': (context) => const AdminDashboard(),
    '/allMembers': (context) => const AllMembersScreen(),
    '/memberDetails': (context) => const MemberDetailsScreen(),

  };

}