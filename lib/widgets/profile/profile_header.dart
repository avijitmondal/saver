import 'package:flutter/material.dart';
import '../../constants/ui_constants.dart';
import '../../utils/theme_helper.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String email;
  final String gender; // 'male', 'female', 'other', or 'prefer_not_to_say'
  final double avatarRadius;
  final double iconSize;
  final VoidCallback? onEditPressed;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.email,
    required this.gender,
    this.avatarRadius = 50,
    this.iconSize = 50,
    this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(UIConstants.spacing16),
      decoration: ThemeHelper.getCardDecoration(
        context,
        color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: avatarRadius,
            backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.10),
            child: _buildGenderVector(iconSize, Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(height: UIConstants.spacing16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (onEditPressed != null) ...[
                const SizedBox(width: UIConstants.spacing8),
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    size: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: onEditPressed,
                ),
              ],
            ],
          ),
          Text(
            email.trim(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: UIConstants.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderVector(double size, Color color) {
    CustomPainter painter;
    switch (gender.toLowerCase()) {
      case 'female':
        painter = _FemaleSilhouettePainter(color);
        break;
      case 'male':
        painter = _MaleSilhouettePainter(color);
        break;
      case 'other':
      case 'prefer_not_to_say':
      default:
        painter = _OtherSilhouettePainter(color);
    }
    return SizedBox(width: size, height: size, child: CustomPaint(painter: painter));
  }
}

class _FemaleSilhouettePainter extends CustomPainter {
  final Color color;
  _FemaleSilhouettePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..style = PaintingStyle.fill;
    final w = size.width;
    final h = size.height;
    final head = Path()
      ..moveTo(w * 0.15, h * 0.55)
      ..quadraticBezierTo(w * 0.05, h * 0.25, w * 0.30, h * 0.15)
      ..quadraticBezierTo(w * 0.50, h * 0.00, w * 0.70, h * 0.15)
      ..quadraticBezierTo(w * 0.95, h * 0.25, w * 0.85, h * 0.55)
      ..quadraticBezierTo(w * 0.75, h * 0.48, w * 0.70, h * 0.55)
      ..quadraticBezierTo(w * 0.50, h * 0.65, w * 0.30, h * 0.55)
      ..quadraticBezierTo(w * 0.25, h * 0.50, w * 0.15, h * 0.55)
      ..close();
    canvas.drawPath(head, paint);
    final torso = Path()
      ..moveTo(w * 0.10, h * 0.85)
      ..quadraticBezierTo(w * 0.10, h * 0.65, w * 0.28, h * 0.65)
      ..lineTo(w * 0.72, h * 0.65)
      ..quadraticBezierTo(w * 0.90, h * 0.65, w * 0.90, h * 0.85)
      ..quadraticBezierTo(w * 0.50, h * 0.95, w * 0.10, h * 0.85)
      ..close();
    canvas.drawPath(torso, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MaleSilhouettePainter extends CustomPainter {
  final Color color;
  _MaleSilhouettePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..style = PaintingStyle.fill;
    final w = size.width;
    final h = size.height;
    final headRect = Rect.fromCenter(center: Offset(w * 0.5, h * 0.42), width: w * 0.40, height: h * 0.45);
    canvas.drawRRect(RRect.fromRectAndRadius(headRect, Radius.circular(w * 0.22)), paint);
    final hair = Path()
      ..moveTo(w * 0.30, h * 0.20)
      ..quadraticBezierTo(w * 0.50, h * 0.05, w * 0.70, h * 0.20)
      ..quadraticBezierTo(w * 0.55, h * 0.18, w * 0.30, h * 0.20)
      ..close();
    canvas.drawPath(hair, paint);
    final torso = Path()
      ..moveTo(w * 0.12, h * 0.85)
      ..quadraticBezierTo(w * 0.12, h * 0.68, w * 0.32, h * 0.68)
      ..lineTo(w * 0.68, h * 0.68)
      ..quadraticBezierTo(w * 0.88, h * 0.68, w * 0.88, h * 0.85)
      ..quadraticBezierTo(w * 0.50, h * 0.95, w * 0.12, h * 0.85)
      ..close();
    canvas.drawPath(torso, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _OtherSilhouettePainter extends CustomPainter {
  final Color color;
  _OtherSilhouettePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..style = PaintingStyle.fill;
    final w = size.width;
    final h = size.height;
    canvas.drawCircle(Offset(w * 0.5, h * 0.40), w * 0.22, paint);
    final shouldersRect = Rect.fromCenter(center: Offset(w * 0.5, h * 0.78), width: w * 0.70, height: h * 0.38);
    canvas.drawRRect(RRect.fromRectAndRadius(shouldersRect, Radius.circular(w * 0.18)), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
