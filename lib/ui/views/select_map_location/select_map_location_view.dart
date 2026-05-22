import 'package:city_customer_app/ui/buttons/custom_elevated_button.dart';
import 'package:city_customer_app/ui/common/app_colors.dart';
import 'package:city_customer_app/ui/widgets/common/custom_text_field/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';

import 'select_map_location_viewmodel.dart';

class SelectMapLocationView extends StackedView<SelectMapLocationViewModel> {
  const SelectMapLocationView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    SelectMapLocationViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: _appBar(context),
      body: Stack(children: [
        _mapSection(viewModel),
        _searchBar(viewModel),
        if (viewModel.isLocationSearched) _locationList(context, viewModel),
        _confirmButton(viewModel)
      ]),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      title: Text("Search Location",
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontSize: 14.sp)),
    );
  }

  Positioned _confirmButton(SelectMapLocationViewModel viewModel) {
    return Positioned(
      bottom: 40.h,
      left: 20.w,
      right: 20.w,
      child: CustomElevatedButton(
        text: "Confirm Location",
        onPressed: () {
          viewModel.showBottomSheet();
          // viewModel.navigateToBack();
        },
      ),
    );
  }

  Positioned _locationList(
      BuildContext context, SelectMapLocationViewModel viewModel) {
    return Positioned(
      top: 86.h,
      left: 20.w,
      right: 20.w,
      child: Container(
        width: 374.w,
        // height: 357.h,
        color: kcWhiteColor,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "Suggestions",
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(fontSize: 16.sp),
          ),
          10.verticalSpace,
          ListView.separated(
            itemCount: viewModel.prediction.length,
            shrinkWrap: true,
            itemBuilder: (context, index) => placeTile(
              context,
              viewModel.prediction[index].placeId ?? "",
              viewModel.prediction[index].structuredFormatting?.mainText ?? "",
              viewModel.prediction[index].description ?? "",
              viewModel,
            ),
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(thickness: .7, height: .5),
          ),
        ]),
      ),
    );
  }

  Positioned _searchBar(SelectMapLocationViewModel viewModel) {
    return Positioned(
      top: 20.h,
      left: 20.w,
      right: 20.w,
      child: SizedBox(
        width: 350.w,
        child: CustomTextField(
          // onTap: viewModel.clearControllerData,
          focusNode: viewModel.locFocusNode,
          hintText: "Search location",
          onChanged: viewModel.findPlace,
          controller: viewModel.locController,
          prefix: const Icon(Icons.search),
          suffix: GestureDetector(
              onTap: viewModel.setLocationAndMarker,
              child: const Icon(Icons.my_location)),
        ),
      ),
    );
  }

  ListTile placeTile(BuildContext context, String placeId, String title,
      String subTitle, SelectMapLocationViewModel viewModel) {
    return ListTile(
      splashColor: kcGreyColor,
      onTap: () {
        viewModel.locController.text = title;
        viewModel.notifyListeners();
        viewModel.getPlaceAddressDetails(placeId);
      },
      contentPadding: EdgeInsets.zero,
      visualDensity: const VisualDensity(vertical: -4),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall,
      ),
      subtitle: Text(
        subTitle,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }

  _mapSection(SelectMapLocationViewModel viewModel) {
    // Don't show map until location is loaded
    if (viewModel.isLocationLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    
    return GoogleMap(
        zoomControlsEnabled: false,
        zoomGesturesEnabled: true,
        mapType: MapType.normal,
        myLocationEnabled: false,
        markers: viewModel.markers,
        initialCameraPosition:
            CameraPosition(target: viewModel.initialCameraPosition, zoom: 11.0),
        onMapCreated: viewModel.onMapCreated
        // viewModel.mapController?.setMapStyle(kMapStyle);
        );
  }

  @override
  SelectMapLocationViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      SelectMapLocationViewModel();
}
