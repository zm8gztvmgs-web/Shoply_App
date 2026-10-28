import 'package:flutter/material.dart';
import 'package:shoply_app/core/utils/widgets/app_bar/custom_app_bar.dart';

part 'widgets/row_icon.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleText: 'Settings'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            _RowIcon(
              iconData: Icons.person_outline,
              title: 'Update Profile',
              onTap: () {},
            ),

            const SizedBox(height: 30),

            _RowIcon(
              iconData: Icons.lock_outline,
              title: 'Update Password',
              onTap: () {},
            ),

            const SizedBox(height: 30),

            _RowIcon(
              iconData: Icons.info_outline,
              title: 'About',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
