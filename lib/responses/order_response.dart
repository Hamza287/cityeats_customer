import 'package:city_customer_app/app/app.logger.dart';
import 'package:city_customer_app/responses/base_responses/base_response.dart';
import 'package:city_customer_app/responses/cart_response.dart';

int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString());
}

double? _parseDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}

String? _parseString(dynamic value) {
  if (value == null) return null;
  return value.toString();
}

class OrderResponse extends BaseResponse {
  List<OrderModel>? body;

  OrderResponse(success, error, {this.body}) : super(success, error: error);

  OrderResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    success = json['success'];
    error = json['error'];
    if (json['body'] != null) {
      body = <OrderModel>[];
      json['body'].forEach((v) {
        body?.add(OrderModel.fromJson(v));
      });
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['error'] = error;
    if (body != null) {
      data['body'] = body!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderModel {
  int? id;
  int? userId;
  int? orderId;
  int? riderId;
  String? orderAmount;
  String? couponDiscountAmount;
  dynamic couponDiscountTitle;
  String? paymentStatus;
  String? orderStatus;
  String? totalTaxAmount;
  double? adminCommission;
  String? paymentMethod;
  String? transactionReference;
  dynamic deliveryAddressId;
  dynamic deliveryManId;
  dynamic couponCode;
  String? orderNote;
  String? orderType;
  int? checked;
  int? restaurantId;
  String? createdAt;
  String? updatedAt;
  String? deliveryCharge;
  dynamic scheduleAt;
  dynamic callback;
  dynamic otp;
  dynamic pending;
  dynamic accepted;
  dynamic confirmed;
  dynamic processing;
  dynamic handover;
  dynamic pickedUp;
  dynamic delivered;
  dynamic canceled;
  dynamic refundRequested;
  dynamic refunded;
  dynamic deliveryAddress;
  int? scheduled;
  String? storeDiscountAmount;
  String? originalDeliveryCharge;
  dynamic failed;
  String? adjusment;
  int? edited;
  String? riderPickingStatus;
  List<OrderDetail>? orderDetail;
  Restaurant? restaurant;
  bool? canCancel;
  Review? restReview;
  Review? riderReview;
  int? isScheduled;
  Slots? scheduledSlots;

  OrderModel(
      {this.id,
      this.userId,
      this.orderId,
      this.riderId,
      this.canCancel,
      this.orderAmount,
      this.couponDiscountAmount,
      this.couponDiscountTitle,
      this.paymentStatus,
      this.restReview,
      this.riderReview,
      this.orderStatus,
      this.totalTaxAmount,
      this.adminCommission,
      this.paymentMethod,
      this.transactionReference,
      this.deliveryAddressId,
      this.deliveryManId,
      this.couponCode,
      this.restaurant,
      this.orderNote,
      this.orderType,
      this.checked,
      this.restaurantId,
      this.createdAt,
      this.updatedAt,
      this.deliveryCharge,
      this.scheduleAt,
      this.callback,
      this.otp,
      this.pending,
      this.accepted,
      this.confirmed,
      this.processing,
      this.handover,
      this.pickedUp,
      this.delivered,
      this.canceled,
      this.refundRequested,
      this.refunded,
      this.deliveryAddress,
      this.scheduled,
      this.storeDiscountAmount,
      this.originalDeliveryCharge,
      this.failed,
      this.adjusment,
      this.edited,
      this.riderPickingStatus,
      this.isScheduled = 0,
      this.scheduledSlots,
      this.orderDetail});

  OrderModel.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']);
    userId = _parseInt(json['user_id']);
    orderId = _parseInt(json['order_id']);
    riderId = _parseInt(json['delivery_man_id']);
    orderAmount = _parseString(json['order_amount']);
    couponDiscountAmount = _parseString(json['coupon_discount_amount']);
    couponDiscountTitle = json['coupon_discount_title'];
    paymentStatus = _parseString(json['payment_status']);
    orderStatus = _parseString(json['order_status']);
    totalTaxAmount = _parseString(json['total_tax_amount']);
    adminCommission = _parseDouble(json['admin_commission']) ?? 0;
    paymentMethod = _parseString(json['payment_method']);
    transactionReference = _parseString(json['transaction_reference']);
    deliveryAddressId = json['delivery_address_id'];
    deliveryManId = json['delivery_man_id'];
    couponCode = json['coupon_code'];
    orderNote = _parseString(json['order_note']);
    orderType = _parseString(json['order_type']);
    checked = _parseInt(json['checked']);
    // print(json['review']);
    if (json['restaurant_review'] != null) {
      restReview = Review.fromJson(json['restaurant_review']);
    }
    if (json['rider_review'] != null) {
      riderReview = Review.fromJson(json['rider_review']);
    }
    restaurantId = _parseInt(json['restaurant_id']);
    createdAt = _parseString(json['created_at']);
    updatedAt = _parseString(json['updated_at']);
    deliveryCharge = _parseString(json['delivery_charge']);
    scheduleAt = json['schedule_at'];
    callback = json['callback'];
    otp = json['otp'];
    pending = json['pending'];
    accepted = json['accepted'];
    confirmed = json['confirmed'];
    processing = json['processing'];
    handover = json['handover'];
    pickedUp = json['picked_up'];
    delivered = json['delivered'];
    canceled = json['canceled'];
    refundRequested = json['refund_requested'];
    refunded = json['refunded'];
    deliveryAddress = json['delivery_address'];
    scheduled = _parseInt(json['scheduled']);
    storeDiscountAmount = _parseString(json['store_discount_amount']);
    originalDeliveryCharge = _parseString(json['original_delivery_charge']);
    failed = json['failed'];
    adjusment = _parseString(json['adjusment']);
    edited = _parseInt(json['edited']);
    riderPickingStatus = _parseString(json['rider_picking_status']);
    if (json['order_detail'] != null) {
      orderDetail = <OrderDetail>[];
      json['order_detail'].forEach((v) {
        orderDetail!.add(OrderDetail.fromJson(v));
      });
    }
    if (json['restaurant'] != null) {
      getLogger("").wtf(json['restaurant']);
      restaurant = Restaurant.fromJson(json['restaurant']);
    }
    isScheduled = _parseInt(json['is_scheduled']) ?? 0;

    if (json['schedule_slot'] != null) {
      getLogger("").wtf(json['schedule_slot']);
      scheduledSlots = Slots.fromJson(json['schedule_slot']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['order_id'] = orderId;
    data['delivery_man_id'] = riderId;
    data['order_amount'] = orderAmount;
    data['coupon_discount_amount'] = couponDiscountAmount;
    data['coupon_discount_title'] = couponDiscountTitle;
    data['payment_status'] = paymentStatus;
    data['order_status'] = orderStatus;
    data['restaurant_review'] = restReview;
    data['rider_review'] = riderReview;
    data['total_tax_amount'] = totalTaxAmount;
    data['admin_commission'] = double.parse(adminCommission.toString());
    data['payment_method'] = paymentMethod;
    data['transaction_reference'] = transactionReference;
    data['delivery_address_id'] = deliveryAddressId;
    data['delivery_man_id'] = deliveryManId;
    data['coupon_code'] = couponCode;
    data['order_note'] = orderNote;
    data['order_type'] = orderType;
    data['checked'] = checked;
    data['restaurant_id'] = restaurantId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['delivery_charge'] = deliveryCharge;
    data['schedule_at'] = scheduleAt;
    data['callback'] = callback;
    data['otp'] = otp;
    data['pending'] = pending;
    data['accepted'] = accepted;
    data['confirmed'] = confirmed;
    data['processing'] = processing;
    data['handover'] = handover;
    data['picked_up'] = pickedUp;
    data['delivered'] = delivered;
    data['canceled'] = canceled;
    data['refund_requested'] = refundRequested;
    data['refunded'] = refunded;
    data['delivery_address'] = deliveryAddress;
    data['scheduled'] = scheduled;
    data['store_discount_amount'] = storeDiscountAmount;
    data['original_delivery_charge'] = originalDeliveryCharge;
    data['failed'] = failed;
    data['adjusment'] = adjusment;
    data['edited'] = edited;

    data['rider_picking_status'] = riderPickingStatus;
    if (restaurant != null) {
      data['restaurant'] = restaurant?.toJson();
    }
    if (orderDetail != null) {
      data['order_detail'] = orderDetail!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderDetail {
  int? id;
  int? foodId;
  int? orderId;
  String? price;
  dynamic foodDetails;
  dynamic variation;
  dynamic addOns;
  dynamic discountOnItem;
  String? discountType;
  int? quantity;
  String? taxAmount;
  dynamic variant;
  String? createdAt;
  String? updatedAt;
  dynamic itemCampaignId;
  String? totalAddOnPrice;
  List<OrderSubProduct> orderSubProducts = [];
  bool showMore = false;

  OrderDetail(
      {this.id,
      this.foodId,
      this.orderId,
      this.price,
      this.foodDetails,
      this.variation,
      this.addOns,
      this.discountOnItem,
      this.discountType,
      this.quantity,
      this.taxAmount,
      this.variant,
      this.createdAt,
      this.updatedAt,
      this.itemCampaignId,
      this.totalAddOnPrice,
      required this.orderSubProducts});

  OrderDetail.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']);
    foodId = _parseInt(json['food_id']);
    orderId = _parseInt(json['order_id']);
    price = _parseString(json['price']);
    foodDetails = json['food_details'];
    variation = json['variation'];
    addOns = json['add_ons'];
    discountOnItem = json['discount_on_item'];
    discountType = _parseString(json['discount_type']);
    quantity = _parseInt(json['quantity']);
    taxAmount = _parseString(json['tax_amount']);
    variant = json['variant'];
    createdAt = _parseString(json['created_at']);
    updatedAt = _parseString(json['updated_at']);
    itemCampaignId = json['item_campaign_id'];
    totalAddOnPrice = _parseString(json['total_add_on_price']);
    if (json['order_sub_products'] != null) {
      orderSubProducts = <OrderSubProduct>[];
      json['order_sub_products'].forEach((v) {
        orderSubProducts.add(OrderSubProduct.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['food_id'] = foodId;
    data['order_id'] = orderId;
    data['price'] = price;
    data['food_details'] = foodDetails;
    data['variation'] = variation;
    data['add_ons'] = addOns;
    data['discount_on_item'] = discountOnItem;
    data['discount_type'] = discountType;
    data['quantity'] = quantity;
    data['tax_amount'] = taxAmount;
    data['variant'] = variant;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['item_campaign_id'] = itemCampaignId;
    data['total_add_on_price'] = totalAddOnPrice;
    data['order_sub_products'] =
        orderSubProducts.map((v) => v.toJson()).toList();
    return data;
  }
}

class OrderSubProduct {
  int id;
  int orderDetailId;
  String sideItemName;
  String sideItemPrice;
  String createdAt;
  String updatedAt;

  OrderSubProduct({
    required this.id,
    required this.orderDetailId,
    required this.sideItemName,
    required this.sideItemPrice,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory method to create an instance of the model from a JSON map
  factory OrderSubProduct.fromJson(Map<String, dynamic> json) {
    return OrderSubProduct(
      id: _parseInt(json['id']) ?? 0,
      orderDetailId: _parseInt(json['order_detail_id']) ?? 0,
      sideItemName: _parseString(json['side_item_name']) ?? '',
      sideItemPrice: _parseString(json['side_item_price']) ?? '',
      createdAt: _parseString(json['created_at']) ?? '',
      updatedAt: _parseString(json['updated_at']) ?? '',
    );
  }

  // Method to convert the model into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_detail_id': orderDetailId,
      'side_item_name': sideItemName,
      'side_item_price': sideItemPrice,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class Review {
  int? id;
  int? userId;
  String? reviewRemarks;
  int? reviewStar;
  int? type;
  int? typeId;
  int? reviewStatus;
  String? createdAt;
  String? updatedAt;

  Review(
      {this.id,
      this.userId,
      this.reviewRemarks,
      this.reviewStar,
      this.type,
      this.typeId,
      this.reviewStatus,
      this.createdAt,
      this.updatedAt});

  Review.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']);
    userId = _parseInt(json['user_id']);
    reviewRemarks = _parseString(json['review_remarks']);
    reviewStar = _parseInt(json['review_star']);
    type = _parseInt(json['type']);
    typeId = _parseInt(json['type_id']);
    reviewStatus = _parseInt(json['review_status']);
    createdAt = _parseString(json['created_at']);
    updatedAt = _parseString(json['updated_at']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['review_remarks'] = reviewRemarks;
    data['review_star'] = reviewStar;
    data['type'] = type;
    data['type_id'] = typeId;
    data['review_status'] = reviewStatus;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
