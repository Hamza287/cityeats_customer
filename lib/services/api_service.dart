// ignore_for_file: unrelated_type_equality_checks

import 'package:city_customer_app/app/app.dialogs.dart';
import 'package:city_customer_app/app/app.locator.dart';
import 'package:city_customer_app/app/app.logger.dart';
import 'package:city_customer_app/responses/base_responses/request_response.dart';
import 'package:city_customer_app/services/config_service.dart';
import 'package:city_customer_app/services/local_storage_service.dart';
import 'package:city_customer_app/services/token_interceptor_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:stacked_services/stacked_services.dart';

class ApiService {
  final log = getLogger('ApiService');
  final _config = locator<ConfigService>();
  final _dialogService = locator<DialogService>();

  Future<Dio> launchDio() async {
    await checkInternetConnection();
    String? accessToken =
        // "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIzIiwianRpIjoiZGI0ZTE1NDRmNDFjNDI4OGFmNzE4MTczMGQ5ODU0MmUyYzk5NGVkZGZkM2Y2NTU4OTM0ZDZiOTZmNGYxOTBmZTdmMTRiOWMxYjM1NTdhYjEiLCJpYXQiOjE2OTk2Nzc2NzcuMzA1OTYyMDg1NzIzODc2OTUzMTI1LCJuYmYiOjE2OTk2Nzc2NzcuMzA1OTY0OTQ2NzQ2ODI2MTcxODc1LCJleHAiOjE3MzEzMDAwNzcuMzA0NzE3MDYzOTAzODA4NTkzNzUsInN1YiI6IjI0MyIsInNjb3BlcyI6W119.XL2oydLl1KtG-1bInm_L1ExeM3G6ibda4Yk_2sk5M6DaPlgTNq0KcsjqW1HwhFTvkGJPlvFGmduLQeaH8bI4Y-oWVOINEVjessl3CsqBUN20QDYXMG9JZ2R2bvTC8HoCShBHA5GeayDuULwIR4pJDnVZj2Rw7OnR8IPxVw0UQQ8fA3ymwkZYNpzCvxzeR9LFCm_z0KIkUP8jK8EECoEk0hjIvy5PSf4RycBfRVRgCzQxPZneC6Vf3RlmggiEgTHt5bd4xUO04vmcfqvyRsN8dWxH2ai8EG3chXjLeHYA7WkgwqqdJD2f8SvrcE83c9sOKbyB5S1-7cfM6ZXt5rBFAH4wS-ZNKZIs5Nm8ptmIz0szz7TXEPbId1ElMePKlz2RmD-u_fckVoazpokj2BxUHqqyEKuI9G8mV1htFp1RkpBty8aBRM1JMt35KSEKj6k64nGcDTvrWCrbRDeKbdkexxS5eJR1K7srlRbaGN4fm_sM8S84QARzbKpqvcdZ5SIkmEqiu3rLTUks4D0faGR8ktEU52m5ATdCMUzpKWlGZjReCrA60xi1fPaG5EW3aFIkgaae2OmYhGFzjZ_2oAyBb24o6DEXTeKSXlYm3wGpD8k5-VxWveve_oHV8bfYkUQ-dcDc4AIOeZj6f5w8ilrNz4dy5i-9-AP09VqT_-UTPcg";
        locator<LocalStorageService>().accessToken;

    Dio dio = Dio();
    dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
    dio.interceptors.add(TokenInterceptorService());
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers["accept"] = 'application/json';
    dio.options.headers["Authorization"] = 'Bearer $accessToken';

    dio.options.followRedirects = false;
    // *STOP REQUESTING IN CASE OF TIMEOUT OR SLOW INTERNET CONNECTION
    // dio.options.connectTimeout = const Duration(seconds: 20);
    // dio.options.receiveTimeout = const Duration(seconds: 20);
    // dio.options.sendTimeout = const Duration(seconds: 20);

    dio.options.validateStatus = (s) {
      if (s != null) {
        return s < 500;
      } else {
        return false;
      }
    };
    return dio;
  }

  checkInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      _showDialog();
      return;
    }
  }

  _showDialog() {
    _dialogService.showCustomDialog(
      variant: DialogType.error,
      title: 'No Internet',
      description: "You have no internet connection! please connect to connect",
    );
  }

  get({required String endPoint, params}) async {
    String? errorMessage;
    try {
      Dio dio = await launchDio();
      final response = await dio.get('${_config.baseUrl}/$endPoint',
          queryParameters: params);

      // Dio full response error handling checks
      return getResponse(response);
    } catch (error) {
      log.e('@get error $error');
      log.e('@get error message: $errorMessage');
    }
    return RequestResponse.fromJson({'success': false, 'error': errorMessage});
  }

  post({required String endPoint, data, queryParameters}) async {
    final Response response;
    String? errorMessage;
    try {
      log.wtf('post base url:${_config.baseUrl}/$endPoint');
      Dio dio = await launchDio();
      response = await dio.post('${_config.baseUrl}/$endPoint',
          data: data, queryParameters: queryParameters);

      // Dio full response error handling checks
      // Dio full response error handling checks
      log.wtf('@get response $response');
      return getResponse(response);
    } catch (error) {
      log.e('@get error $error');
      log.e('@get error message: $errorMessage');
    }
    return RequestResponse.fromJson({'success': false, 'error': errorMessage});
  }

  put({required String endPoint, data}) async {
    String? errorMessage;
    try {
      Dio dio = await launchDio();
      final response =
          await dio.put('${_config.baseUrl}/$endPoint', data: data);
      // Dio full response error handling checks
      return getResponse(response);
    } catch (error) {
      log.e('@get error $error');
      log.e('@get error message: $errorMessage');
    }
    return RequestResponse.fromJson({'success': false, 'error': errorMessage});
  }

  delete({required String endPoint, params}) async {
    String? errorMessage;
    try {
      Dio dio = await launchDio();
      final response = await dio.delete('${_config.baseUrl}/$endPoint',
          queryParameters: params);
      // Dio full response error handling checks
      return getResponse(response);
    } catch (error) {
      log.e('@get error $error');
      log.e('@get error message: $errorMessage');
    }
    return RequestResponse.fromJson({'success': false, 'error': errorMessage});
  }

  getResponse(Response response) {
    if (response.statusCode.toString().contains("5")) {
      // For 5xx errors, try to get error from response body first, then fallback to status message
      final errorFromBody = response.data is Map && response.data['error'] != null
          ? response.data['error']
          : null;
      return RequestResponse(false,
          error: errorFromBody ?? response.statusMessage ?? "server error");
    }
    if (response.statusCode.toString().contains("4")) {
      // For 4xx errors, parse the error from response body (which contains the actual error message)
      // The response.data should contain {"success":false,"error":"Unauthorised",...}
      if (response.data is Map && response.data['error'] != null) {
        // Parse the full response to get the actual error message
        return RequestResponse.fromJson(response.data);
      } else {
        // Fallback to status message if error is not in body
        return RequestResponse(false,
            error: response.statusMessage ?? "unAuthenticated");
      }
    } else {
      return RequestResponse.fromJson(response.data);
    }
  }
}
