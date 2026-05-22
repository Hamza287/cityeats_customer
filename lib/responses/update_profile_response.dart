import 'package:city_customer_app/models/user_profile.dart';
import 'package:city_customer_app/responses/base_responses/base_response.dart';

class UpdateProfileResponse extends BaseResponse {
  UserProfile? user;

  UpdateProfileResponse(success, error, {this.user})
      : super(success, error: error);

  UpdateProfileResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    success = json['success'];
    error = json['error'];
    user = json['body'] != null ? UserProfile.fromJson(json['body']) : null;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['error'] = error;
    if (user != null) {
      data['body'] = user?.toJson();
    }
    return data;
  }
}
