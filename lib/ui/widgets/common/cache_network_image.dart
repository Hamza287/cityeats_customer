// ignore_for_file: avoid_print

import 'package:cached_network_image/cached_network_image.dart';
import 'package:city_customer_app/constants/asesets.dart';
import 'package:city_customer_app/ui/common/app_colors.dart';
import 'package:flutter/material.dart';

class NetworkImageWidget extends StatelessWidget {
  const NetworkImageWidget({
    Key? key,
    required this.url,
    this.isProfilePic = false,
    this.radius = 50,
    this.height,
    this.width,
    this.topLeftRadius,
    this.topRightRadius,
    this.bottomLeftRadius,
    this.bottomRightRadius,
  }) : super(key: key);

  final String url;
  final double radius;
  final bool isProfilePic;
  final double? height, width;
  final double? topLeftRadius, topRightRadius;
  final double? bottomLeftRadius, bottomRightRadius;

  @override
  Widget build(BuildContext context) {
    return isProfilePic
        ? CircleAvatar(
            radius: radius,
            backgroundColor: kcGreyColor,
            backgroundImage: const NetworkImage(
                "https://media.istockphoto.com/id/1300845620/vector/user-icon-flat-isolated-on-white-background-user-symbol-vector-illustration.jpg?s=612x612&w=0&k=20&c=yBeyba0hUkh14_jgv1OKqIH0CCSWU_4ckRkAoy2p73o="),
            foregroundImage: NetworkImage(url.isEmpty
                ? "https://media.istockphoto.com/id/1300845620/vector/user-icon-flat-isolated-on-white-background-user-symbol-vector-illustration.jpg?s=612x612&w=0&k=20&c=yBeyba0hUkh14_jgv1OKqIH0CCSWU_4ckRkAoy2p73o="
                : url),
          )
        // .animate(delay: 300.ms)
        // .moveX()
        // .fadeIn(duration: 400.ms)
        : ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(topLeftRadius ?? 0),
              topRight: Radius.circular(topRightRadius ?? 0),
              bottomLeft: Radius.circular(bottomLeftRadius ?? 0),
              bottomRight: Radius.circular(bottomRightRadius ?? 0),
            ),
            child: url.isEmpty
                ? Image.asset(
                    "$kcStaticImagesPath/place_pro.jpeg",
                    fit: BoxFit.cover,
                    height: height,
                    width: width,
                  )
                : CachedNetworkImage(
                    fit: BoxFit.contain,
                    imageUrl: url,

                    height: height,
                    width: width,
                    errorListener: (value) => print(value),
                    // progressIndicatorBuilder: (context, url, progress) =>
                    //     // SpinKitFadingCircle(color: kcPrimaryColor, size: 60),
                    //     Container(
                    //   height: 30.h,
                    //   width: 30.w,
                    //   // margin: EdgeInsets.only(top: 100.h, bottom: 100.h),
                    //   child: CircularProgressIndicator(
                    //     value: progress.progress,
                    //     color: kcPrimaryColor,
                    //   ),
                    // ),
                    imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover))),
                    placeholder: (context, url) => Image.asset(
                        height: height,
                        width: width,
                        "$kcStaticImagesPath/place_pro.jpeg",
                        fit: BoxFit.cover),
                    errorWidget: (context, url, error) => Image.asset(
                        "$kcStaticImagesPath/place_pro.jpeg",
                        fit: BoxFit.cover),
                  ),
          );
    // .animate(delay: 200.ms).moveX().fadeIn(duration: 300.ms);
  }
}
