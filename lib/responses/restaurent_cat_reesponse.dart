import 'package:city_customer_app/app/app.logger.dart';
import 'package:city_customer_app/responses/base_responses/base_response.dart';
import 'package:city_customer_app/responses/restaurant_response.dart';

int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString());
}

class RestaurantCategoriesResponse extends BaseResponse {
  List<RestaurantCategory>? restaurantCat;
  Restaurant? restaurant;

  RestaurantCategoriesResponse(success, error,
      {this.restaurantCat, this.restaurant})
      : super(success, error: error);

  RestaurantCategoriesResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    if (json['body'] != null) {
      restaurantCat = <RestaurantCategory>[];
      json['body'].forEach((v) {
        restaurantCat?.add(RestaurantCategory.fromJson(v));
      });
      restaurant = Restaurant.fromJson(json['body'].last['restaurant']);
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['error'] = error;
    if (restaurantCat != null) {
      data['body'] = restaurantCat?.map((v) => v.toJson()).toList();
    }
    data['restaurant'] = restaurant?.toJson();

    return data;
  }
}

class RestaurantCategory {
  int? id;
  String? name;
  String? image;
  int? parentId;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? description;
  List<Foods>? foods = [];

  RestaurantCategory(
      {this.id,
      this.name,
      this.image,
      this.parentId,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.description,
      this.foods});

  RestaurantCategory.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']);
    name = json['name'];
    image = json['image'];
    parentId = _parseInt(json['parent_id']);
    status = _parseInt(json['status']);
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    description = json['description'] ?? '';
    if (json['foods'] != null) {
      foods = <Foods>[];
      json['foods'].forEach((v) {
        foods!.add(Foods.fromJson(v));
      });
    }

    ///
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
    data['description'] = description;
    if (foods != null) {
      data['foods'] = foods!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Foods {
  int? id;
  String? name;
  String? description;
  String? image;
  int? categoryId;
  String? variations;
  String? choiceOptions;
  String? price;
  String? tax;
  String? taxType;
  String? discount;
  String? discountType;
  String? availableTimeStarts;
  String? availableTimeEnds;
  int? veg;
  int? status;
  int? restaurantId;
  String? createdAt;
  String? updatedAt;
  int? orderCount;
  int? isSuggested;
  String? featuredImage;
  double? totalPrice;
  List<SideItem>? sideItems;
  List<Variants>? variants;
  List<Modifiers>? modifiers;
  double? percentDiscount;
  double? discountedPrice;
  int? ageRestricted;

  Foods({
    this.id,
    this.name,
    this.description,
    this.image,
    this.categoryId,
    this.variations,
    this.choiceOptions,
    this.price,
    this.sideItems,
    this.tax,
    this.taxType,
    this.discount,
    this.discountType,
    this.availableTimeStarts,
    this.availableTimeEnds,
    this.veg,
    this.status,
    this.restaurantId,
    this.createdAt,
    this.updatedAt,
    this.orderCount,
    this.isSuggested,
    this.featuredImage,
    this.totalPrice,
    this.modifiers,
    this.percentDiscount,
    this.ageRestricted,
    this.discountedPrice,
  });

  Foods.fromJson(Map<String, dynamic> json) {
    getLogger("Food").wtf(json['side_items']);
    id = _parseInt(json['id']);
    name = json['name'];
    description = json['description'];
    image = json['image'];
    categoryId = _parseInt(json['category_id']);
    variations = json['variations'];
    choiceOptions = json['choice_options'];
    price = json['price'];
    if (json['side_items'] != null) {
      sideItems = (json['side_items'] as List)
          .map((item) => SideItem.fromJson(item))
          .toList();
    }
    tax = json['tax'];
    taxType = json['tax_type'];
    discount = json['discount'];
    discountType = json['discount_type'];
    availableTimeStarts = json['available_time_starts'];
    availableTimeEnds = json['available_time_ends'];
    veg = _parseInt(json['veg']);
    status = _parseInt(json['status']);
    restaurantId = _parseInt(json['restaurant_id']);
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    orderCount = _parseInt(json['order_count']);
    isSuggested = _parseInt(json['is_suggested']);
    featuredImage = json['featured_image'];
    totalPrice = double.parse(json['total_price'].toString());
    if (json["variants"] != null) {
      variants =
          (json["variants"] as List).map((e) => Variants.fromJson(e)).toList();
    }
    if (json['modifiers'] != null) {
      modifiers = <Modifiers>[];
      json['modifiers'].forEach((v) {
        modifiers!.add(Modifiers.fromJson(v));
      });
    }
    ageRestricted = _parseInt(json['age_restricted']) ?? 0;
    percentDiscount = double.parse(json['discount_percentage']);
    discountedPrice =
        getDiscountedPrice(double.parse(price ?? "0"), percentDiscount ?? 0);
  }
  getDiscountedPrice(double price, double percentDiscount) {
    double discountedPrice = price - (price * (percentDiscount / 100));
    return discountedPrice;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['image'] = image;
    data['category_id'] = categoryId;
    data['variations'] = variations;
    data['choice_options'] = choiceOptions;
    data['price'] = price;
    data['tax'] = tax;
    data['tax_type'] = taxType;
    data['side_items'] = sideItems;
    data['discount'] = discount;
    data['discount_type'] = discountType;
    data['available_time_starts'] = availableTimeStarts;
    data['available_time_ends'] = availableTimeEnds;
    data['veg'] = veg;
    data['status'] = status;
    data['restaurant_id'] = restaurantId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['order_count'] = orderCount;
    data['is_suggested'] = isSuggested;
    data['featured_image'] = featuredImage;
    data['age_restricted'] = ageRestricted;
    data['total_price'] = totalPrice;
    if (sideItems != null) {
      sideItems?.forEach((v) {
        data['side_items'] = v.toJson();
      });
    }
    if (variants != null) {
      variants?.forEach((v) {
        data["variants"] = v.toJson();
      });
    }
    if (modifiers != null) {
      data['modifiers'] = modifiers!.map((v) => v.toJson()).toList();
    }
    data['discount_percentage'] = percentDiscount;
    return data;
  }
}

class Variants {
  int? id;
  int? foodId;
  String? variant;
  double? price;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;
  int? variantId = 0;

  Variants(
      {this.id,
      this.foodId,
      this.variant,
      this.price,
      this.deletedAt,
      this.createdAt,
      this.updatedAt});

  Variants.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json["id"]);
    foodId = _parseInt(json["food_id"]);
    variant = json["variant"];
    price = double.parse(((json['price'] ?? '0').toString()));
    deletedAt = json["deleted_at"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
    variantId = _parseInt(json["variant_id"]) ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["food_id"] = foodId;
    data["variant"] = variant;
    data["price"] = price;
    data["deleted_at"] = deletedAt;
    data["created_at"] = createdAt;
    data["updated_at"] = updatedAt;
    data["variant_id"] = variantId;
    return data;
  }
}

class SideItem {
  int id;
  String name;
  String? description;
  String? image;
  int? categoryId;
  double? price;
  int veg;
  int status;
  DateTime? deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  int restaurantId;
  Pivot? pivot;

  SideItem({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.categoryId,
    required this.price,
    required this.veg,
    required this.status,
    required this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.restaurantId,
    this.pivot,
  });

  factory SideItem.fromJson(Map<String, dynamic> json) {
    return SideItem(
      id: _parseInt(json['id']) ?? 0,
      name: json['name'] ?? "",
      description: json['description'] ?? "",
      image: json['image'] ?? "",
      categoryId: _parseInt(json['category_id']),
      price: double.parse(((json['price'] ?? '0').toString())),
      veg: _parseInt(json['veg']) ?? 0,
      status: _parseInt(json['status']) ?? 0,
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      restaurantId: _parseInt(json['restuarant_id']) ?? 0,
      pivot: json['pivot'] != null ? Pivot.fromJson(json['pivot']) : null,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'category_id': categoryId,
      'price': price,
      'veg': veg,
      'status': status,
      'deleted_at': deletedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'restuarant_id': restaurantId,
      // 'pivot': pivot?.toJson(),
    };
  }
}

class Pivot {
  int foodId;
  int sideItemsId;

  Pivot({required this.foodId, required this.sideItemsId});

  factory Pivot.fromJson(Map<String, dynamic> json) {
    return Pivot(
      foodId: _parseInt(json['food_id']) ?? 0,
      sideItemsId: _parseInt(json['side_items_id']) ?? 0,
    );
  }
}

class Modifiers {
  int? id;
  int? foodId;
  String? name;
  String? type;
  String? optionStatus;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;
  List<SubModifiers>? subModifiers;

  Modifiers(
      {this.id,
      this.foodId,
      this.name,
      this.type,
      this.optionStatus,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.subModifiers});

  Modifiers.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']);
    foodId = _parseInt(json['food_id']);
    name = json['name'];
    type = json['type'];
    optionStatus = json['option_status'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['sub_modifiers'] != null) {
      subModifiers = <SubModifiers>[];
      json['sub_modifiers'].forEach((v) {
        subModifiers!.add(SubModifiers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['food_id'] = foodId;
    data['name'] = name;
    data['type'] = type;
    data['option_status'] = optionStatus;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (subModifiers != null) {
      data['sub_modifiers'] = subModifiers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubModifiers {
  int? id;
  int? modifierId;
  int? cartmodifierProductId;
  int? submodifierId;
  String? name;
  double? price;
  String? description;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;
  bool? isSelected;

  SubModifiers(
      {this.id,
      this.modifierId,
      this.cartmodifierProductId,
      this.submodifierId,
      this.name,
      this.price,
      this.description,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.isSelected = false});

  SubModifiers.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']);
    modifierId = _parseInt(json['modifier_id']);
    submodifierId = _parseInt(json['sub_modifier_id']);
    cartmodifierProductId = _parseInt(json['cart_modifier_products_id']);
    name = json['name'];
    price = double.parse(((json['price'] ?? '0').toString()));
    description = json['description'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['modifier_id'] = modifierId;
    data['cart_modifier_products_id'] = cartmodifierProductId;
    data['sub_modifier_id'] = submodifierId;
    data['name'] = name;
    data['price'] = price;
    data['description'] = description;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
