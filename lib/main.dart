import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'config/app_config.dart';
// import 'routes/routes.dart'; // make sure this exposes generateRoute
import 'package:coaching_ai_new/constants/route_names.dart';
import 'routes/routes.dart' show generateRoute;



void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: Env.supabaseUrl,
    anonKey: Env.supabaseAnonKey,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coaching AI',
      debugShowCheckedModeBanner: false,
      initialRoute: RouteNames.splash, // or '/' if splash is route-mapped
      onGenerateRoute: generateRoute,
    );
  }
}
