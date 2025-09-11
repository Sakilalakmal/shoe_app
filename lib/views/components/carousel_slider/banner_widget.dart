import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoe_app_assigment/controllers/banner_controller/banner_controller.dart';
import 'package:shoe_app_assigment/utils/theme/sizes.dart';
import 'package:shoe_app_assigment/utils/theme/widget_themes/device_utility.dart';
import 'package:shoe_app_assigment/utils/theme/colors.dart';

class BannerWidget extends StatefulWidget {
  BannerWidget({Key? key}) : super(key: key);

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  final BannerController _bannerController = BannerController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Container(
        width: TDeviceUtils.getScreenWidth(context),
        height: TSizes.bannerShadow,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
          color: TColors.white,
          boxShadow: [
            BoxShadow(
              color: TColors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: StreamBuilder<List<String>>(
          stream: _bannerController.getBannerUrls(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: TColors.white),
              );
            } else if (snapshot.hasError) {
              return Icon(Iconsax.warning_2);
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  "Banner not found!...",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              );
            } else {
              return Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  PageView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return CachedNetworkImage(
                        fit: BoxFit.fill,
                        imageUrl: snapshot.data![index],
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                CircularProgressIndicator(
                                  value: downloadProgress.progress,
                                ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      );
                    },
                  ),

                  //indicator
                  _buildPageIndicators(snapshot.data!.length),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildPageIndicators(int pageCount) {
    return Container(
      margin: EdgeInsets.only(bottom: TSizes.buttonHeight),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(pageCount, (index) {
          return Container(
            width: TSizes.indicatorWidth,
            height: TSizes.indicatorWidth,
            margin: EdgeInsets.symmetric(horizontal: TSizes.xs),
            decoration: BoxDecoration(
              color: TColors.accent,
              shape: BoxShape.circle,
            ),
          );
        }),
      ),
    );
  }
}
