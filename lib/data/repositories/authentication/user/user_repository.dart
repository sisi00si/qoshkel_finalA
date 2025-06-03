import 'package:QoshKel/data/repositories/authentication/authentication_repository.dart';
import 'package:QoshKel/features/personalization/models/badge_criteria.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:QoshKel/features/personalization/models/user_model.dart';

import 'package:QoshKel/utils/exceptions/firebase_exceptions.dart';
import 'package:QoshKel/utils/exceptions/format_exceptions.dart';
import 'package:QoshKel/utils/exceptions/platform_exceptions.dart';

/// repository class for user-related operations.
class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// function to save user data to Firestore.
  Future<void> saveUserRecord(UserModel user) async {
    try {
      await _db.collection("Users").doc(user.id).set(user.toJson());
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (e) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  /*---------------------- CRUD OPERATIONS ---------------------------*/

  /// Function to fetch user details  ased on user ID.
   Future<UserModel> fetchUserDetails() async {
    try {

      final documentSnapshot = await _db.collection("Users").doc(AuthenticationRepository.instance.authUser?.uid).get();
      if(documentSnapshot.exists) {
        return UserModel.fromSnapshot(documentSnapshot);
      } else {
        return UserModel.empty();
      }
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (e) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }


  // function to update user data in db
   Future<void> updateUserDetails(UserModel updatedUser) async {
    try {
      await _db.collection("Users").doc(updatedUser.id).update(updatedUser.toJson());

    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (e) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

     Future<void> updateSingleField(Map<String, dynamic> json) async {
    try {
      await _db.collection("Users").doc(AuthenticationRepository.instance.authUser?.uid).update(json);
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (e) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

   Future<void> removeUserRecord(String userId) async {
    try {
      await _db.collection("Users").doc(userId).delete();

    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (e) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }



  Future<void> recordPlaceVisit(String placeType, String city) async {
  try {
    final uid = AuthenticationRepository.instance.authUser?.uid;
    if (uid == null) return;

    await _db.collection("Users").doc(uid).update({
      'visitedPlaces.$placeType': FieldValue.increment(1),
      'visitedPlaces.${city.toLowerCase()}': FieldValue.increment(1),
      'total_places': FieldValue.increment(1),

      
    });

    _checkBadgeAchievements(uid);
  } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (e) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
}

Future<void> _checkBadgeAchievements(String uid) async {
  final userDoc = await _db.collection("Users").doc(uid).get();
  final userData = userDoc.data() ?? {};
  final badges = userData['badgesEarned'] as List<dynamic>? ?? [];
  final visited = userData['visitedPlaces'] as Map<String, dynamic>? ?? {};
  
  final earnedBadges = <String>[];

  for (final badge in BadgeCriteria.allBadges) {
    if (badges.contains(badge.id)) continue;
    
    bool meetsCriteria = true;
    for (final req in badge.requirements.entries) {
      final count = visited[req.key]?.toInt() ?? 0;
      if (count < req.value) {
        meetsCriteria = false;
        break;
      }
    }
    
    if (meetsCriteria) {
      earnedBadges.add(badge.id);
    }
  }

  if (earnedBadges.isNotEmpty) {
    await _db.collection("Users").doc(uid).update({
      'badgesEarned': FieldValue.arrayUnion(earnedBadges)
    });
  }
}
}
