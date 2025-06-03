import 'package:QoshKel/data/repositories/authentication/user/user_repository.dart';
import 'package:QoshKel/features/personalization/models/badge_criteria.dart';
import 'package:QoshKel/features/personalization/models/user_model.dart';
import 'package:QoshKel/utils/popups/loaders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';


class UserController extends GetxController{
  static UserController get instance => Get.find();

  Rx<UserModel> user = UserModel.empty().obs;
  final userRepository = Get.put(UserRepository());


  @override
  void onInit() {
    super.onInit();
    fetchUserRecord();

  }

  Future<void> fetchUserRecord() async {
    try {   
      final user = await userRepository.fetchUserDetails();
      this.user(user);
    } catch (e) {
      user(UserModel.empty());
    }
  }


  Future<void> saveUserRecord(UserCredential? userCredentials) async {
    try {

      if (userCredentials != null) {
        // convert name to first and last name 
        final nameParts = UserModel.nameParts(userCredentials.user!.displayName ?? '');
        final username = UserModel.generateUsername(userCredentials.user!.displayName ?? '');
        
        // map data
        final user = UserModel(
        id: userCredentials.user!.uid,
        firstName: nameParts[0],
        lastName:  nameParts.length > 1? nameParts.sublist(1).join(' ') : '',
        username:  username,
        email:  userCredentials.user!.email ?? '',
        phoneNumber:  userCredentials.user!.phoneNumber ?? '',
        profilePicture: userCredentials.user!.photoURL ?? '',
        badgesEarned: [], visitedPlaces: {}
      );

      await userRepository.saveUserRecord(user);
    }

    } catch (e) {
      TLoaders.warningSnackBar(title: 'Data not saved', message: 'Something went wrong while saving your information. You can re-save your data in your Profile.',
      );
    }
  }

    double calculateBadgeProgress(BadgeCriteria criteria) {
   final userController = Get.find<UserController>();
  final user = userController.user;
  final visited = user.value.visitedPlaces;
  double maxProgress = 0;
  
  for (final req in criteria.requirements.entries) {
    final current = visited[req.key]?.toDouble() ?? 0;
    final progress = current / req.value;
    if (progress > maxProgress) maxProgress = progress;
  }
  
  return maxProgress.clamp(0, 1);
}
}