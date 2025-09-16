import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shoe_app_assigment/controllers/auth_controller/vendor_auth_controller.dart';
import 'package:shoe_app_assigment/utils/constants/text_string.dart';
import 'package:shoe_app_assigment/utils/helpers/helper_functions.dart';
import 'package:shoe_app_assigment/utils/theme/colors.dart';
import 'package:shoe_app_assigment/utils/theme/sizes.dart';
import 'package:shoe_app_assigment/views/authentication/vendor_register/vendor_registraion_screen.dart';
import 'package:shoe_app_assigment/views/components/notify_message/motion_toast.dart';
import 'package:shoe_app_assigment/views/screen/main_screen.dart';
import 'package:shoe_app_assigment/views/vendor_side/main_vendor_screen.dart';

class VendorLoginForm extends StatefulWidget {
  @override
  State<VendorLoginForm> createState() => _VendorLoginFormState();
}

class _VendorLoginFormState extends State<VendorLoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final VendorAuthController _vendorAuthController = VendorAuthController();

  late String email;

  late String password;

  bool _obscureText = false;

  bool _isLoading = false;

  loginUser() async {
    String res = await _vendorAuthController.loginUser(email, password);

    setState(() {
      _isLoading = true;
    });

    if (res == "success") {
      //navigate to main screen
      Future.delayed(Duration.zero, () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return MainVendorScreen();
            },
          ),
        );

        AppToast.success(context, " Start Your Journey with sneakersX ...");
      });
    } else {
      AppToast.error(context, "Login failed try again ...");
      setState(() {
        _isLoading = false;
      });

      Future.delayed(Duration.zero, () {
        AppToast.error(context, res);
      });
    }
  }

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
              onChanged: (value) {
                email = value;
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please enter your vendor email";
                } else {
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
              obscureText: _obscureText,
              onChanged: (value) {
                password = value;
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please enter your vendor password";
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Iconsax.password_check),
                labelText: Texts.password,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  icon: Icon(_obscureText ? Iconsax.eye_slash : Iconsax.eye),
                ),
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
                  if (_formKey.currentState!.validate()) {
                    loginUser();
                  } else {
                    AppToast.error(context, "please fill all the fields");
                  }
                },
                child: _isLoading
                    ? CircularProgressIndicator(
                        color: TColors.cardBackgroundColor,
                      )
                    : Text(
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
