import 'package:city_customer_app/models/user_profile.dart';
import 'package:city_customer_app/responses/base_responses/base_response.dart';

class GuestUserProfileResponse extends BaseResponse {
  GuestUserProfile? body;

  GuestUserProfileResponse(success, error, {this.body})
      : super(success, error: error);

  GuestUserProfileResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    body =
        json["body"] == null ? null : GuestUserProfile.fromJson(json["body"]);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["success"] = success;
    data["error"] = error;
    // errors?.map((v) => v.toJson()).toList();
    if (body != null) {
      data["body"] = body?.toJson();
    }
    return data;
  }
}

class GuestUserProfile {
  UserProfile? user;
  String? token;

  GuestUserProfile({this.user, this.token});

  GuestUserProfile.fromJson(Map<String, dynamic> json) {
    user = json["user"] == null ? null : UserProfile.fromJson(json["user"]);
    token = json["token"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data["user"] = user?.toJson();
    }
    data["token"] = token;
    return data;
  }
}

// class User {
//   int? id;
//   String? name;
//   dynamic lastName;
//   String? email;
//   dynamic emailVerifiedAt;
//   int? status;
//   dynamic restaurantId;
//   int? userTypeId;
//   dynamic fcmToken;
//   dynamic locationId;
//   dynamic lat;
//   dynamic lng;
//   dynamic image;
//   dynamic contactNumber;
//   String? createdAt;
//   String? updatedAt;
//   int? userOnline;
//   int? riderBusy;
//   int? verified;
//   int? isDocumentsVerified;
//   int? isAddressAdded;
//   int? isLicenseAdded;
//   int? isVehicleAdded;
//   dynamic deletedAt;
//   String? userType;
//   List<Address>? address;

//   User(
//       {this.id,
//       this.name,
//       this.lastName,
//       this.email,
//       this.emailVerifiedAt,
//       this.status,
//       this.restaurantId,
//       this.userTypeId,
//       this.fcmToken,
//       this.locationId,
//       this.lat,
//       this.lng,
//       this.image,
//       this.contactNumber,
//       this.createdAt,
//       this.updatedAt,
//       this.userOnline,
//       this.riderBusy,
//       this.verified,
//       this.isDocumentsVerified,
//       this.isAddressAdded,
//       this.isLicenseAdded,
//       this.isVehicleAdded,
//       this.deletedAt,
//       this.userType,
//       this.address});

//   User.fromJson(Map<String, dynamic> json) {
//     id = json["id"];
//     name = json["name"];
//     lastName = json["last_name"];
//     email = json["email"];
//     emailVerifiedAt = json["email_verified_at"];
//     status = json["status"];
//     restaurantId = json["restaurant_id"];
//     userTypeId = json["user_type_id"];
//     fcmToken = json["fcm_token"];
//     locationId = json["location_id"];
//     lat = json["lat"];
//     lng = json["lng"];
//     image = json["image"];
//     contactNumber = json["contact_number"];
//     createdAt = json["created_at"];
//     updatedAt = json["updated_at"];
//     userOnline = json["user_online"];
//     riderBusy = json["rider_busy"];
//     verified = json["verified"];
//     isDocumentsVerified = json["is_documents_verified"];
//     isAddressAdded = json["is_address_added"];
//     isLicenseAdded = json["is_license_added"];
//     isVehicleAdded = json["is_vehicle_added"];
//     deletedAt = json["deleted_at"];
//     userType = json["user_type"];
//     address = json["address"] == null
//         ? null
//         : (json["address"] as List).map((e) => Address.fromJson(e)).toList();
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> _data = <String, dynamic>{};
//     _data["id"] = id;
//     _data["name"] = name;
//     _data["last_name"] = lastName;
//     _data["email"] = email;
//     _data["email_verified_at"] = emailVerifiedAt;
//     _data["status"] = status;
//     _data["restaurant_id"] = restaurantId;
//     _data["user_type_id"] = userTypeId;
//     _data["fcm_token"] = fcmToken;
//     _data["location_id"] = locationId;
//     _data["lat"] = lat;
//     _data["lng"] = lng;
//     _data["image"] = image;
//     _data["contact_number"] = contactNumber;
//     _data["created_at"] = createdAt;
//     _data["updated_at"] = updatedAt;
//     _data["user_online"] = userOnline;
//     _data["rider_busy"] = riderBusy;
//     _data["verified"] = verified;
//     _data["is_documents_verified"] = isDocumentsVerified;
//     _data["is_address_added"] = isAddressAdded;
//     _data["is_license_added"] = isLicenseAdded;
//     _data["is_vehicle_added"] = isVehicleAdded;
//     _data["deleted_at"] = deletedAt;
//     _data["user_type"] = userType;
//     if (address != null) {
//       _data["address"] = address?.map((e) => e.toJson()).toList();
//     }
//     return _data;
//   }
// }

// class Address {
//   int? id;
//   String? lat;
//   String? lang;
//   String? type;
//   String? address;
//   String? zipCode;
//   int? userId;
//   dynamic apt;
//   dynamic city;
//   dynamic state;
//   String? updatedAt;
//   String? createdAt;
//   dynamic deletedAt;

//   Address(
//       {this.id,
//       this.lat,
//       this.lang,
//       this.type,
//       this.address,
//       this.zipCode,
//       this.userId,
//       this.apt,
//       this.city,
//       this.state,
//       this.updatedAt,
//       this.createdAt,
//       this.deletedAt});

//   Address.fromJson(Map<String, dynamic> json) {
//     id = json["id"];
//     lat = json["lat"];
//     lang = json["lang"];
//     type = json["type"];
//     address = json["address"];
//     zipCode = json["zip_code"];
//     userId = json["user_id"];
//     apt = json["apt"];
//     city = json["city"];
//     state = json["state"];
//     updatedAt = json["updated_at"];
//     createdAt = json["created_at"];
//     deletedAt = json["deleted_at"];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> _data = <String, dynamic>{};
//     _data["id"] = id;
//     _data["lat"] = lat;
//     _data["lang"] = lang;
//     _data["type"] = type;
//     _data["address"] = address;
//     _data["zip_code"] = zipCode;
//     _data["user_id"] = userId;
//     _data["apt"] = apt;
//     _data["city"] = city;
//     _data["state"] = state;
//     _data["updated_at"] = updatedAt;
//     _data["created_at"] = createdAt;
//     _data["deleted_at"] = deletedAt;
//     return _data;
//   }
// }
