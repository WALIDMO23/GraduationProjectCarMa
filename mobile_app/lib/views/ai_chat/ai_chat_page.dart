import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:graduation_project/logic/providers/ai_provider.dart';
import 'package:graduation_project/logic/providers/orders_provider.dart';
import 'package:graduation_project/core/comeponents/app_background.dart';
import 'package:graduation_project/views/services/towing_services.dart';
import 'package:graduation_project/views/services/carWash_services.dart';
import 'package:graduation_project/views/services/emergency_services.dart';
import 'package:graduation_project/views/services/battery_services.dart';
import 'package:graduation_project/views/services/tire_services.dart';
import 'package:graduation_project/views/services/oil_services.dart';
import 'package:graduation_project/views/services/location_picker.dart';
import 'package:graduation_project/views/services/payment_methods.dart';
import 'package:graduation_project/views/profile/profile.dart';
import 'package:graduation_project/views/profile/order_history.dart';
import 'package:graduation_project/views/chat/chat_page.dart';
import 'package:graduation_project/views/home/order_details_page.dart';
import 'package:graduation_project/views/home/technician_details_page.dart';
import 'package:graduation_project/views/services/request_service_page.dart';

class AiChatPage extends StatefulWidget {
  const AiChatPage({super.key});

  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage> with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  Color get _bg => Theme.of(context).scaffoldBackgroundColor;
  Color get _cardBg => Theme.of(context).colorScheme.surface;
  Color get _inputBg => Theme.of(context).brightness == Brightness.dark ? const Color(0xFF232323) : Colors.grey.shade200;
  Color get _primary => Theme.of(context).colorScheme.primary;
  Color get _light => Theme.of(context).brightness == Brightness.dark ? const Color(0xFFFDE68A) : Theme.of(context).colorScheme.primary.withValues(alpha: 0.7);
  Color get _glow => Theme.of(context).colorScheme.primary.withValues(alpha: 0.3);

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();
    _scrollToBottom();
    
    final aiProvider = context.read<AiProvider>();
    await aiProvider.sendMessage(text);
    
    if (mounted) {
      _scrollToBottom();
      if (aiProvider.messages.isNotEmpty) {
        final lastMsg = aiProvider.messages.last;
        if (lastMsg['sender'] == 'bot') {
          _handleBotAction(lastMsg['text'] ?? '');
        }
      }
    }
  }

  void _handleBotAction(String rawText) {
    try {
      final parsed = jsonDecode(rawText);
      final action = parsed['action'] as String? ?? 'none';
      final params = parsed['parameters'] as Map<String, dynamic>? ?? {};

      if (action == 'none') return;

      switch (action) {
        case 'open_location_picker':
          Navigator.push(context, MaterialPageRoute(builder: (_) => const LocationPickerPage()));
          break;
        case 'open_payment':
          Navigator.push(context, MaterialPageRoute(builder: (_) => const PaymentMethodsPage()));
          break;
        case 'open_profile':
          Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage()));
          break;
        case 'open_order_history':
          Navigator.push(context, MaterialPageRoute(builder: (_) => const OrderHistoryPage()));
          break;
        case 'open_chat':
          _openActiveOrderChat();
          break;
        case 'open_active_order':
          _openActiveOrderDetails();
          break;
        case 'open_technician':
          _openActiveOrderTechnician();
          break;
        case 'open_towing_service':
          Navigator.push(context, MaterialPageRoute(builder: (_) => const TowingServices()));
          break;
        case 'open_battery_service':
          Navigator.push(context, MaterialPageRoute(builder: (_) => const BatteryServices()));
          break;
        case 'open_tire_service':
          Navigator.push(context, MaterialPageRoute(builder: (_) => const TireServices()));
          break;
        case 'open_oil_service':
          Navigator.push(context, MaterialPageRoute(builder: (_) => const OilServices()));
          break;
        case 'open_carwash_service':
          Navigator.push(context, MaterialPageRoute(builder: (_) => const CarWashServices()));
          break;
        case 'open_emergency_service':
          Navigator.push(context, MaterialPageRoute(builder: (_) => const EmergencyServices()));
          break;
        case 'open_fuel_delivery':
          Navigator.push(context, MaterialPageRoute(builder: (_) => const EmergencyServices(initialServiceIndex: 1)));
          break;
        case 'create_service_request':
          final serviceId = params['serviceId'] as int? ?? 1;
          final serviceName = params['serviceName'] as String? ?? 'خدمة صيانة';
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RequestServicePage(
                serviceName: serviceName,
                serviceId: serviceId,
                serviceIcon: Icons.build_rounded,
                serviceColor: Theme.of(context).colorScheme.primary,
              ),
            ),
          );
          break;
      }
    } catch (e) {
      debugPrint('[AiChatPage] Failed to handle bot action: $e');
    }
  }

  void _openActiveOrderChat() {
    final ordersProvider = context.read<OrdersProvider>();
    final activeOrders = ordersProvider.orders.where((o) => o.isActive).toList();
    if (activeOrders.isNotEmpty) {
      final order = activeOrders.first;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChatPage(
            serviceRequestId: order.id,
            technicianName: order.technicianName ?? 'الفني',
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لا يوجد طلب نشط حالياً لبدء المحادثة مع الفني.')),
      );
    }
  }

  void _openActiveOrderDetails() {
    final ordersProvider = context.read<OrdersProvider>();
    final activeOrders = ordersProvider.orders.where((o) => o.isActive).toList();
    if (activeOrders.isNotEmpty) {
      final order = activeOrders.first;
      OrderDetailsPage.show(
        context,
        order,
        serviceName: ordersProvider.serviceNameForOrder(order.id) ?? 'طلب صيانة',
        notes: ordersProvider.notesForOrder(order.id),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لا يوجد طلب نشط حالياً لعرض تفاصيله.')),
      );
    }
  }

  void _openActiveOrderTechnician() {
    final ordersProvider = context.read<OrdersProvider>();
    final activeOrders = ordersProvider.orders.where((o) => o.isActive).toList();
    if (activeOrders.isNotEmpty) {
      final order = activeOrders.first;
      if (order.hasTechnician) {
        TechnicianDetailsPage.show(context, order);
      } else {
        OrderDetailsPage.show(
          context,
          order,
          serviceName: ordersProvider.serviceNameForOrder(order.id) ?? 'طلب صيانة',
          notes: ordersProvider.notesForOrder(order.id),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لا يوجد طلب نشط حالياً لعرض معلومات الفني.')),
      );
    }
  }

  // ── Parse service buttons from bot response ──────────────────────────────
  bool _hasWinch(String text) {
    try {
      final parsed = jsonDecode(text);
      final action = parsed['action'] ?? '';
      return action == 'open_towing_service' || action == 'open_emergency_service' || text.contains('[WINCH_BUTTON]');
    } catch (_) {
      return text.contains('[WINCH_BUTTON]');
    }
  }

  bool _hasWash(String text) {
    try {
      final parsed = jsonDecode(text);
      final action = parsed['action'] ?? '';
      return action == 'open_carwash_service' || text.contains('[WASH_BUTTON]');
    } catch (_) {
      return text.contains('[WASH_BUTTON]');
    }
  }

  bool _hasMaintenance(String text) {
    try {
      final parsed = jsonDecode(text);
      final action = parsed['action'] ?? '';
      return action == 'open_battery_service' ||
          action == 'open_tire_service' ||
          action == 'open_oil_service' ||
          action == 'open_fuel_delivery' ||
          action == 'create_service_request' ||
          text.contains('[MAINTENANCE_BUTTON]');
    } catch (_) {
      return text.contains('[MAINTENANCE_BUTTON]');
    }
  }

  String _cleanText(String text) {
    try {
      final parsed = jsonDecode(text);
      String msg = parsed['message'] ?? text;
      return msg
          .replaceAll('[WINCH_BUTTON]', '')
          .replaceAll('[WASH_BUTTON]', '')
          .replaceAll('[MAINTENANCE_BUTTON]', '')
          .trim();
    } catch (_) {
      return text
          .replaceAll('[WINCH_BUTTON]', '')
          .replaceAll('[WASH_BUTTON]', '')
          .replaceAll('[MAINTENANCE_BUTTON]', '')
          .trim();
    }
  }

  // ── Navigate to service page ─────────────────────────────────────────────
  void _goToService(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white70, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [_primary, _light],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(color: _glow.withValues(alpha: 0.5), blurRadius: 8)
                ],
              ),
              child: const Icon(Icons.auto_awesome, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('CarMa AI', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                Text('مساعدك الذكي', style: TextStyle(color: Colors.white54, fontSize: 11)),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<AiProvider>(
              builder: (context, ai, _) {
                // Auto-scroll when new messages arrive
                if (ai.messages.isNotEmpty) _scrollToBottom();

                if (ai.messages.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount: ai.messages.length + (ai.isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == ai.messages.length) {
                      return _buildTypingIndicator();
                    }
                    final msg = ai.messages[index];
                    final isUser = msg['sender'] == 'user';
                    final text = msg['text'] ?? '';
                    return isUser
                        ? _buildUserBubble(text)
                        : _buildBotBubble(text);
                  },
                );
              },
            ),
          ),
          _buildInputBar(),
        ],
      ),
      ),
    );
  }

  // ── Empty State ───────────────────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: _pulseAnimation,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    _light.withValues(alpha: 0.8),
                    _primary.withValues(alpha: 0.6),
                    _glow.withValues(alpha: 0.3),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.4, 0.7, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: _primary.withValues(alpha: 0.4),
                    blurRadius: 40,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: const Icon(Icons.auto_awesome, color: Colors.white, size: 48),
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'اسأل أي حاجة',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'هساعدك في أي مشكلة مع عربيتك',
            style: TextStyle(color: Colors.white54, fontSize: 14),
          ),
          const SizedBox(height: 40),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [
              _buildSuggestionChip('عندي إطار واقف'),
              _buildSuggestionChip('عاوز أغسل عربيتي'),
              _buildSuggestionChip('فيه صوت غريب في الموتور'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionChip(String text) {
    return GestureDetector(
      onTap: () {
        _controller.text = text;
        _send();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _primary.withValues(alpha: 0.4)),
        ),
        child: Text(text, style: TextStyle(color: _light, fontSize: 13)),
      ),
    );
  }

  // ── User Bubble ───────────────────────────────────────────────────────────
  Widget _buildUserBubble(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.72,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_primary, _glow],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(4),
                ),
                boxShadow: [
                  BoxShadow(color: _primary.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 3)),
                ],
              ),
              child: Text(
                text,
                textDirection: TextDirection.rtl,
                style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            radius: 14,
            backgroundColor: _primary,
            child: const Icon(Icons.person, color: Colors.white, size: 16),
          ),
        ],
      ),
    );
  }

  // ── Bot Bubble ────────────────────────────────────────────────────────────
  Widget _buildBotBubble(String rawText) {
    final cleanText = _cleanText(rawText);
    final showWinch = _hasWinch(rawText);
    final showWash = _hasWash(rawText);
    final showMaintenance = _hasMaintenance(rawText);
    final hasButtons = showWinch || showWash || showMaintenance;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [_primary, _light],
              ),
              boxShadow: [BoxShadow(color: _glow.withValues(alpha: 0.4), blurRadius: 6)],
            ),
            child: const Icon(Icons.auto_awesome, color: Colors.white, size: 14),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.72,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: _cardBg,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(18),
                      bottomLeft: Radius.circular(18),
                      bottomRight: Radius.circular(18),
                    ),
                    border: Border.all(color: _primary.withValues(alpha: 0.2)),
                  ),
                  child: Text(
                    cleanText,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
                  ),
                ),
                if (hasButtons) ...[
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (showWinch)
                        _buildServiceButton(
                          icon: Icons.local_shipping_rounded,
                          label: '🚛 اطلب ونش',
                          color: _primary,
                          onTap: () => _goToService(const TowingServices()),
                        ),
                      if (showWash)
                        _buildServiceButton(
                          icon: Icons.water_drop_rounded,
                          label: '💧 اطلب غسيل',
                          color: _primary,
                          onTap: () => _goToService(const CarWashServices()),
                        ),
                      if (showMaintenance)
                        _buildServiceButton(
                          icon: Icons.build_rounded,
                          label: '🔧 اطلب فني',
                          color: _primary,
                          onTap: () => _goToService(const EmergencyServices()),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.5)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  // ── Typing Indicator ──────────────────────────────────────────────────────
  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: [_primary, _light]),
            ),
            child: const Icon(Icons.auto_awesome, color: Colors.white, size: 14),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: _cardBg,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: _primary.withValues(alpha: 0.2)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) => _buildDot(i)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.4, end: 1.0),
      duration: Duration(milliseconds: 600 + index * 200),
      curve: Curves.easeInOut,
      builder: (_, value, __) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 3),
        width: 7,
        height: 7,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _light.withValues(alpha: value),
        ),
      ),
    );
  }

  // ── Input Bar ─────────────────────────────────────────────────────────────
  Widget _buildInputBar() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        decoration: BoxDecoration(
          color: _bg,
          border: Border(top: BorderSide(color: _primary.withValues(alpha: 0.15))),
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: _inputBg,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: _primary.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        textDirection: TextDirection.rtl,
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                        cursorColor: _light,
                        decoration: const InputDecoration(
                          hintText: 'اسألني عن عربيتك...',
                          hintStyle: TextStyle(color: Colors.white38, fontSize: 14),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          filled: true,
                          fillColor: Colors.transparent,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        onSubmitted: (_) => _send(),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Consumer<AiProvider>(
              builder: (_, ai, __) => GestureDetector(
                onTap: ai.isLoading ? null : _send,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: ai.isLoading
                        ? const LinearGradient(colors: [Colors.grey, Colors.grey])
                        : LinearGradient(
                            colors: [_primary, _light],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                    boxShadow: ai.isLoading
                        ? []
                        : [BoxShadow(color: _primary.withValues(alpha: 0.5), blurRadius: 12)],
                  ),
                  child: ai.isLoading
                      ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Icon(Icons.send_rounded, color: Colors.white, size: 22),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
