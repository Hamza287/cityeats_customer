class EndPoints {
  static const userProfile = 'v1/getUser';
  static const updateProfile = 'v1/userInfoUpdate';
  static const fcmToken = 'customer/v1/update/fcm';
  static const clearFcmToken = 'customer/v1/clear/fcm';
  static const getGuestUserInfo = 'customer/v1/store_guest_user_info';

  ///
  static const login = 'v1/login';
  static const signUp = 'v1/register';
  static const deleteAccount = 'v1/delete_account';

  static const forgotPassword = 'v1/password/email';
  static const generateOTP = 'v1/resend_otp';
  static const changePassword = 'v1/change-password';

  static const banners = 'customer/v1/banners';
  static const category = 'v1/categoryList';
  static const restaurants = 'customer/v1/resturant/all';
  static const restaurantCat = 'customer/v1/resturant/categories/products';
  static const featureRestaurant = 'customer/v1/resturant/feature';
  static const favRestaurants = 'customer/v1/favorite/restaurants';
  static const categoryRestaurants = 'v1/getRestuarantAndFoodAgainstCategory';
  static const singleRestaurant = 'v1/getRestuarantFood';

  static const addToCart = 'customer/v1/cart/products/add';
  static const myCart = 'customer/v1/cart';
  static const updateProductCount = 'customer/v1/cart/update/product/count';
  static const clearCart = 'customer/v1/cart/clear';
  static const removeItem = 'customer/v1/cart/remove/product';

  static const applyVoucher = '';

  static const allOrder = 'customer/v1/order/all';
  static const specificOrder = 'v1/showOrderById';
  static const placeOrder = 'customer/v1/placeOrder';
  static const completeOrder = 'v1/user/complete_order';
  static const recentOrder = 'v1/getRecentOrder';
  static const cancelOrder = 'customer/v1/cancelOrder';
  static const specificItem = 'customer/v1/food/details';
  static const resetPassword = 'v1/password/reset';
  static const location = 'v1/userAddressAdd';
  static const updateLocation = 'v1/userAddressUpdate';
  static const deleteLocation = 'v1/deleteAddress';
  static const userLocations = 'v1/userAddressList';

  static const verifyOtp = 'v1/verify_otp';

  static const allCoupons = 'customer/v1/coupons/all';
  static const applyCoupon = 'customer/v1/coupon/apply';
  static const dispute = 'customer/v1/dispute/add';
  static const allGroceries = 'customer/v1/grocery_stores/all';
  static const toggleFav = 'customer/v1/add/restaurant/favorite';
  static const search = 'customer/v1/search/by/keyword';
  static const filter = 'customer/v1/filter';
  static const review = 'customer/v1/rider/review';
  static const reviewRest = 'customer/v1/resturant/review';
  static const rideCharges = 'rider/v1/calculate/rider/charges';
}
