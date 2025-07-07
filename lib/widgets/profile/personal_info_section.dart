import 'package:flutter/material.dart';
import '../../controllers/profile_controller.dart';
import 'info_list_tile.dart';
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

  @override
  Widget build(BuildContext context) {
    final userProvider = controller.userProvider;
    
    return InfoSection(
      title: 'Personal Information',
      children: [
        InfoListTile(
          icon: Icons.phone,
          title: 'Phone Number',
          subtitle: userProvider.phone,
          trailing: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => controller.showEditPhoneDialog(),
          ),
        ),
        InfoListTile(
          icon: Icons.location_on,
          title: 'Address',
          subtitle: userProvider.address,
          trailing: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => controller.showEditAddressDialog(),
          ),
        ),
        InfoListTile(
          icon: Icons.calendar_today,
          title: 'Date of Birth',
          subtitle: _formatDate(userProvider.dateOfBirth),
          trailing: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => controller.showDatePickerDialog(),
          ),
        ),
      ],
    );
  }
}
