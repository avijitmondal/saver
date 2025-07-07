import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../controllers/profile_controller.dart';
import '../widgets/profile/profile_header.dart';
import '../widgets/profile/personal_info_section.dart';
import '../widgets/profile/security_section.dart';
import '../widgets/profile/account_actions_section.dart';
import '../widgets/common/app_scaffold.dart';
import '../constants/ui_constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProfileController _controller;

  @override
  void initState() {
    super.initState();
    // Controller will be initialized in didChangeDependencies
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize controller with the current context and user provider
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _controller = ProfileController(
      userProvider: userProvider,
      context: context,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return AppScaffold(
          title: 'Profile',
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: _controller.showEditNameDialog,
            ),
          ],
          body: ListView(
            children: [
              // Profile Header
              Padding(
                padding: const EdgeInsets.only(bottom: UIConstants.spacing32),
                child: ProfileHeader(
                  name: '${userProvider.firstName} ${userProvider.lastName}',
                  email: userProvider.email,
                  onEditPressed: null,
                ),
              ),

              // Personal Information Section
              PersonalInfoSection(controller: _controller),

              // Security Section
              SecuritySection(controller: _controller),

              // Account Actions Section
              AccountActionsSection(controller: _controller),
            ],
          ),
        );
      },
    );
  }
}
