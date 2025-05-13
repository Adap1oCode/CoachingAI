import 'package:flutter/material.dart';
import 'package:coaching_ai_new/constants/route_names.dart';
import 'package:coaching_ai_new/core/utils/user_session.dart';
import 'package:coaching_ai_new/core/widget/auth_screen_scaffold.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fullName = UserSession.fullName;
    final initials = UserSession.initials;

    return AuthScreenScaffold(
      title: 'My Account',
      initials: initials,
      conversations: const [], // ✅ No chat sidebar needed here
      conversationId: null,
      onStartNewConversation: () {},
      onSelectConversation: (_) {},
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 36,
                  backgroundImage: NetworkImage('https://i.postimg.cc/0jqKB6mS/Profile-Image.png'),
                ),
                const SizedBox(height: 16),
                Text(
                  fullName,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                _AccountTile(
                  icon: Icons.person_outline,
                  label: 'My Account',
                  onTap: () => Navigator.pushNamed(context, RouteNames.editProfile),
                ),
                _AccountTile(
                  icon: Icons.notifications_none,
                  label: 'Notifications',
                  onTap: () {},
                ),
                _AccountTile(
                  icon: Icons.settings_outlined,
                  label: 'Settings',
                  onTap: () {},
                ),
                _AccountTile(
                  icon: Icons.help_outline,
                  label: 'Help Center',
                  onTap: () {},
                ),
                _AccountTile(
                  icon: Icons.logout,
                  label: 'Log Out',
                  isDestructive: true,
                  onTap: () => Navigator.pushNamed(context, RouteNames.logout),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AccountTile extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isDestructive;
  final VoidCallback? onTap;

  const _AccountTile({
    required this.icon,
    required this.label,
    this.isDestructive = false,
    this.onTap,
  });

  @override
  State<_AccountTile> createState() => _AccountTileState();
}

class _AccountTileState extends State<_AccountTile> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: _hovering ? const Color(0xFFE0E0E0) : const Color(0xFFF5F6F9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                widget.icon,
                color: widget.isDestructive ? Colors.red : const Color(0xFF00BF6D),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 16,
                    color: widget.isDestructive ? Colors.red : Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
