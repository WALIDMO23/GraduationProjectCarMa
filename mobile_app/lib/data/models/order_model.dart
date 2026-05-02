enum OrderStatus {
  newOrder,
  onTheWay,
  underProcess,
  completed,
  canceled
}

OrderStatus _orderStatusFromString(String? status) {
  switch (status?.toLowerCase()) {
    case 'new':          return OrderStatus.newOrder;
    case 'ontheway':     return OrderStatus.onTheWay;
    case 'underprocess': return OrderStatus.underProcess;
    case 'completed':    return OrderStatus.completed;
    case 'canceled':     return OrderStatus.canceled;
    default:             return OrderStatus.newOrder;
  }
}

class OrderModel {
  final int id;
  final int userId;
  final int vehicleId;
  final int serviceId;
  final OrderStatus orderStatus;
  final String address;
  final String phoneNumber;

  // Technician info (filled when admin accepts)
  final int? technicianId;
  final String? technicianName;
  final String? technicianPhone;
  final double? technicianRating;
  final int? estimatedArrival; // minutes

  final DateTime createdAt;
  final DateTime? updatedAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.vehicleId,
    required this.serviceId,
    required this.orderStatus,
    required this.address,
    required this.phoneNumber,
    this.technicianId,
    this.technicianName,
    this.technicianPhone,
    this.technicianRating,
    this.estimatedArrival,
    required this.createdAt,
    this.updatedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id:              json['id'] as int? ?? 0,
      userId:          json['userId'] as int? ?? 0,
      vehicleId:       json['vehicleId'] as int? ?? 0,
      serviceId:       json['serviceId'] as int? ?? 0,
      orderStatus:     _orderStatusFromString(json['orderStatus'] as String?),
      address:         json['address'] as String? ?? '',
      phoneNumber:     json['phoneNumber'] as String? ?? '',
      technicianId:    json['technicianId'] as int?,
      technicianName:  json['technicianName'] as String?,
      technicianPhone: json['technicianPhone'] as String?,
      technicianRating: (json['technicianRating'] as num?)?.toDouble(),
      estimatedArrival: json['estimatedArrival'] as int?,
      createdAt:       json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      updatedAt:       json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  bool get hasTechnician => technicianId != null && technicianName != null;
}

class CreateOrderDto {
  final int userId;
  final int vehicleId;
  final int serviceId;
  final String address;
  final String phoneNumber;
  final String? carImagePath; // local path (stored on device only)
  final String? serviceName;  // stored locally for display
  final String? notes;        // stored locally for display

  CreateOrderDto({
    required this.userId,
    required this.vehicleId,
    required this.serviceId,
    required this.address,
    required this.phoneNumber,
    this.carImagePath,
    this.serviceName,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'vehicleId': vehicleId,
      'serviceId': serviceId,
      'address': address,
      'phoneNumber': phoneNumber,
      // Note: image and serviceName are stored locally, not sent to backend
    };
  }
}
