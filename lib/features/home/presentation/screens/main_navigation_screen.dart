import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/constants/design_tokens.dart';
import '../../../members/presentation/screens/merged_members_screen.dart';
import '../../../news/presentation/screens/news_screen.dart';
import '../../../auth/presentation/screens/profile_screen.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../../community/presentation/screens/post_composer_screen.dart';
import '../../../education/presentation/screens/education_career_screen.dart';
import '../../../../shared/models/post_model.dart';
import '../widgets/app_drawer.dart';
import 'home_screen.dart';

// Provider for navigation index
final navigationIndexProvider = StateProvider<int>((ref) => 0);

class MainNavigationScreen extends ConsumerStatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  ConsumerState<MainNavigationScreen> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState extends ConsumerState<MainNavigationScreen> {
  @override
  void initState() {
    super.initState();
    // Ensure initial index is valid
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentIndex = ref.read(navigationIndexProvider);
      if (currentIndex < 0 || currentIndex >= 5) {
        ref.read(navigationIndexProvider.notifier).state = 0;
      }
    });
  }

  List<Widget> _buildScreens() {
    return [
      const HomeScreen(),
      const NewsScreen(),
      const MergedMembersScreen(),
      const EducationCareerScreen(),
      const ProfileScreen(),
    ];
  }

  void setSelectedIndex(int index) {
    if (index >= 0 && index < 5) {
      ref.read(navigationIndexProvider.notifier).state = index;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final selectedIndex = ref.watch(navigationIndexProvider);
    final authState = ref.watch(authControllerProvider);
    final user = authState.user;
    final isAdmin = user?.isAdmin ?? false;

    final screens = _buildScreens();
    // Ensure selectedIndex is within valid range
    final safeIndex = selectedIndex >= 0 && selectedIndex < screens.length
        ? selectedIndex
        : 0;

    return Scaffold(
      drawer: AppDrawer(
        user: user,
        isAdmin: isAdmin,
      ),
      body: IndexedStack(
        index: safeIndex,
        children: screens,
      ),
      floatingActionButton: safeIndex == 0 && user != null
          ? FloatingActionButton(
              onPressed: () {
                // Navigate to post composer - default to discussion category
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PostComposerScreen(
                      initialCategory: PostCategory.discussion,
                    ),
                  ),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: DesignTokens.backgroundWhite,
          boxShadow: [
            BoxShadow(
              color: DesignTokens.shadowLight,
              blurRadius: DesignTokens.elevationMedium,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildNavItem(
                  context,
                  icon: Icons.home_rounded,
                  label: l10n.home,
                  index: 0,
                ),
                _buildNavItem(
                  context,
                  icon: Icons.newspaper_rounded,
                  label: l10n.news,
                  index: 1,
                ),
                _buildNavItem(
                  context,
                  icon: Icons.people_rounded,
                  label: l10n.members,
                  index: 2,
                ),
                _buildNavItem(
                  context,
                  icon: Icons.school_rounded,
                  label: 'Education',
                  index: 3,
                ),
                _buildNavItem(
                  context,
                  icon: Icons.person_rounded,
                  label: l10n.profile,
                  index: 4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int index,
  }) {
    final selectedIndex = ref.watch(navigationIndexProvider);
    final safeIndex =
        selectedIndex >= 0 && selectedIndex < 5 ? selectedIndex : 0;
    final isSelected = safeIndex == index;
    final selectedColor = DesignTokens.primaryOrange;
    final unselectedColor = DesignTokens.grey500;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            ref.read(navigationIndexProvider.notifier).state = index;
          },
          borderRadius: BorderRadius.circular(DesignTokens.radiusM),
          child: AnimatedContainer(
            duration: DesignTokens.durationMedium,
            curve: Curves.easeInOutCubic,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            decoration: BoxDecoration(
              color: isSelected
                  ? DesignTokens.primaryOrange.withValues(alpha: 0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(DesignTokens.radiusM),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AnimatedScale(
                  scale: isSelected ? 1.1 : 1.0,
                  duration: DesignTokens.durationMedium,
                  curve: Curves.easeInOutCubic,
                  child: AnimatedContainer(
                    duration: DesignTokens.durationMedium,
                    curve: Curves.easeInOutCubic,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? DesignTokens.primaryOrange.withValues(alpha: 0.15)
                          : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: isSelected ? selectedColor : unselectedColor,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                AnimatedDefaultTextStyle(
                  duration: DesignTokens.durationMedium,
                  curve: Curves.easeInOutCubic,
                  style: TextStyle(
                    fontSize: isSelected ? 12 : 11,
                    fontWeight: isSelected
                        ? DesignTokens.fontWeightSemiBold
                        : DesignTokens.fontWeightRegular,
                    color: isSelected ? selectedColor : unselectedColor,
                    height: 1.2,
                  ),
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
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
