import 'dart:io';
import 'package:QoshKel/data/repositories/authentication/authentication_repository.dart';
import 'package:QoshKel/features/authentication/controllers/user_controller.dart';
import 'package:QoshKel/utils/constants/image_strings.dart';
import 'package:QoshKel/utils/helpers/network_manager.dart';
import 'package:QoshKel/utils/popups/full_screen_loader.dart';
import 'package:QoshKel/utils/popups/loaders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController{
  
  final rememberMe = false.obs;
  final hidePassword = true.obs;
  final localStorage = GetStorage();
  final email = TextEditingController();
  final password = TextEditingController();

  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  final userController = Get.put(UserController());

  @override
    void onInit() {
      final savedEmail = localStorage.read('REMEMBER_ME_EMAIL');
      final savedPassword = localStorage.read('REMEMBER_ME_PASSWORD');

      email.text = savedEmail ?? '';
      password.text = savedPassword ?? '';
      super.onInit();    
    }


  // -- Email and Password Sign In
  Future<void> emailAndPsswordSignIn() async {
    try {
      TFullScreenLoader.openLoadingDialog('Logging you in...', TImages.docerAnimation);

      //check network connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      //form validation
      if (!loginFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }
      
      // save data if remember Me is selected
      if (rememberMe.value) {
        localStorage.write('REMEMBER_ME_EMAIL', email.text.trim());
        localStorage.write('REMEMBER_ME_PASSWORD', password.text.trim());
      }

      // login user using Email & Password Authentication
      final UserCredential = await AuthenticationRepository.instance.loginWithEmailAndPassword(
        email.text.trim(), password.text.trim());

      // remove loader
      TFullScreenLoader.stopLoading();

      //Redirect
      AuthenticationRepository.instance.screenRedirect();
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  Future<void> googleSignIn() async {

  try {
    // start loading
    TFullScreenLoader.openLoadingDialog('Logging you in...', TImages.docerAnimation);

      //check network connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // google authentication
      final userCredentials = await AuthenticationRepository.instance.signInWithGoogle();


      // save user record
      await userController.saveUserRecord(userCredentials);

      TFullScreenLoader.stopLoading();
      AuthenticationRepository.instance.screenRedirect();


  } catch (e) {
    //remove loading
    TFullScreenLoader.stopLoading();
    TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
  }

}
}


