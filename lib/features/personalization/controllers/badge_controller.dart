
import 'package:QoshKel/data/repositories/authentication/user/user_repository.dart';
import 'package:QoshKel/features/authentication/controllers/user_controller.dart';
import 'package:QoshKel/features/personalization/controllers/badge_controller.dart';
import 'package:QoshKel/features/personalization/models/badge_criteria.dart';
import 'package:get/get.dart';


void recordPlaceVisit(String placeType, String city) {

    final userController = Get.find<UserController>();
    final user = userController.user;

  UserRepository.instance.recordPlaceVisit(placeType, city);
  userController.fetchUserRecord(); // Refresh user data after recording visit

  
}

