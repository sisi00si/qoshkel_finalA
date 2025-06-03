import 'package:QoshKel/data/repositories/authentication/authentication_repository.dart';
import 'package:QoshKel/features/authentication/controllers/user_controller.dart';
import 'package:QoshKel/features/personalization/models/badge_criteria.dart';
import 'package:QoshKel/features/personalization/screens/badge/places_detail_screen.dart';
import 'package:QoshKel/features/personalization/screens/profile/edit_profile_screen.dart';
import 'package:QoshKel/features/personalization/screens/widgets/badge.dart';
import 'package:QoshKel/features/personalization/screens/widgets/jump_animation.dart';
import 'package:QoshKel/features/personalization/screens/widgets/metaballs_qoshkel.dart';
import 'package:QoshKel/features/personalization/screens/widgets/progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:QoshKel/utils/constants/sizes.dart';
import 'package:metaballs/metaballs.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userController = Get.find<UserController>();
    final user = userController.user;
    final RxBool isGeoEnabled = true.obs;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ===== Banner with Avatar =====
            SizedBox(
              height: 260,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  // Animated Metaballs Background
                 SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: SimpleBallsScreen(
                        ballCount: 10), 
                  ),

                  // Avatar
                  const Positioned(
                    bottom: -40,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 46,
                        backgroundImage:
                            AssetImage('assets/images/user/girl.png'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),

            // ===== Name and Email =====
    // ===== Name and Email =====
Column(
  mainAxisSize: MainAxisSize.min,
  children: [
    // Name with Edit Button
    Obx(
      () => Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              userController.user.value.fullName.isNotEmpty
                  ? userController.user.value.fullName
                  : 'No Name',
              style: theme.textTheme.titleLarge,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 0), // Reduced spacing
            child: IconButton(
              padding: EdgeInsets.zero,
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              constraints: const BoxConstraints(),
              icon: const Icon(Icons.edit, size: 20),
              onPressed: () => Get.to(() => const EditProfileScreen()),
            ),
          ),
        ],
      ),
    ),
    
    // Email
    Obx(
      () => Text(
        userController.user.value.email.isNotEmpty
            ? userController.user.value.email
            : 'No Email',
        style: theme.textTheme.bodyMedium,
        textAlign: TextAlign.center,
      ),
    ),
  ],
),
            const SizedBox(height: TSizes.spaceBtwSections),

            // ===== Badges =====
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Achievements", style: theme.textTheme.titleMedium),
                  const SizedBox(height: TSizes.spaceBtwItems),
               Obx(() {
        final user = userController.user.value;
        return Wrap(
          alignment: WrapAlignment.center,
          spacing: 20,
          runSpacing: 20,
          children: BadgeCriteria.allBadges.map((criteria) {
            final isEarned = user.badgesEarned.contains(criteria.id);
            final progress = userController.calculateBadgeProgress(criteria);
            
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: SizedBox(
                width: 100,
                key: ValueKey(criteria.id + isEarned.toString()),
                child: JumpingBadge(
                  delay: const Duration(milliseconds: 500),
                  child: GoldBadge(
                    criteria: criteria,
                    isEarned: isEarned,
                    progress: progress, // Only 3 arguments now
                  ),
                ),
              ),
            );
          }).toList(),
        );
      }),
                ],
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwSections),

            // ===== Progress Bars =====
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("City Progress", style: theme.textTheme.titleMedium),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  _buildProgress("Astana", 0.7),
                  _buildProgress("Almaty", 0.3),
                ],
              ),
            ),

            const SizedBox(height: TSizes.spaceBtwSections),

            // ===== Favorite Places Tile =====
               // ===== check in button =====
            ListTile(
              leading: const Icon(Iconsax.heart),
              title: const Text("Must Visit Places"),
              subtitle: const Text("Your Visits"),
              trailing: const Icon(Iconsax.arrow_right_34),
              onTap: () {
                Get.to(() => const PlaceScreen(
                   placeId: 'unique_place_id',
                  placeName: 'Baiterek Tower',
                  placeType: 'historic',
                  city: 'Astana',
                ));
              },
            ),

            const SizedBox(height: TSizes.spaceBtwItems),

            // ===== Geolocation Toggle =====
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("App Settings", style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Enable Geolocation",
                          style: theme.textTheme.titleSmall),
                      Switch(
                        value: true,
                        onChanged: (value) {
                          // TODO: Handle toggle
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Iconsax.logout),
              title: const Text("Logout"),
              onTap: () => AuthenticationRepository.instance.logout(),
            ),
            const SizedBox(height: TSizes.spaceBtwSections * 2),
          ],
        ),
      ),
    );

    
  }

  // ===== Progress Bar Widget =====
  Widget _buildProgress(String city, double value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(city),
        const SizedBox(height: 4),
        GradientProgressBar(
          progress: value,
          height: 12,
          radius: 50,
          gradient: const LinearGradient(
            colors: [
              Color(0xFF3B82F6), // Example primary blue
              Color(0xFF8B5CF6), // Purple-ish gradient end
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
