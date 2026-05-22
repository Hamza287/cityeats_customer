// import 'dart:io';
import 'package:city_customer_app/app/app.locator.dart';
import 'package:city_customer_app/constants/end_points.dart';
import 'package:city_customer_app/models/add_to_cart.dart';
import 'package:city_customer_app/models/auth_models/login_body.dart';
import 'package:city_customer_app/models/auth_models/signup_body.dart';
import 'package:city_customer_app/models/coupon_model.dart';
import 'package:city_customer_app/models/filter.dart';
import 'package:city_customer_app/models/guest_user.dart';
import 'package:city_customer_app/models/guest_user_body.dart';
import 'package:city_customer_app/models/location_body.dart';
import 'package:city_customer_app/models/update_profile_body.dart';
import 'package:city_customer_app/responses/add_to_cart_response.dart';
import 'package:city_customer_app/responses/addresses_response.dart';
import 'package:city_customer_app/responses/auth_response.dart';
import 'package:city_customer_app/responses/base_responses/base_response.dart';
import 'package:city_customer_app/responses/base_responses/request_response.dart';
import 'package:city_customer_app/responses/cart_response.dart';
import 'package:city_customer_app/responses/categories_response.dart';
import 'package:city_customer_app/responses/order_response.dart';
import 'package:city_customer_app/responses/profile_response.dart';
import 'package:city_customer_app/responses/restaurant_response.dart';
import 'package:city_customer_app/responses/restaurent_cat_reesponse.dart';
import 'package:city_customer_app/responses/single_restaurant_response.dart';
import 'package:city_customer_app/responses/specific_food_response.dart';
import 'package:city_customer_app/responses/specific_order_response.dart';
import 'package:city_customer_app/responses/update_profile_response.dart';
import 'package:city_customer_app/services/auth_service.dart';
import 'package:city_customer_app/services/database_repo_service.dart';
import 'package:dio/dio.dart';

import '../responses/banners_response.dart';
// import 'package:dio/dio.dart';

class DatabaseService extends DatabaseRepoService {
  get resId => null;

  // ///profile
  // @override
  Future<ProfileResponse> getUserProfile() async {
    final RequestResponse response =
        await apiServices.get(endPoint: EndPoints.userProfile);
    return ProfileResponse.fromJson(response.data);
  }

  Future<GuestUserProfileResponse> getGuestUserInfo(GuestUserBody body) async {
    final RequestResponse response = await apiServices.post(
        endPoint: EndPoints.getGuestUserInfo, data: body.toJson());
    return GuestUserProfileResponse.fromJson(response.data);
  }

  // ///token update
  // @override
  Future<BaseResponse> updateFcmToken(String deviceId, String token) async {
    final RequestResponse response = await apiServices.post(
      endPoint: EndPoints.fcmToken,
      data: {
        'device_id': deviceId,
        'fcm_token': token,
      },
    );
    return BaseResponse.fromJson(response.data);
  }

  // ///token clear
  // @override
  Future<BaseResponse> clearFcmToken(String deviceId) async {
    final RequestResponse response = await apiServices.post(
      endPoint: EndPoints.clearFcmToken,
      data: {'device_id': deviceId},
    );
    return BaseResponse.fromJson(response.data);
  }

  ///create account
  // @override
  Future<AuthResponse> createAccount(SignUpBody body) async {
    final RequestResponse response = await apiServices.post(
      endPoint: EndPoints.signUp,
      queryParameters: body.toJson(),
    );
    return AuthResponse.fromJson(response.data);
  }

  ///login (email,password)
  // @override
  Future<AuthResponse> loginWithEmailAndPassword(LoginBody body) async {
    final RequestResponse response =
        await apiServices.post(endPoint: EndPoints.login, data: body.toJson());
    return AuthResponse.fromJson(response.data);
  }

  ///login (email,password)
  // @override
  Future<RequestResponse> forgotPassword(String email) async {
    final RequestResponse response = await apiServices
        .post(endPoint: EndPoints.forgotPassword, data: {"email": email});
    return response;
  }

  ///reset password
  // @override
  Future<RequestResponse> resetPassword(
      String otp, String email, String newPass) async {
    final RequestResponse response = await apiServices.post(
        endPoint: EndPoints.resetPassword,
        data: {"email": email, "code": otp, "password": newPass});
    return response;
  }

  ///update location
  // @override
  Future<dynamic> updateLocation(LocationBody body) async {
    final RequestResponse response = await apiServices.post(
        endPoint:
            body.id != null ? EndPoints.updateLocation : EndPoints.location,
        data: body.toJson());
    return response.data;
  }

  ///verify otp
  // @override
  Future<AuthResponse> verifyOTP(String email, String otp) async {
    // Log the OTP being sent for debugging
    print(
        "🔐 verifyOTP - Email: $email, OTP Code: $otp, OTP Length: ${otp.length}");

    final requestData = {"email": email, "code": otp};
    print("🔐 verifyOTP - Request Data: $requestData");

    final RequestResponse response = await apiServices.post(
        endPoint: EndPoints.verifyOtp, data: requestData);

    // Log the full response for debugging
    print("🔐 verifyOTP - Full Response: ${response.data}");
    print("🔐 verifyOTP - Response Success: ${response.success}");
    print("🔐 verifyOTP - Response Error: ${response.error}");

    final authResponse = AuthResponse.fromJson(response.data);
    // rawData is already stored in AuthResponse.fromJson
    return authResponse;
  }

  ///sent otp
  // @override
  Future<dynamic> generateOTP(String email) async {
    final Map<String, dynamic> data = {
      "email": email,
      "send_via_email": true, // Always send via email as per API update
    };
    final RequestResponse response =
        await apiServices.post(endPoint: EndPoints.generateOTP, data: data);
    return response.data;
  }

  ///banners
  Future<BannersResponse> fetchBanners() async {
    final RequestResponse response =
        await apiServices.get(endPoint: EndPoints.banners);
    return BannersResponse.fromJson(response.data);
  }

  ///categories
  Future<CategoriesResponse> fetchCategories() async {
    final RequestResponse response =
        await apiServices.get(endPoint: EndPoints.category);
    return CategoriesResponse.fromJson(response.data);
  }

  //all restaurant
  Future<RestaurantsResponse> fetchAllRestaurants(int? addressId) async {
    final Map<String, dynamic> params = {};
    if (addressId != null) {
      params['address_id'] = addressId;
    }

    final RequestResponse response =
        await apiServices.get(endPoint: EndPoints.restaurants, params: params);
    return RestaurantsResponse.fromJson(response.data);
  }

  //feature restaurants
  Future<RestaurantsResponse> fetchFeatureRestaurants(int? addressId) async {
    final Map<String, dynamic> params = {};
    if (addressId != null) {
      params['address_id'] = addressId;
    }

    final RequestResponse response = await apiServices.get(
        endPoint: EndPoints.featureRestaurant, params: params);
    return RestaurantsResponse.fromJson(response.data);
  }

  //fav restaurants
  Future<RestaurantsResponse> fetchFavoriteRestaurants(int? addressId) async {
    final Map<String, dynamic> params = {};
    if (addressId != null) {
      params['address_id'] = addressId;
    }
    final RequestResponse response = await apiServices.get(
        endPoint: EndPoints.favRestaurants, params: params);
    return RestaurantsResponse.fromJson(response.data);
  }

//restaurant Category
  Future<RestaurantCategoriesResponse> fetchRestaurantCat(int id) async {
    final RequestResponse response = await apiServices.get(
      endPoint: "${EndPoints.restaurantCat}/$id",
    );
    return RestaurantCategoriesResponse.fromJson(response.data);
  }
  // fetch single resturant

  Future<SingleRestaurantResponse> fetchsingleRestaurant(
      int id, int addressId) async {
    final Map<String, dynamic> params = {};

    params['address_id'] = addressId;

    final RequestResponse response = await apiServices.get(
        endPoint: "${EndPoints.singleRestaurant}/$id", params: params);
    return SingleRestaurantResponse.fromJson(response.data);
  }

// fetch Category Restaurants
  Future<RestaurantsResponse> fetchCategoryRestaurants(int id) async {
    final RequestResponse response =
        await apiServices.get(endPoint: "${EndPoints.categoryRestaurants}/$id");
    return RestaurantsResponse.fromJson(response.data);
  }

//add to cart
  Future<AddToCartResponse> addToCart(AddToCartBody body) async {
    final RequestResponse response = await apiServices.post(
        endPoint: EndPoints.addToCart, data: body.toJson());
    return AddToCartResponse.fromJson(response.data);
  }

//fetch my cart
  Future<CartResponse> fetchMyCart() async {
    final RequestResponse response =
        await apiServices.get(endPoint: EndPoints.myCart);
    return CartResponse.fromJson(response.data);
  }

//change my password
  Future<dynamic> changeMyPassword(String oldPass, String newPass) async {
    final RequestResponse response = await apiServices.post(
        endPoint: EndPoints.changePassword,
        data: {"old_password": oldPass, "new_password": newPass});
    return response.data;
  }

  //fetch addresses
  Future<AddressesResponse> fetchAddresses() async {
    final RequestResponse response =
        await apiServices.get(endPoint: EndPoints.userLocations);
    return AddressesResponse.fromJson(response.data);
  }

  //increment product count
  Future<CartResponse> incrementProductCount(int productId, int count,
      int variantId, bool isVariant, List<int> subModIds) async {
    RequestResponse response;
    if (isVariant) {
      response = await apiServices.post(
        endPoint: EndPoints.updateProductCount,
        data: {
          "product_id": productId,
          "item_count": count,
          "variant_id": variantId
        },
      );
    } else {
      response = await apiServices.post(
        endPoint: EndPoints.updateProductCount,
        data: {
          "product_id": productId,
          "item_count": count,
          "sub_modifiers": subModIds
        },
      );
    }

    return CartResponse.fromJson(response.data);
  }

  //create order
  Future<dynamic> createOrder(body) async {
    log.w("isScheduled: ${body.isScheduled}");
    // log.w("chosenSlotID: ${body!.chosenSlotID}");
    final RequestResponse response = await apiServices.post(
        endPoint: EndPoints.placeOrder, data: body.toJson());
    return response.data;
  }

  //clear cart

  Future<dynamic> clearCart() async {
    final RequestResponse response = await apiServices.get(
      endPoint: EndPoints.clearCart,
    );
    return response.data;
  }

  //remove item from cart
  Future<CartResponse> removeItemFromCart(int id) async {
    final RequestResponse response = await apiServices.get(
      endPoint: "${EndPoints.removeItem}/$id",
    );
    return CartResponse.fromJson(response.data);
  }

  //fetch my orders
  Future<OrderResponse> fetchMyOrders() async {
    final RequestResponse response = await apiServices.get(
      endPoint: EndPoints.allOrder,
    );
    // return CartResponse.fromJson(response.data);
    return OrderResponse.fromJson(response.data);
  }

  //fetch order details
  Future<SpecificOrderResponse> fetchOrderDetails(int id) async {
    final RequestResponse response = await apiServices.get(
      endPoint: "${EndPoints.specificOrder}/$id",
    );
    // return CartResponse.fromJson(response.data);
    return SpecificOrderResponse.fromJson(response.data);
  }

  ///
  //fetch coupons
  Future<CouponModel> fetchAllCoupons(int addressId) async {
    // Debug: Log request details
    print("🎟️ fetchAllCoupons - Endpoint: ${EndPoints.allCoupons}");
    print("🎟️ fetchAllCoupons - Params: {address_id: $addressId}");

    final RequestResponse response = await apiServices.get(
      endPoint: EndPoints.allCoupons,
      params: {'address_id': addressId},
    );

    // Debug: Log response details
    print("🎟️ fetchAllCoupons - Response Success: ${response.success}");
    print("🎟️ fetchAllCoupons - Response Data: ${response.data}");
    print("🎟️ fetchAllCoupons - Response Error: ${response.error}");

    return CouponModel.fromJson(response.data);
  }

  ///
  //apply coupon
  Future<CartResponse> applyCoupons(String code, int cartId) async {
    final RequestResponse response = await apiServices.post(
        endPoint: EndPoints.applyCoupon,
        data: {"cart_id": cartId, "coupon_code": code});
    return CartResponse.fromJson(response.data);
  }

  ///
  //delete location
  Future<SpecificFoodResponse> specificFoodDetails(int id) async {
    final RequestResponse response = await apiServices.get(
      endPoint: "${EndPoints.specificItem}/$id",
    );
    return SpecificFoodResponse.fromJson(response.data);
  }

  //delete location
  Future<dynamic> deleteLocation(int id) async {
    final RequestResponse response = await apiServices.get(
      endPoint: "${EndPoints.deleteLocation}/$id",
    );
    return response.data;
  }

  ///
  //update profile
  Future<UpdateProfileResponse> updateProfile(UpdateProfileBody body) async {
    final formData = FormData.fromMap({
      if (body.profileImage?.path != null)
        'image': await MultipartFile.fromFile(body.profileImage?.path ?? ""),
      'name': body.name,
      'contact_number': body.phone,
    });

    final RequestResponse response = await apiServices.post(
      endPoint: EndPoints.updateProfile,
      data: formData,
    );

    if (response.success) {
      await locator<AuthService>().getUserProfile;
    }
    return UpdateProfileResponse.fromJson(response.data);
  }

  ///
  //delete location
  Future<dynamic> deleteAccount() async {
    final RequestResponse response = await apiServices.get(
      endPoint: EndPoints.deleteAccount,
    );
    return response.data;
  }

  ///
  //cancel order
  Future<dynamic> cancelOrder(int orderId) async {
    final RequestResponse response =
        await apiServices.get(endPoint: "${EndPoints.cancelOrder}/$orderId");
    return response.data;
  }

  //dispute
  Future<dynamic> dispute(String obj, String title, String desc) async {
    final RequestResponse response = await apiServices.post(
        endPoint: EndPoints.dispute,
        data: {
          "feedback_for": title,
          "feedback_title": title,
          "feedback_description": desc
        });
    return response.data;
  }

  //get all groceries
  Future<RestaurantsResponse> getAllGroceries() async {
    final RequestResponse response =
        await apiServices.get(endPoint: EndPoints.allGroceries);
    return RestaurantsResponse.fromJson(response.data);
  }

  //toggle favorite
  Future<dynamic> toggleFavorite(int restaurantId) async {
    final RequestResponse response =
        await apiServices.get(endPoint: "${EndPoints.toggleFav}/$restaurantId");
    return response.data;
  }

  //get delivery fee
  Future<RequestResponse> getDeliveryCharges(int cartId, int addId) async {
    final requestBody = {
      "cart_id": cartId,
      "address_id": addId,
    };

    // Debug: Log request details
    print("🚚 getDeliveryCharges - Endpoint: ${EndPoints.rideCharges}");
    print("🚚 getDeliveryCharges - Request Body: $requestBody");
    print(
        "🚚 getDeliveryCharges - cart_id type: ${cartId.runtimeType}, value: $cartId");
    print(
        "🚚 getDeliveryCharges - address_id type: ${addId.runtimeType}, value: $addId");

    final RequestResponse response = await apiServices.post(
        endPoint: EndPoints.rideCharges, data: requestBody);

    // Debug: Log response details
    print("🚚 getDeliveryCharges - Response Success: ${response.success}");
    print("🚚 getDeliveryCharges - Response Data: ${response.data}");
    print("🚚 getDeliveryCharges - Response Error: ${response.error}");

    return response;
  }

  //search
  Future<RestaurantsResponse> search(String keyword) async {
    final RequestResponse response = await apiServices
        .post(endPoint: EndPoints.search, data: {"keyword": keyword});
    return RestaurantsResponse.fromJson(response.data);
  }

  //filter
  Future<RestaurantsResponse> filter(FilterBody body) async {
    final RequestResponse response =
        await apiServices.post(endPoint: EndPoints.filter, data: body.toJson());
    return RestaurantsResponse.fromJson(response.data);
  }

  //
  Future<RequestResponse> submitReview(
      int orderId, int riderId, double ratings, String review) async {
    final RequestResponse response =
        await apiServices.post(endPoint: EndPoints.review, data: {
      "order_id": orderId,
      "review_star": ratings,
      "review_remarks": review,
      "rider_id": riderId,
    });
    return response;
  }

  //
  Future<RequestResponse> submitReviewForRest(
      int orderId, int restaurantId, double ratings, String review) async {
    final RequestResponse response =
        await apiServices.post(endPoint: EndPoints.reviewRest, data: {
      "order_id": orderId,
      "restaurant_id": restaurantId,
      "review_star": ratings,
      "review_remarks": review,
    });
    return response;
  }
}
