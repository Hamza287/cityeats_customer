import 'package:city_customer_app/app/app.logger.dart';
import 'package:city_customer_app/models/user_models/auth_response_model.dart';
import 'package:city_customer_app/responses/base_responses/base_response.dart';

class AuthResponse extends BaseResponse {
  var log = getLogger("AuthResponse");
  String? accessToken;
  AuthResponseModel? authResponseModel;
  Map<String, dynamic>? rawData; // Store raw response for detailed error extraction

  AuthResponse(success, {error}) : super(success, error: error);

  AuthResponse.fromJson(json) : super.fromJson(json) {
    log.wtf(json);
    // Store raw data for error extraction
    if (json is Map<String, dynamic>) {
      rawData = Map<String, dynamic>.from(json);
    }
    if (json['body'] != null) {
      authResponseModel = AuthResponseModel.fromJson(json['body']);
    }
    accessToken = authResponseModel?.token;
  }
}
