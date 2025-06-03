// draggable_section.dart
import 'package:QoshKel/features/personalization/controllers/places_controller.dart';
import 'package:QoshKel/features/personalization/models/place_model.dart';
import 'package:QoshKel/utils/constants/colors.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:QoshKel/features/planner/screens/home/widgets/rowevents.dart';
import 'package:QoshKel/features/planner/screens/home/widgets/searchbar.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconsax/iconsax.dart';

class DraggableSection extends StatelessWidget {
  final ScrollController scrollController;
  final bool isSearching;
  final VoidCallback onSearchTapped;
  final VoidCallback onExitSearch;
  final double top;
  final FocusNode? searchFocusNode;
  final FocusNode? budgetFocusNode;
  final TextEditingController? searchController;
  final Function(LatLng) onShowRoute;

  DraggableSection({
    super.key,
    required this.scrollController,
    required this.isSearching,
    required this.onSearchTapped,
    required this.onExitSearch,
    this.top = 0.0,
    this.searchFocusNode,
    this.budgetFocusNode,
    this.searchController,
    required this.onShowRoute,
  });

  final TextEditingController _budgetController = TextEditingController();
  final PlacesController placesController = Get.put(PlacesController());

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            blurRadius: 30,
            color: Colors.grey[300]!,
          )
        ],
      ),
      child: Column(
        children: [
          Center(
            // FIRST LINE
            child: Container(
              margin: const EdgeInsets.only(top: 8, bottom: 8),
              height: 1,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.yellow[300],
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          // Search bar
          SearchBar(
            onTap: onSearchTapped,
            isSearching: isSearching,
            onExitSearch: onExitSearch,
            focusNode: searchFocusNode,
            controller: searchController,
            onChanged: (value) =>
            placesController.setSearchQuery(value),
          ),

          // Content area
          Expanded(
            child: isSearching
                ? _buildSearchContent(scrollController, context)
                : _buildDefaultContent(scrollController),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultContent(ScrollController scrollController) {
    return SingleChildScrollView(
      controller: scrollController,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: const Column(
        children: [
          RowEvents(),
        ],
      ),
    );
  }


Widget _buildSearchContent(ScrollController scrollController, BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        children: [
          // Budget filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 const Text(
                  'Budget',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _budgetController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[50],
                    hintText: 'Enter your budget here                 〒',
                    prefixIcon: const Icon(Iconsax.wallet, size: 20),
                    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 1.5,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) {
                    final budget = int.tryParse(value);
                    placesController.setBudget(budget);
                  },
                ),
              ],
            ),
          ),

          // Category filters
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildCategoryButton(
                        context,
                        'Cultural',
                        Iconsax.book_saved,
                        placesController.selectedCategories.contains('Cultural'),
                        () => placesController.toggleCategory('Cultural'),
                      ),
                      _buildCategoryButton(
                        context,
                        'Entertainment',
                        Iconsax.emoji_normal,
                        placesController.selectedCategories.contains('Entertainment'),
                        () => placesController.toggleCategory('Entertainment'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Result list
          Obx(() {
            final hasActiveSearch = searchController?.text.isNotEmpty == true;
            final noResults = placesController.places.isEmpty;
            final hasFilters = placesController.selectedCategories.isNotEmpty || 
                              placesController.budget.value > 0;

            if (hasActiveSearch && noResults) {
              return const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'No places found matching your search',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              );
            } else if (noResults && hasFilters) {
              return const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'No places match your filters',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    
                  ),
                ),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: placesController.places.length,
              itemBuilder: (context, index) {
                final place = placesController.places[index];
                return GestureDetector(
                  onTap: () => _showPlaceDetails(context, place),
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: InkWell(
                      onTap: () => _showPlaceDetails(context, place),
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    place.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Icon(Iconsax.location, size: 16, color: Colors.red[400]),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          place.address,
                                          style: TextStyle(color: Colors.grey[700], fontSize: 13),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(Iconsax.wallet, size: 16, color: Colors.green[400]),
                                      const SizedBox(width: 6),
                                      Text(
                                        '${place.averageBill} 〒',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(
    BuildContext context,
    String label,
    IconData icon,
    bool isSelected,
    VoidCallback onPressed,
  ) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? TColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey.shade300,
            width: 1.5,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: Theme.of(context).primaryColor.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              )
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? Colors.white : Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPlaceDetails(BuildContext context, Place place) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => PlaceDetailsCard(
        place: place,
        onShowRoute: onShowRoute,
      ),
    );
  }
}

class PlaceDetailsCard extends StatelessWidget {
  final Place place;
  final Function(LatLng) onShowRoute;
  


  const PlaceDetailsCard({
    super.key,
    required this.place,
    required this.onShowRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(255, 255, 255, 255),
            blurRadius: 25,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            place.name,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Iconsax.location, color: Colors.redAccent, size: 20),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  place.address,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Iconsax.ticket, color: Colors.orange, size: 20),
              const SizedBox(width: 6),
              Text(
                'Average bill: ${place.averageBill} 〒',
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            place.description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                onShowRoute(place.latLng);
              },
              icon: const Icon(Iconsax.route_square),
              label: const Text('Show Route'),
            ),
          ),
        ],
      ),
    );
  }
}