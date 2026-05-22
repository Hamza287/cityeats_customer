import 'package:city_customer_app/ui/common/app_colors.dart';
// import 'package:ewanc/routes/my.router.dart';
// import 'package:ewanc/ui/common/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AppThemes {
  ///LIGHT THEME

  ThemeData lightTheme = ThemeData(
    appBarTheme: const AppBarTheme(
        surfaceTintColor: kcWhitColor, shadowColor: kcGreyColor),
    hintColor: kSlateGrayColor,
    splashColor: Colors.transparent,
    dividerColor: kRichBlackColor,
    disabledColor: kcPrimaryColor,
    indicatorColor: kcPrimaryColor,
    primaryColor: kcBackgroundColor,
    dialogBackgroundColor: kWhiteColor,
    scaffoldBackgroundColor: kcWhitColor,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    useMaterial3: true,

    ///TEXT FIELD THEME
    inputDecorationTheme: InputDecorationTheme(
      fillColor: kcWhitColor,
      hintStyle: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: kSlateGrayColor,
        fontFamily: GoogleFonts.abhayaLibre().fontFamily,
        height: 1.5,
      ),
      labelStyle: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: kSlateGrayColor.withOpacity(0.7),
        fontFamily: GoogleFonts.abhayaLibre().fontFamily,
        height: 1.5,
      ),
      enabledBorder: outlineBorder,
      border: outlineBorder,
      focusedBorder: outlineBorder.copyWith(
        borderSide: const BorderSide(color: kcPrimaryColor),
      ),
    ),

    ///COLOR SCHEME
    colorScheme: const ColorScheme.light(
      background: kcWhitColor,
      error: kUpsdellRedColor,
      brightness: Brightness.light,
    ),

    ///FLOATING ACTION BUTTON THEME
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: kcBlackColor,
      foregroundColor: kcMediumGrey,
    ),

    ///DIALOG THEME
    dialogTheme: DialogThemeData(
      backgroundColor: kcWhiteColor,
      iconColor: kcPrimaryColor,
      shadowColor: kcGreyColor,
      contentTextStyle: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: kSlateGrayColor,
        height: 1.5,
      ),
      titleTextStyle: TextStyle(
        fontSize: 24.sp,
        fontWeight: FontWeight.w700,
        color: kRichBlackColor,
        letterSpacing: -1,
        height: 1.5,
      ),
    ),

    ///TEXT THEME
    textTheme: GoogleFonts.manropeTextTheme(
      TextTheme(
        bodySmall: TextStyle(
          color: kcBlackColor,
          fontSize: 12.sp,
          fontFamily: GoogleFonts.abhayaLibre().fontFamily,
          fontWeight: FontWeight.w500,
        ),

        bodyLarge: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
          color: kSlateGrayColor,
          fontFamily: GoogleFonts.abhayaLibre().fontFamily,
          height: 1.5,
          letterSpacing: 0.3,
        ),

        bodyMedium: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.normal,
          fontFamily: GoogleFonts.abhayaLibre().fontFamily,
          color: kcBlackColor,
          // height: 1.5,
        ),

        /// displaySmall is used for custom button texts
        displaySmall: TextStyle(
          fontSize: 16.sp,
          fontFamily: GoogleFonts.abhayaLibre().fontFamily,
          fontWeight: FontWeight.w500,
          color: kcWhitColor,
          height: 1.5,
          letterSpacing: 0.2,
        ),

        displayLarge: TextStyle(
          //msgtitle
          fontSize: 18.sp,
          fontWeight: FontWeight.w500,
          color: kRichBlackColor,
          fontFamily: GoogleFonts.abhayaLibre().fontFamily,
          height: 1.5,
          letterSpacing: -0.5,
        ),

        displayMedium: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          fontFamily: GoogleFonts.abhayaLibre().fontFamily,
          color: kRichBlackColor,
          height: 1.5,
        ),

        headlineLarge: GoogleFonts.inter(
          // style: TextStyle(
          fontSize: 24.sp,
          fontWeight: FontWeight.w500,
          color: kcBlackColor,
          height: 1.3,
          // )
        ),

        headlineMedium: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
          height: 1.5,
          fontFamily: GoogleFonts.abhayaLibre().fontFamily,
          letterSpacing: 0.3,
          color: kSlateGrayColor,
        ),

        titleSmall: TextStyle(
          fontSize: 14.sp,
          fontFamily: GoogleFonts.abhayaLibre().fontFamily,
          fontWeight: FontWeight.w500,
          height: 1.4,
          color: kRichBlackColor,
        ),

        titleMedium: TextStyle(
          fontSize: 24.sp,
          fontWeight: FontWeight.w700,
          fontFamily: GoogleFonts.abhayaLibre().fontFamily,
          color: kRichBlackColor,
          letterSpacing: -1,
          height: 1.5,
        ),

        titleLarge: TextStyle(
          fontSize: 24.sp,
          fontWeight: FontWeight.w800,
          fontFamily: GoogleFonts.abhayaLibre().fontFamily,
          height: 1.5,
          letterSpacing: -1,
          color: kBluePigmentColor,
        ),

        labelSmall: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w500,
          fontFamily: GoogleFonts.abhayaLibre().fontFamily,
          color: kSlateGrayColor,
          height: 1.5,
          letterSpacing: 0.4,
        ),

        labelMedium: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          color: kRichBlackColor,
          fontFamily: GoogleFonts.abhayaLibre().fontFamily,
          height: 1.5,
        ),

        labelLarge: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          fontFamily: GoogleFonts.abhayaLibre().fontFamily,
          height: 1.4,
          color: kcCetaceanBlueColor,
          letterSpacing: -0.5,
        ),
      ),
    ),

    // ///CARD THEME
    cardTheme: const CardThemeData(
      color: kcPrimaryColor,
      margin: EdgeInsets.all(8),
      clipBehavior: Clip.none,
    ),

    ///SNACKBAR THEME
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: kcPrimaryColor,
      closeIconColor: kcBackgroundColor,
      behavior: SnackBarBehavior.floating,
    ),

    // ///BUTTON THEME
    buttonTheme: const ButtonThemeData(
      buttonColor: kcPrimaryColor,
      focusColor: kcLightGrey,
      disabledColor: kcGreyColor,
      splashColor: kcMediumGrey,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: kcPrimaryColor,
        onPrimary: kcPrimaryColor,
        secondary: kcPrimaryColor,
        onSecondary: kcPrimaryColor,
        error: kcPrimaryColor,
        onError: kcPrimaryColor,
        background: kcBackgroundColor,
        onBackground: kcPrimaryColor,
        surface: kcPrimaryColor,
        onSurface: kcPrimaryColor,
      ),
      padding: EdgeInsets.all(8),
      height: 40,
      minWidth: 200,
    ),
  );
}

final OutlineInputBorder outlineBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(8.r),
  borderSide: const BorderSide(color: kcGreyColor, width: 1),
);

final customButtonTextStyle = TextStyle(
  fontSize: 16.sp,
  fontWeight: FontWeight.w700,
  color: kLotionColor,
  height: 1.5,
  letterSpacing: 0.2,
);

// /// Date range picker header style
// final headerTextStyle = DateRangePickerHeaderStyle(
//   textAlign: TextAlign.center,
//   textStyle: Theme.of(getContext).textTheme.titleMedium?.copyWith(
//         fontSize: 18.sp,
//         fontWeight: FontWeight.w600,
//         fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
//       ),
// );

// /// Date range picker month view settings
// final monthViewSettings = DateRangePickerMonthViewSettings(
//   dayFormat: 'EEE',
//   viewHeaderStyle: DateRangePickerViewHeaderStyle(
//     textStyle: Theme.of(getContext).textTheme.titleSmall?.copyWith(
//           fontSize: 12.sp,
//           fontWeight: FontWeight.w600,
//           fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
//           color: kGraniteGreyColor,
//         ),
//   ),
// );

// /// Date range picker month cell style
// final monthCellStyle = DateRangePickerMonthCellStyle(
//   textStyle: Theme.of(getContext).textTheme.titleMedium?.copyWith(
//         fontSize: 16.sp,
//         fontWeight: FontWeight.w600,
//         fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
//       ),
//   todayTextStyle: Theme.of(getContext).textTheme.titleMedium?.copyWith(
//         fontSize: 16.sp,
//         fontWeight: FontWeight.w600,
//         fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
//         color: kBluePigmentColor,
//       ),
// );

// final selectionTextStyle = Theme.of(getContext).textTheme.titleMedium?.copyWith(
//       fontSize: 16.sp,
//       fontWeight: FontWeight.w600,
//       fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
//       color: kWhiteColor,
//     );
