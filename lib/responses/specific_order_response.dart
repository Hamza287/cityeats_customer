import 'package:city_customer_app/app/app.logger.dart';
import 'package:city_customer_app/responses/base_responses/base_response.dart';
import 'package:city_customer_app/responses/cart_response.dart';
import 'package:city_customer_app/responses/order_response.dart';
import 'package:city_customer_app/responses/restaurent_cat_reesponse.dart';

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

class SpecificOrderResponse extends BaseResponse {
  Body? body;

  SpecificOrderResponse(success, error, {this.body})
      : super(success, error: error);

  SpecificOrderResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    success = json['success'];
    error = json['error'];
    body = json['body'] != null ? Body.fromJson(json['body']) : null;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['error'] = error;
    if (body != null) {
      data['body'] = body!.toJson();
    }
    return data;
  }
}

class Body {
  Orders? orders;

  Body({this.orders});

  Body.fromJson(Map<String, dynamic> json) {
    orders = json['orders'] != null ? Orders.fromJson(json['orders']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (orders != null) {
      data['orders'] = orders!.toJson();
    }
    return data;
  }
}

class Orders {
  int? id;
  int? userId;
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
  Review? restReview;
  Review? riderReview;
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
  String? deliveryAddress;
  int? scheduled;
  String? storeDiscountAmount;
  String? originalDeliveryCharge;
  dynamic failed;
  String? adjusment;
  int? edited;
  String? riderPickingStatus;
  List<OrderDetail>? orderDetail;
  Restaurant? restaurant;
  double? vat;
  double? serviceCharges;
  double? bagFee;
  Address? address;
  double newUserDiscount = 0;
  double newUserDeliveryDiscount = 0;
  String? verificationCode;
  Slots? scheduledSlots;

  Orders(
      {this.id,
      this.userId,
      this.riderId,
      this.address,
      this.restReview,
      this.riderReview,
      this.orderAmount,
      this.couponDiscountAmount,
      this.couponDiscountTitle,
      this.paymentStatus,
      this.orderStatus,
      this.totalTaxAmount,
      this.adminCommission,
      this.paymentMethod,
      this.transactionReference,
      this.deliveryAddressId,
      this.deliveryManId,
      this.couponCode,
      this.orderNote,
      this.restaurant,
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
      this.vat,
      this.bagFee,
      this.serviceCharges,
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
      this.newUserDeliveryDiscount = 0,
      this.newUserDiscount = 0,
      this.verificationCode,
      this.scheduledSlots,
      this.orderDetail});

  Orders.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']);
    userId = _parseInt(json['user_id']);
    riderId = _parseInt(json['delivery_man_id']);
    orderAmount = json['order_amount'];
    couponDiscountAmount = json['coupon_discount_amount'];
    couponDiscountTitle = json['coupon_discount_title'];
    paymentStatus = json['payment_status'];
    orderStatus = json['order_status'];
    totalTaxAmount = json['total_tax_amount'];
    if (json['restaurant_review'] != null) {
      restReview = Review.fromJson(json['restaurant_review']);
    }
    if (json['rider_review'] != null) {
      riderReview = Review.fromJson(json['rider_review']);
    }
    vat = _parseDouble(json['VAT']) ?? 0;
    serviceCharges = _parseDouble(json['service_charges']) ?? 0;
    bagFee = _parseDouble(json['bag_fee']) ?? 0;

    ///

    address =
        json['address'] != null ? Address.fromJson(json['address']) : null;
    adminCommission = _parseDouble(json['admin_commission']) ?? 0;
    paymentMethod = json['payment_method'];
    transactionReference = json['transaction_reference'];
    deliveryAddressId = json['deliveryAddressId'];
    deliveryManId = json['delivery_man_id'];
    couponCode = json['coupon_code'];
    orderNote = json['order_note'];
    orderType = json['order_type'];
    checked = _parseInt(json['checked']);
    restaurantId = _parseInt(json['restaurant_id']);
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deliveryCharge = json['delivery_charge'];
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
    deliveryAddress = json['delivery_address'] ?? 'No-address-Found';
    // json['address']['address'];
    scheduled = _parseInt(json['scheduled']);
    storeDiscountAmount = json['store_discount_amount'];
    originalDeliveryCharge = json['original_delivery_charge'];
    failed = json['failed'];
    adjusment = json['adjusment'];
    edited = _parseInt(json['edited']);
    riderPickingStatus = json['rider_picking_status'];
    if (json['order_detail'] != null) {
      orderDetail = <OrderDetail>[];
      json['order_detail'].forEach((v) {
        orderDetail!.add(OrderDetail.fromJson(v));
      });
    }
    if (json['restaurant'] != null) {
      restaurant = Restaurant.fromJson(json['restaurant']);
    }
    newUserDiscount = _parseDouble(json['new_customer_discount']) ?? 0;
    newUserDeliveryDiscount =
        _parseDouble(json['newUserDeliveryDiscount']) ?? 0;
    verificationCode = json['verification_code'] ?? "0000";
    if (json['schedule_slot'] != null) {
      getLogger("").wtf(json['schedule_slot']);
      scheduledSlots = Slots.fromJson(json['schedule_slot']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['rider_id'] = riderId;
    data['order_amount'] = orderAmount;
    data['coupon_discount_amount'] = couponDiscountAmount;
    data['coupon_discount_title'] = couponDiscountTitle;
    data['payment_status'] = paymentStatus;
    data['order_status'] = orderStatus;
    data['total_tax_amount'] = totalTaxAmount;
    data['admin_commission'] = adminCommission;
    if (address != null) {
      data['address'] = address?.toJson();
    }
    if (restReview != null) {
      data['restaurant_review'] = restReview?.toJson();
    }
    if (riderReview != null) {
      data['rider_review'] = riderReview?.toJson();
    }
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
    if (orderDetail != null) {
      data['order_detail'] = orderDetail!.map((v) => v.toJson()).toList();
    }
    if (restaurant != null) {
      data['restaurant'] = restaurant?.toJson();
    }
    data['new_customer_discount'] = newUserDiscount;
    data['newUserDeliveryDiscount'] = newUserDeliveryDiscount;
    data['verification_code'] = verificationCode;
    data['schedule_slot'] = scheduledSlots?.toJson();
    return data;
  }
}

class OrderDetail {
  int? id;
  int? foodId;
  int? orderId;
  double? price;
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
  Food? food;
  List<OrderSubProduct> orderSubProducts = [];
  List<Modifiers>? modifiers = [];
  bool showMore = false;
  double discount = 0;

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
      this.food,
      this.discount = 0,
      this.modifiers});

  OrderDetail.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']);
    foodId = _parseInt(json['food_id']);
    orderId = _parseInt(json['order_id']);
    price = double.parse(((json['price'] ?? '0').toString()));
    foodDetails = json['food_details'];
    variation = json['variation'];
    addOns = json['add_ons'];
    discountOnItem = json['discount_on_item'];
    discountType = json['discount_type'];
    quantity = _parseInt(json['quantity']);
    taxAmount = json['tax_amount'];
    variant = json['variant'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    itemCampaignId = json['item_campaign_id'];
    totalAddOnPrice = json['total_add_on_price'];
    food = json['food'] != null ? Food.fromJson(json['food']) : null;
    if (json['order_sub_products'] != null) {
      orderSubProducts = <OrderSubProduct>[];
      json['order_sub_products'].forEach((v) {
        orderSubProducts.add(OrderSubProduct.fromJson(v));
      });
    }
    modifiers = <Modifiers>[];
    if (json['modifiers'] != null) {
      json['modifiers'].forEach((v) {
        modifiers!.add(Modifiers.fromJson(v));
      });
    }
    discount = double.parse(((json['discount'] ?? '0').toString()));
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
    if (food != null) {
      data['food'] = food!.toJson();
    }
    data['modifiers'] = modifiers!.map((v) => v.toJson()).toList();
    data['order_sub_products'] =
        orderSubProducts.map((v) => v.toJson()).toList();

    data['discount'] = discount;
    return data;
  }
}

class Food {
  int? id;
  String? name;
  String? description;
  String? image;
  int? categoryId;
  dynamic variations;
  dynamic choiceOptions;
  String? price;
  String? tax;
  String? taxType;
  String? discount;
  String? discountType;
  dynamic availableTimeStarts;
  dynamic availableTimeEnds;
  int? veg;
  int? status;
  int? restaurantId;
  String? createdAt;
  String? updatedAt;
  int? orderCount;
  int? isSuggested;
  String? featuredImage;
  dynamic deletedAt;
  double? totalPrice;

  Food({
    this.id,
    this.name,
    this.description,
    this.image,
    this.categoryId,
    this.variations,
    this.choiceOptions,
    this.price,
    this.tax,
    this.taxType,
    this.discount,
    this.discountType,
    this.availableTimeStarts,
    this.availableTimeEnds,
    this.veg,
    this.status,
    this.restaurantId,
    this.createdAt,
    this.updatedAt,
    this.orderCount,
    this.isSuggested,
    this.featuredImage,
    this.deletedAt,
    this.totalPrice,
  });

  Food.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']);
    name = json['name'];
    description = json['description'];
    image = json['image'];
    categoryId = _parseInt(json['category_id']);
    variations = json['variations'];
    choiceOptions = json['choice_options'];
    price = json['price'];
    tax = json['tax'];
    taxType = json['tax_type'];
    discount = json['discount'];
    discountType = json['discount_type'];
    availableTimeStarts = json['available_time_starts'];
    availableTimeEnds = json['available_time_ends'];
    veg = _parseInt(json['veg']);
    status = _parseInt(json['status']);
    restaurantId = _parseInt(json['restaurant_id']);
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    orderCount = _parseInt(json['order_count']);
    isSuggested = _parseInt(json['is_suggested']);
    featuredImage = json['featured_image'];
    deletedAt = json['deleted_at'];
    totalPrice = _parseDouble(json['total_price']) ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['image'] = image;
    data['category_id'] = categoryId;
    data['variations'] = variations;
    data['choice_options'] = choiceOptions;
    data['price'] = price;
    data['tax'] = tax;
    data['tax_type'] = taxType;
    data['discount'] = discount;
    data['discount_type'] = discountType;
    data['available_time_starts'] = availableTimeStarts;
    data['available_time_ends'] = availableTimeEnds;
    data['veg'] = veg;
    data['status'] = status;
    data['restaurant_id'] = restaurantId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['order_count'] = orderCount;
    data['is_suggested'] = isSuggested;
    data['featured_image'] = featuredImage;
    data['deleted_at'] = deletedAt;
    data['total_price'] = totalPrice;

    return data;
  }
}

class Address {
  int? id;
  String? lat;
  String? lang;
  String? type;
  String? address;
  String? zipCode;
  int? userId;
  String? updatedAt;
  String? createdAt;
  dynamic deletedAt;

  Address(
      {this.id,
      this.lat,
      this.lang,
      this.type,
      this.address,
      this.zipCode,
      this.userId,
      this.updatedAt,
      this.createdAt,
      this.deletedAt});

  Address.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']);
    lat = json['lat'];
    lang = json['lang'];
    type = json['type'];
    address = json['address'];
    zipCode = json['zip_code'];
    userId = _parseInt(json['user_id']);
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['lat'] = lat;
    data['lang'] = lang;
    data['type'] = type;
    data['address'] = address;
    data['zip_code'] = zipCode;
    data['user_id'] = userId;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['deleted_at'] = deletedAt;
    return data;
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
    reviewRemarks = json['review_remarks'];
    reviewStar = _parseInt(json['review_star']);
    type = _parseInt(json['type']);
    typeId = _parseInt(json['type_id']);
    reviewStatus = _parseInt(json['review_status']);
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
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
