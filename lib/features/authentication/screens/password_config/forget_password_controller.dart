import 'package:QoshKel/data/repositories/authentication/authentication_repository.dart';
import 'package:QoshKel/features/authentication/screens/password_config/reset_password.dart';
import 'package:QoshKel/utils/constants/image_strings.dart';
import 'package:QoshKel/utils/helpers/network_manager.dart';
import 'package:QoshKel/utils/popups/full_screen_loader.dart';
import 'package:QoshKel/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class ForgetPasswordController extends GetxController{
  static ForgetPasswordController get instance => Get.find();

  final email = TextEditingController();
  GlobalKey<FormState> forgetPasswordFormKey = GlobalKey<FormState>();


  // send reset password Email
  sendPasswordResetEmail() async {
    try {

    TFullScreenLoader.openLoadingDialog('Processing your request...', TImages.docerAnimation);
    
    // check network connectivity
    final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      //form validation
      if (!forgetPasswordFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      await AuthenticationRepository.instance.sendPasswordResetEmail(email.text.trim());

      //remove loader
      TFullScreenLoader.stopLoading();

      //show success screen
      TLoaders.successSnackBar(title: 'Email Sent', message: 'Email Link Sent to Reset your account.');


      // redirect
      Get.to(() => ResetPasswordScreen(email: email.text.trim()));

    } catch (e) {

      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }


    resendPasswordResetEmail(String email) async  {
    try {

    TFullScreenLoader.openLoadingDialog('Processing your request...', TImages.docerAnimation);
    
    // check network connectivity
    final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      //form validation
      if (!forgetPasswordFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      await AuthenticationRepository.instance.sendPasswordResetEmail(email);

      //remove loader
      TFullScreenLoader.stopLoading();

      //show success screen
      TLoaders.successSnackBar(title: 'Email Sent', message: 'Email Link Sent to Reset your account.');

 

    } catch (e) {

      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }
}