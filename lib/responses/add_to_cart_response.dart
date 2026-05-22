import 'package:city_customer_app/responses/base_responses/base_response.dart';
import 'package:city_customer_app/responses/restaurant_response.dart';

int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString());
}

class AddToCartResponse extends BaseResponse {
  Body? body;

  AddToCartResponse(success, error, {this.body}) : super(success, error: error);

  AddToCartResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
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

  Body({this.cart});

  Body.fromJson(Map<String, dynamic> json) {
    cart = json['cart'] != null ? Cart.fromJson(json['cart']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (cart != null) {
      data['cart'] = cart?.toJson();
    }
    return data;
  }
}

class Cart {
  int? id;
  int? customerId;
  int? restaurantId;
  int? couponId;
  int? couponApplied;
  double? subTotal;
  double? deliveryFee;
  double? discounts;
  double? total;
  int? coupon;
  String? createdAt;
  String? updatedAt;
  List<CartProducts>? cartProducts;
  Restaurant? restaurant;

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
      this.cartProducts,
      this.restaurant});

  Cart.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']);
    customerId = _parseInt(json['customer_id']);
    restaurantId = _parseInt(json['restaurant_id']);
    couponId = _parseInt(json['coupon_id']);
    couponApplied = _parseInt(json['coupon_applied']);
    subTotal = double.tryParse(json['sub_total'].toString()) ?? 0.0;
    deliveryFee = double.tryParse(json['delivery_fee'].toString()) ?? 0.0;
    discounts = double.tryParse(json['discounts'].toString()) ?? 0.0;
    total = double.tryParse(json['total'].toString()) ?? 0.0;
    coupon = _parseInt(json['coupon']);
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
  String? createdAt;
  String? updatedAt;

  CartProducts(
      {this.id,
      this.cartId,
      this.productId,
      this.productPrice,
      this.productCount,
      this.totalPrice,
      this.createdAt,
      this.updatedAt});

  CartProducts.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']);
    cartId = _parseInt(json['cart_id']);
    productId = _parseInt(json['product_id']);
    productPrice = double.tryParse(json['product_price'].toString()) ?? 0.0;
    productCount = _parseInt(json['product_count']);
    totalPrice = double.tryParse(json['total_price'].toString()) ?? 0.0;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
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
    data['updated_at'] = updatedAt;
    return data;
  }
}

// class Restaurant {
//   int? id;
//   String? name;
//   String? phone;
//   String? restaurantEmail;
//   String? logo;
//   double? latitude;
//   double? longitude;
//   String? address;
//   String? footerText;
//   String? minimumOrder;
//   String? commission;
//   int? scheduleOrder;
//   String? openingTime;
//   String? closeingTime;
//   int? status;
//   int? vendorId;
//   dynamic createdAt;
//   dynamic updatedAt;
//   int? freeDelivery;
//   double? rating;
//   String? coverPhoto;
//   int? delivery;
//   int? takeAway;
//   int? foodSection;
//   String? tax;
//   int? zoneId;
//   int? reviewsSection;
//   int? active;
//   String? offDay;
//   double? gst;
//   int? selfDeliverySystem;
//   int? posSystem;
//   String? deliveryCharge;
//   String? deliveryTime;
//   int? veg;
//   int? nonVeg;
//   String? featureImage;
//   String? type;

//   Restaurant(
//       {this.id,
//       this.name,
//       this.phone,
//       this.restaurantEmail,
//       this.logo,
//       this.latitude,
//       this.longitude,
//       this.address,
//       this.footerText,
//       this.minimumOrder,
//       this.commission,
//       this.scheduleOrder,
//       this.openingTime,
//       this.closeingTime,
//       this.status,
//       this.vendorId,
//       this.createdAt,
//       this.updatedAt,
//       this.freeDelivery,
//       this.rating,
//       this.coverPhoto,
//       this.delivery,
//       this.takeAway,
//       this.foodSection,
//       this.tax,
//       this.zoneId,
//       this.reviewsSection,
//       this.active,
//       this.offDay,
//       this.gst,
//       this.selfDeliverySystem,
//       this.posSystem,
//       this.deliveryCharge,
//       this.deliveryTime,
//       this.veg,
//       this.nonVeg,
//       this.featureImage,
//       this.type});

//   Restaurant.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     phone = json['phone'];
//     restaurantEmail = json['restaurant_email'];
//     logo = json['logo'];
//     latitude = json['latitude'];
//     longitude = json['longitude'];
//     address = json['address'];
//     footerText = json['footer_text'];
//     minimumOrder = json['minimum_order'];
//     commission = json['commission'];
//     scheduleOrder = json['schedule_order'];
//     openingTime = json['opening_time'];
//     closeingTime = json['closeing_time'];
//     status = json['status'];
//     vendorId = json['vendor_id'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     freeDelivery = json['free_delivery'];
//     rating = json['rating'];
//     coverPhoto = json['cover_photo'];
//     delivery = json['delivery'];
//     takeAway = json['take_away'];
//     foodSection = json['food_section'];
//     tax = json['tax'];
//     zoneId = json['zone_id'];
//     reviewsSection = json['reviews_section'];
//     active = json['active'];
//     offDay = json['off_day'];
//     gst = json['gst'];
//     selfDeliverySystem = json['self_delivery_system'];
//     posSystem = json['pos_system'];
//     deliveryCharge = json['delivery_charge'];
//     deliveryTime = json['delivery_time'];
//     veg = json['veg'];
//     nonVeg = json['non_veg'];
//     featureImage = json['feature_image'];
//     type = json['type'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['name'] = name;
//     data['phone'] = phone;
//     data['restaurant_email'] = restaurantEmail;
//     data['logo'] = logo;
//     data['latitude'] = latitude;
//     data['longitude'] = longitude;
//     data['address'] = address;
//     data['footer_text'] = footerText;
//     data['minimum_order'] = minimumOrder;
//     data['commission'] = commission;
//     data['schedule_order'] = scheduleOrder;
//     data['opening_time'] = openingTime;
//     data['closeing_time'] = closeingTime;
//     data['status'] = status;
//     data['vendor_id'] = vendorId;
//     data['created_at'] = createdAt;
//     data['updated_at'] = updatedAt;
//     data['free_delivery'] = freeDelivery;
//     data['rating'] = rating;
//     data['cover_photo'] = coverPhoto;
//     data['delivery'] = delivery;
//     data['take_away'] = takeAway;
//     data['food_section'] = foodSection;
//     data['tax'] = tax;
//     data['zone_id'] = zoneId;
//     data['reviews_section'] = reviewsSection;
//     data['active'] = active;
//     data['off_day'] = offDay;
//     data['gst'] = gst;
//     data['self_delivery_system'] = selfDeliverySystem;
//     data['pos_system'] = posSystem;
//     data['delivery_charge'] = deliveryCharge;
//     data['delivery_time'] = deliveryTime;
//     data['veg'] = veg;
//     data['non_veg'] = nonVeg;
//     data['feature_image'] = featureImage;
//     data['type'] = type;
//     return data;
//   }
// }
