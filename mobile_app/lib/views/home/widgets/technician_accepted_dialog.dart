import 'package:flutter/material.dart';
import 'package:graduation_project/core/theme/app_theme.dart';
import 'package:graduation_project/data/models/order_model.dart';

/// Shows automatically when admin accepts the order and assigns a technician.
class TechnicianAcceptedDialog extends StatelessWidget {
  final OrderModel order;

  const TechnicianAcceptedDialog({super.key, required this.order});

  static void show(BuildContext context, OrderModel order) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => TechnicianAcceptedDialog(order: order),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ظ¤ظ¤ Success animation circle ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.successColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: AppTheme.successColor,
                size: 50,
              ),
            ),
            const SizedBox(height: 16),

            // ظ¤ظ¤ Title ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤
            const Text(
              '╪ز┘à ┘é╪ذ┘ê┘ ╪╖┘╪ذ┘â! ظ£à',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '╪ز┘à ╪ز╪╣┘è┘è┘ ┘┘┘è ╪╡┘è╪د┘╪ر ┘ê┘ç┘ê ┘┘è ╪د┘╪╖╪▒┘è┘é ╪ح┘┘è┘â ╪د┘╪ت┘',
              style: TextStyle(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // ظ¤ظ¤ Technician Card ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.engineering, color: AppTheme.primaryColor, size: 28),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order.technicianName ?? '╪د┘┘┘┘è',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  order.technicianRating?.toStringAsFixed(1) ?? 'ظ¤',
                                  style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 13),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Phone
                  _InfoRow(
                    icon: Icons.phone_android,
                    label: '╪▒┘é┘à ╪د┘┘ç╪د╪ز┘',
                    value: order.technicianPhone ?? 'ظ¤',
                    isPhone: true,
                  ),
                  const SizedBox(height: 10),

                  // ETA
                  if (order.estimatedArrival != null)
                    _InfoRow(
                      icon: Icons.access_time_rounded,
                      label: '┘ê┘é╪ز ╪د┘┘ê╪╡┘ê┘ ╪د┘┘à╪ز┘ê┘é╪╣',
                      value: '${order.estimatedArrival} ╪»┘é┘è┘é╪ر',
                      highlightColor: AppTheme.successColor,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ظ¤ظ¤ OK Button ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('╪ص╪│┘╪د┘ï╪î ╪┤┘â╪▒╪د┘ï ┘┘â', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isPhone;
  final Color? highlightColor;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isPhone = false,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: highlightColor ?? Theme.of(context).colorScheme.onSurfaceVariant),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant)),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: highlightColor ?? Theme.of(context).colorScheme.onSurface,
              ),
              textDirection: isPhone ? TextDirection.ltr : null,
            ),
          ],
        ),
      ],
    );
  }
}
