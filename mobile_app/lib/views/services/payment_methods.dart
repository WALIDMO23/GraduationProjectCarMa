import 'package:flutter/material.dart';
import 'package:graduation_project/core/comeponents/app_button.dart';
import 'package:graduation_project/views/services/order_confirmation.dart';
import 'package:graduation_project/core/comeponents/app_background.dart';

class PaymentMethodsPage extends StatefulWidget {
  const PaymentMethodsPage({super.key});

  @override
  State<PaymentMethodsPage> createState() => _PaymentMethodsPageState();
}

class _PaymentMethodsPageState extends State<PaymentMethodsPage> {
  int _selectedMethod = 0;

  final List<Map<String, dynamic>> _methods = [
    {
      'title': '╪د┘╪»┘╪╣ ┘┘é╪»╪د┘ï',
      'icon': Icons.money,
      'desc': '╪د┘╪»┘╪╣ ┘┘╪│╪د╪خ┘é ╪╣┘╪» ╪د┘┘ê╪╡┘ê┘',
    },
    {
      'title': '╪د┘╪ذ╪╖╪د┘é╪ر ╪د┘╪د╪خ╪ز┘à╪د┘┘è╪ر / ┘à╪»┘ë',
      'icon': Icons.credit_card,
      'desc': '**** **** **** 1234',
    },
    {
      'title': '╪ث╪ذ┘ ╪ذ╪د┘è (Apple Pay)',
      'icon': Icons.apple,
      'desc': '╪»┘╪╣ ╪│╪▒┘è╪╣ ┘ê╪ت┘à┘',
    },
    {
      'title': '╪د┘┘à╪ص┘╪╕╪ر',
      'icon': Icons.account_balance_wallet,
      'desc': '╪د┘╪▒╪╡┘è╪» ╪د┘┘à╪ز╪د╪ص: 250 ╪▒┘è╪د┘',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('╪╖╪▒┘è┘é╪ر ╪د┘╪»┘╪╣'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Summary Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Color(0xff1C398E), Color(0xff1447E6)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '╪ح╪ش┘à╪د┘┘è ╪د┘┘à╪ذ┘╪║',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                '150 ╪▒┘è╪د┘',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Divider(color: Colors.white24),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                '╪د┘╪«╪»┘à╪ر:',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                '┘ê┘╪┤ ┘ç┘è╪»╪▒┘ê┘┘è┘â',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      '╪د╪«╪ز╪▒ ╪╖╪▒┘è┘é╪ر ╪د┘╪»┘╪╣',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _methods.length,
                      separatorBuilder:
                          (context, index) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final method = _methods[index];
                        final isSelected = _selectedMethod == index;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedMethod = index;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.05)
                                      : Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color:
                                    isSelected
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context).colorScheme.outline,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.surfaceContainerHighest ,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    method['icon'] as IconData,
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        method['title'] as String,
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.onSurface,
                                          fontSize: 16,
                                          fontWeight:
                                              isSelected
                                                  ? FontWeight.bold
                                                  : FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        method['desc'] as String,
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isSelected)
                                   Icon(
                                    Icons.check_circle,
                                    color: Theme.of(context).colorScheme.primary,
                                  )
                                else
                                  Icon(
                                    Icons.circle_outlined,
                                    color: Theme.of(context).colorScheme.outline,
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    offset: const Offset(0, -5),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: AppButton(
                text: '╪ز╪ث┘â┘è╪» ╪د┘╪»┘╪╣ ┘ê╪د┘╪╖┘╪ذ',
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
}
