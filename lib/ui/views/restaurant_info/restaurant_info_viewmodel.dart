import 'package:city_customer_app/app/app.locator.dart';
import 'package:city_customer_app/services/date_time_service.dart';
import 'package:stacked/stacked.dart';

class RestaurantInfoViewModel extends BaseViewModel {
  final dateTimeService = locator<DateTimeService>();
}
