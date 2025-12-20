import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/config/app_config.dart';
import '../../../../core/utils/app_logger.dart';
import '../domain/models/vadodara_news_model.dart';

class NewsResponse {
  final List<VadodaraNews> news;
  final String? nextPage;

  NewsResponse({
    required this.news,
    this.nextPage,
  });
}

class VadodaraNewsService {
  // NewsData.io API base URL
  static const String baseUrl = 'https://newsdata.io/api/1/news';

  /// Get NewsData.io API key from environment configuration
  static String get _apiKey {
    final key = AppConfig.newsDataApiKey;
    if (key.isEmpty || !AppConfig.isNewsDataApiKeyConfigured) {
      throw Exception(
          'NewsData.io API key is not configured. Please set NEWSDATA_API_KEY in .env file.');
    }
    return key;
  }

  // Limit initial load to 10 items for smooth performance
  static const int pageSize = 10;

  static Future<NewsResponse> fetchVadodaraNews({String? nextPage}) async {
    try {
      AppLogger.logApiCall('fetchVadodaraNews', method: 'GET');

      // Query for Vadodara or Gujarat specific news with pagination
      String urlString =
          '$baseUrl?apikey=$_apiKey&q=vadodara OR baroda OR gujarat&country=in&language=en,gu,hi&size=$pageSize';

      if (nextPage != null && nextPage.isNotEmpty) {
        urlString += '&page=$nextPage';
      }

      final url = Uri.parse(urlString);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List<dynamic>? ?? [];
        final nextPageToken = data['nextPage'] as String?;

        // Strict filtering: Only include news that mentions Vadodara, Baroda, or Gujarat
        final filteredNews = results
            .map((json) => VadodaraNews.fromJson(json as Map<String, dynamic>))
            .where((news) => _isVadodaraOrGujaratNews(news))
            .toList();

        AppLogger.logApiResponse('fetchVadodaraNews',
            statusCode: response.statusCode);
        return NewsResponse(news: filteredNews, nextPage: nextPageToken);
      } else {
        AppLogger.logApiResponse('fetchVadodaraNews',
            statusCode: response.statusCode);
        throw Exception('Failed to load news: ${response.statusCode}');
      }
    } catch (e) {
      AppLogger.logApiResponse('fetchVadodaraNews', error: e);
      // Return empty response on error
      return NewsResponse(news: []);
    }
  }

  static Future<NewsResponse> fetchBusinessNews({String? nextPage}) async {
    try {
      AppLogger.logApiCall('fetchBusinessNews', method: 'GET');

      String urlString =
          '$baseUrl?apikey=$_apiKey&q=business&country=in&language=en,gu,hi&category=business&size=$pageSize';

      if (nextPage != null && nextPage.isNotEmpty) {
        urlString += '&page=$nextPage';
      }

      final url = Uri.parse(urlString);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List<dynamic>? ?? [];
        final nextPageToken = data['nextPage'] as String?;

        final news = results
            .map((json) => VadodaraNews.fromJson(json as Map<String, dynamic>))
            .toList();

        AppLogger.logApiResponse('fetchBusinessNews',
            statusCode: response.statusCode);
        return NewsResponse(news: news, nextPage: nextPageToken);
      } else {
        AppLogger.logApiResponse('fetchBusinessNews',
            statusCode: response.statusCode);
        throw Exception('Failed to load business news: ${response.statusCode}');
      }
    } catch (e) {
      AppLogger.logApiResponse('fetchBusinessNews', error: e);
      // Return empty response on error
      return NewsResponse(news: []);
    }
  }

  static Future<NewsResponse> fetchRajasthanNews({String? nextPage}) async {
    try {
      AppLogger.logApiCall('fetchRajasthanNews', method: 'GET');

      // Query for Rajasthan news - focusing on Pali, Jodhpur, Jaipur
      // Prioritize Hindi language for Rajasthan news
      String urlString =
          '$baseUrl?apikey=$_apiKey&q=pali OR jodhpur OR jaipur OR rajasthan&country=in&language=hi,en&size=$pageSize';

      if (nextPage != null && nextPage.isNotEmpty) {
        urlString += '&page=$nextPage';
      }

      final url = Uri.parse(urlString);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List<dynamic>? ?? [];
        final nextPageToken = data['nextPage'] as String?;

        // Filter and prioritize: Pali district news first, then Jodhpur, Jaipur, then other Rajasthan
        final filteredNews = results
            .map((json) => VadodaraNews.fromJson(json as Map<String, dynamic>))
            .where((news) => _isRajasthanNews(news))
            .toList();

        // Sort: Pali district news on top, then Jodhpur, then Jaipur, then other Rajasthan
        filteredNews.sort((a, b) {
          final aText =
              '${a.title} ${a.description} ${a.content ?? ''}'.toLowerCase();
          final bText =
              '${b.title} ${b.description} ${b.content ?? ''}'.toLowerCase();

          // Priority: Pali > Jodhpur > Jaipur > Other Rajasthan
          final aIsPali = aText.contains('pali') || aText.contains('पाली');
          final bIsPali = bText.contains('pali') || bText.contains('पाली');
          final aIsJodhpur =
              aText.contains('jodhpur') || aText.contains('जोधपुर');
          final bIsJodhpur =
              bText.contains('jodhpur') || bText.contains('जोधपुर');
          final aIsJaipur = aText.contains('jaipur') || aText.contains('जयपुर');
          final bIsJaipur = bText.contains('jaipur') || bText.contains('जयपुर');

          // Pali has highest priority
          if (aIsPali && !bIsPali) return -1;
          if (!aIsPali && bIsPali) return 1;

          // If both are Pali or both are not Pali, check Jodhpur
          if (aIsJodhpur && !bIsJodhpur && !bIsPali) return -1;
          if (!aIsJodhpur && bIsJodhpur && !aIsPali) return 1;

          // If both are Jodhpur or both are not Jodhpur, check Jaipur
          if (aIsJaipur && !bIsJaipur && !bIsPali && !bIsJodhpur) return -1;
          if (!aIsJaipur && bIsJaipur && !aIsPali && !aIsJodhpur) return 1;

          // Maintain original order for same priority
          return 0;
        });

        AppLogger.logApiResponse('fetchRajasthanNews',
            statusCode: response.statusCode);
        return NewsResponse(news: filteredNews, nextPage: nextPageToken);
      } else {
        AppLogger.logApiResponse('fetchRajasthanNews',
            statusCode: response.statusCode);
        throw Exception(
            'Failed to load Rajasthan news: ${response.statusCode}');
      }
    } catch (e) {
      AppLogger.logApiResponse('fetchRajasthanNews', error: e);
      // Return empty response on error
      return NewsResponse(news: []);
    }
  }

  // Strict validation: Check if news is related to Vadodara or Gujarat
  static bool _isVadodaraOrGujaratNews(VadodaraNews news) {
    final searchText =
        '${news.title} ${news.description} ${news.content ?? ''}'.toLowerCase();

    // Keywords that indicate Vadodara/Gujarat relevance
    final vadodaraKeywords = [
      'vadodara',
      'baroda',
      'gujarat',
      'gujarati',
      'ahmedabad',
      'surat',
      'rajkot',
      'gandhinagar',
      'jamnagar',
      'bhavnagar',
      'anand',
      'nadiad',
      'mehsana',
      'bharuch',
      'valsad',
      'navsari',
    ];

    // Check if any keyword is present in the news content
    return vadodaraKeywords.any((keyword) => searchText.contains(keyword));
  }

  // Validation: Check if news is related to Rajasthan (Pali, Jodhpur, Jaipur, or Rajasthan)
  static bool _isRajasthanNews(VadodaraNews news) {
    final searchText =
        '${news.title} ${news.description} ${news.content ?? ''}'.toLowerCase();

    // Keywords that indicate Rajasthan relevance
    final rajasthanKeywords = [
      'pali',
      'पाली', // Pali in Hindi
      'jodhpur',
      'जोधपुर', // Jodhpur in Hindi
      'jaipur',
      'जयपुर', // Jaipur in Hindi
      'rajasthan',
      'राजस्थान', // Rajasthan in Hindi
      'udaipur',
      'उदयपुर', // Udaipur in Hindi
      'ajmer',
      'अजमेर', // Ajmer in Hindi
      'bikaner',
      'बीकानेर', // Bikaner in Hindi
      'kota',
      'कोटा', // Kota in Hindi
      'jaisalmer',
      'जैसलमेर', // Jaisalmer in Hindi
      'bharatpur',
      'भरतपुर', // Bharatpur in Hindi
      'sikar',
      'सीकर', // Sikar in Hindi
      'alwar',
      'अलवर', // Alwar in Hindi
    ];

    // Check if any keyword is present in the news content
    return rajasthanKeywords.any((keyword) => searchText.contains(keyword));
  }
}
