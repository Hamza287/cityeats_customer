// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedBottomsheetGenerator
// **************************************************************************

import 'package:stacked_services/stacked_services.dart';

import 'app.locator.dart';
import '../ui/bottom_sheets/map_address/map_address_sheet.dart';
import '../ui/bottom_sheets/notice/notice_sheet.dart';
import '../ui/bottom_sheets/restaurant_menu/restaurant_menu_sheet.dart';
import '../ui/bottom_sheets/schedule_sheet/schedule_sheet_sheet.dart';

enum BottomSheetType {
  notice,
  mapAddress,
  restaurantMenu,
  scheduleSheet,
}

void setupBottomSheetUi() {
  final bottomsheetService = locator<BottomSheetService>();

  final Map<BottomSheetType, SheetBuilder> builders = {
    BottomSheetType.notice: (context, request, completer) =>
        NoticeSheet(request: request, completer: completer),
    BottomSheetType.mapAddress: (context, request, completer) =>
        MapAddressSheet(request: request, completer: completer),
    BottomSheetType.restaurantMenu: (context, request, completer) =>
        RestaurantMenuSheet(request: request, completer: completer),
    BottomSheetType.scheduleSheet: (context, request, completer) =>
        ScheduleSheetSheet(request: request, completer: completer),
  };

  bottomsheetService.setCustomSheetBuilders(builders);
}
