import 'package:flutter/material.dart';
import 'package:graduation_project/core/comeponents/app_button.dart';
import 'package:graduation_project/core/theme/app_theme.dart';
import 'package:graduation_project/views/home/home.dart';
import 'package:graduation_project/core/comeponents/app_background.dart';

class OrderConfirmationPage extends StatelessWidget {
  const OrderConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              // Success Animation or Icon
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppTheme.successColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  size: 100,
                  color: AppTheme.successColor,
                ),
              ),
               SizedBox(height: 40),
               Text(
                '╪ز┘à ╪ز╪ث┘â┘è╪» ╪د┘╪╖┘╪ذ ╪ذ┘╪ش╪د╪ص!',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
               SizedBox(height: 16),
               Text(
                '╪ز┘à ╪ح╪▒╪│╪د┘ ╪╖┘╪ذ┘â ╪ذ┘╪ش╪د╪ص╪î ╪د┘╪│╪د╪خ┘é ╪د┘╪ت┘ ┘┘è ╪╖╪▒┘è┘é┘ç ╪ح┘┘è┘â. ┘è┘à┘â┘┘â ╪ز╪ز╪ذ╪╣ ╪د┘╪╖┘╪ذ ┘à┘ ╪د┘╪┤╪د╪┤╪ر ╪د┘╪▒╪خ┘è╪│┘è╪ر.',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 16,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Theme.of(context).colorScheme.outline),
                ),
                child: Column(
                  children: [
                    _buildRow(context, '╪▒┘é┘à ╪د┘╪╖┘╪ذ', '#10245'),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Divider(color: Theme.of(context).colorScheme.outline),
                    ),
                    _buildRow(context, '╪د┘╪«╪»┘à╪ر', '┘ê┘╪┤ ┘ç┘è╪»╪▒┘ê┘┘è┘â'),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Divider(color: Theme.of(context).colorScheme.outline),
                    ),
                    _buildRow(context, '╪د┘┘ê┘é╪ز ╪د┘┘à┘é╪»╪▒ ┘┘┘ê╪╡┘ê┘', '10 - 15 ╪»┘é┘è┘é╪ر'),
                  ],
                ),
              ),
              const Spacer(),
              AppButton(
                text: '╪ز╪ز╪ذ╪╣ ╪د┘╪╖┘╪ذ',
                onPressed: () {
                  // TODO: Navigate to active tracking view
                },
              ),
              const SizedBox(height: 16),
              AppButton(
                text: '╪د┘╪╣┘ê╪»╪ر ┘┘╪▒╪خ┘è╪│┘è╪ر',
                isOutlined: true,
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }

  Widget _buildRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
