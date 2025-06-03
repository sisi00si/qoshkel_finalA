import 'package:QoshKel/features/personalization/controllers/badge_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:QoshKel/features/authentication/controllers/user_controller.dart';
import 'package:QoshKel/utils/constants/colors.dart';
import 'package:QoshKel/utils/constants/sizes.dart';
import 'package:confetti/confetti.dart';

class PlaceScreen extends StatefulWidget {
  final String placeId;
  final String placeName;
  final String placeType;
  final String city;

  const PlaceScreen({
    super.key,
    required this.placeId,
    required this.placeName,
    required this.placeType,
    required this.city,
  });

  @override
  State<PlaceScreen> createState() => _PlaceScreenState();
}

class _PlaceScreenState extends State<PlaceScreen> {
  late ConfettiController _confettiController;
  bool _isCheckingIn = false;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _triggerConfetti() {
    _confettiController.play();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserController>();
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            flexibleSpace: FlexibleSpaceBar(
              // title: Text(widget.placeName,
              //     style: theme.textTheme.titleSmall?.copyWith(
              //       color: Colors.white,
              //       shadows: [const Shadow(color: Colors.black, blurRadius: 6)],
              //     )),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: widget.placeId,
                    child: Image.asset(
                      'assets/images/baiterek_tower.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Row(
                      children: [
                        _buildInfoBadge(Iconsax.location, widget.city),
                        const SizedBox(width: 8),
                        _buildInfoBadge(Iconsax.category, widget.placeType),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Check-in Section
                  Obx(() {
                    final visitedCount = controller.user.value.visitedPlaces[widget.placeId] ?? 0;
                    return Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: double.infinity,
                              height: 60,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: visitedCount > 0
                                      ? [TColors.primary, TColors.secondary]
                                      : [Colors.blueAccent, TColors.buttonPrimary],
                                ),
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [BoxShadow(
                                  color: TColors.primary.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                )],
                              ),
                              child: TextButton.icon(
                                icon: _isCheckingIn
                                    ? const CircularProgressIndicator(color: Colors.white)
                                    : const Icon(Iconsax.location, color: Colors.white),
                                label: Text(
                                  visitedCount > 0 ? 'Check In Again' : 'Check In Now',
                                  style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
                                ),
                                onPressed: _isCheckingIn ? null : () async {
                                  setState(() => _isCheckingIn = true);
                                  recordPlaceVisit(widget.placeType, widget.city);
                                  setState(() => _isCheckingIn = false);
                                  _triggerConfetti();
                                  Get.snackbar(
                                    'Success!',
                                    '➕ Progress has been updated',
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: TColors.success,
                                    colorText: Colors.white,
                                  );
                                },
                              ),
                            ),
                            Positioned(
                              right: 20,
                              child: Badge(
                                label: Text('$visitedCount'),
                                backgroundColor: Colors.white,
                                textColor: TColors.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: TSizes.spaceBtwItems),
                        _buildVisitProgress(visitedCount),
                      ],
                    );
                  }),

                  const SizedBox(height: TSizes.spaceBtwSections),

                  // Place Details
                  Text('${widget.placeName}', 
                      style: theme.textTheme.headlineMedium),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  Text(
                    'Explore the rich history of ${widget.placeName}, one of ${widget.city}\'s most iconic landmarks. '
                    'This magnificent structure represents the cultural heritage and modern aspirations of Kazakhstan.',
                    style: theme.textTheme.bodyMedium,
                  ),
                  
                  const SizedBox(height: TSizes.spaceBtwSections),

                  // Highlights
                  _buildSectionTitle('Highlights', Iconsax.star),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  _buildHighlightItem('Architectural Marvel'),
                  _buildHighlightItem('360° City Views'),
                  _buildHighlightItem('Historical Exhibits'),

                  // Tips
                  const SizedBox(height: TSizes.spaceBtwSections),
                  _buildSectionTitle('Visitor Tips', Iconsax.lamp),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  _buildTipItem('Best time to visit: Morning hours'),
                  _buildTipItem('Guided tours available'),
                  _buildTipItem('Photography allowed'),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: ConfettiWidget(
        confettiController: _confettiController,
        blastDirectionality: BlastDirectionality.explosive,
        emissionFrequency: 0.05,
        numberOfParticles: 20,
        gravity: 0.1,
      ),
    );
  }

  Widget _buildInfoBadge(IconData icon, String text) {
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(text.capitalizeFirst!),
      backgroundColor: Colors.black.withOpacity(0.4),
      labelStyle: const TextStyle(color: Colors.white),
    );
  }

  Widget _buildVisitProgress(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Icon(
          index < count ? Iconsax.tick_circle : Iconsax.more_circle,
          color: index < count ? TColors.success : Colors.grey,
          size: 20,
        ),
      )),
    );
  }

  Widget _buildSectionTitle(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 8),
        Text(text, style: Get.textTheme.titleMedium),
      ],
    );
  }

  Widget _buildHighlightItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: TSizes.spaceBtwItems/2),
      child: Row(
        children: [
          const Icon(Iconsax.arrow_right, size: 16, color: TColors.primary),
          const SizedBox(width: 8),
          Text(text, style: Get.textTheme.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildTipItem(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: TColors.light.withOpacity(0.3),
        borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
      ),
      child: Row(
        children: [
          const Icon(Iconsax.info_circle, size: 18, color: TColors.primary),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: Get.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}