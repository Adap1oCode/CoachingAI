import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'config/app_config.dart';
import 'constants/route_names.dart';
import 'routes/routes.dart' show generateRoute;
import 'core/theme/app_theme.dart'; // ✅ Add this line

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
      theme: appTheme, // ✅ Use the custom theme
      initialRoute: RouteNames.splash,
      onGenerateRoute: generateRoute,
    );
  }
}
