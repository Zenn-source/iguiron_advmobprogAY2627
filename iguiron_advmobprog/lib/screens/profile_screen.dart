import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/user.dart';
import '../services/user_service.dart';
import '../widgets/custom_text.dart';

// enhancement 3: fetches the persisted user and renders it here.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<User> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = UserService().getUser();
  }

  Future<void> _logout(BuildContext context) async {
    await UserService().logout();
    if (!context.mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/signin', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: FutureBuilder<User>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: CustomText(
                text: 'Unable to load profile: ${snapshot.error}',
                fontSize: 14.sp,
              ),
            );
          }

          final user = snapshot.data!;

          return ListView(
            padding: EdgeInsets.all(20.r),
            children: [
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 44.r,
                      backgroundColor: colorScheme.primaryContainer,
                      backgroundImage: user.image.isNotEmpty
                          ? NetworkImage(user.image)
                          : null,
                      child: user.image.isEmpty
                          ? Icon(Icons.person, size: 44.sp)
                          : null,
                    ),
                    SizedBox(height: 12.h),
                    CustomText(
                      text: user.fullName,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    CustomText(
                      text: '@${user.username}',
                      fontSize: 13.sp,
                      fontColor: Colors.amber.shade800,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              _ProfileInfoTile(
                icon: Icons.email_outlined,
                label: 'Email',
                value: user.email,
              ),
              _ProfileInfoTile(
                icon: Icons.wc_outlined,
                label: 'Gender',
                value: user.gender,
              ),
              _ProfileInfoTile(
                icon: Icons.badge_outlined,
                label: 'User ID',
                value: '#${user.id}',
              ),
              SizedBox(height: 24.h),
              SizedBox(
                height: 48.h,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent.shade200,
                  ),
                  onPressed: () => _logout(context),
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const CustomText(
                    text: 'Log Out',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    fontColor: Colors.white,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ProfileInfoTile extends StatelessWidget {
  const _ProfileInfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20.sp, color: colorScheme.onSurfaceVariant),
          SizedBox(width: 12.w),
          CustomText(
            text: label,
            fontSize: 12.sp,
            fontColor: colorScheme.onSurfaceVariant,
          ),
          const Spacer(),
          CustomText(
            text: value,
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}
