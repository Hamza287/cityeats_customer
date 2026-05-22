import 'package:city_customer_app/app/app.router.dart';
import 'package:city_customer_app/responses/addresses_response.dart';
import 'package:city_customer_app/services/database_service.dart';
import 'package:city_customer_app/ui/dialogs/confirmation_dialogue.dart';
import 'package:city_customer_app/ui/snackbars/custom_snackbar.dart';
import 'package:city_customer_app/viewModels/location_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';

class SaveAddressesViewModel extends BaseViewModel {
  final _dbService = locator<DatabaseService>();
  final _navigationService = locator<NavigationService>();

  SaveAddressesViewModel() {
    getAddresses();
  }

  List<LocationAddress> addressList = [];

  ///get addresses
  Future<void> getAddresses() async {
    setBusy(true);
    AddressesResponse res = await _dbService.fetchAddresses();
    if (res.success) {
      addressList = res.body ?? [];
    } else {}
    setBusy(false);
  }

  back(LocationAddress address) {
    _navigationService.back(result: address);
  }

  navigateToAddressScreen(LocationAddress? address) {
    _navigationService.navigateToLocationView(address: address);
  }

  /// Show confirmation dialog before deleting address
  Future<void> showDeleteConfirmation(
      BuildContext context, int id, String addressText) async {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: ConfirmationDialog(
              title: "Delete Address",
              subTitle: "Are you sure you want to delete this address?\n\n$addressText",
              onPressed: () async {
                await deleteLocation(context, id);
              },
            ),
          ),
        );
      },
    );
  }

  /// Delete location after confirmation
  Future<void> deleteLocation(BuildContext context, int id) async {
    setBusy(true);
    try {
      final response = await _dbService.deleteLocation(id);
      if (response != null && response['success'] == true) {
        // Remove from local list
        addressList.removeWhere((element) => element.id == id);
        rebuildUi();
        
        // Refresh GlobalLocationViewModel addresses
        if (context.mounted) {
          Provider.of<GlobalLocationViewModel>(context, listen: false)
              .getAddresses();
          
          // Show success message
          showSnackBar(context, message: "Address deleted successfully");
        }
      } else {
        // Show error message if deletion failed
        if (context.mounted) {
          showSnackBar(context, message: "Failed to delete address. Please try again.");
        }
      }
    } catch (e) {
      // Show error message on exception
      if (context.mounted) {
        showSnackBar(context, message: "An error occurred. Please try again.");
      }
    } finally {
      setBusy(false);
    }
  }
}
