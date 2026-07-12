import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graduation_project/core/comeponents/app_background.dart';
import 'package:graduation_project/core/localization/app_strings.dart';
import 'package:graduation_project/core/theme/app_theme.dart';
import 'package:graduation_project/data/models/order_model.dart';
import 'package:graduation_project/logic/providers/locale_provider.dart';
import 'package:graduation_project/logic/providers/orders_provider.dart';
import 'package:graduation_project/views/home/widgets/technician_accepted_dialog.dart';
import 'package:provider/provider.dart';

/// Payment Method Screen ظ¤ shown after the user fills out the service
/// request form and presses "╪ح╪▒╪│╪د┘ ╪د┘╪╖┘╪ذ". Only Cash is currently enabled;
/// InstaPay, Fawry, Vodafone Cash and Apple Pay are displayed as "┘é╪▒┘è╪ذ╪د┘ï".
class PaymentMethodScreen extends StatefulWidget {
  /// The pre-built DTO carrying all order data from the form.
  final CreateOrderDto orderDto;

  /// Service visual identity (used in the waiting/success screen).
  final IconData serviceIcon;
  final Color serviceColor;

  const PaymentMethodScreen({
    super.key,
    required this.orderDto,
    required this.serviceIcon,
    required this.serviceColor,
  });

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen>
    with SingleTickerProviderStateMixin {
  /// Index of the currently selected payment method (null = none selected).
  int? _selectedIndex;

  /// Tracks whether the order has been submitted.
  bool _submitted = false;

  late final AnimationController _headerAnimCtrl;
  late final Animation<double> _headerFadeIn;

  @override
  void initState() {
    super.initState();
    _headerAnimCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _headerFadeIn = CurvedAnimation(
      parent: _headerAnimCtrl,
      curve: Curves.easeOut,
    );
    _headerAnimCtrl.forward();
  }

  @override
  void dispose() {
    _headerAnimCtrl.dispose();
    super.dispose();
  }

  // ظ¤ظ¤ Payment method definitions ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤
  List<PaymentMethodData> _buildMethods(bool isArabic) {
    return [
      PaymentMethodData(
        id: 'cash',
        title: isArabic ? '╪د┘╪»┘╪╣ ╪ذ╪╣╪» ╪د┘╪د┘╪ز┘ç╪د╪ة ┘à┘ ╪د┘╪«╪»┘à╪ر' : 'Cash after service',
        subtitle:
            isArabic
                ? '╪د╪»┘╪╣ ┘à╪ذ╪د╪┤╪▒╪ر ╪ذ╪╣╪» ╪ز┘┘┘è╪░ ╪د┘╪«╪»┘à╪ر'
                : 'Pay directly after service completion',
        iconWidget: _buildIconContainer(
          Icons.payments_rounded,
          AppTheme.successColor,
        ),
        enabled: true,
      ),
      PaymentMethodData(
        id: 'instapay',
        title: isArabic ? '╪د┘╪│╪ز╪د ╪ذ╪د┘è' : 'InstaPay',
        subtitle: isArabic ? '╪د┘╪»┘╪╣ ╪╣╪ذ╪▒ ╪د┘╪│╪ز╪د ╪ذ╪د┘è' : 'Pay via InstaPay',
        iconWidget: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/instapay.jpeg',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        enabled: false,
      ),
      PaymentMethodData(
        id: 'fawry',
        title: isArabic ? '┘┘ê╪▒┘è' : 'Fawry',
        subtitle: isArabic ? '╪د┘╪»┘╪╣ ╪╣╪ذ╪▒ ┘┘ê╪▒┘è' : 'Pay via Fawry',
        iconWidget: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Transform.scale(
              scale: 1.2,
              child: SvgPicture.asset(
                'assets/icons/fawry.svg',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        enabled: false,
      ),
      PaymentMethodData(
        id: 'vodafone_cash',
        title: isArabic ? '┘┘ê╪»╪د┘┘ê┘ ┘â╪د╪┤' : 'Vodafone Cash',
        subtitle: isArabic ? '╪د┘╪»┘╪╣ ╪╣╪ذ╪▒ ┘┘ê╪»╪د┘┘ê┘ ┘â╪د╪┤' : 'Pay via Vodafone Cash',
        iconWidget: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: SvgPicture.asset(
              'assets/icons/vodafon.svg',
              fit: BoxFit.contain,
            ),
          ),
        ),
        enabled: false,
      ),
      PaymentMethodData(
        id: 'apple_pay',
        title: isArabic ? '╪ث╪ذ┘ ╪ذ╪د┘è' : 'Apple Pay',
        subtitle: isArabic ? '╪د┘╪»┘╪╣ ╪╣╪ذ╪▒ ╪ث╪ذ┘ ╪ذ╪د┘è' : 'Pay via Apple Pay',
        iconWidget: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: SvgPicture.asset(
              'assets/icons/applepay.svg',
              fit: BoxFit.contain,
            ),
          ),
        ),
        enabled: false,
      ),
    ];
  }

  /// Builds a round icon container for the Cash method.
  Widget _buildIconContainer(IconData icon, Color color) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }

  // ظ¤ظ¤ Submit order ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤
  Future<void> _confirmOrder(AppStrings s, String paymentMethodId) async {
    final orders = context.read<OrdersProvider>();

    orders.onOrderAccepted = (order) {
      if (mounted) TechnicianAcceptedDialog.show(context, order);
    };

    if (paymentMethodId == 'cash') {
      widget.orderDto.paymentMethod = 1;
    } else if (paymentMethodId == 'instapay') {
      widget.orderDto.paymentMethod = 3;
    } else {
      widget.orderDto.paymentMethod = 2; // wallets
    }

    final newOrder = await orders.createOrder(widget.orderDto);
    if (!mounted) return;

    if (newOrder != null) {
      setState(() => _submitted = true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            orders.errorMessage ??
                (s.isArabic ? '┘╪┤┘ ╪ح╪▒╪│╪د┘ ╪د┘╪╖┘╪ذ' : 'Failed to send order'),
          ),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  // ظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـ
  //  BUILD
  // ظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـ
  @override
  Widget build(BuildContext context) {
    final isArabic = context.watch<LocaleProvider>().isArabic;
    final s = appStrings(isArabic);

    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body:
            _submitted
                ? _buildSuccessScreen(s)
                : _buildPaymentScreen(s, isArabic),
      ),
    );
  }

  // ظ¤ظ¤ Payment selection screen ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤
  Widget _buildPaymentScreen(AppStrings s, bool isArabic) {
    final methods = _buildMethods(isArabic);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Column(
        children: [
          // ظ¤ظ¤ App bar ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  style: IconButton.styleFrom(
                    backgroundColor:
                        isDark
                            ? Colors.white.withValues(alpha: 0.08)
                            : Colors.black.withValues(alpha: 0.05),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 18,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),

          // ظ¤ظ¤ Scrollable content ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: FadeTransition(
                opacity: _headerFadeIn,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ظ¤ظ¤ Header ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤
                    Text(
                      s.isArabic ? '╪╖╪▒┘è┘é╪ر ╪د┘╪»┘╪╣' : 'Payment Method',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w800, fontSize: 26),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      s.isArabic
                          ? '╪د╪«╪ز╪▒ ╪╖╪▒┘è┘é╪ر ╪د┘╪»┘╪╣ ╪د┘┘à┘╪د╪│╪ذ╪ر ┘╪ح╪ز┘à╪د┘à ╪د┘╪╖┘╪ذ'
                          : 'Choose the appropriate payment method to complete the order',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // ظ¤ظ¤ Payment method cards ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤
                    ...List.generate(methods.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: PaymentMethodCard(
                          data: methods[index],
                          isSelected: _selectedIndex == index,
                          index: index,
                          onTap:
                              methods[index].enabled
                                  ? () => setState(() => _selectedIndex = index)
                                  : null,
                        ),
                      );
                    }),

                    const SizedBox(height: 16),

                    // ظ¤ظ¤ Secure payment note ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color:
                            isDark
                                ? AppTheme.carmaSurface
                                : const Color(0xFFF0F7FF),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color:
                              isDark
                                  ? AppTheme.carmaOutline
                                  : const Color(0xFFD6E8FF),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.security_rounded,
                            color: Theme.of(context).colorScheme.primary,
                            size: 22,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              s.isArabic
                                  ? '╪ش┘à┘è╪╣ ╪د┘┘à╪╣╪د┘à┘╪د╪ز ┘à╪ج┘à┘╪ر ┘ê┘à╪ص┘à┘è╪ر ╪ذ╪د┘┘â╪د┘à┘'
                                  : 'All transactions are fully secured',
                              style: TextStyle(
                                color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ظ¤ظ¤ Bottom confirm button ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤
          Consumer<OrdersProvider>(
            builder: (_, orders, __) {
              final canConfirm =
                  _selectedIndex != null && methods[_selectedIndex!].enabled;

              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  color:
                      isDark
                          ? AppTheme.carmaSurface
                          : Theme.of(context).scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      offset: const Offset(0, -4),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child:
                    orders.isLoading
                        ? Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        )
                        : _ConfirmButton(
                          text: s.isArabic ? '╪ز╪ث┘â┘è╪» ╪د┘╪╖┘╪ذ' : 'Confirm Order',
                          enabled: canConfirm,
                          onPressed:
                              canConfirm
                                  ? () => _confirmOrder(
                                    s,
                                    methods[_selectedIndex!].id,
                                  )
                                  : null,
                        ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ظ¤ظ¤ Order success screen ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤
  Widget _buildSuccessScreen(AppStrings s) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animated pulsing icon
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 800),
                curve: Curves.elasticOut,
                builder:
                    (_, value, child) =>
                        Transform.scale(scale: value, child: child),
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppTheme.successColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    color: AppTheme.successColor,
                    size: 64,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Text(
                s.isArabic
                    ? '╪ز┘à ╪ح╪▒╪│╪د┘ ╪╖┘╪ذ┘â ╪ذ┘╪ش╪د╪ص! ظ£à'
                    : 'Order Sent Successfully! ظ£à',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                s.isArabic
                    ? '╪╖┘╪ذ┘â ╪د┘╪ت┘ ┘é┘è╪» ╪د┘┘à╪▒╪د╪ش╪╣╪ر ┘à┘ ┘é┘╪ذ┘ ╪د┘╪ح╪»╪د╪▒╪ر.\n╪│┘è╪ز┘à ╪ح╪«╪╖╪د╪▒┘â ┘┘ê╪▒ ╪د┘┘à┘ê╪د┘┘é╪ر ┘ê╪ز╪╣┘è┘è┘ ╪د┘┘┘┘è.'
                    : 'Your order is being reviewed.\nYou will be notified when a technician is assigned.',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 15,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              // Payment method confirmation
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.successColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.successColor.withValues(alpha: 0.25),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.payments_rounded,
                      size: 20,
                      color: AppTheme.successColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      s.isArabic
                          ? '╪╖╪▒┘è┘é╪ر ╪د┘╪»┘╪╣: ╪د┘╪»┘╪╣ ╪ذ╪╣╪» ╪د┘╪«╪»┘à╪ر'
                          : 'Payment: Cash after service',
                      style: TextStyle(
                        color: AppTheme.successColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor:
                        Theme.of(context).brightness == Brightness.dark
                            ? AppTheme.carmaDark
                            : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    s.isArabic ? '╪د┘╪╣┘ê╪»╪ر ┘┘╪▒╪خ┘è╪│┘è╪ر' : 'Back to Home',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                s.isArabic
                    ? '┘è┘à┘â┘┘â ┘à╪ز╪د╪ذ╪╣╪ر ╪ص╪د┘╪ر ╪د┘╪╖┘╪ذ ┘à┘ ╪د┘╪┤╪د╪┤╪ر ╪د┘╪▒╪خ┘è╪│┘è╪ر'
                    : 'You can track the order status from the home screen',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـ
//  DATA MODEL
// ظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـ

/// Data model for a single payment method entry.
class PaymentMethodData {
  final String id;
  final String title;
  final String subtitle;
  final Widget iconWidget;
  final bool enabled;

  const PaymentMethodData({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.iconWidget,
    required this.enabled,
  });
}

// ظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـ
//  REUSABLE PAYMENT METHOD CARD
// ظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـ

class PaymentMethodCard extends StatelessWidget {
  final PaymentMethodData data;
  final bool isSelected;
  final int index;
  final VoidCallback? onTap;

  const PaymentMethodCard({
    super.key,
    required this.data,
    required this.isSelected,
    required this.index,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = context.watch<LocaleProvider>().isArabic;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).colorScheme.primary;

    // ظ¤ظ¤ Card colors based on state ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤
    final Color bgColor;
    final Color borderColor;

    if (isSelected) {
      // Selected ظ¤ primary accent
      bgColor =
          isDark
              ? primary.withValues(alpha: 0.08)
              : primary.withValues(alpha: 0.04);
      borderColor = primary;
    } else {
      // Default state for unselected (both enabled and disabled)
      bgColor = isDark ? AppTheme.carmaSurface : Colors.white;
      borderColor = isDark ? AppTheme.carmaOutline : Colors.grey.shade200;
    }

    final card = AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: isSelected ? 2 : 1),
        boxShadow:
            isSelected
                ? [
                  BoxShadow(
                    color: primary.withValues(alpha: 0.12),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
                : null,
      ),
      child: Row(
        children: [
          // ظ¤ظ¤ Icon / logo ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤
          data.iconWidget,
          const SizedBox(width: 14),

          // ظ¤ظ¤ Title & subtitle ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  data.subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          // ظ¤ظ¤ Trailing indicator ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤
          if (data.enabled)
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder:
                  (child, anim) => ScaleTransition(scale: anim, child: child),
              child:
                  isSelected
                      ? Icon(
                        Icons.check_circle_rounded,
                        key: const ValueKey('selected'),
                        color: primary,
                        size: 26,
                      )
                      : Icon(
                        Icons.radio_button_unchecked_rounded,
                        key: const ValueKey('unselected'),
                        color:
                            isDark
                                ? AppTheme.carmaSubtleText
                                : Colors.grey.shade400,
                        size: 24,
                      ),
            )
          else
            Icon(
              Icons.lock_outline_rounded,
              color:
                  isDark
                      ? AppTheme.carmaSubtleText.withValues(alpha: 0.5)
                      : Colors.grey.shade400,
              size: 20,
            ),
        ],
      ),
    );

    // Wrap the card: if disabled, add "┘é╪▒┘è╪ذ╪د┘ï" badge
    if (!data.enabled) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          card,
          // ظ¤ظ¤ "┘é╪▒┘è╪ذ╪د┘ï" badge ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤ظ¤
          Positioned(
            top: -8,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors:
                      isDark
                          ? [const Color(0xFF3A3A3A), const Color(0xFF2A2A2A)]
                          : [const Color(0xFF9E9E9E), const Color(0xFF757575)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                isArabic ? '┘é╪▒┘è╪ذ╪د┘ï' : 'Soon',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      );
    }

    // Enabled card ظ¤ tappable with ink splash
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: card,
      ),
    );
  }
}

// ظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـ
//  CONFIRM BUTTON
// ظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـظـ

class _ConfirmButton extends StatelessWidget {
  final String text;
  final bool enabled;
  final VoidCallback? onPressed;

  const _ConfirmButton({
    required this.text,
    required this.enabled,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).colorScheme.primary;

    return AnimatedOpacity(
      opacity: enabled ? 1.0 : 0.5,
      duration: const Duration(milliseconds: 250),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient:
                enabled
                    ? LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors:
                          isDark
                              ? [AppTheme.carmaGold, AppTheme.carmaGoldDim]
                              : const [Color(0xff1C398E), Color(0xff1447E6)],
                    )
                    : null,
            color:
                enabled
                    ? null
                    : (isDark ? AppTheme.carmaOutline : Colors.grey.shade300),
            boxShadow:
                enabled
                    ? [
                      BoxShadow(
                        color: primary.withValues(alpha: 0.3),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ]
                    : null,
          ),
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle_outline_rounded,
                  size: 20,
                  color: isDark ? AppTheme.carmaDark : Colors.white,
                ),
                const SizedBox(width: 8),
                Text(
                  text,
                  style: TextStyle(
                    color: isDark ? AppTheme.carmaDark : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
