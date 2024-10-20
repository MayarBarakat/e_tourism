import 'package:e_tourism/module/admin/program/programs_mangment_screen.dart';
import 'package:e_tourism/module/admin/tour/tours_menegement_screen.dart';
import 'package:e_tourism/shared/componenet/components.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // FontAwesome for icons
import '../../shared/network/local/cache_helper.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get user role from cache
    String? userRole = CacheHelper.getData(key: 'role');

    // Check if the user is an admin
    if (userRole != 'admin') {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Admin Panel'),
          backgroundColor: Colors.red.shade700, // More subtle red
        ),
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red.shade200, width: 1.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'You do not have permission to access this screen.\nThis section is for admins only.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.redAccent, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
    }

    // If the user is an admin, show the admin functionalities
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Text(
              'Admin Functions',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).primaryColorDark,
              ),
            ),
            const SizedBox(height: 30),
            _buildAdminButton(
              context,
              title: 'Programs Management',
              color: Colors.teal.shade400, // Slightly muted teal
              icon: FontAwesomeIcons.clipboardList,
              onTap: () {
                navigateTo(context, ProgramsManagementScreen());
              },
            ),
            const SizedBox(height: 20),
            _buildAdminButton(
              context,
              title: 'Tours Management',
              color: Colors.blueGrey, // A calm, neutral color
              icon: FontAwesomeIcons.mapMarkedAlt,
              onTap: () {
                navigateTo(context, ToursManagementScreen());
              },
            ),
            const SizedBox(height: 20),
            _buildAdminButton(
              context,
              title: 'Users Management',
              color: Colors.deepPurple.shade400, // Deep, balanced purple
              icon: FontAwesomeIcons.userShield,
              onTap: () {
                // Navigate to Users management screen
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminButton(BuildContext context, {
    required String title,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 18),
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 5,
        shadowColor: Colors.black.withOpacity(0.2),
      ),
      icon: FaIcon(icon, size: 22, color: Colors.white),
      label: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
      ),
    );
  }
}
