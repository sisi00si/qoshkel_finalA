import 'package:QoshKel/data/repositories/authentication/user/user_repository.dart';
import 'package:QoshKel/features/authentication/controllers/user_controller.dart';
import 'package:QoshKel/features/personalization/screens/widgets/metaballs_qoshkel.dart';
import 'package:QoshKel/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metaballs/metaballs.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userController = Get.find<UserController>();
    final user = userController.user.value;

    final TextEditingController firstNameController =
        TextEditingController(text: user.firstName);
    final TextEditingController lastNameController =
        TextEditingController(text: user.lastName);
    final TextEditingController usernameController =
        TextEditingController(text: user.username);

    return Scaffold(
      body: Stack(
        children: [
          // === Metaballs Background ===
    const SizedBox.expand(
            child: SimpleBallsScreen(
                ballCount: 20), // тут регулируешь количество шариков
          ),
          // === Back Button ===
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 12,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, size: 28),
              color: TColors.primary,
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // === Form ===
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Edit Profile", style: theme.textTheme.headlineSmall),
                    const SizedBox(height: 20),

                    // First Name
                    TextField(
                      controller: firstNameController,
                      decoration: const InputDecoration(
                        labelText: "First Name",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Last Name
                    TextField(
                      controller: lastNameController,
                      decoration: const InputDecoration(
                        labelText: "Last Name",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Username
                    TextField(
                      controller: usernameController,
                      decoration: const InputDecoration(
                        labelText: "Username",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Save Button
                    ElevatedButton(
                      onPressed: () async {
                        final updatedUser = user.copyWith(
                          firstName: firstNameController.text.trim(),
                          lastName: lastNameController.text.trim(),
                          username: usernameController.text.trim(),
                        );

                        try {
                          await UserRepository.instance
                              .updateUserDetails(updatedUser);
                          userController.user.value = updatedUser;

                          Get.snackbar("Success", "Profile updated successfully",
                              snackPosition: SnackPosition.BOTTOM);
                          Navigator.pop(context);
                        } catch (e) {
                          Get.snackbar("Error", e.toString(),
                              snackPosition: SnackPosition.BOTTOM);
                        }
                      },
                      child: const Text("Save Changes"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
