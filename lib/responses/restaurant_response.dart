import 'package:city_customer_app/responses/base_responses/base_response.dart';
import 'package:city_customer_app/responses/specific_order_response.dart';

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

bool _parseBool(dynamic value) {
  if (value is bool) return value;
  if (value is num) return value == 1;
  return value?.toString() == '1' || value?.toString().toLowerCase() == 'true';
}

class RestaurantsResponse extends BaseResponse {
  List<Restaurant>? restaurantList = [];

  RestaurantsResponse(success, error, {this.restaurantList})
      : super(success, error: error);

  RestaurantsResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    success = json['success'] ?? false;
    error = json['error'];
    if (json['body'] != null) {
      restaurantList = <Restaurant>[];
      json['body'].forEach((v) {
        restaurantList?.add(Restaurant.fromJson(v));
      });
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['error'] = error;
    if (restaurantList != null) {
      data['body'] = restaurantList?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Restaurant {
  late int id;
  String? name;
  String? phone;
  String? restaurantEmail;
  String? logo;
  double? latitude;
  bool? isFav;
  double? longitude;
  String? address;
  String? footerText;
  String? minimumOrder;
  String? commission;
  int? scheduleOrder;
  String? openingTime;
  String? closeingTime;
  int? status;
  int? vendorId;
  dynamic createdAt;
  String? updatedAt;
  int? freeDelivery;
  dynamic rating;
  String? coverPhoto;
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
  bool? isBusy;
  double? charge;
  double? radius;
  double? chargePerKm;
  List<Food> food = [];
  String foodNamesString = '';
  List<WeeklyTimings>? weeklyTimings;
  double? highestDiscount;
  double? expectedDeliveryCharges;
  int? hygineRating;
  int? isScheduleForLater;

  Restaurant(this.food, this.foodNamesString,
      {required this.id,
      this.weeklyTimings,
      this.name,
      isFav = false,
      isBusy = false,
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
      this.charge,
      this.radius,
      this.chargePerKm,
      this.highestDiscount,
      this.hygineRating,
      this.isScheduleForLater,
      this.type});

  Restaurant.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']) ?? 0;
    name = json['name'];
    phone = json['phone'];
    restaurantEmail = json['restaurant_email'];
    logo = json['logo'];
    latitude = _parseDouble(json['latitude']);
    longitude = _parseDouble(json['longitude']);

    address = json['address'];
    footerText = json['footer_text'];
    minimumOrder = json['minimum_order'];
    commission = json['commission'];
    scheduleOrder = _parseInt(json['schedule_order']);
    openingTime = json['opening_time'];
    closeingTime = json['closeing_time'];
    status = _parseInt(json['status']);
    isBusy = _parseBool(json['is_busy']);
    vendorId = _parseInt(json['vendor_id']);
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
    highestDiscount = _parseDouble(json['highest_discount_percentage']) ?? 0;

    type = json['type'];
    charge = _parseDouble(json['charge']) ?? 0;
    radius = _parseDouble(json['radius_at_customer_end']) ?? 0;
    chargePerKm = _parseDouble(json['charge_per_km']) ?? 0;
    food = <Food>[];
    if (json['food'] != null) {
      json['food'].forEach((v) {
        food.add(Food.fromJson(v));
      });
    }

    if (json['weekly_timings'] != null) {
      weeklyTimings = <WeeklyTimings>[];
      json['weekly_timings'].forEach((v) {
        weeklyTimings?.add(WeeklyTimings.fromJson(v));
      });
    }
    for (var element in food) {
      foodNamesString = foodNamesString.isEmpty
          ? element.name ?? ''
          : (('$foodNamesString , ${element.name!}'));
    }
    expectedDeliveryCharges =
        _parseDouble(json['expected_delivery_charges']) ?? 0;
    hygineRating = _parseInt(json['hygine_rating']);
    isScheduleForLater = _parseInt(json['schedule_order']) ?? 0;
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
    if (weeklyTimings != null) {
      data['weekly_timings'] = weeklyTimings?.map((v) => v.toJson()).toList();
    }
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
    data['food'] = food.map((v) => v.toJson()).toList();
    data['highest_discount_percentage'] = highestDiscount;
    data['expected_delivery_charges'] = expectedDeliveryCharges;
    data['hygine_rating'] = hygineRating;
    data['schedule_order'] = isScheduleForLater;
    return data;
  }
}

class WeeklyTimings {
  int? id;
  int? restaurantId;
  String? day;
  String? openingTime;
  String? closingTime;
  String? status;
  String? createdAt;
  String? updatedAt;

  WeeklyTimings(
      {this.id,
      this.restaurantId,
      this.day,
      this.openingTime,
      this.closingTime,
      this.status,
      this.createdAt,
      this.updatedAt});

  WeeklyTimings.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']);
    restaurantId = _parseInt(json['restaurant_id']);
    day = json['day'];
    openingTime = json['opening_time'];
    closingTime = json['closing_time'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['restaurant_id'] = restaurantId;
    data['day'] = day;
    data['opening_time'] = openingTime;
    data['closing_time'] = closingTime;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
