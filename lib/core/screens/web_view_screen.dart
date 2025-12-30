import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../constants/design_tokens.dart';
import '../theme/app_colors.dart';
import '../../l10n/app_localizations.dart';

/// Global WebView screen with dynamic URL and app bar title
/// Can be used throughout the app for opening web URLs
class GlobalWebViewScreen extends StatefulWidget {
  final String url;
  final String? title;

  const GlobalWebViewScreen({
    super.key,
    required this.url,
    this.title,
  });

  @override
  State<GlobalWebViewScreen> createState() => _GlobalWebViewScreenState();
}

class _GlobalWebViewScreenState extends State<GlobalWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  String? _errorMessage;
  String? _pageTitle;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  bool _isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  void _initializeWebView() {
    // Validate URL before loading
    if (!_isValidUrl(widget.url)) {
      setState(() {
        _isLoading = false;
        _errorMessage =
            'Invalid URL: "${widget.url}"\n\nThis appears to be a description rather than a web address. Please check the resource link.';
      });
      return;
    }

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
              _errorMessage = null;
            });
          },
          onPageFinished: (String url) async {
            // Get page title
            final title = await _controller.getTitle();
            setState(() {
              _isLoading = false;
              _pageTitle = title;
            });
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              _isLoading = false;
              _errorMessage = error.description;
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            // Allow all navigation
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  String _getAppBarTitle() {
    if (widget.title != null && widget.title!.isNotEmpty) {
      return widget.title!;
    }
    if (_pageTitle != null && _pageTitle!.isNotEmpty) {
      return _pageTitle!;
    }
    return AppLocalizations.of(context)?.eNewspaper ?? 'Web View';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getAppBarTitle()),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () {
              _controller.reload();
            },
          ),
          IconButton(
            icon: const Icon(Icons.open_in_browser),
            tooltip: 'Open in Browser',
            onPressed: () async {
              // Open in external browser
              // You can use url_launcher here if needed
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            Container(
              color: AppColors.backgroundWhite,
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryOrange,
                ),
              ),
            ),
          if (_errorMessage != null && !_isLoading)
            Container(
              color: AppColors.backgroundWhite,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(DesignTokens.spacingL),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red[300],
                      ),
                      const SizedBox(height: DesignTokens.spacingM),
                      Text(
                        _errorMessage!,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: DesignTokens.spacingL),
                      ElevatedButton(
                        onPressed: () {
                          _controller.reload();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryOrange,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
