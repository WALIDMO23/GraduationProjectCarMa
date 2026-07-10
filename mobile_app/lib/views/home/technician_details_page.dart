import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:graduation_project/core/theme/app_theme.dart';
import 'package:graduation_project/data/models/order_model.dart';
import 'package:graduation_project/logic/providers/locale_provider.dart';
import 'package:graduation_project/core/comeponents/app_background.dart';
import 'package:graduation_project/core/comeponents/app_button.dart';
import 'package:graduation_project/views/chat/chat_page.dart';

class TechnicianDetailsPage extends StatelessWidget {
  final OrderModel order;

  const TechnicianDetailsPage({super.key, required this.order});

  static void show(BuildContext context, OrderModel order) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TechnicianDetailsPage(order: order),
      ),
    );
  }

  void _callTechnician(BuildContext context, String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تعذر الاتصال برقم الهاتف')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = context.watch<LocaleProvider>().isArabic;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final techName = order.technicianName ?? (isArabic ? 'فني معتمد' : 'Certified Tech');
    final techPhone = order.technicianPhone ?? '01000000000';
    final techRating = order.technicianRating ?? 4.8;
    final eta = order.estimatedArrival ?? 15;

    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: isDark ? AppTheme.carmaDeepDark : AppTheme.primaryColor,
          foregroundColor: Colors.white,
          title: Text(
            isArabic ? 'الفني المعين' : 'Assigned Technician',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 16),

              // ── Header Profile Card ──────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.carmaDeepDark : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark ? AppTheme.carmaOutline : Colors.grey.shade200,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Technician Avatar
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppTheme.carmaGold, width: 2),
                          ),
                          child: CircleAvatar(
                            radius: 54,
                            backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade100,
                            child: Icon(
                              Icons.engineering_rounded,
                              size: 54,
                              color: isDark ? Colors.white70 : Colors.black45,
                            ),
                          ),
                        ),
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: AppTheme.successColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark ? AppTheme.carmaDeepDark : Colors.white,
                              width: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      techName,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black87,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isArabic ? 'فني صيانة سيارات معتمد' : 'Certified Car Maintenance Tech',
                      style: TextStyle(
                        color: isDark ? Colors.white54 : Colors.black54,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Rating & Completed Jobs Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          techRating.toStringAsFixed(1),
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          width: 1,
                          height: 14,
                          color: isDark ? Colors.white24 : Colors.black26,
                        ),
                        const SizedBox(width: 16),
                        const Icon(Icons.task_alt, color: AppTheme.successColor, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          isArabic ? '48 عملية صيانة ناجحة' : '48 completed jobs',
                          style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.black87,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── ETA & Distance & Live Status ──────────────────────
              Row(
                children: [
                  Expanded(
                    child: _buildInfoCard(
                      context,
                      isDark,
                      Icons.timer_outlined,
                      isArabic ? 'الوقت المقدر' : 'ETA',
                      '$eta ${isArabic ? 'دقيقة' : 'mins'}',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildInfoCard(
                      context,
                      isDark,
                      Icons.map_outlined,
                      isArabic ? 'المسافة' : 'Distance',
                      '2.5 ${isArabic ? 'كم' : 'km'}',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ── Vehicle Details Card ─────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.carmaDeepDark : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark ? AppTheme.carmaOutline : Colors.grey.shade200,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.carmaGold.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.local_shipping_outlined, color: AppTheme.carmaGold, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isArabic ? 'مركبة الخدمة' : 'Service Vehicle',
                            style: TextStyle(
                              color: isDark ? Colors.white70 : Colors.black54,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isArabic ? 'تويوتا دينا - ونش سحب ذهبي' : 'Toyota Dyna - Gold Tow Truck',
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black87,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isArabic ? 'لوحة رقم: [ ٢ ٩ ٣ ٧ ج م د ]' : 'Plate No: [ 2937 GMD ]',
                            style: const TextStyle(
                              color: AppTheme.carmaGold,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // ── Contact Buttons Row ──────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: AppTheme.carmaGold, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () => _callTechnician(context, techPhone),
                      icon: const Icon(Icons.phone, color: AppTheme.carmaGold),
                      label: Text(
                        isArabic ? 'اتصال هاتفى' : 'Call Tech',
                        style: const TextStyle(
                          color: AppTheme.carmaGold,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AppButton(
                      text: isArabic ? 'محادثة (شات)' : 'Chat',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatPage(
                              serviceRequestId: order.id,
                              technicianName: techName,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    bool isDark,
    IconData icon,
    String label,
    String value,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.carmaDeepDark : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppTheme.carmaOutline : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppTheme.carmaGold, size: 24),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              color: isDark ? Colors.white54 : Colors.black54,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
