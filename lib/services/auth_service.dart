import 'package:city_customer_app/app/app.locator.dart';
import 'package:city_customer_app/app/app.logger.dart';
import 'package:city_customer_app/models/auth_models/login_body.dart';
import 'package:city_customer_app/models/auth_models/signup_body.dart';
import 'package:city_customer_app/models/user_profile.dart';
import 'package:city_customer_app/responses/auth_response.dart';
import 'package:city_customer_app/responses/profile_response.dart';
import 'package:city_customer_app/services/database_service.dart';
import 'package:city_customer_app/services/device_info_service.dart';
import 'package:city_customer_app/services/local_storage_service.dart';
import 'package:city_customer_app/services/notification_service.dart';
import 'package:stacked/stacked.dart';

class AuthService with ListenableServiceMixin {
  AuthService() {
    listenToReactiveValues([userProfile]);
  }

  String? fcmToken;
  late bool _isLogin;
  UserProfile? userProfile;
  get getUserProfile => _getUserProfile();
  static final log = getLogger('AuthService');
  final _dbService = locator<DatabaseService>();
  final _localStorageService = locator<LocalStorageService>();

  get isLogin => _localStorageService.accessToken != null;
  // "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIzIiwianRpIjoiZGI0ZTE1NDRmNDFjNDI4OGFmNzE4MTczMGQ5ODU0MmUyYzk5NGVkZGZkM2Y2NTU4OTM0ZDZiOTZmNGYxOTBmZTdmMTRiOWMxYjM1NTdhYjEiLCJpYXQiOjE2OTk2Nzc2NzcuMzA1OTYyMDg1NzIzODc2OTUzMTI1LCJuYmYiOjE2OTk2Nzc2NzcuMzA1OTY0OTQ2NzQ2ODI2MTcxODc1LCJleHAiOjE3MzEzMDAwNzcuMzA0NzE3MDYzOTAzODA4NTkzNzUsInN1YiI6IjI0MyIsInNjb3BlcyI6W119.XL2oydLl1KtG-1bInm_L1ExeM3G6ibda4Yk_2sk5M6DaPlgTNq0KcsjqW1HwhFTvkGJPlvFGmduLQeaH8bI4Y-oWVOINEVjessl3CsqBUN20QDYXMG9JZ2R2bvTC8HoCShBHA5GeayDuULwIR4pJDnVZj2Rw7OnR8IPxVw0UQQ8fA3ymwkZYNpzCvxzeR9LFCm_z0KIkUP8jK8EECoEk0hjIvy5PSf4RycBfRVRgCzQxPZneC6Vf3RlmggiEgTHt5bd4xUO04vmcfqvyRsN8dWxH2ai8EG3chXjLeHYA7WkgwqqdJD2f8SvrcE83c9sOKbyB5S1-7cfM6ZXt5rBFAH4wS-ZNKZIs5Nm8ptmIz0szz7TXEPbId1ElMePKlz2RmD-u_fckVoazpokj2BxUHqqyEKuI9G8mV1htFp1RkpBty8aBRM1JMt35KSEKj6k64nGcDTvrWCrbRDeKbdkexxS5eJR1K7srlRbaGN4fm_sM8S84QARzbKpqvcdZ5SIkmEqiu3rLTUks4D0faGR8ktEU52m5ATdCMUzpKWlGZjReCrA60xi1fPaG5EW3aFIkgaae2OmYhGFzjZ_2oAyBb24o6DEXTeKSXlYm3wGpD8k5-VxWveve_oHV8bfYkUQ-dcDc4AIOeZj6f5w8ilrNz4dy5i-9-AP09VqT_-UTPcg" !=
  // null;
  set login(val) => val;

  ///
  /// [doSetup] Function does the following things:
  ///   1) Checks if the user is logged then:
  ///       a) Get the user profile data
  ///       b) Updates the user FCM Token
  //
  Future<void> doSetup() async {
    _isLogin = _localStorageService.accessToken != null;
    if (_isLogin) {
      log.d('User is already logged-in');
      // Future.microtask(() async =>
      // );
      await _getUserProfile();
      updateFcmToken();
    } else {
      log.d('@doSetup: User is not logged-in');
    }
  }

  checkLogin(
      // {required void Function() callback}
      ) {
    if (userProfile != null) {
      // callback();
      return true;
    } else {
      // _navigationService.navigateToLoginView();
      return false;
    }
  }

  ///user profile
  Future<dynamic> _getUserProfile() async {
    ProfileResponse response = await _dbService.getUserProfile();
    // _localStorageService.accessToken =
    //     "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIzIiwianRpIjoiZGI0ZTE1NDRmNDFjNDI4OGFmNzE4MTczMGQ5ODU0MmUyYzk5NGVkZGZkM2Y2NTU4OTM0ZDZiOTZmNGYxOTBmZTdmMTRiOWMxYjM1NTdhYjEiLCJpYXQiOjE2OTk2Nzc2NzcuMzA1OTYyMDg1NzIzODc2OTUzMTI1LCJuYmYiOjE2OTk2Nzc2NzcuMzA1OTY0OTQ2NzQ2ODI2MTcxODc1LCJleHAiOjE3MzEzMDAwNzcuMzA0NzE3MDYzOTAzODA4NTkzNzUsInN1YiI6IjI0MyIsInNjb3BlcyI6W119.XL2oydLl1KtG-1bInm_L1ExeM3G6ibda4Yk_2sk5M6DaPlgTNq0KcsjqW1HwhFTvkGJPlvFGmduLQeaH8bI4Y-oWVOINEVjessl3CsqBUN20QDYXMG9JZ2R2bvTC8HoCShBHA5GeayDuULwIR4pJDnVZj2Rw7OnR8IPxVw0UQQ8fA3ymwkZYNpzCvxzeR9LFCm_z0KIkUP8jK8EECoEk0hjIvy5PSf4RycBfRVRgCzQxPZneC6Vf3RlmggiEgTHt5bd4xUO04vmcfqvyRsN8dWxH2ai8EG3chXjLeHYA7WkgwqqdJD2f8SvrcE83c9sOKbyB5S1-7cfM6ZXt5rBFAH4wS-ZNKZIs5Nm8ptmIz0szz7TXEPbId1ElMePKlz2RmD-u_fckVoazpokj2BxUHqqyEKuI9G8mV1htFp1RkpBty8aBRM1JMt35KSEKj6k64nGcDTvrWCrbRDeKbdkexxS5eJR1K7srlRbaGN4fm_sM8S84QARzbKpqvcdZ5SIkmEqiu3rLTUks4D0faGR8ktEU52m5ATdCMUzpKWlGZjReCrA60xi1fPaG5EW3aFIkgaae2OmYhGFzjZ_2oAyBb24o6DEXTeKSXlYm3wGpD8k5-VxWveve_oHV8bfYkUQ-dcDc4AIOeZj6f5w8ilrNz4dy5i-9-AP09VqT_-UTPcg";
    if (response.success) {
      userProfile = response.body;
      log.wtf(userProfile?.id);
      log.d('Got User Data: ${userProfile?.toJson()}');
    } else {
      // logout();
    }
  }

  ///
  /// Updating FCM Token here...
  ///
  Future<dynamic> updateFcmToken() async {
    if (_localStorageService.accessToken == null) {
      return;
    }

    final fcmToken = await locator<NotificationService>().getFcmToken();
    if (fcmToken == null) {
      return;
    }

    final deviceId = await DeviceInfoService().getDeviceId();
    if (deviceId != null) {
      final response = await _dbService.updateFcmToken(deviceId, fcmToken);
      if (response.success) {
        // userProfile?.fcmToken = fcmToken;
      }
    }
  }

  // ///
  Future<dynamic> _clearFcm() async {
    final deviceId = await DeviceInfoService().getDeviceId();
    if (deviceId != null) {
      final response = await _dbService.clearFcmToken(deviceId);
      return response;
    }
  }

  ///sign up (email and pass)
  Future<AuthResponse> signUpWithEmailAndPassword(SignUpBody body) async {
    AuthResponse response = await _dbService.createAccount(body);
    if (response.success) {
      _localStorageService.accessToken = response.accessToken;
      await _getUserProfile();
      await updateFcmToken();
    }
    return response;
  }

  ///login (email and pass)
  Future<AuthResponse> loginWithEmailAndPassword(LoginBody body) async {
    LoginBody loginBody = body;
    AuthResponse response =
        await _dbService.loginWithEmailAndPassword(loginBody);
    log.wtf(response.accessToken);
    if (response.success) {
      _localStorageService.accessToken = response.accessToken;
      await _getUserProfile();
      updateFcmToken();
    }
    return response;
  }

  Future<bool> logout() async {
    _clearFcm();
    _isLogin = false;
    userProfile = null;
    _localStorageService.accessToken = null;
    _localStorageService.address = null;

    return true;
  }

  Future<dynamic> deleteAccount() async {
    final res = await _dbService.deleteAccount();
    logout();
    return res;
  }
}
