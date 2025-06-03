// TODO Implement this library.import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';


class BadgeCriteria {
  final String id;
  final String title;
  final IconData icon;
  final String description;
  final Map<String, int> requirements;

  const BadgeCriteria({
    required this.id,
    required this.title,
    required this.icon,
    required this.description,
    required this.requirements,
  });

  static const allBadges = [
    BadgeCriteria(
      id: 'explorer',
      title: 'Explorer',
      icon: Iconsax.global,
      description: 'Visit 3 different places',
      requirements: {'total_places': 3},
    ),
    BadgeCriteria(
      id: 'history_hunter',
      title: 'History Hunter',
      icon: Iconsax.cup,
      description: 'Visit 5 historical places',
      requirements: {'historic': 5},
    ),
    BadgeCriteria(
      id: 'astanchanin',
      title: 'Astanchanin',
      icon: Iconsax.crown,
      description: 'Visit 12 places in Astana',
      requirements: {'astana': 12},
    ),
  ];
}