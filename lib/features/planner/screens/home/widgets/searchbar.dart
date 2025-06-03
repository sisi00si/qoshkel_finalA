import 'package:flutter/material.dart';
import 'package:QoshKel/utils/constants/colors.dart';

class SearchBar extends StatelessWidget {
  final VoidCallback onTap;
  final bool isSearching;
  final VoidCallback onExitSearch;
  final double height;
  final double baseTop;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  

  const SearchBar({
    super.key,
    required this.onTap,
    required this.isSearching,
    required this.onExitSearch,
    this.height = 60.0,
    this.baseTop = 0.0,
    this.focusNode,
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (!isSearching) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: height,
          padding: const EdgeInsets.only(top: 6),
          margin: const EdgeInsets.only(left: 10, right: 10),
          transform: Matrix4.translationValues(0.0, -20.0, 0.0),
          decoration: BoxDecoration(
            color: TColors.primary,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              const Icon(Icons.search, color: Colors.white, size: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: const Opacity(
                  opacity: 0.8,
                  child: Text(
                    'Search here',
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        margin: const EdgeInsets.only(left: 10, right: 10),
        transform: Matrix4.translationValues(0.0, -20.0, 0.0),
        decoration: BoxDecoration(
          color: TColors.primary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                focusNode: focusNode,
                controller: controller,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Type address or building name',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                autofocus: true,
                onChanged: onChanged,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: onExitSearch,
            )
          ],
        ),
      );
    }
  }
}


