import 'package:QoshKel/features/authentication/controllers/onboarding/onboarding_controller.dart';
import 'package:QoshKel/utils/constants/colors.dart';
import 'package:QoshKel/utils/constants/sizes.dart';
import 'package:QoshKel/utils/device/device_utility.dart';
import 'package:QoshKel/utils/helpers/helper_function.dart';
import 'package:flutter/material.dart';

class OnBoardingNextButton extends StatelessWidget {
  const OnBoardingNextButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);


    return Positioned(
      right: TSizes.defaultSpace,
      bottom: TDeviceUtils.getBottomNavigationBarHeight(),
      child: ElevatedButton(
        onPressed: () => OnboardingController.instance.nextPage(),
          style: ElevatedButton.styleFrom(
            backgroundColor: dark ? TColors.primary : Colors.white,
            shape: const CircleBorder(), // Keeps the circular shape
            padding: const EdgeInsets.all(16), // Adjust padding for the button's size
            side: BorderSide.none, // Remove border
            ),
          child: Icon(
            Icons.arrow_forward, // Your arrow icon (or any other icon)
            color: dark ? Colors.white : Colors.black, // Adjust icon color based on theme
          ),
        )
    );
  }
}