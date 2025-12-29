import '../domain/models/vedic_siksha_model.dart';

/// Vedic Siksha Data Provider
/// Contains detailed information about all Vedic scriptures, philosophy, and values
class VedicSikshaData {
  /// Get Rigveda details
  static VedicSikshaDetail getRigvedaDetail() {
    return VedicSikshaDetail(
      title: 'ऋग्वेद',
      subtitle: 'Rigveda – Knowledge of Hymns',
      heroImage:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800&h=400&fit=crop',
      description:
          'ऋग्वेद विश्व का सबसे प्राचीन वैदिक ग्रंथ है। इसमें देवताओं की स्तुति हेतु '
          'रचित 1028 सूक्त हैं। यह प्रकृति, सत्य और ब्रह्मांडीय संतुलन का ज्ञान देता है। '
          'ऋग्वेद में 10 मंडल हैं जिनमें विभिन्न देवताओं की स्तुतियाँ, प्रार्थनाएँ और '
          'दार्शनिक विचार समाहित हैं। यह मानव जीवन के मूलभूत सिद्धांतों को प्रस्तुत करता है।',
      keyPoints: [
        'अग्नि, इंद्र, वरुण आदि देवताओं की स्तुति',
        'सत्य और ऋत का महत्व',
        'मानव और प्रकृति का सामंजस्य',
        'ब्रह्मांडीय व्यवस्था और नैतिकता',
        'ज्ञान और बुद्धि की प्रार्थना',
        'समाज और परिवार के मूल्य',
      ],
      imageGallery: [
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=300&fit=crop',
        'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=400&h=300&fit=crop',
      ],
      links: [
        ResourceLink(
          'ऋग्वेद – विकिपीडिया',
          'https://hi.wikipedia.org/wiki/ऋग्वेद',
        ),
        ResourceLink(
          'Public Domain Rigveda Text',
          'https://www.wikisource.org/wiki/Rigveda',
        ),
        ResourceLink(
          'Rigveda in English',
          'https://www.sacred-texts.com/hin/rigveda/index.htm',
        ),
      ],
      videos: [
        ResourceLink(
          'ऋग्वेद मंत्र उच्चारण',
          'https://www.youtube.com/watch?v=ZJj8Z1xR6E8',
        ),
        ResourceLink(
          'Introduction to Rigveda',
          'https://www.youtube.com/watch?v=K9G5ZxY1mRM',
        ),
        ResourceLink(
          'Rigveda Explained',
          'https://www.youtube.com/results?search_query=Rigveda+explained',
        ),
      ],
    );
  }

  /// Get Yajurveda details
  static VedicSikshaDetail getYajurvedaDetail() {
    return VedicSikshaDetail(
      title: 'यजुर्वेद',
      subtitle: 'Yajurveda – Knowledge of Rituals',
      heroImage:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800&h=400&fit=crop',
      description:
          'यजुर्वेद यज्ञ और अनुष्ठानों से संबंधित ज्ञान का ग्रंथ है। इसमें यज्ञ की विधियाँ, '
          'मंत्रों का उच्चारण और अनुष्ठानों का विस्तृत वर्णन है। यह कर्मकांड और आध्यात्मिक '
          'अनुष्ठानों के बीच सेतु का काम करता है। यजुर्वेद दो भागों में विभाजित है - '
          'शुक्ल यजुर्वेद और कृष्ण यजुर्वेद।',
      keyPoints: [
        'यज्ञ और अनुष्ठानों की विधियाँ',
        'कर्मकांड और आध्यात्मिकता का संतुलन',
        'मंत्रों का सही उच्चारण',
        'सामाजिक और धार्मिक कर्तव्य',
        'देवताओं की पूजा विधि',
        'यज्ञ के लाभ और महत्व',
      ],
      imageGallery: [
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=300&fit=crop',
        'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=400&h=300&fit=crop',
      ],
      links: [
        ResourceLink(
          'यजुर्वेद – विकिपीडिया',
          'https://hi.wikipedia.org/wiki/यजुर्वेद',
        ),
        ResourceLink(
          'Yajurveda Text',
          'https://www.sacred-texts.com/hin/yv/index.htm',
        ),
      ],
      videos: [
        ResourceLink(
          'यजुर्वेद मंत्र',
          'https://www.youtube.com/results?search_query=Yajurveda+mantras',
        ),
        ResourceLink(
          'Yajurveda Introduction',
          'https://www.youtube.com/results?search_query=Yajurveda+introduction',
        ),
      ],
    );
  }

  /// Get Samaveda details
  static VedicSikshaDetail getSamavedaDetail() {
    return VedicSikshaDetail(
      title: 'सामवेद',
      subtitle: 'Samaveda – Knowledge of Melodies',
      heroImage:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800&h=400&fit=crop',
      description:
          'सामवेद संगीत और मंत्रों के सामवेदिक स्वरों का ग्रंथ है। इसमें ऋग्वेद के मंत्रों को '
          'संगीतमय रूप में प्रस्तुत किया गया है। सामवेद को भारतीय संगीत का मूल माना जाता है। '
          'इसमें विभिन्न रागों और स्वरों का वर्णन है जो आध्यात्मिक अनुभव को गहरा करते हैं।',
      keyPoints: [
        'संगीत और मंत्रों का संगम',
        'भारतीय संगीत का मूल',
        'राग और स्वरों का ज्ञान',
        'आध्यात्मिक संगीत की परंपरा',
        'मंत्रों का संगीतमय उच्चारण',
        'संगीत के माध्यम से मोक्ष',
      ],
      imageGallery: [
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=300&fit=crop',
        'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=400&h=300&fit=crop',
      ],
      links: [
        ResourceLink(
          'सामवेद – विकिपीडिया',
          'https://hi.wikipedia.org/wiki/सामवेद',
        ),
        ResourceLink(
          'Samaveda Text',
          'https://www.sacred-texts.com/hin/sv/index.htm',
        ),
      ],
      videos: [
        ResourceLink(
          'सामवेद संगीत',
          'https://www.youtube.com/results?search_query=Samaveda+music',
        ),
        ResourceLink(
          'Samaveda Chanting',
          'https://www.youtube.com/results?search_query=Samaveda+chanting',
        ),
      ],
    );
  }

  /// Get Atharvaveda details
  static VedicSikshaDetail getAtharvavedaDetail() {
    return VedicSikshaDetail(
      title: 'अथर्ववेद',
      subtitle: 'Atharvaveda – Knowledge of Daily Life',
      heroImage:
          'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=800&h=400&fit=crop',
      description:
          'अथर्ववेद दैनिक जीवन, चिकित्सा, जादू-टोना और व्यावहारिक ज्ञान से संबंधित है। '
          'इसमें रोगों के उपचार, शुभ-अशुभ कार्यों, गृहस्थ जीवन और सामाजिक व्यवस्था के '
          'बारे में विस्तृत जानकारी है। यह वेद सबसे बाद में रचा गया और इसमें लोक जीवन के '
          'विभिन्न पहलुओं को शामिल किया गया है।',
      keyPoints: [
        'दैनिक जीवन का ज्ञान',
        'चिकित्सा और आयुर्वेद',
        'गृहस्थ जीवन के नियम',
        'सामाजिक व्यवस्था',
        'रोग निवारण के उपाय',
        'शुभ-अशुभ कार्यों का ज्ञान',
      ],
      imageGallery: [
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=300&fit=crop',
        'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=400&h=300&fit=crop',
      ],
      links: [
        ResourceLink(
          'अथर्ववेद – विकिपीडिया',
          'https://hi.wikipedia.org/wiki/अथर्ववेद',
        ),
        ResourceLink(
          'Atharvaveda Text',
          'https://www.sacred-texts.com/hin/av/index.htm',
        ),
      ],
      videos: [
        ResourceLink(
          'अथर्ववेद ज्ञान',
          'https://www.youtube.com/results?search_query=Atharvaveda',
        ),
        ResourceLink(
          'Atharvaveda Explained',
          'https://www.youtube.com/results?search_query=Atharvaveda+explained',
        ),
      ],
    );
  }

  /// Get Upanishads details
  static VedicSikshaDetail getUpanishadsDetail() {
    return VedicSikshaDetail(
      title: 'उपनिषद',
      subtitle: 'Upanishads – Philosophical Knowledge',
      heroImage:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800&h=400&fit=crop',
      description:
          'उपनिषद वैदिक दर्शन के मूल ग्रंथ हैं जो आत्म-साक्षात्कार और ब्रह्म ज्ञान पर केंद्रित हैं। '
          'मुख्य उपनिषदों में ईश, केन, कठ, प्रश्न, मुंडक, मांडूक्य, तैत्तिरीय, ऐतरेय, '
          'छांदोग्य और बृहदारण्यक शामिल हैं। ये ग्रंथ आत्मा, ब्रह्म और मोक्ष के बारे में '
          'गहन दार्शनिक चिंतन प्रस्तुत करते हैं।',
      keyPoints: [
        'आत्म-साक्षात्कार का ज्ञान',
        'ब्रह्म और आत्मा की एकता',
        'मोक्ष और मुक्ति का मार्ग',
        'दार्शनिक चिंतन',
        'आध्यात्मिक ज्ञान',
        'वेदांत दर्शन का आधार',
      ],
      imageGallery: [
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=300&fit=crop',
        'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=400&h=300&fit=crop',
      ],
      links: [
        ResourceLink(
          'उपनिषद – विकिपीडिया',
          'https://hi.wikipedia.org/wiki/उपनिषद',
        ),
        ResourceLink(
          'Principal Upanishads',
          'https://www.sacred-texts.com/hin/upan/index.htm',
        ),
        ResourceLink(
          'Upanishads in Hindi',
          'https://hi.wikipedia.org/wiki/उपनिषदों_की_सूची',
        ),
      ],
      videos: [
        ResourceLink(
          'उपनिषद व्याख्या',
          'https://www.youtube.com/results?search_query=Upanishads+explained',
        ),
        ResourceLink(
          'Upanishads Philosophy',
          'https://www.youtube.com/results?search_query=Upanishads+philosophy',
        ),
      ],
    );
  }

  /// Get Samkhya Philosophy details
  static VedicSikshaDetail getSamkhyaDetail() {
    return VedicSikshaDetail(
      title: 'सांख्य दर्शन',
      subtitle: 'Samkhya Philosophy',
      heroImage:
          'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=800&h=400&fit=crop',
      description:
          'सांख्य दर्शन भारतीय दर्शन की सबसे प्राचीन प्रणाली है। यह पुरुष (चेतना) और प्रकृति '
          '(भौतिक जगत) के बीच अंतर स्थापित करता है। सांख्य दर्शन के अनुसार, सृष्टि 25 तत्वों '
          'से बनी है जिनमें पुरुष और प्रकृति मुख्य हैं। यह दर्शन दुःख के कारणों की व्याख्या '
          'करता है और मोक्ष का मार्ग बताता है।',
      keyPoints: [
        'पुरुष और प्रकृति का विभेद',
        '25 तत्वों का सिद्धांत',
        'दुःख के कारणों का विश्लेषण',
        'मोक्ष का मार्ग',
        'चेतना और भौतिक जगत',
        'द्वैतवादी दर्शन',
      ],
      imageGallery: [
        'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=400&h=300&fit=crop',
      ],
      links: [
        ResourceLink(
          'सांख्य दर्शन – विकिपीडिया',
          'https://hi.wikipedia.org/wiki/सांख्य_दर्शन',
        ),
        ResourceLink(
          'Samkhya Philosophy',
          'https://www.sacred-texts.com/hin/sbe23/index.htm',
        ),
      ],
      videos: [
        ResourceLink(
          'सांख्य दर्शन व्याख्या',
          'https://www.youtube.com/results?search_query=Samkhya+philosophy',
        ),
        ResourceLink(
          'Samkhya Explained',
          'https://www.youtube.com/results?search_query=Samkhya+explained',
        ),
      ],
    );
  }

  /// Get Yoga Philosophy details
  static VedicSikshaDetail getYogaDetail() {
    return VedicSikshaDetail(
      title: 'योग दर्शन',
      subtitle: 'Yoga Philosophy – Patanjali Yoga Sutras',
      heroImage:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800&h=400&fit=crop',
      description:
          'योग दर्शन पतंजलि के योग सूत्रों पर आधारित है। इसमें आठ अंगों का वर्णन है - '
          'यम, नियम, आसन, प्राणायाम, प्रत्याहार, धारणा, ध्यान और समाधि। योग दर्शन चित्त की '
          'वृत्तियों को नियंत्रित करके आत्म-साक्षात्कार का मार्ग बताता है। यह शारीरिक, '
          'मानसिक और आध्यात्मिक स्वास्थ्य का समग्र दर्शन है।',
      keyPoints: [
        'पतंजलि के योग सूत्र',
        'अष्टांग योग',
        'चित्त वृत्ति निरोध',
        'आत्म-साक्षात्कार',
        'शारीरिक और मानसिक स्वास्थ्य',
        'समाधि की प्राप्ति',
      ],
      imageGallery: [
        'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=400&h=300&fit=crop',
      ],
      links: [
        ResourceLink(
          'योग दर्शन – विकिपीडिया',
          'https://hi.wikipedia.org/wiki/योग_दर्शन',
        ),
        ResourceLink(
          'Patanjali Yoga Sutras',
          'https://www.sacred-texts.com/hin/yogasutr.htm',
        ),
      ],
      videos: [
        ResourceLink(
          'योग सूत्र व्याख्या',
          'https://www.youtube.com/results?search_query=Yoga+Sutras+explained',
        ),
        ResourceLink(
          'Yoga Philosophy',
          'https://www.youtube.com/results?search_query=Yoga+philosophy',
        ),
      ],
    );
  }

  /// Get Vedanta Philosophy details
  static VedicSikshaDetail getVedantaDetail() {
    return VedicSikshaDetail(
      title: 'वेदांत दर्शन',
      subtitle: 'Vedanta Philosophy – Unity of Brahman and Atman',
      heroImage:
          'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=800&h=400&fit=crop',
      description:
          'वेदांत दर्शन उपनिषदों पर आधारित है और ब्रह्म और आत्मा की एकता का सिद्धांत प्रतिपादित करता है। '
          'इसके तीन मुख्य शाखाएँ हैं - अद्वैत वेदांत (शंकराचार्य), विशिष्टाद्वैत (रामानुज) '
          'और द्वैत वेदांत (मध्वाचार्य)। वेदांत का मुख्य सिद्धांत है - "ब्रह्म सत्यं जगत मिथ्या, '
          'जीवो ब्रह्मैव नापरः" (ब्रह्म ही सत्य है, जगत मिथ्या है, जीव ब्रह्म से भिन्न नहीं है)।',
      keyPoints: [
        'ब्रह्म और आत्मा की एकता',
        'अद्वैत, विशिष्टाद्वैत और द्वैत',
        'माया और ब्रह्म का सिद्धांत',
        'मोक्ष का मार्ग',
        'ज्ञान मार्ग',
        'भक्ति और ज्ञान का संतुलन',
      ],
      imageGallery: [
        'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=400&h=300&fit=crop',
      ],
      links: [
        ResourceLink(
          'वेदांत दर्शन – विकिपीडिया',
          'https://hi.wikipedia.org/wiki/वेदांत',
        ),
        ResourceLink(
          'Vedanta Philosophy',
          'https://www.sacred-texts.com/hin/sbe34/index.htm',
        ),
      ],
      videos: [
        ResourceLink(
          'वेदांत व्याख्या',
          'https://www.youtube.com/results?search_query=Vedanta+philosophy',
        ),
        ResourceLink(
          'Advaita Vedanta',
          'https://www.youtube.com/results?search_query=Advaita+Vedanta',
        ),
      ],
    );
  }

  /// Get Dharma details
  static VedicSikshaDetail getDharmaDetail() {
    return VedicSikshaDetail(
      title: 'धर्म (Dharma)',
      subtitle: 'Righteous Duty and Morality',
      heroImage:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800&h=400&fit=crop',
      description:
          'धर्म वैदिक जीवन का मूल सिद्धांत है जो धार्मिक कर्तव्य, नैतिकता और सही आचरण को '
          'दर्शाता है। धर्म का अर्थ है वह कर्तव्य जो व्यक्ति, समाज और ब्रह्मांड के कल्याण के लिए '
          'आवश्यक है। धर्म सत्य, अहिंसा, दया, करुणा और न्याय पर आधारित है। यह मानव जीवन के '
          'चार पुरुषार्थों में से पहला है।',
      keyPoints: [
        'धार्मिक कर्तव्य और नैतिकता',
        'सत्य और अहिंसा',
        'समाज के प्रति कर्तव्य',
        'व्यक्तिगत और सामाजिक धर्म',
        'कर्म और धर्म का संबंध',
        'धर्म का पालन और महत्व',
      ],
      imageGallery: [
        'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=400&h=300&fit=crop',
      ],
      links: [
        ResourceLink(
          'धर्म – विकिपीडिया',
          'https://hi.wikipedia.org/wiki/धर्म',
        ),
        ResourceLink(
          'Dharma in Hinduism',
          'https://www.sacred-texts.com/hin/index.htm',
        ),
      ],
      videos: [
        ResourceLink(
          'धर्म का अर्थ',
          'https://www.youtube.com/results?search_query=Dharma+meaning',
        ),
        ResourceLink(
          'Dharma Explained',
          'https://www.youtube.com/results?search_query=Dharma+explained',
        ),
      ],
    );
  }

  /// Get Artha details
  static VedicSikshaDetail getArthaDetail() {
    return VedicSikshaDetail(
      title: 'अर्थ (Artha)',
      subtitle: 'Wealth and Material Prosperity',
      heroImage:
          'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=800&h=400&fit=crop',
      description:
          'अर्थ धन और भौतिक समृद्धि का प्रतीक है। वैदिक दर्शन में अर्थ को जीवन के चार पुरुषार्थों '
          'में से दूसरा माना गया है। अर्थ का अर्थ केवल धन नहीं है, बल्कि वह सभी भौतिक संसाधन '
          'हैं जो जीवन के लिए आवश्यक हैं। धर्म के अनुसार अर्थ अर्जित करना और उसका उपयोग करना '
          'मानव का कर्तव्य है।',
      keyPoints: [
        'धन और भौतिक समृद्धि',
        'धर्म के अनुसार अर्थ अर्जन',
        'अर्थ का सदुपयोग',
        'समाज के लिए अर्थ का योगदान',
        'अर्थ और धर्म का संतुलन',
        'भौतिक और आध्यात्मिक समृद्धि',
      ],
      imageGallery: [
        'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=400&h=300&fit=crop',
      ],
      links: [
        ResourceLink(
          'अर्थ – विकिपीडिया',
          'https://hi.wikipedia.org/wiki/पुरुषार्थ',
        ),
        ResourceLink(
          'Artha in Hinduism',
          'https://www.sacred-texts.com/hin/index.htm',
        ),
      ],
      videos: [
        ResourceLink(
          'अर्थ का महत्व',
          'https://www.youtube.com/results?search_query=Artha+meaning',
        ),
        ResourceLink(
          'Artha Explained',
          'https://www.youtube.com/results?search_query=Artha+explained',
        ),
      ],
    );
  }

  /// Get Kama details
  static VedicSikshaDetail getKamaDetail() {
    return VedicSikshaDetail(
      title: 'काम (Kama)',
      subtitle: 'Desires and Pleasure',
      heroImage:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800&h=400&fit=crop',
      description:
          'काम इच्छाओं और सुख का प्रतीक है। वैदिक दर्शन में काम को जीवन के चार पुरुषार्थों में '
          'से तीसरा माना गया है। काम का अर्थ केवल भौतिक सुख नहीं है, बल्कि वह सभी इच्छाएँ हैं '
          'जो मानव जीवन को पूर्ण बनाती हैं। धर्म और अर्थ के अनुसार काम का पालन करना मानव का '
          'अधिकार है। कामसूत्र जैसे ग्रंथों में काम के विभिन्न पहलुओं का वर्णन है।',
      keyPoints: [
        'इच्छाएँ और सुख',
        'धर्म के अनुसार काम',
        'काम और धर्म का संतुलन',
        'गृहस्थ जीवन में काम',
        'कामसूत्र का ज्ञान',
        'आध्यात्मिक और भौतिक सुख',
      ],
      imageGallery: [
        'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=400&h=300&fit=crop',
      ],
      links: [
        ResourceLink(
          'काम – विकिपीडिया',
          'https://hi.wikipedia.org/wiki/पुरुषार्थ',
        ),
        ResourceLink(
          'Kama in Hinduism',
          'https://www.sacred-texts.com/hin/index.htm',
        ),
      ],
      videos: [
        ResourceLink(
          'काम का अर्थ',
          'https://www.youtube.com/results?search_query=Kama+meaning',
        ),
        ResourceLink(
          'Kama Explained',
          'https://www.youtube.com/results?search_query=Kama+explained',
        ),
      ],
    );
  }

  /// Get Moksha details
  static VedicSikshaDetail getMokshaDetail() {
    return VedicSikshaDetail(
      title: 'मोक्ष (Moksha)',
      subtitle: 'Liberation and Self-Realization',
      heroImage:
          'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=800&h=400&fit=crop',
      description:
          'मोक्ष मुक्ति और आत्म-साक्षात्कार का प्रतीक है। वैदिक दर्शन में मोक्ष को जीवन के चार '
          'पुरुषार्थों में से अंतिम और सर्वोच्च माना गया है। मोक्ष का अर्थ है जन्म-मृत्यु के '
          'चक्र से मुक्ति और ब्रह्म के साथ एकता की प्राप्ति। यह ज्ञान, भक्ति और कर्म के माध्यम '
          'से प्राप्त होता है। मोक्ष ही मानव जीवन का अंतिम लक्ष्य है।',
      keyPoints: [
        'मुक्ति और आत्म-साक्षात्कार',
        'जन्म-मृत्यु चक्र से मुक्ति',
        'ब्रह्म के साथ एकता',
        'ज्ञान, भक्ति और कर्म मार्ग',
        'मोक्ष के साधन',
        'मानव जीवन का अंतिम लक्ष्य',
      ],
      imageGallery: [
        'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=400&h=300&fit=crop',
      ],
      links: [
        ResourceLink(
          'मोक्ष – विकिपीडिया',
          'https://hi.wikipedia.org/wiki/मोक्ष',
        ),
        ResourceLink(
          'Moksha in Hinduism',
          'https://www.sacred-texts.com/hin/index.htm',
        ),
      ],
      videos: [
        ResourceLink(
          'मोक्ष का मार्ग',
          'https://www.youtube.com/results?search_query=Moksha+path',
        ),
        ResourceLink(
          'Moksha Explained',
          'https://www.youtube.com/results?search_query=Moksha+explained',
        ),
      ],
    );
  }

  /// Get detail by section ID
  static VedicSikshaDetail? getDetailById(String sectionId) {
    switch (sectionId) {
      case 'rigveda':
        return getRigvedaDetail();
      case 'yajurveda':
        return getYajurvedaDetail();
      case 'samaveda':
        return getSamavedaDetail();
      case 'atharvaveda':
        return getAtharvavedaDetail();
      case 'upanishads':
        return getUpanishadsDetail();
      case 'samkhya':
        return getSamkhyaDetail();
      case 'yoga':
        return getYogaDetail();
      case 'vedanta':
        return getVedantaDetail();
      case 'dharma':
        return getDharmaDetail();
      case 'artha':
        return getArthaDetail();
      case 'kama':
        return getKamaDetail();
      case 'moksha':
        return getMokshaDetail();
      default:
        return null;
    }
  }
}
