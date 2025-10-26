import 'package:flutter/material.dart';
import '../../controllers/profile_controller.dart';
import 'info_section.dart';

class PersonalInfoSection extends StatelessWidget {
  final ProfileController controller;

  const PersonalInfoSection({
    Key? key,
    required this.controller,
  }) : super(key: key);

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(value),
      trailing: onTap != null ? const Icon(Icons.chevron_right) : null,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = controller.userProvider;

    return InfoSection(
      title: 'Personal Information',
      children: [
        _buildInfoTile(
          icon: Icons.phone,
          title: 'Phone Number',
          value: userProvider.phone,
          onTap: () => controller.showEditPhoneDialog(),
        ),
        _buildInfoTile(
          icon: Icons.location_on,
          title: 'Address',
          value: userProvider.address,
          onTap: () => controller.showEditAddressDialog(),
        ),
        _buildInfoTile(
          icon: Icons.calendar_today,
          title: 'Date of Birth',
          value: _formatDate(userProvider.dateOfBirth),
          onTap: () => controller.showDatePickerDialog(),
        ),
      ],
    );
  }
}
