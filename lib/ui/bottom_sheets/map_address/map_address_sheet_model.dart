import 'package:city_customer_app/app/app.locator.dart';
import 'package:city_customer_app/app/app.router.dart';
import 'package:city_customer_app/enums/address_lable.dart';
import 'package:city_customer_app/models/location_body.dart';
import 'package:city_customer_app/viewModels/location_view_model.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../services/auth_service.dart';
import '../../../services/database_service.dart';
import '../../../ui/snackbars/custom_snackbar.dart';

class MapAddressSheetModel extends BaseViewModel {
  AddressLabel label = AddressLabel.home;
  final _dbService = locator<DatabaseService>();
  final _authService = locator<AuthService>();
  SheetRequest? request;
  LocationBody? locationBody = LocationBody();
  final _navigationService = locator<NavigationService>();

  final TextEditingController buildingController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController zipcodeController = TextEditingController();
  final log = Logger();
  bool isTapped = false;

  MapAddressSheetModel(this.request) {
    locationBody = request?.data as LocationBody?;

    if (locationBody != null) {
      toggleLabel(label);
    } else {
      locationBody = LocationBody();
    }
    toggleLabel(getType(locationBody?.label ?? ""));
  }

  getType(String label) {
    return label == "home"
        ? AddressLabel.home
        : label == "office"
            ? AddressLabel.office
            : AddressLabel.other;
  }

  toggleLabel(AddressLabel label) {
    this.label = label;
    locationBody?.label = label.name;
    rebuildUi();
  }

  navigateToBack() {
    _navigationService.back();
  }

  onTapped() {
    isTapped = true;
    rebuildUi();
  }

  Future<void> requestConfirmLocation(context) async {
    // Check if user is logged in - if guest, navigate to login
    if (!_authService.checkLogin()) {
      showSnackBar(context, message: "Please Login First");
      _navigationService.back(); // Close the bottom sheet
      _navigationService.navigateToLoginView();
      return;
    }
    
    setBusy(true);
    final res = await _dbService.updateLocation(locationBody!);

    // showSnackBar(context,message: res['error']);
    if (res['success'] == true) {
      Provider.of<GlobalLocationViewModel>(context, listen: false)
          .getAddresses();
      _navigationService.clearStackAndShow(Routes.rootView);
    } else {
      log.d("LocationBody: ${locationBody!.toJson()}");
      _navigationService.back();
      _navigationService.back(result: locationBody);

      // _dialogService.showCustomDialog(
      //     variant: DialogType.error, title: "Error", description: res['error']);
    }
    setBusy(false);
  }
}
