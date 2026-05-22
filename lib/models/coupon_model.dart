int _parseInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString()) ?? 0;
}

String _parseString(dynamic value) {
  if (value == null) return '';
  return value.toString();
}

class CouponModel {
  bool success;
  dynamic error;
  List<CouponBody> body;

  CouponModel({
    required this.success,
    required this.error,
    required this.body,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      success: json['success'] ?? false,
      error: json['error'],
      body: (json['body'] as List<dynamic>?)
              ?.map((bodyItem) => CouponBody.fromJson(bodyItem))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'error': error,
      'body': body.map((bodyItem) => bodyItem.toJson()).toList(),
    };
  }
}

class CouponBody {
  dynamic couponId;
  String couponCode;
  String couponTitle;
  String couponValue;
  String couponType;
  String couponDiscount;
  String couponStartDate;
  String couponEndDate;
  String couponQuantity;
  String couponMaximumSpend;
  String couponMinimumSpend;
  String couponPerCustomer;
  dynamic couponStatus;
  String createdAt;
  String updatedAt;
  String couponImage;
  dynamic deletedAt;

  CouponBody({
    required this.couponId,
    required this.couponCode,
    required this.couponTitle,
    required this.couponValue,
    required this.couponType,
    required this.couponDiscount,
    required this.couponStartDate,
    required this.couponEndDate,
    required this.couponQuantity,
    required this.couponMaximumSpend,
    required this.couponMinimumSpend,
    required this.couponPerCustomer,
    required this.couponStatus,
    required this.createdAt,
    required this.updatedAt,
    required this.couponImage,
    required this.deletedAt,
  });

  factory CouponBody.fromJson(Map<String, dynamic> json) {
    return CouponBody(
      couponId: json['coupon_id'],
      couponCode: _parseString(json['coupon_code']),
      couponTitle: _parseString(json['coupon_title']),
      couponValue: _parseString(json['coupon_value']),
      couponType: _parseString(json['coupon_type']),
      couponDiscount: _parseString(json['coupon_discount']),
      couponStartDate: _parseString(json['coupon_startdate']),
      couponEndDate: _parseString(json['coupon_enddate']),
      couponQuantity: _parseString(json['coupon_quantity']),
      couponMaximumSpend: _parseString(json['coupon_maximum_spend']),
      couponMinimumSpend: _parseString(json['coupon_minimum_spend']),
      couponPerCustomer: _parseString(json['coupon_percoustomer']),
      couponStatus: json['coupon_status'],
      createdAt: _parseString(json['created_at']),
      updatedAt: _parseString(json['updated_at']),
      couponImage: _parseString(json['coupon_image']),
      deletedAt: json['deleted_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'coupon_id': couponId,
      'coupon_code': couponCode,
      'coupon_title': couponTitle,
      'coupon_value': couponValue,
      'coupon_type': couponType,
      'coupon_discount': couponDiscount,
      'coupon_startdate': couponStartDate,
      'coupon_enddate': couponEndDate,
      'coupon_quantity': couponQuantity,
      'coupon_maximum_spend': couponMaximumSpend,
      'coupon_minimum_spend': couponMinimumSpend,
      'coupon_percoustomer': couponPerCustomer,
      'coupon_status': couponStatus,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'coupon_image': couponImage,
      'deleted_at': deletedAt,
    };
  }
}
