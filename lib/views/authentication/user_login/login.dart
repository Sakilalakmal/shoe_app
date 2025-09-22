import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:shoe_app_assigment/utils/constants/text_string.dart';
import 'package:shoe_app_assigment/utils/helpers/helper_functions.dart';
import 'package:shoe_app_assigment/utils/theme/colors.dart';
import 'package:shoe_app_assigment/utils/theme/sizes.dart';
import 'package:shoe_app_assigment/views/authentication/user_login/widgets/login_form.dart';
import 'package:shoe_app_assigment/views/authentication/user_login/widgets/login_header.dart';
import 'package:shoe_app_assigment/views/authentication/vendor_login/vendor_login.dart';



class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: TSizes.appBarHeight,
            left: TSizes.defaultSpace,
            right: TSizes.defaultSpace,
            bottom: TSizes.defaultSpace,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //logo , title with subtitle
              LoginHeader(),

              //form
              loginForm(),

              //divider
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Divider(
                      color: dark ? TColors.darkGrey : TColors.grey,
                      thickness: 0.5,
                      indent: 60,
                      endIndent: 5,
                    ),
                  ),
                  Text(Texts.orYouCan.capitalize! , style: Theme.of(context).textTheme.bodyMedium,),

                  Flexible(
                    child: Divider(
                      color: dark ? TColors.darkGrey : TColors.grey,
                      thickness: 0.5,
                      indent: 5,
                      endIndent: 60,
                    ),
                  ),
                ],
              ),

              SizedBox(height: TSizes.spaceBtwItems,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(Texts.becomeAVendor , style: Theme.of(context).textTheme.titleLarge,),
                  TextButton(onPressed: (){
                    Navigator.push(context,MaterialPageRoute(builder: (context){
                       return VendorLoginScreen();
                    }));
                  }, child: Text(Texts.signIn),),

                   
                ],
              ),

             
            ],
          ),
        ),
      ),
    );
  }
}

