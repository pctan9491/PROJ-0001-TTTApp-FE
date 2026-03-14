import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = true;

  @override
  Widget build(BuildContext context) {
    final secondaryColor = Theme.of(context).colorScheme.secondary;

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: TextStyle(color: secondaryColor)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: secondaryColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          _buildSectionHeader('General'),
          SwitchListTile(
            title: const Text('Notifications', style: TextStyle(color: Colors.white)),
            subtitle: Text('Enable push notifications', style: TextStyle(color: Colors.grey[400])),
            value: _notificationsEnabled,
            activeColor: secondaryColor,
            onChanged: (bool value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Dark Mode', style: TextStyle(color: Colors.white)),
            subtitle: Text('Enable dark theme', style: TextStyle(color: Colors.grey[400])),
            value: _darkModeEnabled,
            activeColor: secondaryColor,
            onChanged: (bool value) {
              setState(() {
                _darkModeEnabled = value;
              });
            },
          ),
          const Divider(color: Colors.white10),
          
          _buildSectionHeader('Account'),
          ListTile(
            leading: Icon(Icons.lock_outline, color: secondaryColor),
            title: const Text('Change Password', style: TextStyle(color: Colors.white)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            onTap: () {
              // TODO: Navigate to Change Password Page
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Change Password functionality coming soon')),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.language, color: secondaryColor),
            title: const Text('Language', style: TextStyle(color: Colors.white)),
            subtitle: Text('English', style: TextStyle(color: Colors.grey[400])),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            onTap: () {
              // TODO: Language selection
            },
          ),
          const Divider(color: Colors.white10),

          _buildSectionHeader('About'),
          ListTile(
            leading: Icon(Icons.info_outline, color: secondaryColor),
            title: const Text('App Version', style: TextStyle(color: Colors.white)),
            subtitle: Text('1.0.0', style: TextStyle(color: Colors.grey[400])),
          ),
          ListTile(
            leading: Icon(Icons.privacy_tip_outlined, color: secondaryColor),
            title: const Text('Privacy Policy', style: TextStyle(color: Colors.white)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            onTap: () {
              // TODO: Show Privacy Policy
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Theme.of(context).colorScheme.secondary,
          fontWeight: FontWeight.bold,
          fontSize: 12,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}