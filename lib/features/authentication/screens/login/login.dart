import 'package:QoshKel/common/styles/spacing_style.dart';
import 'package:QoshKel/common/widgets_login_signup/form_divider.dart';
import 'package:QoshKel/common/widgets_login_signup/social_buttons.dart';
import 'package:QoshKel/features/authentication/screens/login/widgets/login_form.dart';
import 'package:QoshKel/features/authentication/screens/login/widgets/login_header.dart';
import 'package:QoshKel/utils/constants/sizes.dart';
import 'package:QoshKel/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              const TLoginHeader(),

              const TLoginForm(),

//divider
              TFormDivider(dividerText: TTexts.orSignInWith.capitalize!),
              const SizedBox(height: TSizes.spaceBtwSections),
//footer
              const TSocialButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
