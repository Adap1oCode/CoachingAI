import 'package:flutter/material.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: const Color(0xFF00BF6D),
        foregroundColor: Colors.white,
        title: const Text("Edit Profile"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            const _ProfilePic(),
            const SizedBox(height: 24),
            const _FormFields(),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 120,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 160,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00BF6D),
                      foregroundColor: Colors.white,
                      shape: const StadiumBorder(),
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    onPressed: () {
                      // TODO: Save logic
                    },
                    child: const Text("Save Update"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _ProfilePic extends StatelessWidget {
  const _ProfilePic();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.grey.withOpacity(0.2),
            ),
          ),
          child: const CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(
              'https://i.postimg.cc/cCsYDjvj/user-2.png',
            ),
          ),
        ),
        InkWell(
          onTap: () {
            // TODO: Image picker
          },
          child: const CircleAvatar(
            radius: 14,
            backgroundColor: Color(0xFF00BF6D),
            child: Icon(Icons.edit, size: 16, color: Colors.white),
          ),
        )
      ],
    );
  }
}

class _FormFields extends StatelessWidget {
  const _FormFields();

  @override
  Widget build(BuildContext context) {
    InputDecoration fieldDecoration(String hint) {
      return InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFF00BF6D).withOpacity(0.05),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide.none,
        ),
      );
    }

    return Column(
      children: [
        TextFormField(
          initialValue: 'Annette Black',
          decoration: fieldDecoration('Name'),
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: 'annette@gmail.com',
          decoration: fieldDecoration('Email'),
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: '(316) 555-0116',
          decoration: fieldDecoration('Phone'),
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: 'New York, NY',
          decoration: fieldDecoration('Address'),
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: '',
          obscureText: true,
          decoration: fieldDecoration('New Password'),
        ),
      ],
    );
  }
}
