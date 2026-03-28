import 'package:flutter/material.dart';

/// A reusable button widget used across the app.
/// Supports primary (filled) and outlined styles.
class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isOutlined;
  final bool isLoading;
  final IconData? icon;

  const CustomButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.isOutlined = false,
    this.isLoading = false,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final child = isLoading
        ? SizedBox(
            height: 18,
            width: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: isOutlined ? theme.colorScheme.primary : Colors.white,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18),
                const SizedBox(width: 8),
              ],
              Text(label),
            ],
          );

    if (isOutlined) {
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: child,
          ),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: child,
        ),
      ),
    );
  }
}
