import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoe_app_assigment/controllers/auth_controller/vendor_auth_controller.dart';
import 'package:shoe_app_assigment/utils/constants/text_string.dart';
import 'package:shoe_app_assigment/utils/helpers/helper_functions.dart';
import 'package:shoe_app_assigment/utils/theme/colors.dart';
import 'package:shoe_app_assigment/utils/theme/sizes.dart';
import 'package:shoe_app_assigment/views/authentication/vendor_register/vendor_registraion_screen.dart';

class VendorLoginForm extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final VendorAuthController _vendorAuthController = VendorAuthController();

  late String email;
  late String password;
  bool _obscureText = false;

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwSections),
        child: Column(
          children: [
            //email
            TextFormField(
              validator: (value){
                if(value!.isEmpty){
                  return "Please enter your vendor email";
                }else{
                  return null;
                }
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Iconsax.direct_right),
                labelText: Texts.email,
              ),
            ),
            SizedBox(height: TSizes.spaceBtwInputFields),
            //password
            TextFormField(
              validator: (value){
                if(value!.isEmpty){
                  return "Please enter your vendor password";
                }else{
                  return null;
                }
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Iconsax.password_check),
                labelText: Texts.password,
                suffixIcon: Icon(Iconsax.eye_slash),
              ),
            ),
            SizedBox(height: TSizes.spaceBtwInputFields / 2),

            //remember me and forgot password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //remember me
                Row(
                  children: [
                    Checkbox(value: true, onChanged: (value) {}),
                    Text(Texts.rememberMe),
                  ],
                ),

                //forgot password
                TextButton(onPressed: () {}, child: Text(Texts.forgotPassword)),
              ],
            ),
            SizedBox(height: TSizes.spaceBtwSections),

            //sign in button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if(_formKey.currentState!.validate()){
                    print("valid");
                  }else{
                    print("invalid");
                  }
                },
                child: Text(
                  Texts.signIn,
                  style: Theme.of(context).textTheme.bodyLarge!.apply(
                    color: dark ? TColors.dark : TColors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: TSizes.spaceBtwItems),

            //create account button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return VendorRegisterScreen();
                      },
                    ),
                  );
                },
                child: Text(Texts.createVendorAccount),
              ),
            ),

            // SizedBox(height: TSizes.spaceBtwSections),
          ],
        ),
      ),
    );
  }
}
