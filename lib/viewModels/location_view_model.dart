import 'package:city_customer_app/responses/addresses_response.dart';
import 'package:city_customer_app/services/auth_service.dart';
import 'package:city_customer_app/services/local_storage_service.dart';
import 'package:stacked/stacked.dart';

import '../app/app.locator.dart';
import '../services/database_service.dart';

class GlobalLocationViewModel extends BaseViewModel {
  final _dbService = locator<DatabaseService>();
  final localStorageService = locator<LocalStorageService>();
  final _authService = locator<AuthService>();

  LocationAddress? _selectedAddress;

  LocationAddress? get getSelectedAddress => _selectedAddress;

  set selectedAddress(LocationAddress? value) {
    _selectedAddress = value;
    // Save the selected address ID to localStorage for persistence
    if (value != null && value.id != null) {
      localStorageService.addressId = value.id;
    } else if (value == null) {
      // Clear the saved address ID if address is cleared
      localStorageService.addressId = null;
    }
    rebuildUi();
  }

  GlobalLocationViewModel() {
    getAddresses();
  }

  List<LocationAddress> addressList = [];
  bool _addressesLoaded = false;

  bool get addressesLoaded => _addressesLoaded;

  /// Construct a display string from available address fields
  String? getDisplayAddressString(LocationAddress? address) {
    if (address == null) return null;

    // If address field is populated and not empty, use it
    if (address.address != null &&
        address.address!.trim().isNotEmpty &&
        address.address != ", ") {
      return address.address;
    }

    // Otherwise, try to construct from available fields
    // Note: LocationAddress model only has: id, lat, lang, type, address, zipCode, userId
    List<String> parts = [];
    if (address.type != null && address.type!.trim().isNotEmpty) {
      parts.add(address.type!);
    }
    if (address.zipCode != null && address.zipCode!.trim().isNotEmpty) {
      parts.add(address.zipCode!);
    }

    return parts.isNotEmpty ? parts.join(", ") : null;
  }

  /// Get the latest timestamp from an address (prefer updated_at, fallback to created_at)
  DateTime? _getLatestTimestamp(LocationAddress address) {
    try {
      if (address.updatedAt != null && address.updatedAt!.isNotEmpty) {
        return DateTime.parse(address.updatedAt!);
      } else if (address.createdAt != null && address.createdAt!.isNotEmpty) {
        return DateTime.parse(address.createdAt!);
      }
    } catch (e) {
      // If parsing fails, return null
    }
    return null;
  }

  /// Find the latest address with valid data
  LocationAddress? _findLatestValidAddress() {
    if (addressList.isEmpty) return null;

    // Filter addresses with valid display strings
    final validAddresses = addressList.where((addr) {
      // Prioritize addresses with valid address field
      if (addr.address != null &&
          addr.address!.trim().isNotEmpty &&
          addr.address != ", ") {
        return true;
      }
      // Fallback to addresses with other displayable fields
      return getDisplayAddressString(addr) != null;
    }).toList();

    if (validAddresses.isEmpty) {
      // If no valid addresses, return the last one in the list (might be incomplete)
      return addressList.last;
    }

    // Find the address with the latest timestamp
    LocationAddress? latestAddress;
    DateTime? latestTimestamp;

    for (var address in validAddresses) {
      final timestamp = _getLatestTimestamp(address);
      if (timestamp != null) {
        if (latestTimestamp == null || timestamp.isAfter(latestTimestamp)) {
          latestTimestamp = timestamp;
          latestAddress = address;
        }
      }
    }

    // If we found a latest address, return it
    if (latestAddress != null) {
      return latestAddress;
    }

    // If no timestamps were parseable, return the last valid address
    return validAddresses.last;
  }

  Future<void> getAddresses() async {
    // Defer setBusy to avoid calling during build phase
    Future.microtask(() => setBusy(true));
    _addressesLoaded = false;

    // Check if user is logged in before fetching addresses
    if (!_authService.isLogin) {
      // User is not logged in, clear addresses
      addressList.clear();
      selectedAddress = null;
      _addressesLoaded = true;
      Future.microtask(() => setBusy(false));
      return;
    }

    // Clear the address list before fetching new addresses
    addressList.clear();

    AddressesResponse res = await _dbService.fetchAddresses();
    if (res.success) {
      res.body?.forEach((element) {
        // Include all addresses, even if address field is null
        // We'll construct display string from available fields
        addressList.add(element);
      });

      // First, check if there's a saved address ID in localStorage
      final savedAddressId = localStorageService.addressId;
      LocationAddress? addressToSelect;

      if (savedAddressId != null && addressList.isNotEmpty) {
        // Try to find the saved address by ID
        try {
          addressToSelect = addressList.firstWhere(
            (addr) => addr.id == savedAddressId,
          );
        } catch (e) {
          // Saved address not found in the list (maybe it was deleted), fall back to latest
          addressToSelect = null;
        }
      }

      // If no saved address found or no saved selection, use the latest valid address
      addressToSelect ??= _findLatestValidAddress();

      if (addressToSelect != null && addressToSelect.id != null) {
        // Always update the selected address with fresh data from API
        // This ensures if the address was updated via API, we get the latest data
        final currentAddressId = _selectedAddress?.id;

        if (currentAddressId != addressToSelect.id) {
          // Different address selected, use setter to save ID to localStorage
          selectedAddress = addressToSelect;
        } else {
          // Same address ID selected, but update with fresh data from API
          // This is important in case the address was edited/updated via API
          // Always update reference with fresh API data to ensure we have latest information
          _selectedAddress = addressToSelect;

          // Always rebuild UI when we get fresh data from API to ensure UI reflects latest state
          // This is especially important after an address update/edit
          rebuildUi();
        }
      } else {
        // No valid addresses found, clear selection
        selectedAddress = null;
      }
      _addressesLoaded = true;
    } else {
      // If API call failed, clear selected address
      selectedAddress = null;
      _addressesLoaded = true;
    }
    Future.microtask(() => setBusy(false));
  }
}
