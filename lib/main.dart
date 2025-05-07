import 'package:flutter/material.dart';
import 'routes/app_routes.dart';

void main() {
  runApp(const CoachingAIApp());
}

class CoachingAIApp extends StatelessWidget {
  const CoachingAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CoachingAI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: AppRoutes.chatwootWidget,
      routes: AppRoutes.routes,
    );
  }
}
