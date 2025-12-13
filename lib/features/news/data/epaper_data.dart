import '../domain/models/epaper_model.dart';

class EpaperData {
  // Vadodara/Gujarati newspapers that don't require login
  static List<Epaper> get vadodaraPapers => [
        Epaper(
          name: 'Gujarat Samachar',
          url: 'https://epaper.gujaratsamachar.com',
          category: 'gujarati',
          requiresLogin: false,
        ),
        Epaper(
          name: 'Sandesh',
          url: 'https://sandeshepaper.in',
          category: 'gujarati',
          requiresLogin: false,
        ),
        Epaper(
          name: 'Akila',
          url: 'https://akilanews.com/epaper',
          category: 'gujarati',
          requiresLogin: false,
        ),
        Epaper(
          name: 'Nobat',
          url: 'https://www.nobat.com/epaper',
          category: 'gujarati',
          requiresLogin: false,
        ),
        Epaper(
          name: 'Phulchhab',
          url: 'https://phulchhabepaper.com',
          category: 'gujarati',
          requiresLogin: false,
        ),
      ];

  static List<Epaper> get gujaratiPapers => [
        // Divya Bhaskar requires login, so excluded from vadodaraPapers
        Epaper(
          name: 'Divya Bhaskar',
          url: 'https://epaper.divyabhaskar.co.in',
          category: 'gujarati',
          requiresLogin: true,
        ),
        ...vadodaraPapers,
      ];

  // Rajasthan newspapers that don't require login
  static List<Epaper> get rajasthanPapersNoLogin => [
        Epaper(
          name: 'Rajasthan Patrika',
          url: 'https://epaper.patrika.com',
          category: 'rajasthan',
          requiresLogin: false,
        ),
        Epaper(
          name: 'Daily News Rajasthan',
          url: 'https://epaper.dnareader.in',
          category: 'rajasthan',
          requiresLogin: false,
        ),
        Epaper(
          name: 'Hindustan',
          url: 'https://epaper.livehindustan.com',
          category: 'rajasthan',
          requiresLogin: false,
        ),
      ];

  static List<Epaper> get rajasthanPapers => [
        ...rajasthanPapersNoLogin,
        // Dainik Bhaskar requires login, so excluded from rajasthanPapersNoLogin
        Epaper(
          name: 'Dainik Bhaskar',
          url: 'https://epaper.bhaskar.com',
          category: 'rajasthan',
          requiresLogin: true,
        ),
      ];

  static List<Epaper> get englishPapers => [
        Epaper(
          name: 'Times of India - Ahmedabad',
          url: 'https://epaper.timesgroup.com',
          category: 'english',
          requiresLogin: true,
        ),
        Epaper(
          name: 'Indian Express - Gujarat',
          url: 'https://epaper.indianexpress.com',
          category: 'english',
          requiresLogin: true,
        ),
        Epaper(
          name: 'Hindustan Times',
          url: 'https://epaper.hindustantimes.com',
          category: 'english',
          requiresLogin: true,
        ),
      ];

  static List<Epaper> getAllPapers() {
    return [
      ...gujaratiPapers,
      ...rajasthanPapers,
      ...englishPapers,
    ];
  }
}
