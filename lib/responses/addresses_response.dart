import 'package:city_customer_app/responses/base_responses/base_response.dart';

int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString());
}

class AddressesResponse extends BaseResponse {
  List<LocationAddress>? body;

  AddressesResponse(success, error) : super(success, error: error);

  AddressesResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    success = json['success'] ?? false;
    error = json['error'];
    if (json['body'] != null) {
      body = <LocationAddress>[];
      json['body'].forEach((v) {
        body!.add(LocationAddress.fromJson(v));
      });
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['error'] = error;
    if (body != null) {
      data['body'] = body!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LocationAddress {
  int? id;
  String? lat;
  String? lang;
  String? type;
  String? address;
  String? zipCode;
  int? userId;
  String? updatedAt;
  String? createdAt;

  LocationAddress(
      {this.id,
      this.lat,
      this.lang,
      this.type,
      this.address,
      this.zipCode,
      this.userId,
      this.updatedAt,
      this.createdAt});

  LocationAddress.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']);
    lat = json['lat'];
    lang = json['lang'];
    type = json['type'];
    address = json['address'];
    zipCode = json['zip_code'];
    userId = _parseInt(json['user_id']);
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
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
    return data;
  }
}
