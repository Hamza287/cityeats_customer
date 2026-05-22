import 'package:city_customer_app/responses/base_responses/base_response.dart';
import 'package:city_customer_app/responses/restaurent_cat_reesponse.dart';

int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString());
}

class CartResponse extends BaseResponse {
  Body? body;

  CartResponse(success, error, {this.body}) : super(success, error: error);

  CartResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    success = json['success'] ?? false;
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
  Cart? cart;
  List<RestaurantAvailableSlots>? restaurantAvailableSlots;

  Body({this.cart});

  Body.fromJson(Map<String, dynamic> json) {
    cart = json['cart'] != null ? Cart.fromJson(json['cart']) : null;
    if (json['restaurant_available_slots'] != null) {
      restaurantAvailableSlots = <RestaurantAvailableSlots>[];
      json['restaurant_available_slots'].forEach((v) {
        restaurantAvailableSlots!.add(RestaurantAvailableSlots.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (cart != null) {
      data['cart'] = cart!.toJson();
    }
    if (restaurantAvailableSlots != null) {
      data['restaurant_available_slots'] =
          restaurantAvailableSlots!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Cart {
  int? id;
  int? customerId;
  int? restaurantId;
  dynamic couponId;
  dynamic couponApplied;
  double? subTotal;
  double? deliveryFee;
  double? discounts;
  double? total;
  double? vat;
  double? serviceCharges;
  double? bagFee;
  dynamic coupon;
  String? createdAt;
  String? updatedAt;
  List<CartProducts>? cartProducts;
  Restaurant? restaurant;
  double newUserDiscount = 0;
  double newUserDeliveryDiscount = 0;

  Cart(
      {this.id,
      this.customerId,
      this.restaurantId,
      this.couponId,
      this.couponApplied,
      this.subTotal,
      this.deliveryFee,
      this.discounts,
      this.total,
      this.coupon,
      this.createdAt,
      this.updatedAt,
      this.vat,
      this.bagFee,
      this.serviceCharges,
      this.cartProducts,
      this.restaurant,
      this.newUserDeliveryDiscount = 0,
      this.newUserDiscount = 0});

  Cart.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']);
    customerId = _parseInt(json['customer_id']);
    restaurantId = _parseInt(json['restaurant_id']);
    couponId = json['coupon_id'];

    vat = double.tryParse((json['VAT'] ?? 0).toString()) ?? 0.0;
    serviceCharges =
        double.tryParse((json['service_charges'] ?? 0).toString()) ?? 0.0;
    bagFee = double.tryParse((json['bag_fee'] ?? 0).toString()) ?? 0.0;

    couponApplied = json['coupon_applied'];
    subTotal = double.tryParse(json['sub_total'].toString()) ?? 0.0;
    deliveryFee = double.tryParse(json['delivery_fee'].toString()) ?? 0.0;
    discounts = double.tryParse(json['discounts'].toString()) ?? 0.0;
    total = double.tryParse(json['total'].toString()) ?? 0.0;
    coupon = json['coupon'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];

    if (json['cart_products'] != null) {
      cartProducts = <CartProducts>[];
      json['cart_products'].forEach((v) {
        cartProducts!.add(CartProducts.fromJson(v));
      });
    }
    restaurant = json['restaurant'] != null
        ? Restaurant.fromJson(json['restaurant'])
        : null;
    newUserDiscount =
        double.tryParse((json['new_customer_discount'] ?? 0.00).toString()) ??
            0.0;
    newUserDeliveryDiscount =
        double.tryParse((json['newUserDeliveryDiscount'] ?? 0.0).toString()) ??
            0.0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['customer_id'] = customerId;
    data['restaurant_id'] = restaurantId;
    data['coupon_id'] = couponId;
    data['coupon_applied'] = couponApplied;
    data['sub_total'] = subTotal;
    data['delivery_fee'] = deliveryFee;
    data['discounts'] = discounts;
    data['total'] = total;
    data['coupon'] = coupon;

    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (cartProducts != null) {
      data['cart_products'] = cartProducts!.map((v) => v.toJson()).toList();
    }
    if (restaurant != null) {
      data['restaurant'] = restaurant!.toJson();
    }
    data['new_customer_discount'] = newUserDiscount;
    data['newUserDeliveryDiscount'] = newUserDeliveryDiscount;
    return data;
  }
}

class CartProducts {
  int? id;
  int? cartId;
  int? productId;
  double? productPrice;
  int? productCount;
  double? totalPrice;
  String? productName;
  String? productImage;
  List<CartSideItems> sideItems = [];
  String? createdAt;
  String? updatedAt;
  List<Variants>? variants = [];
  List<Modifiers>? modifiers = [];
  bool showMore = false;
  double discount = 0;
  double discountAdded = 0;
  double discountOnSingleproduct = 0;

  CartProducts(this.sideItems,
      {this.id,
      this.cartId,
      this.productId,
      this.productPrice,
      this.productImage,
      this.productName,
      this.productCount,
      this.totalPrice,
      this.createdAt,
      this.updatedAt,
      this.variants,
      this.discount = 0,
      this.discountAdded = 0,
      this.discountOnSingleproduct = 0,
      this.modifiers});

  CartProducts.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']);
    cartId = _parseInt(json['cart_id']);
    productId = _parseInt(json['product_id']);
    productPrice = double.tryParse(json['product_price'].toString()) ?? 0.0;
    productCount = _parseInt(json['product_count']);
    discount = double.tryParse((json['discount'] ?? '0').toString()) ?? 0.0;
    discountAdded = discount;
    discountOnSingleproduct = (discount / (productCount ?? 1));
    totalPrice = double.tryParse(json['total_price'].toString()) ?? 0.0;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    sideItems = <CartSideItems>[];
    if (json['side_items'] != null) {
      json['side_items'].forEach((v) {
        sideItems.add(CartSideItems.fromJson(v));
      });
    }
    variants = <Variants>[];
    if (json['variants'] != null) {
      json['variants'].forEach((v) {
        variants!.add(Variants.fromJson(v));
      });
    }
    modifiers = <Modifiers>[];
    if (json['modifiers'] != null) {
      json['modifiers'].forEach((v) {
        modifiers!.add(Modifiers.fromJson(v));
      });
    }

    productName = json["product_name"];
    productImage = json["product_image"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['cart_id'] = cartId;
    data['product_id'] = productId;
    data['product_price'] = productPrice;
    data['product_count'] = productCount;
    data['total_price'] = totalPrice;
    data['created_at'] = createdAt;
    data['side_items'] = sideItems.map((v) => v.toJson()).toList();
    data['modifiers'] = modifiers!.map((v) => v.toJson()).toList();
    data['updated_at'] = updatedAt;
    data['variants'] = variants;
    data['discount'] = discount;
    return data;
  }
}

class Restaurant {
  int? id;
  String? name;
  String? phone;
  String? restaurantEmail;
  String? logo;
  dynamic latitude;
  dynamic longitude;
  String? address;
  dynamic footerText;
  String? minimumOrder;
  String? commission;
  int? scheduleOrder;
  String? openingTime;
  String? closeingTime;
  int? status;
  dynamic vendorId;
  dynamic createdAt;
  dynamic updatedAt;
  int? freeDelivery;
  dynamic rating;
  dynamic coverPhoto;
  int? delivery;
  int? takeAway;
  int? foodSection;
  String? tax;
  int? zoneId;
  int? reviewsSection;
  int? active;
  String? offDay;
  dynamic gst;
  int? selfDeliverySystem;
  int? posSystem;
  String? deliveryCharge;
  String? deliveryTime;
  int? veg;
  int? nonVeg;
  String? featureImage;
  String? type;
  double? charge;
  double? radius;
  double? chargePerKm;
  dynamic deletedAt;
  bool isBusy = false;
  int isRestaurantOwnDelivery = 0;
  double? expectedDeliveryCharges;
  double? highestDiscount;

  Restaurant(
      {this.id,
      this.name,
      this.phone,
      this.restaurantEmail,
      this.logo,
      this.latitude,
      this.longitude,
      this.address,
      this.footerText,
      this.minimumOrder,
      this.commission,
      this.scheduleOrder,
      this.openingTime,
      this.closeingTime,
      this.status,
      this.vendorId,
      this.createdAt,
      this.updatedAt,
      this.freeDelivery,
      this.rating,
      this.coverPhoto,
      this.delivery,
      this.takeAway,
      this.foodSection,
      this.tax,
      this.zoneId,
      this.reviewsSection,
      this.active,
      this.offDay,
      this.gst,
      this.selfDeliverySystem,
      this.posSystem,
      this.deliveryCharge,
      this.deliveryTime,
      this.veg,
      this.nonVeg,
      this.featureImage,
      this.type,
      this.charge,
      this.radius,
      this.chargePerKm,
      this.isBusy = false,
      this.deletedAt,
      this.isRestaurantOwnDelivery = 0,
      this.highestDiscount,
      this.expectedDeliveryCharges});

  Restaurant.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']);
    name = json['name'];
    phone = json['phone'];
    restaurantEmail = json['restaurant_email'];
    logo = json['logo'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
    footerText = json['footer_text'];
    minimumOrder = json['minimum_order'];
    commission = json['commission'];
    scheduleOrder = _parseInt(json['schedule_order']);
    openingTime = json['opening_time'];
    closeingTime = json['closeing_time'];
    status = _parseInt(json['status']);
    vendorId = json['vendor_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    freeDelivery = _parseInt(json['free_delivery']);
    rating = json['rating'];
    coverPhoto = json['cover_photo'];
    delivery = _parseInt(json['delivery']);
    takeAway = _parseInt(json['take_away']);
    foodSection = _parseInt(json['food_section']);
    tax = json['tax'];
    zoneId = _parseInt(json['zone_id']);
    reviewsSection = _parseInt(json['reviews_section']);
    active = _parseInt(json['active']);
    offDay = json['off_day'];
    gst = json['gst'];
    selfDeliverySystem = _parseInt(json['self_delivery_system']);
    posSystem = _parseInt(json['pos_system']);
    deliveryCharge = json['delivery_charge'];
    deliveryTime = json['delivery_time'];
    veg = _parseInt(json['veg']);
    nonVeg = _parseInt(json['non_veg']);
    featureImage = json['feature_image'];
    type = json['type'];
    charge = double.parse(((json['charge'] ?? '0').toString()));
    radius = double.parse(((json['radius_at_customer_end'] ?? '0').toString()));
    chargePerKm = double.parse(((json['charge_per_km'] ?? '0').toString()));
    deletedAt = json['deleted_at'];
    isBusy = (json['is_busy'] ?? false) == 1 ? true : false;
    isRestaurantOwnDelivery =
        _parseInt(json['is_restaurant_own_delivery']) ?? 0;
    expectedDeliveryCharges =
        double.parse(((json['expected_delivery_charges'] ?? '0').toString()));
    highestDiscount =
        double.parse(((json['highest_discount_percentage'] ?? '0').toString()));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['phone'] = phone;
    data['restaurant_email'] = restaurantEmail;
    data['logo'] = logo;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['address'] = address;
    data['footer_text'] = footerText;
    data['minimum_order'] = minimumOrder;
    data['commission'] = commission;
    data['schedule_order'] = scheduleOrder;
    data['opening_time'] = openingTime;
    data['closeing_time'] = closeingTime;
    data['status'] = status;
    data['vendor_id'] = vendorId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['free_delivery'] = freeDelivery;
    data['rating'] = rating;
    data['cover_photo'] = coverPhoto;
    data['delivery'] = delivery;
    data['take_away'] = takeAway;
    data['food_section'] = foodSection;
    data['tax'] = tax;
    data['zone_id'] = zoneId;
    data['reviews_section'] = reviewsSection;
    data['active'] = active;
    data['off_day'] = offDay;
    data['gst'] = gst;
    data['self_delivery_system'] = selfDeliverySystem;
    data['pos_system'] = posSystem;
    data['delivery_charge'] = deliveryCharge;
    data['delivery_time'] = deliveryTime;
    data['veg'] = veg;
    data['non_veg'] = nonVeg;
    data['feature_image'] = featureImage;
    data['type'] = type;
    data['charge'] = charge;
    data['radius_at_customer_end'] = radius;
    data['charge_per_km'] = chargePerKm;
    data['deleted_at'] = deletedAt;
    data['is_restaurant_own_delivery'] = isRestaurantOwnDelivery;
    data['highest_discount_percentage'] = highestDiscount;
    data['expected_delivery_charges'] = expectedDeliveryCharges;
    return data;
  }
}

class CartSideItems {
  int? id;
  int? cartProductsId;
  String? sideItemName;
  String? sideItemPrice;
  String? createdAt;
  String? updatedAt;

  CartSideItems(
      {this.id,
      this.cartProductsId,
      this.sideItemName,
      this.sideItemPrice,
      this.createdAt,
      this.updatedAt});

  CartSideItems.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']);
    cartProductsId = _parseInt(json['cart_products_id']);
    sideItemName = json['side_item_name'];
    sideItemPrice = json['side_item_price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['cart_products_id'] = cartProductsId;
    data['side_item_name'] = sideItemName;
    data['side_item_price'] = sideItemPrice;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class RestaurantAvailableSlots {
  DateTime? date;
  List<Slots>? slots;

  RestaurantAvailableSlots({this.date, this.slots});

  RestaurantAvailableSlots.fromJson(Map<String, dynamic> json) {
    date = DateTime.parse(json['date']);
    if (json['slots'] != null) {
      slots = <Slots>[];
      json['slots'].forEach((v) {
        slots!.add(Slots.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    if (slots != null) {
      data['slots'] = slots!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Slots {
  int? id;
  int? restaurantId;
  String? slotDate;
  String? startTime;
  String? endTime;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  bool isSelected = false;

  Slots(
      {this.id,
      this.restaurantId,
      this.slotDate,
      this.startTime,
      this.endTime,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  Slots.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']) ?? 0;
    restaurantId = _parseInt(json['restaurant_id']) ?? 0;
    slotDate = json['slot_date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['restaurant_id'] = restaurantId;
    data['slot_date'] = slotDate;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    return data;
  }
}
