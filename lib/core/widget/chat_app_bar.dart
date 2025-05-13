import 'package:flutter/material.dart';
import 'package:coaching_ai_new/constants/route_names.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String initials;
  final VoidCallback? onMenuTap;

  const ChatAppBar({
    super.key,
    required this.title,
    required this.initials,
    this.onMenuTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF00BF6D),
      foregroundColor: Colors.white,
      elevation: 0,
      title: Text(title),
      leading: onMenuTap != null
          ? IconButton(
              icon: const Icon(Icons.menu),
              onPressed: onMenuTap,
            )
          : null,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: _HoverAvatar(
            initials: initials,
            onTap: () {
              print('👆 Avatar tapped. Navigating to: ${RouteNames.account}');
              Navigator.pushNamed(context, RouteNames.account);
            },
          ),
        ),
      ],
    );
  }
}

class _HoverAvatar extends StatefulWidget {
  final String initials;
  final VoidCallback onTap;

  const _HoverAvatar({
    required this.initials,
    required this.onTap,
  });

  @override
  State<_HoverAvatar> createState() => _HoverAvatarState();
}

class _HoverAvatarState extends State<_HoverAvatar> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(24),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: _isHovering ? const Color(0xFFE0F2F1) : Colors.white,
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(2),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.transparent,
            child: Text(
              widget.initials,
              style: const TextStyle(
                color: Color(0xFF00BF6D),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
