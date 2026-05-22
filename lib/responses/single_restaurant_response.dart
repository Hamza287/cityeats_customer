import 'package:city_customer_app/responses/base_responses/base_response.dart';
import 'package:city_customer_app/responses/restaurant_response.dart';

class SingleRestaurantResponse extends BaseResponse {
  Restaurant? restaurant;

  // ignore: use_super_parameters
  SingleRestaurantResponse(success, error, {this.restaurant})
      : super(success, error: error);

  SingleRestaurantResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    success = json['success'];
    error = json['error'];
    restaurant =
        json['body'] != null ? Restaurant.fromJson(json['body']) : null;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['error'] = error;
    if (restaurant != null) {
      data['body'] = restaurant!.toJson();
    }
    return data;
  }
}

class Variants {
  int? id;
  int? foodId;
  String? variant;
  int? price;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;

  Variants(
      {this.id,
      this.foodId,
      this.variant,
      this.price,
      this.deletedAt,
      this.createdAt,
      this.updatedAt});

  Variants.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    foodId = json["food_id"];
    variant = json["variant"];
    price = json["price"];
    deletedAt = json["deleted_at"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["food_id"] = foodId;
    data["variant"] = variant;
    data["price"] = price;
    data["deleted_at"] = deletedAt;
    data["created_at"] = createdAt;
    data["updated_at"] = updatedAt;
    return data;
  }
}
