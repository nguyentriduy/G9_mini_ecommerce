import 'package:flutter/material.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelected,
  });

  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 172,
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.9,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category;
          return Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => onSelected(category),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFFEA580C)
                        : const Color(0xFFEFE1D5),
                    width: isSelected ? 1.4 : 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: isSelected
                            ? const Color(0xFFFFE7D4)
                            : const Color(0xFFF6EEE7),
                        child: Icon(
                          _resolveIcon(category),
                          color: const Color(0xFF9A3412),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Expanded(
                        child: Center(
                          child: Text(
                            category,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                              color: isSelected
                                  ? const Color(0xFF9A3412)
                                  : const Color(0xFF1F2937),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _resolveIcon(String category) {
    switch (category.toLowerCase()) {
      case 'electronics':
        return Icons.devices_other_rounded;
      case 'clothing':
        return Icons.checkroom_rounded;
      case 'beauty':
        return Icons.spa_outlined;
      case 'home':
        return Icons.chair_alt_rounded;
      case 'toys':
        return Icons.toys_rounded;
      case 'shoes':
        return Icons.hiking_rounded;
      case 'sports':
        return Icons.sports_basketball_rounded;
      case 'grocery':
        return Icons.local_grocery_store_outlined;
      case 'tất cả':
        return Icons.grid_view_rounded;
      default:
        return Icons.widgets_outlined;
    }
  }
}
