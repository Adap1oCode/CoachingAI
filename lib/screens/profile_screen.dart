import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(decoration: InputDecoration(labelText: 'Name')),
            TextFormField(decoration: InputDecoration(labelText: 'Email')),
            SizedBox(height: 20),
            ElevatedButton(onPressed: () {}, child: Text("Update")),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {},
              child: Text("Delete Account", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }
}
