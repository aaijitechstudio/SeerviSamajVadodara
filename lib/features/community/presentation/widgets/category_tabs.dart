import 'package:flutter/material.dart';
import '../../../../shared/models/post_model.dart';
import '../../../../core/constants/design_tokens.dart';

class CategoryTabs extends StatelessWidget {
  final TabController controller;
  final Function(PostCategory)? onCategorySelected;

  const CategoryTabs({
    super.key,
    required this.controller,
    this.onCategorySelected,
  });

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
      color: Theme.of(context).scaffoldBackgroundColor,
      child: TabBar(
        controller: controller,
        isScrollable: true,
        indicatorColor: Theme.of(context).primaryColor,
        labelColor: Theme.of(context).primaryColor,
        unselectedLabelColor: DesignTokens.grey600,
        labelStyle: TextStyle(
          fontSize: DesignTokens.fontSizeM,
          fontWeight: DesignTokens.fontWeightBold,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: DesignTokens.fontSizeM,
          fontWeight: DesignTokens.fontWeightRegular,
        ),
        tabs: PostCategory.values.map((category) {
          return Tab(
            text: _getCategoryLabel(category),
          );
        }).toList(),
        onTap: (index) {
          onCategorySelected?.call(PostCategory.values[index]);
        },
      ),
    );
  }
}
