import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:shoe_app_assigment/controllers/auth_controller/auth_controller.dart';
import 'package:shoe_app_assigment/utils/constants/image_string.dart';
import 'package:shoe_app_assigment/utils/constants/text_string.dart';
import 'package:shoe_app_assigment/utils/helpers/helper_functions.dart';
import 'package:shoe_app_assigment/utils/theme/colors.dart';
import 'package:shoe_app_assigment/utils/theme/sizes.dart';
import 'package:shoe_app_assigment/views/authentication/user_login/login.dart';
import 'package:shoe_app_assigment/views/components/notify_message/motion_toast.dart';

class UserRegisterScreen extends StatefulWidget {
  @override
  State<UserRegisterScreen> createState() => _UserRegisterScreenState();
}

class _UserRegisterScreenState extends State<UserRegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final AuthController _authController = AuthController();

  bool _isObsecure = true;

  bool _isLoading = false;

  late String email;

  late String password;

  late String fullName;

  registerUser() async {
    BuildContext localContext = context;
    setState(() {
      _isLoading = true;
    });
    String res = await _authController.registerNewUser(
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
              return LoginScreen();
            },
          ),
        );
        AppToast.success(context, "User Account created successfully.");
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
                Texts.registerTitle,
                style: Theme.of(
                  context,
                ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
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
                            return "Please enter your email";
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
                            return "Please enter your fullname";
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
                        obscureText: _isObsecure,
                        onChanged: (value) {
                          password = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter your password";
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
                                _isObsecure = !_isObsecure;
                              });
                            },
                            icon: Icon(
                              _isObsecure ? Iconsax.eye_slash : Iconsax.eye,
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
                      SizedBox(height: TSizes.spaceBtwSections),

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
                            Texts.alreadyHaveAnAccount,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return LoginScreen();
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
