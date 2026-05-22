import 'package:city_customer_app/responses/base_responses/base_response.dart';

int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString());
}

class BannersResponse extends BaseResponse {
  List<BannerModel> bannerList = [];

  BannersResponse(success, error) : super(success, error: error);

  BannersResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    success = json['success'];
    error = json['error'];
    if (json['body'] != null) {
      bannerList = <BannerModel>[];
      json['body'].forEach((v) {
        bannerList.add(BannerModel.fromJson(v));
      });
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['error'] = error;
    if (bannerList.isNotEmpty) {
      data['body'] = bannerList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BannerModel {
  late int id;
  String? sliderImage;
  int? position;
  dynamic createdAt;
  String? updatedAt;
  late int restaurantId;
  int? foodId;

  BannerModel(
      {required this.id,
      this.sliderImage,
      this.position,
      this.createdAt,
      required this.restaurantId,
      this.foodId,
      this.updatedAt});

  BannerModel.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']) ?? 0;
    sliderImage = json['slider_image'];
    position = _parseInt(json['position']);
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    restaurantId = _parseInt(json["restaurant_id"]) ?? 0;
    foodId = _parseInt(json["food_id"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['slider_image'] = sliderImage;
    data['position'] = position;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data["restaurant_id"] = restaurantId;
    data["food_id"] = foodId;
    return data;
  }
}
