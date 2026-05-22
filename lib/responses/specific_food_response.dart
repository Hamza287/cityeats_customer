import 'package:city_customer_app/responses/base_responses/base_response.dart';
import 'package:city_customer_app/responses/restaurent_cat_reesponse.dart';

class SpecificFoodResponse extends BaseResponse {
  Body? body;

  SpecificFoodResponse(success, error, {this.body})
      : super(success, error: error);

  SpecificFoodResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
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
  Foods? food;

  Body({this.food});

  Body.fromJson(Map<String, dynamic> json) {
    food = json['food'] != null ? Foods.fromJson(json['food']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (food != null) {
      data['food'] = food!.toJson();
    }
    return data;
  }
}
