import 'package:flutter/material.dart';

/// A small coloured chip that represents an appointment status.
/// Used in [AppointmentCard] and the dashboard list.
class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  Color _backgroundColor(BuildContext context) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green.shade100;
      case 'pending':
        return Colors.orange.shade100;
      case 'cancelled':
        return Colors.red.shade100;
      case 'completed':
        return Colors.blue.shade100;
      default:
        return Colors.grey.shade200;
    }
  }

  Color _textColor(BuildContext context) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green.shade800;
      case 'pending':
        return Colors.orange.shade800;
      case 'cancelled':
        return Colors.red.shade800;
      case 'completed':
        return Colors.blue.shade800;
      default:
        return Colors.grey.shade700;
    }
  }

  IconData _icon() {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Icons.check_circle_outline;
      case 'pending':
        return Icons.schedule;
      case 'cancelled':
        return Icons.cancel_outlined;
      case 'completed':
        return Icons.task_alt;
      default:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _backgroundColor(context),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon(), size: 12, color: _textColor(context)),
          const SizedBox(width: 4),
          Text(
            status[0].toUpperCase() + status.substring(1).toLowerCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: _textColor(context),
            ),
          ),
        ],
      ),
    );
  }
}
