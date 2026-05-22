import 'package:city_customer_app/app/app.logger.dart';
import 'package:dio/dio.dart';

class TokenInterceptorService extends Interceptor {
  final log = getLogger('TokenInterceptor');
  // final _localStorageService = locator<LocalStorageService>();

  TokenInterceptorService();
  late final RequestOptions? requestOptions;

  @override
  Future onRequest(RequestOptions? options, handler) async {
    // log.i('@Interceptor.onRequest: Dio Request $options');
    requestOptions = options;
    return handler.next(options!);
  }

  @override
  Future onResponse(Response response, handler) async {
    // log.i('@Interceptor.onResponse: Dio Response $response');
    // if (response.statusCode == 401) {
    //   locator<AuthService>().login = false;
    //   _localStorageService.accessToken = null;
    //   // GoRouter.of(getContext).go(AppRoutes.signIn);
    //   // showSnackBar(message: "unAuthorized User");
    // } else
    if (response.statusCode == 500) {
      //   // GoRouter.of(getContext).go(AppRoutes.serverError);
    } else {
      handler.resolve(response);
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log.i('@Interceptor.onError: Dio Error ${err.error}');
    // getX.Get.snackbar('Request Failed', "${err.message}");

    if (err.message != null) {
      if (err.message!.toLowerCase().contains("timeOut")) {
        // showSnackBar(message: "");
      }
    }
    handler.resolve(
      Response(
        requestOptions: requestOptions!,
        data: {'error': err.message},
        statusCode: 410,
      ),
    );
    super.onError(err, handler);
  }
}
