import 'package:flutter/material.dart';
import '../../constants/ui_constants.dart';
import '../../utils/theme_helper.dart';
import '../common/styled_components.dart';

class InfoSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final EdgeInsets padding;

  const InfoSection({
    Key? key,
    required this.title,
    required this.children,
    this.padding = const EdgeInsets.only(bottom: UIConstants.spacing16),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StyledSectionHeader(title: title),
          const SizedBox(height: UIConstants.spacing8),
          StyledCard(
            child: Column(children: children),
          ),
        ],
      ),
    );
  }
}
