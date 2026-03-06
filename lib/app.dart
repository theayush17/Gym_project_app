import 'package:flutter/material.dart';
import 'config/routes.dart';

class EcoGymApp extends StatelessWidget {
  const EcoGymApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: AppRoutes.routes,
    );
  }
}