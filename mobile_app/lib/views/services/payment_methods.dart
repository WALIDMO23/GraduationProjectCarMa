import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graduation_project/core/comeponents/app_button.dart';
import 'package:graduation_project/views/services/order_confirmation.dart';
import 'package:graduation_project/core/comeponents/app_background.dart';
import 'package:graduation_project/core/theme/app_theme.dart';

class PaymentMethodsPage extends StatefulWidget {
  const PaymentMethodsPage({super.key});

  @override
  State<PaymentMethodsPage> createState() => _PaymentMethodsPageState();
}

/// Represents a payment method entry.
class _PaymentMethod {
  final String title;
  final String desc;
  final Widget icon;
  final bool isAvailable;

  const _PaymentMethod({
    required this.title,
    required this.desc,
    required this.icon,
    this.isAvailable = true,
  });
}

class _PaymentMethodsPageState extends State<PaymentMethodsPage> {
  int _selectedMethod = 0;

  late final List<_PaymentMethod> _methods;

  @override
  void initState() {
    super.initState();
    _methods = [
      _PaymentMethod(
        title: 'الدفع بعد الانتهاء من الخدمة',
        desc: 'ادفع مباشرة بعد تنفيذ الخدمة',
        icon: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFF1A7A4A),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.point_of_sale_rounded, color: Colors.white, size: 26),
        ),
        isAvailable: true,
      ),
      _PaymentMethod(
        title: 'انستا باي',
        desc: 'الدفع عبر انستا باي',
        icon: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            'assets/images/instapay.jpeg',
            width: 48,
            height: 48,
            fit: BoxFit.cover,
          ),
        ),
        isAvailable: false,
      ),
      _PaymentMethod(
        title: 'فوري',
        desc: 'الدفع عبر فوري',
        icon: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 4)],
          ),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: SvgPicture.asset(
              'assets/icons/fawry.svg',
              fit: BoxFit.contain,
            ),
          ),
        ),
        isAvailable: false,
      ),
      _PaymentMethod(
        title: 'فودافون كاش',
        desc: 'الدفع عبر فودافون كاش',
        icon: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 4)],
          ),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: SvgPicture.asset(
              'assets/icons/vodafon.svg',
              fit: BoxFit.contain,
            ),
          ),
        ),
        isAvailable: false,
      ),
      _PaymentMethod(
        title: 'أبل باي',
        desc: 'الدفع عبر أبل باي',
        icon: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: SvgPicture.asset(
              'assets/icons/applepay.svg',
              fit: BoxFit.contain,
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
          ),
        ),
        isAvailable: false,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Column(
            children: [
              Text(
                'طريقة الدفع',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'اختر طريقة الدفع المناسبة لإتمام الطلب',
                style: TextStyle(fontSize: 11, color: Colors.white60),
              ),
            ],
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Payment Methods List
                      ...List.generate(_methods.length, (index) {
                        final method = _methods[index];
                        final isSelected = _selectedMethod == index;
                        final isLocked = !method.isAvailable;
                        return _buildPaymentCard(
                          method: method,
                          isSelected: isSelected,
                          isLocked: isLocked,
                          index: index,
                          isDark: isDark,
                        );
                      }),
                    ],
                  ),
                ),
              ),

              // Confirm Button
              Container(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      offset: const Offset(0, -4),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: AppButton(
                  text: 'تأكيد الدفع والمتابعة',
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OrderConfirmationPage(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentCard({
    required _PaymentMethod method,
    required bool isSelected,
    required bool isLocked,
    required int index,
    required bool isDark,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: isLocked ? null : () => setState(() => _selectedMethod = index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.primaryColor.withValues(alpha: isDark ? 0.12 : 0.06)
                  : (isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade100),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? AppTheme.primaryColor
                    : (isDark ? Colors.white12 : Colors.grey.shade300),
                width: isSelected ? 1.8 : 1.0,
              ),
            ),
            child: Row(
              children: [
                // Brand Icon
                method.icon,
                const SizedBox(width: 14),

                // Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        method.title,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isLocked
                              ? (isDark ? Colors.white38 : Colors.black38)
                              : (isDark ? Colors.white : Colors.black87),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        method.desc,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 12,
                          color: isLocked
                              ? (isDark ? Colors.white24 : Colors.black26)
                              : (isDark ? Colors.white54 : Colors.black54),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // Selection indicator or lock
                if (isLocked)
                  Icon(
                    Icons.lock_outline_rounded,
                    color: isDark ? Colors.white24 : Colors.black26,
                    size: 20,
                  )
                else if (isSelected)
                  Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.primaryColor,
                    ),
                    child: const Icon(Icons.check_rounded, color: Colors.white, size: 14),
                  )
                else
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark ? Colors.white24 : Colors.black26,
                        width: 1.5,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),

        // "قريباً" badge for locked methods
        if (isLocked)
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.amber.shade700,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(14),
                  bottomLeft: Radius.circular(10),
                ),
              ),
              child: const Text(
                'قريباً',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}


