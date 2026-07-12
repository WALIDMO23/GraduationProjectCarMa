import 'package:flutter/material.dart';

/// Matches the backend's NewNotificationDto
class AppNotification {
  final int id;
  final String type;
  final String severity;
  final String title;
  final String message;
  bool isRead;
  final String? actionUrl;
  final String? targetType;
  final int? targetId;
  final DateTime createdAt;
  final DateTime? readAt;

  AppNotification({
    required this.id,
    required this.type,
    required this.severity,
    required this.title,
    required this.message,
    required this.isRead,
    this.actionUrl,
    this.targetType,
    this.targetId,
    required this.createdAt,
    this.readAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    // Parse UTC timestamp correctly (backend sends UTC)
    DateTime parseUtc(String? raw) {
      if (raw == null) return DateTime.now();
      final s = raw.endsWith('Z') || raw.contains('+') ? raw : '${raw}Z';
      return DateTime.parse(s).toLocal();
    }

    return AppNotification(
      id: json['id'] as int? ?? 0,
      type: json['type'] as String? ?? '',
      severity: json['severity'] as String? ?? 'Info',
      title: json['title'] as String? ?? '',
      message: json['message'] as String? ?? '',
      isRead: json['isRead'] as bool? ?? false,
      actionUrl: json['actionUrl'] as String?,
      targetType: json['targetType'] as String?,
      targetId: json['targetId'] as int?,
      createdAt: parseUtc(json['createdAt'] as String?),
      readAt: json['readAt'] != null ? parseUtc(json['readAt'] as String?) : null,
    );
  }

  // ظ¤ظ¤ Original SVG-based icon mapping (matches the original UI) ظ¤ظ¤

  /// SVG asset filename ظ¤ matches original design exactly
  String get iconAsset {
    final t = type.toLowerCase();
    final ttl = title.toLowerCase();
    if (t.contains('pending') || t.contains('review') || t.contains('waiting') ||
        ttl.contains('┘à╪▒╪د╪ش╪╣╪ر') || ttl.contains('┘é┘è╪»')) {
      return 'time.svg';
    }
    if (t.contains('approved') || t.contains('accepted') || t.contains('confirm') ||
        ttl.contains('┘à┘ê╪د┘┘é╪ر') || ttl.contains('┘é╪ذ┘ê┘')) {
      return 'accept.svg';
    }
    if (t.contains('assigned') || t.contains('technician') ||
        ttl.contains('╪ز╪╣┘è┘è┘')) {
      return 'done.svg';
    }
    if (t.contains('ontheway') || t.contains('way') || t.contains('dispatched') ||
        ttl.contains('╪╖╪▒┘è┘é')) {
      return 'trucks.svg';
    }
    if (t.contains('completed') || t.contains('done') || t.contains('finished') ||
        ttl.contains('╪د┘â╪ز┘à┘') || ttl.contains('╪د┘╪ز┘ç┘ë')) {
      return 'star.svg';
    }
    if (t.contains('rejected') || t.contains('cancel') || t.contains('failed') ||
        ttl.contains('╪▒┘╪╢') || ttl.contains('┘à┘╪║')) {
      return 'fales.svg';
    }
    return 'time.svg';
  }

  /// Background color for icon circle ظ¤ matches original design exactly
  Color get iconBackgroundColor {
    final t = type.toLowerCase();
    final ttl = title.toLowerCase();
    if (t.contains('pending') || t.contains('review') || t.contains('waiting') ||
        ttl.contains('┘à╪▒╪د╪ش╪╣╪ر') || ttl.contains('┘é┘è╪»')) {
      return const Color(0xffFEF3C6);
    }
    if (t.contains('approved') || t.contains('accepted') || t.contains('confirm') ||
        ttl.contains('┘à┘ê╪د┘┘é╪ر') || ttl.contains('┘é╪ذ┘ê┘')) {
      return const Color(0xffDCFCE7);
    }
    if (t.contains('assigned') || t.contains('technician') ||
        ttl.contains('╪ز╪╣┘è┘è┘')) {
      return const Color(0xffDBEAFE);
    }
    if (t.contains('ontheway') || t.contains('way') || t.contains('dispatched') ||
        ttl.contains('╪╖╪▒┘è┘é')) {
      return const Color(0xffF3E8FF);
    }
    if (t.contains('completed') || t.contains('done') || t.contains('finished') ||
        ttl.contains('╪د┘â╪ز┘à┘') || ttl.contains('╪د┘╪ز┘ç┘ë')) {
      return const Color(0xffFEF9C2);
    }
    if (t.contains('rejected') || t.contains('cancel') || t.contains('failed') ||
        ttl.contains('╪▒┘╪╢') || ttl.contains('┘à┘╪║')) {
      return const Color(0xffFFE2E2);
    }
    return const Color(0xffFEF3C6);
  }

  /// Icon data matching Figma design
  IconData get iconData {
    final t = type.toLowerCase();
    // Pending / Under review
    if (t.contains('pending') || t.contains('review') || t.contains('waiting')) {
      return Icons.access_time_rounded;
    }
    // Approved / Accepted
    if (t.contains('approved') || t.contains('accepted') || t.contains('confirm')) {
      return Icons.check_circle_outline_rounded;
    }
    // Technician assigned
    if (t.contains('assigned') || t.contains('technician')) {
      return Icons.person_outline_rounded;
    }
    // On the way
    if (t.contains('ontheway') || t.contains('way') || t.contains('towing') ||
        t.contains('dispatched')) {
      return Icons.local_shipping_outlined;
    }
    // Completed
    if (t.contains('completed') || t.contains('done') || t.contains('finished')) {
      return Icons.star_outline_rounded;
    }
    // Rejected / Cancelled / Failed
    if (t.contains('rejected') || t.contains('cancel') || t.contains('failed')) {
      return Icons.cancel_outlined;
    }
    // Fallback by title keywords
    final ttl = title.toLowerCase();
    if (ttl.contains('┘à╪▒╪د╪ش╪╣╪ر') || ttl.contains('review') || ttl.contains('┘é┘è╪»')) {
      return Icons.access_time_rounded;
    }
    if (ttl.contains('┘à┘ê╪د┘┘é╪ر') || ttl.contains('approved') || ttl.contains('┘é╪ذ┘ê┘')) {
      return Icons.check_circle_outline_rounded;
    }
    if (ttl.contains('┘┘┘è') && (ttl.contains('╪ز╪╣┘è┘è┘') || ttl.contains('assigned'))) {
      return Icons.person_outline_rounded;
    }
    if (ttl.contains('╪╖╪▒┘è┘é') || ttl.contains('way') || ttl.contains('╪╖╪▒┘è┘é┘ç')) {
      return Icons.local_shipping_outlined;
    }
    if (ttl.contains('╪د┘â╪ز┘à┘') || ttl.contains('completed') || ttl.contains('╪د┘╪ز┘ç┘ë')) {
      return Icons.star_outline_rounded;
    }
    if (ttl.contains('╪▒┘╪╢') || ttl.contains('rejected') || ttl.contains('┘à┘╪║')) {
      return Icons.cancel_outlined;
    }
    return Icons.notifications_outlined;
  }

  /// Icon foreground color matching Figma
  Color get iconColor {
    final t = type.toLowerCase();
    if (t.contains('pending') || t.contains('review') || t.contains('waiting')) {
      return const Color(0xffD97706);
    }
    if (t.contains('approved') || t.contains('accepted') || t.contains('confirm')) {
      return const Color(0xff16A34A);
    }
    if (t.contains('assigned') || t.contains('technician')) {
      return const Color(0xff2563EB);
    }
    if (t.contains('ontheway') || t.contains('way') || t.contains('dispatched')) {
      return const Color(0xff7C3AED);
    }
    if (t.contains('completed') || t.contains('done') || t.contains('finished')) {
      return const Color(0xffCA8A04);
    }
    if (t.contains('rejected') || t.contains('cancel') || t.contains('failed')) {
      return const Color(0xffDC2626);
    }
    // title fallback
    final ttl = title.toLowerCase();
    if (ttl.contains('┘à╪▒╪د╪ش╪╣╪ر') || ttl.contains('┘é┘è╪»')) return const Color(0xffD97706);
    if (ttl.contains('┘à┘ê╪د┘┘é╪ر') || ttl.contains('┘é╪ذ┘ê┘')) return const Color(0xff16A34A);
    if (ttl.contains('┘┘┘è') && ttl.contains('╪ز╪╣┘è┘è┘')) return const Color(0xff2563EB);
    if (ttl.contains('╪╖╪▒┘è┘é')) return const Color(0xff7C3AED);
    if (ttl.contains('╪د┘â╪ز┘à┘') || ttl.contains('╪د┘╪ز┘ç┘ë')) return const Color(0xffCA8A04);
    if (ttl.contains('╪▒┘╪╢') || ttl.contains('┘à┘╪║')) return const Color(0xffDC2626);
    return const Color(0xff2563EB);
  }

  /// Icon background color matching Figma
  Color get iconBgColor {
    final t = type.toLowerCase();
    if (t.contains('pending') || t.contains('review') || t.contains('waiting')) {
      return const Color(0xffFEF3C6);
    }
    if (t.contains('approved') || t.contains('accepted') || t.contains('confirm')) {
      return const Color(0xffDCFCE7);
    }
    if (t.contains('assigned') || t.contains('technician')) {
      return const Color(0xffDBEAFE);
    }
    if (t.contains('ontheway') || t.contains('way') || t.contains('dispatched')) {
      return const Color(0xffF3E8FF);
    }
    if (t.contains('completed') || t.contains('done') || t.contains('finished')) {
      return const Color(0xffFEF9C2);
    }
    if (t.contains('rejected') || t.contains('cancel') || t.contains('failed')) {
      return const Color(0xffFFE2E2);
    }
    // title fallback
    final ttl = title.toLowerCase();
    if (ttl.contains('┘à╪▒╪د╪ش╪╣╪ر') || ttl.contains('┘é┘è╪»')) return const Color(0xffFEF3C6);
    if (ttl.contains('┘à┘ê╪د┘┘é╪ر') || ttl.contains('┘é╪ذ┘ê┘')) return const Color(0xffDCFCE7);
    if (ttl.contains('┘┘┘è') && ttl.contains('╪ز╪╣┘è┘è┘')) return const Color(0xffDBEAFE);
    if (ttl.contains('╪╖╪▒┘è┘é')) return const Color(0xffF3E8FF);
    if (ttl.contains('╪د┘â╪ز┘à┘') || ttl.contains('╪د┘╪ز┘ç┘ë')) return const Color(0xffFEF9C2);
    if (ttl.contains('╪▒┘╪╢') || ttl.contains('┘à┘╪║')) return const Color(0xffFFE2E2);
    return const Color(0xffDBEAFE);
  }
}

class PagedNotificationsResponse {
  final List<AppNotification> items;
  final int page;
  final int pageSize;
  final int totalCount;
  final int totalPages;
  final int unreadCount;

  PagedNotificationsResponse({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
    required this.unreadCount,
  });

  factory PagedNotificationsResponse.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'] as List<dynamic>? ?? [];
    return PagedNotificationsResponse(
      items: itemsJson
          .map((e) => AppNotification.fromJson(e as Map<String, dynamic>))
          .toList(),
      page: json['page'] as int? ?? 1,
      pageSize: json['pageSize'] as int? ?? 10,
      totalCount: json['totalCount'] as int? ?? 0,
      totalPages: json['totalPages'] as int? ?? 0,
      unreadCount: json['unreadCount'] as int? ?? 0,
    );
  }
}
