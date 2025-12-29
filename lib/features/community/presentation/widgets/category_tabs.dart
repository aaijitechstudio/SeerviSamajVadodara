import 'package:flutter/material.dart';
import '../../../../shared/models/post_model.dart';
import '../../../../core/constants/design_tokens.dart';
import '../../../../core/theme/app_colors.dart';

class CategoryTabs extends StatefulWidget {
  final TabController controller;
  final Function(PostCategory)? onCategorySelected;

  const CategoryTabs({
    super.key,
    required this.controller,
    this.onCategorySelected,
  });

  @override
  State<CategoryTabs> createState() => _CategoryTabsState();
}

class _CategoryTabsState extends State<CategoryTabs> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTabChanged);
    super.dispose();
  }

  void _onTabChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  String _getCategoryLabel(PostCategory category) {
    switch (category) {
      case PostCategory.announcement:
        return '📢 Announcements';
      case PostCategory.discussion:
        return '💬 Discussion';
      case PostCategory.events:
        return '🎉 Events';
      case PostCategory.gallery:
        return '📸 Gallery';
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spacingM,
          vertical: DesignTokens.spacingS,
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: PostCategory.values.asMap().entries.map((entry) {
              final index = entry.key;
              final category = entry.value;
              final isSelected = widget.controller.index == index;

              return Padding(
                padding: const EdgeInsets.only(right: DesignTokens.spacingS),
                child: _buildCategoryChip(
                  category: category,
                  isSelected: isSelected,
                  onTap: () {
                    widget.controller.animateTo(index);
                    widget.onCategorySelected?.call(category);
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip({
    required PostCategory category,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryOrange : AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(DesignTokens.radiusXL),
        border: Border.all(
          color: isSelected ? AppColors.primaryOrange : AppColors.borderLight,
          width: 1.5,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppColors.primaryOrange.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(DesignTokens.radiusXL),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: DesignTokens.spacingL,
              vertical: DesignTokens.spacingM,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _getCategoryLabel(category),
                  style: TextStyle(
                    fontSize: DesignTokens.fontSizeM,
                    fontWeight: isSelected
                        ? DesignTokens.fontWeightBold
                        : DesignTokens.fontWeightSemiBold,
                    color: isSelected
                        ? AppColors.textOnPrimary
                        : AppColors.textPrimary,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
