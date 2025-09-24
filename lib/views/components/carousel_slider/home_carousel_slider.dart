import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shoe_app_assigment/utils/theme/colors.dart';
import 'package:shoe_app_assigment/utils/theme/sizes.dart';

class carousel_slider_sales extends StatelessWidget {
  const carousel_slider_sales({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    

    return Padding(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        children: [
          CarouselSlider(
            items: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(TSizes.md),
                ),
    
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(TSizes.md),
                  child: Image(
                    image: AssetImage('assets/images/c1.webp'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(TSizes.md),
                ),
    
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(TSizes.md),
                  child: Image(
                    image: AssetImage('assets/images/c2.webp'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(TSizes.md),
                ),
    
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(TSizes.md),
                  child: Image(
                    image: AssetImage('assets/images/c3.webp'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
            options: CarouselOptions(viewportFraction: 1),
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for(int i = 0; i < 3; i++)
              Container(
                height: 4,
                width: 20,
                margin: EdgeInsets.only(right: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: TColors.newBlue,
                ),
                )
             
            ],
          ),
        ],
      ),
    );
  }
}