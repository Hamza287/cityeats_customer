import 'package:city_customer_app/models/user_profile.dart';
import 'package:city_customer_app/responses/base_responses/base_response.dart';

class ProfileResponse extends BaseResponse {
  UserProfile? body;

  ProfileResponse(success, error, this.body) : super(success, error: error);

  ProfileResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    body = json['body'] != null ? UserProfile.fromJson(json['body']) : null;
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
