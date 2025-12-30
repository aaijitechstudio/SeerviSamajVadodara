import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/responsive_page.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../community/presentation/widgets/post_list_widget.dart';
import '../../../weather/providers/weather_provider.dart';

class HomeScreen extends ConsumerWidget {
  final VoidCallback onOpenDrawer;

  const HomeScreen({
    super.key,
    required this.onOpenDrawer,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final weatherAsync = ref.watch(weatherProvider);

    final locationName = weatherAsync.when(
      data: (weather) => weather?.location ?? 'Vadodara',
      loading: () => 'Vadodara',
      error: (_, __) => 'Vadodara',
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          tooltip: l10n.menu,
          onPressed: onOpenDrawer,
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.asset(
                'assets/images/samaj_logo.png',
                width: 34,
                height: 34,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.people);
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.samajTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    locationName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
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
      ),
      body: const ResponsivePage(
        useSafeArea: false,
        child: PostListWidget(),
      ),
    );
  }
}


