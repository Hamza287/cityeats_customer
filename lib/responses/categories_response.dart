import 'package:city_customer_app/responses/base_responses/base_response.dart';

int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString());
}

class CategoriesResponse extends BaseResponse {
  List<Category> categoryList = [];

  CategoriesResponse(success, error) : super(success, error: error);

  CategoriesResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    success = json['success'] ?? false;
    error = json['error'];
    if (json['body'] != null) {
      categoryList = <Category>[];
      json['body'].forEach((v) {
        categoryList.add(Category.fromJson(v));
      });
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['error'] = error;
    if (categoryList.isNotEmpty) {
      data['body'] = categoryList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Category {
  late int id;
  String? name;
  String? image;
  int? parentId;
  int? status;
  String? createdAt;
  String? updatedAt;
  List<dynamic>? childrenRecursive;

  Category(
      {required this.id,
      this.name,
      this.image,
      this.parentId,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.childrenRecursive});

  Category.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']) ?? 0;
    name = json['name'];
    image = json['image'];
    parentId = _parseInt(json['parent_id']);
    status = _parseInt(json['status']);
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['children_recursive'] != null) {
      // childrenRecursive = <Null>[];
      // json['children_recursive'].forEach((v) {
      // childrenRecursive!.add(new Null.fromJson(v));
      // });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['parent_id'] = parentId;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (childrenRecursive != null) {
      // data['children_recursive'] =
      // this.childrenRecursive!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
