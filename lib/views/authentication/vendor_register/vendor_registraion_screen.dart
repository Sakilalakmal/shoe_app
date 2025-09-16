import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:shoe_app_assigment/controllers/auth_controller/vendor_auth_controller.dart';
import 'package:shoe_app_assigment/utils/constants/image_string.dart';
import 'package:shoe_app_assigment/utils/constants/text_string.dart';
import 'package:shoe_app_assigment/utils/helpers/helper_functions.dart';
import 'package:shoe_app_assigment/utils/theme/colors.dart';
import 'package:shoe_app_assigment/utils/theme/sizes.dart';
import 'package:shoe_app_assigment/views/authentication/vendor_login/vendor_login.dart';
import 'package:shoe_app_assigment/views/components/notify_message/motion_toast.dart';

class VendorRegisterScreen extends StatefulWidget {
  @override
  State<VendorRegisterScreen> createState() => _VendorRegisterScreenState();
}

class _VendorRegisterScreenState extends State<VendorRegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final VendorAuthController _vendorAuthController = VendorAuthController();
  bool _isLoading = false;

  late String email;
  late String fullName;
  late String password;

  bool _obscureText = true;

  registerUser() async {
    BuildContext localContext = context;
    setState(() {
      _isLoading = true;
    });
    String res = await _vendorAuthController.registerNewUser(
      email,
      fullName,
      password,
    );
    if (res == "success") {
      Future.delayed(Duration.zero, () {
        Navigator.push(
          localContext,
          MaterialPageRoute(
            builder: (context) {
              return VendorLoginScreen();
            },
          ),
        );
        AppToast.success(context, "You have become a vendor.");
      });
    } else {
      setState(() {
        _isLoading = false;
      });

      AppToast.error(context, res);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(),
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
              Text(
                Texts.vendorRegisterTitle,
                style: Theme.of(
                  context,
                ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: TSizes.sm),
              Text(
                Texts.vendorRegisterSubTitle,
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium!.copyWith(fontSize: 13),
              ),
              Lottie.asset(
                TImages.signUpIllustration,
                height: HelperFunctions.screenHeight() * 0.2,
              ),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: TSizes.spaceBtwSections,
                  ),
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
                        onChanged: (value) {
                          fullName = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter your vendor fullname";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Iconsax.profile_2user4),
                          labelText: Texts.fullName,
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
                            icon: Icon(
                              _obscureText ? Iconsax.eye_slash : Iconsax.eye,
                            ),
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
                              Text(
                                Texts.privacyPolicy,
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium!.copyWith(fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: TSizes.spaceBtwItems),

                      //sign in button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              registerUser();
                            } else {
                              AppToast.error(
                                context,
                                "Please fill all the fields.",
                              );
                            }
                          },
                          child: _isLoading
                              ? CircularProgressIndicator(
                                  color: TColors.cardBackgroundColor,
                                )
                              : Text(
                                  Texts.signUp,
                                  style: Theme.of(context).textTheme.bodyLarge!
                                      .apply(
                                        color: dark
                                            ? TColors.dark
                                            : TColors.white,
                                      ),
                                ),
                        ),
                      ),
                      SizedBox(height: TSizes.spaceBtwItems),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            Texts.alreadyHaveAnVendorAccount,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return VendorLoginScreen();
                                  },
                                ),
                              );
                            },
                            child: Text(Texts.signIn),
                          ),
                        ],
                      ),

                      // SizedBox(height: TSizes.spaceBtwSections),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
