import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoe_app_assigment/utils/theme/colors.dart';
import 'package:shoe_app_assigment/utils/theme/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';

class TEComAppBar extends StatelessWidget {
  const TEComAppBar({
    super.key,
    this.title,
    this.actions,
    this.leadingIcon,
    this.leadingOnPressed,
    this.showBackArrow = false,
  });

  final Widget? title;
  final bool showBackArrow;
  final IconData? leadingIcon;
  final List<Widget>? actions;
  final VoidCallback? leadingOnPressed;

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TSizes.md, vertical: TSizes.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side: Back or Custom Icon
          if (showBackArrow)
            IconButton(
              onPressed: () => Get.back(),
              icon: Icon(Iconsax.arrow_left, color: dark ? TColors.white : TColors.dark),
            )
          else if (leadingIcon != null)
            IconButton(
              onPressed: leadingOnPressed,
              icon: Icon(leadingIcon, color: dark ? TColors.white : TColors.dark),
            )
          else
            const SizedBox(width: 48), // Placeholder for alignment if no icon

          // Center: Title (optional)
          if (title != null) Expanded(child: Align(alignment: Alignment.centerLeft, child: title!)),

          // Right side: Actions
          if (actions != null)
            Row(mainAxisSize: MainAxisSize.min, children: actions!)
          else
            const SizedBox(width: 48), // Placeholder to balance icon space
        ],
      ),
    );
  }
}
