import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/responsive_page.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/models/post_model.dart';
import '../widgets/post_item_widget.dart';

class PostDetailScreen extends ConsumerWidget {
  const PostDetailScreen({super.key});

  static const String routeName = '/post-detail';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    final args = ModalRoute.of(context)?.settings.arguments;
    final post = args is PostModel ? args : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.details),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ResponsivePage(
        useSafeArea: false,
        child: post == null
            ? Center(child: Text(l10n.error))
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: PostItemWidget(
                    post: post,
                    // No need to open details from within details.
                    onOpenDetails: null,
                  ),
                ),
              ),
      ),
    );
  }
}


