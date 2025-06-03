import 'package:QoshKel/features/authentication/screens/password_config/forget_password_controller.dart';
import 'package:QoshKel/features/authentication/screens/password_config/reset_password.dart';
import 'package:QoshKel/utils/constants/sizes.dart';
import 'package:QoshKel/utils/constants/text_strings.dart';
import 'package:QoshKel/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgetPasswordController());
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADINGS
            Text(TTexts.forgetPasswordTitle,
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: TSizes.spaceBtwItems),
            Text(TTexts.forgetPasswordSubTitle,
                style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: TSizes.spaceBtwSections * 2),

            /// TEXT FIELD
            Form(
              key: controller.forgetPasswordFormKey,
              child:TextFormField(
                controller: controller.email,
                validator: TValidator.validateEmail,
                decoration: const InputDecoration(
                  labelText: TTexts.email,
                  prefixIcon: Icon(Iconsax.direct_right)),
              ), 
            ),
            const SizedBox(height: TSizes.spaceBtwItems),


            SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () => controller.sendPasswordResetEmail() ,
                    child: const Text(TTexts.submit)))
          ],
        ),
      ),
    );
  }
}
