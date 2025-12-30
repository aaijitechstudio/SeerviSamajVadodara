import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/post_model.dart';
import '../../../../l10n/app_localizations.dart';
import '../widgets/post_list_widget.dart';
import '../widgets/category_tabs.dart';
import '../../../../core/widgets/responsive_page.dart';

class CommunityBoardScreen extends ConsumerStatefulWidget {
  const CommunityBoardScreen({super.key});

  @override
  ConsumerState<CommunityBoardScreen> createState() =>
      _CommunityBoardScreenState();
}

class _CommunityBoardScreenState extends ConsumerState<CommunityBoardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Community Board'),
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              final scaffoldState =
                  context.findAncestorStateOfType<ScaffoldState>();
              scaffoldState?.openDrawer();
            },
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            tooltip: l10n.notifications,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.comingSoon)),
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: CategoryTabs(
            controller: _tabController,
            onCategorySelected: (category) {
              // Category selection handled by TabController
            },
          ),
        ),
      ),
      body: ResponsivePage(
        useSafeArea: false,
        child: TabBarView(
          controller: _tabController,
          children: PostCategory.values.map((category) {
            return PostListWidget(
              category: category,
              key: ValueKey(category),
            );
          }).toList(),
        ),
      ),
    );
  }
}
