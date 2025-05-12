import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';


class CallbackScreen extends StatefulWidget {
  const CallbackScreen({super.key});

  @override
  State<CallbackScreen> createState() => _CallbackScreenState();
}

class _CallbackScreenState extends State<CallbackScreen> {
  String? accessToken;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _parseAccessToken();
  }

  // Method to parse the URL for the access token
  void _parseAccessToken() {
    try {
      final Uri uri = Uri.base; // Get the full current URI (including fragment)
      print("Current URI: ${uri.toString()}"); // Log the entire URI to see it

      // Log the URL fragment
      final fragment = uri.fragment;
      print("Fragment: $fragment");

      final accessTokenFragment = fragment.split('&').firstWhere(
        (param) => param.startsWith('access_token='),
        orElse: () => '',
      );

      // Log the access_token if found
      if (accessTokenFragment.isNotEmpty) {
        final token = accessTokenFragment.split('=')[1];
        setState(() {
          accessToken = token;
        });
        print("Access Token: $accessToken");
      } else {
        print("Access Token not found in the URL fragment");
        setState(() {
          errorMessage = "Access token not found in the URL.";
        });
      }
    } catch (e) {
      print("Error while parsing access token: $e");
      setState(() {
        errorMessage = "Error while parsing access token.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Callback Screen")),
      body: Center(
        child: accessToken == null
            ? errorMessage != null
                ? Text(errorMessage!) // Show error message if parsing failed
                : const CircularProgressIndicator() // Show loading while parsing
            : Text('Access token: $accessToken'), // Show access token if successfully parsed
      ),
    );
  }
}
