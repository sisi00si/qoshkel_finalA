import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:QoshKel/utils/formatters/formatter.dart';
import 'package:firebase_core/firebase_core.dart';

// Model class representing user data.
class UserModel {
  final String id;
  String firstName;
  String lastName;
  String username;
  final String email;
  String phoneNumber;
  String profilePicture;
  final List<String> badgesEarned;
  final Map<String, int> visitedPlaces;

  /// Constructor for UserModel.
  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.profilePicture,
    required this.badgesEarned,
    required this.visitedPlaces,
  });

  UserModel copyWith({
    String? firstName,
    String? lastName,
    String? username,
    String? email,
    String? phoneNumber,
    String? profilePicture, 
    List<String>? badgesEarned,
    Map<String, int>? visitedPlaces,
    
  }) {
    return UserModel(
      id: id,
      username: this.username,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePicture: profilePicture ?? this.profilePicture,
      badgesEarned: this.badgesEarned,
      visitedPlaces: this.visitedPlaces,
      
    );
  }
  

  /// Helper function to get the full name.
  String get fullName => '$firstName $lastName';

  /// Helper function to format phone number.
  String get formattedPhoneNo => TFormatter.formatPhoneNumber(phoneNumber);

  /// Static function to split full name into first and last name.
  static List<String> nameParts(fullName) => fullName.split(' ');

  static String generateUsername(fullName) {
    List<String> nameParts = fullName.split(' ');
    String firstName = nameParts[0].toLowerCase();
    String lastName = nameParts.length > 1 ? nameParts[1].toLowerCase() : "";

    String camelCaseUsername = '$firstName $lastName';
    String usernameWithPrefix = '$camelCaseUsername';
    return usernameWithPrefix;
  }

  static UserModel empty() => UserModel(
      id: '',
      firstName: '',
      lastName: '',
      username: '',
      email: '',
      phoneNumber: '',
      profilePicture: '',
      badgesEarned: [], 
      visitedPlaces: {},
      );

  Map<String, dynamic> toJson() {
    return {
      'FirstName': firstName,
      'LastName': lastName,
      'UserName': username,
      'Email': email,
      'PhoneNumber': phoneNumber,
      'ProfilePicture': profilePicture,
      'badgesEarned': badgesEarned,
      'visitedPlaces': visitedPlaces,
    };
  }

  

factory UserModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> document) {
  if (document.data() != null) {
    final data = document.data()!;
    return UserModel(
      id: document.id,
      firstName: data['FirstName'] ?? '', // Uppercase 'F'
      lastName: data['LastName'] ?? '', // Uppercase 'L'
      username: data['UserName'] ?? '', // Uppercase 'U' and 'N'
      email: data['Email'] ?? '', // Uppercase 'E'
      phoneNumber: data['PhoneNumber'] ?? '', // Uppercase 'P' and 'N'
      profilePicture: data['ProfilePicture'] ?? '', // Uppercase 'P,
       badgesEarned: List<String>.from(data['badgesEarned'] ?? []),
      visitedPlaces: Map<String, int>.from(data['visitedPlaces'] ?? {}),
      
    );
  } else {
    return UserModel.empty();
  }
}
}
