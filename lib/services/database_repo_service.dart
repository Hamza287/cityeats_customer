import 'package:city_customer_app/app/app.locator.dart';
import 'package:city_customer_app/app/app.logger.dart';
import 'package:city_customer_app/services/api_service.dart';

abstract class DatabaseRepoService {
  ///log
  var log = getLogger("DatabaseRepoService");

  ///services
  final ApiService _apiServices = locator<ApiService>();
  ApiService get apiServices => _apiServices;
}
