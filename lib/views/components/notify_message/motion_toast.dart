import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:shoe_app_assigment/utils/theme/colors.dart'; // fix path if needed

enum AppToastType { success, error, warning, info }

class AppToast {
  static void show(
    BuildContext context,
    String message, {
    AppToastType type = AppToastType.info,
    String? title,
    int seconds = 5,
    Alignment toastAlignment = Alignment.bottomCenter, 
  }) {
    final duration = Duration(seconds: seconds);
    final double width =
        MediaQuery.of(context).size.width.clamp(280.0, 420.0);

    // map type -> icon/color/default title
    late final IconData icon;
    late final Color color;
    late final String defaultTitle;
    switch (type) {
      case AppToastType.success:
        icon = Icons.check_circle_rounded;
        color = TColors.success;
        defaultTitle = 'Success!';
        break;
      case AppToastType.error:
        icon = Icons.error_rounded;
        color = TColors.error;
        defaultTitle = 'Error!';
        break;
      case AppToastType.warning:
        icon = Icons.warning_rounded;
        color = TColors.warning;
        defaultTitle = 'Warning!';
        break;
      case AppToastType.info:
        icon = Icons.info_rounded;
        color = TColors.info;
        defaultTitle = 'Info!';
        break;
    }

    // default constructor so primaryColor is always accepted
    MotionToast(
      icon: icon,
      primaryColor: color,                       // left stripe + icon color
      title: Text(title ?? defaultTitle,style: GoogleFonts.montserrat(
        color: TColors.cardBackgroundColor,
        fontWeight: FontWeight.bold,
      ),),
      description: Text(message , style: GoogleFonts.montserrat(
        color: TColors.cardBackgroundColor,
        fontWeight: FontWeight.bold,
      ),),
      toastAlignment: toastAlignment,            // <-- correct field
      animationType: AnimationType.slideInFromBottom,
      toastDuration: duration,
      width: width,
      height: 80,
      borderRadius: 12,
      dismissable: true,
    ).show(context);
  }

  // helpers
  static void success(BuildContext c, String m,
          {String title = 'Success!', int seconds = 2, Alignment toastAlignment = Alignment.topCenter}) =>
      show(c, m, type: AppToastType.success, title: title, seconds: seconds, toastAlignment: toastAlignment);

  static void error(BuildContext c, String m,
          {String title = 'Error!', int seconds = 3, Alignment toastAlignment = Alignment.topCenter}) =>
      show(c, m, type: AppToastType.error, title: title, seconds: seconds, toastAlignment: toastAlignment);

  static void warning(BuildContext c, String m,
          {String title = 'Warning!', int seconds = 3, Alignment toastAlignment = Alignment.topCenter}) =>
      show(c, m, type: AppToastType.warning, title: title, seconds: seconds, toastAlignment: toastAlignment);

  static void info(BuildContext c, String m,
          {String title = 'Info!', int seconds = 2, Alignment toastAlignment = Alignment.topCenter}) =>
      show(c, m, type: AppToastType.info, title: title, seconds: seconds, toastAlignment: toastAlignment);
}
