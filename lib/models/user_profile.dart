// ignore_for_file: must_be_immutable, no_leading_underscores_for_local_identifiers
import 'package:city_customer_app/responses/addresses_response.dart';
import 'package:equatable/equatable.dart';

int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString());
}

// class UserProfile extends Equatable {
//   int? id;
//   String? name;
//   String? email;
//   String? emailVerifiedAt;
//   int? status;
//   int? restaurantId;
//   int? userTypeId;
//   String? fcmToken;
//   String? locationId;
//   String? lat;
//   String? lng;
//   String? image;
//   String? contactNumber;
//   String? createdAt;
//   String? updatedAt;
//   int? userOnline;
//   int? riderBusy;
//   int? verified;

//   UserProfile(
//       {this.id,
//       this.name,
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
//       this.verified});

//   UserProfile.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     email = json['email'];
//     emailVerifiedAt = json['email_verified_at'];
//     status = json['status'];
//     restaurantId = json['restaurant_id'];
//     userTypeId = json['user_type_id'];
//     fcmToken = json['fcm_token'];
//     locationId = json['location_id'];
//     lat = json['lat'];
//     lng = json['lng'];
//     image = json['image'];
//     contactNumber = json['contact_number'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     userOnline = json['user_online'];
//     riderBusy = json['rider_busy'];
//     verified = json['verified'] ?? 0;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['name'] = name;
//     data['email'] = email;
//     data['email_verified_at'] = emailVerifiedAt;
//     data['status'] = status;
//     data['restaurant_id'] = restaurantId;
//     data['user_type_id'] = userTypeId;
//     data['fcm_token'] = fcmToken;
//     data['location_id'] = locationId;
//     data['lat'] = lat;
//     data['lng'] = lng;
//     data['image'] = image;
//     data['contact_number'] = contactNumber;
//     data['created_at'] = createdAt;
//     data['updated_at'] = updatedAt;
//     data['user_online'] = userOnline;
//     data['rider_busy'] = riderBusy;
//     data['verified'] = verified;
//     return data;
//   }

//   @override
//   List<Object?> get props => throw UnimplementedError();

//   factory UserProfile.dummyObj() => UserProfile(
//         name: "User",
//         email: "",
//         id: -1, // Change id to Agent id
//         fcmToken: '',
//         createdAt: "",
//         updatedAt: "",
//       );
// }
class UserProfile extends Equatable {
  int? id;
  String? name;
  dynamic lastName;
  String? email;
  dynamic emailVerifiedAt;
  int? status;
  dynamic restaurantId;
  int? userTypeId;
  dynamic fcmToken;
  dynamic locationId;
  dynamic lat;
  dynamic lng;
  dynamic image;
  dynamic contactNumber;
  String? createdAt;
  String? updatedAt;
  int? userOnline;
  int? riderBusy;
  int? verified;
  int? isDocumentsVerified;
  int? isAddressAdded;
  int? isLicenseAdded;
  int? isVehicleAdded;
  dynamic deletedAt;
  String? userType;
  List<LocationAddress>? address;

  UserProfile(
      {this.id,
      this.name,
      this.lastName,
      this.email,
      this.emailVerifiedAt,
      this.status,
      this.restaurantId,
      this.userTypeId,
      this.fcmToken,
      this.locationId,
      this.lat,
      this.lng,
      this.image,
      this.contactNumber,
      this.createdAt,
      this.updatedAt,
      this.userOnline,
      this.riderBusy,
      this.verified,
      this.isDocumentsVerified,
      this.isAddressAdded,
      this.isLicenseAdded,
      this.isVehicleAdded,
      this.deletedAt,
      this.userType,
      this.address});

  UserProfile.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json["id"]);
    name = json["name"];
    lastName = json["last_name"];
    email = json["email"];
    emailVerifiedAt = json["email_verified_at"];
    status = _parseInt(json["status"]);
    restaurantId = json["restaurant_id"];
    userTypeId = _parseInt(json["user_type_id"]);
    fcmToken = json["fcm_token"];
    locationId = json["location_id"];
    lat = json["lat"];
    lng = json["lng"];
    image = json["image"];
    contactNumber = json["contact_number"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
    userOnline = _parseInt(json["user_online"]);
    riderBusy = _parseInt(json["rider_busy"]);
    verified = _parseInt(json["verified"]) ?? 1;
    // userTypeId != 4 ? json["verified"] : 1;
    isDocumentsVerified = _parseInt(json["is_documents_verified"]);
    isAddressAdded = _parseInt(json["is_address_added"]);
    isLicenseAdded = _parseInt(json["is_license_added"]);
    isVehicleAdded = _parseInt(json["is_vehicle_added"]);
    deletedAt = json["deleted_at"];
    userType = json["user_type"];
    address = json["address"] == null
        ? null
        : (json["address"] as List)
            .map((e) => LocationAddress.fromJson(e))
            .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["last_name"] = lastName;
    _data["email"] = email;
    _data["email_verified_at"] = emailVerifiedAt;
    _data["status"] = status;
    _data["restaurant_id"] = restaurantId;
    _data["user_type_id"] = userTypeId;
    _data["fcm_token"] = fcmToken;
    _data["location_id"] = locationId;
    _data["lat"] = lat;
    _data["lng"] = lng;
    _data["image"] = image;
    _data["contact_number"] = contactNumber;
    _data["created_at"] = createdAt;
    _data["updated_at"] = updatedAt;
    _data["user_online"] = userOnline;
    _data["rider_busy"] = riderBusy;
    _data["verified"] = verified;
    _data["is_documents_verified"] = isDocumentsVerified;
    _data["is_address_added"] = isAddressAdded;
    _data["is_license_added"] = isLicenseAdded;
    _data["is_vehicle_added"] = isVehicleAdded;
    _data["deleted_at"] = deletedAt;
    _data["user_type"] = userType;
    if (address != null) {
      _data["address"] = address?.map((e) => e.toJson()).toList();
    }
    return _data;
  }

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
  factory UserProfile.dummyObj() => UserProfile(
        name: "User",
        email: "",
        id: -1, // Change id to Agent id
        fcmToken: '',
        createdAt: "",
        updatedAt: "",
      );
}

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
