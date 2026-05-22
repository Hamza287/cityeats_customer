import 'dart:io';

class UpdateProfileBody {
  String? name;
  String? phone;
  File? profileImage;

  UpdateProfileBody({this.name, this.phone, this.profileImage});

  UpdateProfileBody.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
    profileImage = json['profile_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['phone'] = phone;
    data['profile_image'] = profileImage?.path;
    return data;
  }
}
