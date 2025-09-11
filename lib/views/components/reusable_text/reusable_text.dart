import 'package:flutter/material.dart';
import 'package:shoe_app_assigment/utils/theme/sizes.dart';

class ReusableText extends StatelessWidget {
  final String title;
  final String subTitle;

  const ReusableText({super.key, required this.title, required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,style: Theme.of(context).textTheme.headlineSmall!.copyWith(
            fontSize: 15,
            letterSpacing: 1.1,
          ),),
          Text(subTitle,style: Theme.of(context).textTheme.titleLarge!.copyWith(
            letterSpacing: 1.1,
            fontSize: 12,
          ))
        ],
      ),
    );
  }
}