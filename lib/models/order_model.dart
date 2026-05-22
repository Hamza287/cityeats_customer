class Order {
  int addressId;
  int cartId;
  // int restaurantId;
  // double amount;
  String paymentStatus;
  String paymentMethod;
  String orderType;
  String orderNote;
  late String transactionId;
  // List<int> foodIds;
  // List<double> prices;
  int isScheduled = 0;
  int scheduleSlotId = 0;

  Order({
    required this.transactionId,
    required this.addressId,
    required this.cartId,
    // required this.restaurantId,
    // required this.amount,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.orderType,
    required this.orderNote,
    this.isScheduled = 0,
    this.scheduleSlotId = 0,
    // required this.foodIds,
    // required this.prices,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    List<int> foodIds = [];
    List<double> prices = [];

    // Assuming there can be multiple food items in the order
    for (int i = 0; i < json['food_ids'].length; i++) {
      foodIds.add(json['food_ids'][i]);
      prices.add(json['prices'][i]);
    }

    return Order(
      transactionId: json['transaction_reference'],
      addressId: json['address_id'],
      cartId: json['cart_id'],
      // restaurantId: json['restaurant_id'],
      // amount: json['amount'],
      paymentStatus: json['payment_status'],
      paymentMethod: json['payment_method'],
      orderType: json['order_type'],
      orderNote: json['order_note'],
      isScheduled: json['scheduled'] ?? 0,
      scheduleSlotId: json['schedule_slot_id'] ?? 0,
      // foodIds: foodIds,
      // prices: prices,
    );
  }

  Map<String, dynamic> toJson() {
    // Map<String, dynamic> ids = {};
    // Map<String, dynamic> price = {};
    // Assuming there can be multiple food items in the order
    // for (int i = 0; i < foodIds.length; i++) {
    //   ids['food_id[$i]'] = foodIds[i];
    // }
    // for (int i = 0; i < prices.length; i++) {
    //   price['price[$i]'] = prices[i];
    // } // Using forEach method

    // ids.forEach((key, value) {
    //   print('Key: $key, Value: $value');
    // });
    if (isScheduled == 1) {
      if (addressId == 0) {
        return {
          'transaction_reference': transactionId,
          'cart_id': cartId,
          'payment_status': paymentStatus,
          'payment_method': paymentMethod,
          'order_type': orderType,
          'order_note': orderNote,
          'scheduled': isScheduled,
          'schedule_slot_id': scheduleSlotId,
        };
      } else {
        return {
          'transaction_reference': transactionId,
          'address_id': addressId,
          'cart_id': cartId,
          // 'restaurant_id': restaurantId,
          // 'amount': amount,
          'payment_status': paymentStatus,
          'payment_method': paymentMethod,
          'order_type': orderType,
          'order_note': orderNote,
          'scheduled': isScheduled,
          'schedule_slot_id': scheduleSlotId,
          // 'commission': 0,
          // ids.keys.first.toString(): ids.values.first,
          // ids.entries.first.key: ids.entries.first.value,
          // price.entries.first.key: price.entries.first.value,
        };
      }
    } else {
      if (addressId == 0) {
        return {
          'transaction_reference': transactionId,
          'cart_id': cartId,
          'payment_status': paymentStatus,
          'payment_method': paymentMethod,
          'order_type': orderType,
          'order_note': orderNote,
          'scheduled': isScheduled,
        };
      } else {
        return {
          'transaction_reference': transactionId,
          'address_id': addressId,
          'cart_id': cartId,
          'payment_status': paymentStatus,
          'payment_method': paymentMethod,
          'order_type': orderType,
          'order_note': orderNote,
          'scheduled': isScheduled
        };
      }
    }
  }
}
