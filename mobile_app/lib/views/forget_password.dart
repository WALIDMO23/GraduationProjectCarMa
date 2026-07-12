import 'package:flutter/material.dart';
import 'package:graduation_project/core/comeponents/app_button.dart';
import 'package:graduation_project/core/comeponents/app_image.dart';
import 'package:graduation_project/core/comeponents/app_input.dart';
import 'package:graduation_project/core/theme/app_theme.dart';
import 'package:graduation_project/core/comeponents/app_background.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            '╪د╪│╪ز╪╣╪د╪»╪ر ┘â┘┘à╪ر ╪د┘┘à╪▒┘ê╪▒',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              height: 32,
              letterSpacing: 0,
            ),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
            ), // Back mapping to arrow.svg if needed
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 40.0,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        height: 72,
                        width: 72,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.carmaGold.withValues(alpha: 0.1),
                        ),
                        child: const AppImage(
                          image: 'message.svg',
                          color: AppTheme.carmaGold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        '╪ث╪»╪«┘ ╪ذ╪▒┘è╪»┘â ╪د┘╪ح┘┘â╪ز╪▒┘ê┘┘è ╪د┘┘à╪▒╪ز╪ذ╪╖ ╪ذ╪ص╪│╪د╪ذ┘â╪î ┘ê╪│┘╪▒╪│┘ ┘┘â ╪▒╪د╪ذ╪╖┘ï╪د ┘╪ح╪╣╪د╪»╪ر ╪ز╪╣┘è┘è┘ ┘â┘┘à╪ر ╪د┘┘à╪▒┘ê╪▒.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 32),
                      const AppInput(
                        label: '╪د┘╪ذ╪▒┘è╪» ╪د┘╪ح┘┘â╪ز╪▒┘ê┘┘è',
                        hint: 'example@email.com',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 32),
                      AppButton(
                        text: '╪ح╪▒╪│╪د┘ ╪د┘╪▒╪د╪ذ╪╖',
                        onPressed: () {
                          // TODO: Send link logic
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '┘┘à ╪ز╪ز┘┘é ╪د┘╪ذ╪▒┘è╪»╪ا ',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // TODO: Resend logic
                        },
                        child: const Text(
                          '╪ح╪╣╪د╪»╪ر ╪د┘╪ح╪▒╪│╪د┘',
                          style: TextStyle(
                            color: AppTheme.carmaGold,
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
