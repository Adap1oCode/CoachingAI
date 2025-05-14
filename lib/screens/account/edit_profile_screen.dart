import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/widget/two_factor_settings_section.dart';
import '../../core/utils/user_session.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String email = '';
  bool loading = false;
  late String initials;

  @override
  void initState() {
    super.initState();
    final user = Supabase.instance.client.auth.currentUser;
    final metadata = user?.userMetadata ?? {};

    email = user?.email ?? '';
    fullNameController.text = metadata['full_name'] ?? '';
    phoneController.text = metadata['phone'] ?? '';
    addressController.text = metadata['address'] ?? '';
    initials = UserSession.initials;
  }

  InputDecoration fieldDecoration(String hint) => InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFF00BF6D).withOpacity(0.05),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide.none,
        ),
      );

  Future<void> saveProfile() async {
    setState(() => loading = true);
    try {
      await Supabase.instance.client.auth.updateUser(UserAttributes(
        data: {
          'full_name': fullNameController.text.trim(),
          'phone': phoneController.text.trim(),
          'address': addressController.text.trim(),
        },
      ));
      _showSnack('✅ Profile updated');
    } catch (e) {
      _showSnack('❌ Error: $e');
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> updatePassword() async {
    final newPass = newPasswordController.text;
    final confirm = confirmPasswordController.text;

    if (newPass != confirm) {
      _showSnack('Passwords do not match');
      return;
    }

    try {
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(password: newPass),
      );
      _showSnack('✅ Password updated');
    } catch (e) {
      _showSnack('❌ Error updating password: $e');
    }
  }

  void _showSnack(String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: const Color(0xFF00BF6D),
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                initials,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00BF6D),
                ),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              initialValue: email,
              readOnly: true,
              decoration: fieldDecoration('Email'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: fullNameController,
              decoration: fieldDecoration('Full Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: phoneController,
              decoration: fieldDecoration('Phone'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: addressController,
              decoration: fieldDecoration('Address'),
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00BF6D),
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(),
                    minimumSize: const Size(140, 40),
                  ),
                  child: const Text("Save Update"),
                ),
              ],
            ),

            const TwoFactorSettingsSection(),

            const SizedBox(height: 32),
            TextField(
              controller: currentPasswordController,
              obscureText: true,
              decoration: fieldDecoration('Current Password'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: fieldDecoration('New Password'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: fieldDecoration('Confirm New Password'),
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: updatePassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00BF6D),
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(),
                    minimumSize: const Size(180, 40),
                  ),
                  child: const Text("Update Password"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
