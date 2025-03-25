import 'package:flutter/material.dart';
import 'package:learning_android_1/services/auth_service.dart';
import 'package:learning_android_1/models/staff_interface.dart';
import 'package:learning_android_1/data/constants.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  StaffResponse? user;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final authService = await AuthService.getInstance();
    final userData = await authService.getUser();
    setState(() {
      user = userData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.topCenter,
              clipBehavior: Clip.none, // Allow elements to overflow
              children: [
                // Cover Image
                ClipRRect(
                  child: Image.asset(
                    'assets/images/HaiCau.jpg',
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
                // Avatar and Name (Overlapping the Cover)
                Positioned(
                  top: 160, // Adjust to control how much it overlaps
                  left: 20, // Align avatar to the left
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 4,
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 60, // Adjust size
                          backgroundImage: AssetImage(
                            'assets/images/Miyabi.jpg',
                          ),
                        ),
                      ),
                      SizedBox(width: 16), // Space between avatar and name
                      Text(user?.name ?? 'Loading...', style: AppTextStyle.h3),
                    ],
                  ),
                ),
              ],
            ),
            // Content Section
            Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 60), // Space to prevent overlap with avatar
                  FilledButton(
                    style: FilledButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                    ),
                    onPressed: () {},
                    child: Text('Edit Profile'),
                  ),
                  if (user != null) ...[
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: EdgeInsets.all(AppSpacing.sm),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('User Info', style: AppTextStyle.h3),
                            SizedBox(height: AppSpacing.sm),
                            ListTile(
                              leading: Icon(Icons.email),
                              title: Text(
                                'Email:',
                                style: AppTextStyle.bodyMedium,
                              ),
                              subtitle: Text(
                                user!.email,
                                style: AppTextStyle.bodySmall,
                              ),
                            ),
                            ListTile(
                              leading: Icon(Icons.work),
                              title: Text(
                                'Role:',
                                style: AppTextStyle.bodyMedium,
                              ),
                              subtitle: Text(
                                user!.systemRole,
                                style: AppTextStyle.bodySmall,
                              ),
                            ),
                            ListTile(
                              leading: Icon(Icons.apartment),
                              title: Text(
                                'Department:',
                                style: AppTextStyle.bodyMedium,
                              ),
                              subtitle: Text(
                                user!.department,
                                style: AppTextStyle.bodySmall,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: AppSpacing.lg),
                  ] else ...[
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text('Loading user data...'),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
