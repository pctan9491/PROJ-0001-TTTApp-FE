
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../auth/domain/entities/user.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../../../core/services/api_service.dart';
import 'edit_profile_page.dart';

class PersonalAccountPage extends StatefulWidget {
  const PersonalAccountPage({super.key});

  @override
  State<PersonalAccountPage> createState() =>
      _PersonalAccountPageState();
}

class _PersonalAccountPageState
    extends State<PersonalAccountPage> {

  // Store Future so API doesn't run on every rebuild
  late Future<User> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = _loadUser();
  }

  // Fetch Account Data from Django
  Future<User> _loadUser() async {
    final response = await ApiService.getUser();
    return User.fromMeResponse(response);
  }

  // Retry fetching user profile
  void _refreshUser() {
    setState(() {
      _userFuture = _loadUser();
    });
  }

  // Sign Out
  Future<void> _signOut() async {
    final prefs = await SharedPreferences.getInstance();

    // Remove saved Login Token
    await prefs.remove('access_token');

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor =
        Theme.of(context).scaffoldBackgroundColor;

    final secondaryColor =
        Theme.of(context).colorScheme.secondary;

    return Scaffold(
      backgroundColor: primaryColor,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'My Account',
          style: TextStyle(color: secondaryColor),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: secondaryColor),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Settings functionality coming soon'),
                ),
              );
            },
          ),
        ],
      ),

      // FutureBuilder handles Loading, Error, Success
      body: FutureBuilder<User>(
        future: _userFuture,

        builder: (context, snapshot) {

          // 1. Loading State
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // 2. Error State
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Failed to load Account',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _refreshUser,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // 3. No Data State
          if (!snapshot.hasData) {
            return const Center(
              child: Text(
                'No Account Data',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          // 4. Success State
          final user = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),

            child: Column(
              children: [
                const SizedBox(height: 20),

                // Profile Picture
                Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: secondaryColor.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey[800],
                        backgroundImage: user.profilePictureUrl != null
                            ? NetworkImage(user.profilePictureUrl!)
                            : null,
                        child: user.profilePictureUrl == null
                            ? const Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.white54,
                              )
                            : null,
                      ),
                    ),

                    Positioned(
                      bottom: 0,
                      right: 4,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditProfilePage(user: user),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: secondaryColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: primaryColor,
                              width: 3,
                            ),
                          ),
                          child: Icon(
                            Icons.edit,
                            size: 16,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // User Information Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: secondaryColor.withOpacity(0.1),
                    ),
                  ),

                  child: Column(
                    children: [
                      _buildInfoRow(
                        'Username',
                        user.name,
                        Icon(
                          Icons.person,
                          color: secondaryColor,
                          size: 20,
                        ),
                        secondaryColor,
                      ),

                      const Divider(
                        color: Colors.white10,
                        height: 32,
                      ),

                      _buildInfoRow(
                        'Email',
                        user.email,
                        Icon(
                          Icons.email,
                          color: secondaryColor,
                          size: 20,
                        ),
                        secondaryColor,
                      ),

                      const Divider(
                        color: Colors.white10,
                        height: 32,
                      ),

                      _buildInfoRow(
                        'Gender',
                        user.gender,
                        FaIcon(
                          FontAwesomeIcons.venusMars,
                          color: secondaryColor,
                          size: 20,
                        ),
                        secondaryColor,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Sign Out Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _signOut,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: Colors.redAccent.withOpacity(0.5),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Sign Out',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value,
    Widget icon,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: icon,
        ),

        const SizedBox(width: 16),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}