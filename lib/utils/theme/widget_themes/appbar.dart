
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoe_app_assigment/utils/helpers/helper_functions.dart';
import 'package:shoe_app_assigment/utils/theme/colors.dart';
import 'package:shoe_app_assigment/utils/theme/widget_themes/device_utility.dart';

class TAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Custom appbar for achieving a desired design goal.
  /// - Set [title] for a custom title.
  /// - [showBackArrow] to toggle the visibility of the back arrow.
  /// - [leadingIcon] for a custom leading icon.
  /// - [leadingOnPressed] callback for the leading icon press event.
  /// - [actions] for adding a list of action widgets.
  /// - Horizontal padding of the appbar can be customized inside this widget.
  const TAppBar({
    super.key,
    this.title,
    this.actions,
    this.leadingIcon,
    this.leadingOnPressed,
    this.showActionWithBadge = false,
    this.showBackArrow = false,
     this.showActions = false,
     this.showSkipButton = false,
    this.actionIcon,
    this.actionOnPressed,
    this.centerTitle = false,
  });

  final Widget? title;
  final bool showBackArrow;
  final bool showActions;
  final bool showSkipButton;
  final bool showActionWithBadge;
  final bool centerTitle;
  final IconData? leadingIcon;
  final IconData? actionIcon;
  final List<Widget>? actions;
  final VoidCallback? leadingOnPressed;
  final VoidCallback? actionOnPressed;

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);

    return AppBar(
      centerTitle: centerTitle,
      backgroundColor: Colors.transparent,
      titleTextStyle: Theme.of(context).textTheme.headlineSmall,
      automaticallyImplyLeading: false,
      leading:
          showBackArrow
              ? IconButton(onPressed: () => Get.back(result: true), icon: Icon(Iconsax.arrow_left_24, color: dark ? TColors.white : TColors.dark))
              : leadingIcon != null
              ? IconButton(onPressed: leadingOnPressed, icon: Icon(leadingIcon, color: dark ? TColors.white : TColors.dark))
              : null,
      title: title,
      actions:actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(TDeviceUtils.getAppBarHeight() + 10);
}
