import 'package:city_customer_app/app/app.logger.dart';
import 'package:city_customer_app/models/user_profile.dart';

class AuthResponseModel {
  UserProfile? user;
  String? token;

  AuthResponseModel({this.user, this.token});

  AuthResponseModel.fromJson(Map<String, dynamic> json) {
    var log = getLogger("AuthResponseModel");
    log.wtf(json);
    token = json['token'];
    user = json['user'] != null ? UserProfile.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    if (user != null) {
      data['user'] = user?.toJson();
    }
    return data;
  }
}

// class User {
//   String? name;
//   String? email;
//   String? phone;
//   String? updatedAt;
//   String? createdAt;
//   bool? isEmailVerified;
//   int? id;
//   String? role;
//   List<Roles>? roles;

//   User(
//       {this.name,
//       this.email,
//       this.phone,
//       this.updatedAt,
//       this.createdAt,
//       this.id,
//       this.role,
//       this.roles,
//       this.isEmailVerified});

//   User.fromJson(Map<String, dynamic> json) {
//     name = json['name'];
//     email = json['email'];
//     phone = json['phone'];
//     updatedAt = json['updated_at'];
//     createdAt = json['created_at'];
//     isEmailVerified = json['is_email_verified'] == 1 ? true : false;
//     role = json['role'];
//     id = json['id'];
//     if (json['roles'] != null) {
//       roles = <Roles>[];
//       json['roles'].forEach((v) {
//         roles!.add(Roles.fromJson(v));
//       });
//     }
//   }
//   factory User.dummyObj() => User(
//       name: "sami", email: "samijan7568@gmail.com", phone: "12399898", id: 1);

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['name'] = name;
//     data['email'] = email;
//     data['phone'] = phone;
//     data['updated_at'] = updatedAt;
//     data['created_at'] = createdAt;
//     data['is_email_verified'] = isEmailVerified;
//     data['role'] = role;
//     data['id'] = id;
//     if (roles != null) {
//       data['roles'] = roles!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class Roles {
//   int? id;
//   String? name;
//   String? guardName;
//   dynamic createdAt;
//   dynamic updatedAt;
//   Pivot? pivot;

//   Roles(
//       {this.id,
//       this.name,
//       this.guardName,
//       this.createdAt,
//       this.updatedAt,
//       this.pivot});

//   Roles.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     guardName = json['guard_name'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     pivot = json['pivot'] != null ? Pivot.fromJson(json['pivot']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['name'] = name;
//     data['guard_name'] = guardName;
//     data['created_at'] = createdAt;
//     data['updated_at'] = updatedAt;
//     if (pivot != null) {
//       data['pivot'] = pivot!.toJson();
//     }
//     return data;
//   }
// }

// class Pivot {
//   int? modelId;
//   int? roleId;
//   String? modelType;

//   Pivot({this.modelId, this.roleId, this.modelType});

//   Pivot.fromJson(Map<String, dynamic> json) {
//     modelId = json['model_id'];
//     roleId = json['role_id'];
//     modelType = json['model_type'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['model_id'] = modelId;
//     data['role_id'] = roleId;
//     data['model_type'] = modelType;
//     return data;
//   }
// }
