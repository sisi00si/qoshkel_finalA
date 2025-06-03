import 'package:QoshKel/features/personalization/models/badge_criteria.dart';
import 'package:flutter/material.dart';

class GoldBadge extends StatelessWidget {
   final BadgeCriteria criteria;
  final bool isEarned;
  // final Map<String, int> userProgress;
  final double progress;

  const GoldBadge({
    super.key,
    required this.criteria,
    required this.isEarned,
    required this.progress,
  });

    double _calculateProgress() {
    if (isEarned) return 1.0;
    
    double maxProgress = 0;
    for (final req in criteria.requirements.entries) {
      final current = progress?.toDouble() ?? 0;
      maxProgress = current / req.value;
    }
    return maxProgress;
  }

  @override
  Widget build(BuildContext context) {
    
    final progress = _calculateProgress();

   return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: isEarned 
                    ? const LinearGradient(
                        colors: [Color(0xFFFFD700), Color(0xFFFFC300)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : LinearGradient(
                        colors: [Colors.grey.shade300, Colors.grey.shade400],
                      ),
                  boxShadow: isEarned 
                    ? [/* existing shadow */]
                    : null,
                ),
                padding: const EdgeInsets.all(12),
                child: Icon(criteria.icon, size: 30, 
                  color: isEarned ? Colors.white : Colors.grey.shade600),
              ),
              if (!isEarned)
                CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 2,
                  color: Colors.white,
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            criteria.title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isEarned ? FontWeight.w600 : FontWeight.w400,
              color: isEarned 
                ? const Color.fromARGB(255, 0, 0, 0)
                : Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          if (!isEarned)
            AnimatedOpacity(
              opacity: isEarned ? 0 : 1,
              duration: const Duration(milliseconds: 300),
              child: Text(
                '${(progress * 100).toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
