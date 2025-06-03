// places_controller.dart
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/place_model.dart';

class PlacesController extends GetxController {
  final RxList<Place> places = <Place>[].obs;
  final RxList<String> selectedCategories = <String>[].obs;
  final RxInt budget = 0.obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();

    // Automatically re-fetch when any filter changes
    everAll(
      [selectedCategories, budget],
      (_) => fetchPlaces(),
    );

    // Debounce search to avoid rapid queries
    debounce(searchQuery, (_) => fetchPlaces(), time: Duration(milliseconds: 400));

    fetchPlaces(); // Initial fetch
  }

    bool _matchesSearchTerm(String field, String query) {
      final queryTerms = query.toLowerCase().split(' ');
      final fieldLower = field.toLowerCase();
      
      // Match any search term in the field
      return queryTerms.any((term) => fieldLower.contains(term));
    }

Future<void> fetchPlaces() async {
  try {
    Query query = FirebaseFirestore.instance.collection('places');
    bool hasCategory = selectedCategories.isNotEmpty && selectedCategories.length <= 10;
    bool hasSearch = searchQuery.value.isNotEmpty;

   // When BOTH category filter and search are active
    if (hasCategory && hasSearch) {
      return _fetchWithCategoryAndSearch();
    } 
    // CASE 2: All other cases
    else {
      return _fetchStandardWay();
    }
  } catch (e) {
    print('Error fetching places: $e');
    places.value = [];
  }
}

Future<void> _fetchStandardWay() async {
  Query query = FirebaseFirestore.instance.collection('places');

  if (searchQuery.value.isNotEmpty) {
    query = query
        .where('name', isGreaterThanOrEqualTo: searchQuery.value)
        .where('name', isLessThan: '${searchQuery.value}z');
  }

  if (selectedCategories.isNotEmpty && selectedCategories.length <= 10) {
    query = query.where('category', whereIn: selectedCategories);
  }

  if (budget.value > 0) {
    query = query.where('averageBill', isLessThanOrEqualTo: budget.value);
  }

  query = query.limit(300);
  final snapshot = await query.get();
  _processResults(snapshot);
}

Future<void> _fetchWithCategoryAndSearch() async {
  // First get category-filtered results
  Query categoryQuery = FirebaseFirestore.instance.collection('places')
      .where('category', whereIn: selectedCategories)
      .limit(300);

  if (budget.value > 0) {
    categoryQuery = categoryQuery.where('averageBill', isLessThanOrEqualTo: budget.value);
  }

  final categorySnapshot = await categoryQuery.get();
  List<Place> categoryPlaces = categorySnapshot.docs.map(Place.fromFirestore).toList();

  // Then apply search filtering in-memory
  final searchTerms = searchQuery.value.toLowerCase();
  List<Place> filteredPlaces = categoryPlaces.where((place) {
      return place.name.toLowerCase().contains(searchTerms) ||
             place.address.toLowerCase() == searchTerms ||
             place.description.toLowerCase().contains(searchTerms);
  }).toList();

  places.value = filteredPlaces;
}

void _processResults(QuerySnapshot snapshot) {
  List<Place> fetchedPlaces = snapshot.docs.map(Place.fromFirestore).toList();

  if (searchQuery.value.isNotEmpty) {
    final searchTerms = searchQuery.value.toLowerCase();
    fetchedPlaces = fetchedPlaces.where((place) {
      return place.name.toLowerCase().contains(searchTerms) ||
             place.address.toLowerCase() == searchTerms ||
             place.description.toLowerCase().contains(searchTerms);
    }).toList();
  }

  places.value = fetchedPlaces;
}


bool _matchesAnyField(Place place, List<String> searchTerms) {
    final nameLower = place.name.toLowerCase();
    final addressLower = place.address.toLowerCase();
    final descriptionLower = place.description.toLowerCase();


  return searchTerms.any((term) =>
      nameLower.contains(term) ||
      addressLower.contains(term) ||
      descriptionLower.contains(term));
}

  void toggleCategory(String category) {
    if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
    } else {
      selectedCategories.add(category);
    }
  }

  void setBudget(int? value) {
    budget.value = value ?? 0;
  }

  void setSearchQuery(String query) {
    print('Search query set: $query');
    searchQuery.value = query;
  }
}
