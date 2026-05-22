class AddToCartBody {
  int? restaurantId;
  List<Products>? products;
  List<CartSideItem>? sideItems;
  List<int>? subModifiers;
  List<CartVariants>? variants;
  String? token;

  AddToCartBody(
      {this.restaurantId,
      this.products,
      this.variants,
      this.token,
      this.subModifiers});

  AddToCartBody.fromJson(Map<String, dynamic> json) {
    restaurantId = json['restaurant_id'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(Products.fromJson(v));
      });
    }
    subModifiers = json['sub_modifiers'];
    // if (json['sub_modifiers'] != null) {
    //   subModifiers = <int>[];

    // }
    if (json['side_items'] != null) {
      sideItems = <CartSideItem>[];
      json['side_items'].forEach((v) {
        sideItems?.add(CartSideItem.fromJson(v));
      });
    }
    if (json['variants'] != null) {
      variants = <CartVariants>[];
      json['variants'].forEach((v) {
        variants!.add(CartVariants.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['restaurant_id'] = restaurantId;
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }

    data['sub_modifiers'] = subModifiers;
    // if (sideItems != null) {
    //   data['side_items'] = sideItems!.map((v) => v.toJson()).toList();
    // }
    // if (variants != null) {
    //   data['variants'] = variants!.map((e) => e.toJson()).toList();
    // }

    // if (variants != null) {
    //   data['variants'] = variants!.map((e) => e.toJson()).toList();
    // }

    return data;
  }
}

class Products {
  int? id;
  int? quantity;

  Products({this.id, this.quantity});

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quantity = json['item_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['item_count'] = quantity;
    return data;
  }
}

class CartSideItem {
  int? id;

  CartSideItem({this.id});

  CartSideItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    return data;
  }
}

class CartVariants {
  int? variantId;
  int? quantity;

  CartVariants({this.variantId, this.quantity});

  CartVariants.fromJson(Map<String, dynamic> json) {
    variantId = json['id'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = variantId;
    data['quantity'] = quantity;
    return data;
  }
}
