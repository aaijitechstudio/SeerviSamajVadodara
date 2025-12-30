import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/design_tokens.dart';
import '../../data/vedic_siksha_data.dart';
import 'vedic_siksha_detail_screen.dart';
import '../../../../core/widgets/responsive_page.dart';

/// Vedic Siksha Screen - Vedic Knowledge & Wisdom in Hindi
class VedicSikshaScreen extends StatelessWidget {
  const VedicSikshaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsivePage(
      useSafeArea: false,
      // Keep this screen visually identical; responsive constraints can be tuned later.
      maxContentWidth: 100000,
      child: Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        title: const Text('वैदिक शिक्षा'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(DesignTokens.spacingL - 4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryOrange.withValues(alpha: 0.15),
                    AppColors.primaryOrange.withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primaryOrange.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.menu_book,
                    size: 56,
                    color: AppColors.primaryOrange,
                  ),
                  const SizedBox(height: DesignTokens.spacingM * 0.75),
                  const Text(
                    'वैदिक ज्ञान और बुद्धिमत्ता',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryOrange,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: DesignTokens.spacingS),
                  Text(
                    'Vedic Knowledge & Wisdom',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: DesignTokens.spacingL),

            // Vedic Scriptures Section
            _buildSectionHeader('वैदिक ग्रंथ (Vedic Scriptures)'),
            const SizedBox(height: 12),
            _buildVedicScriptureCard(
              context,
              title: 'ऋग्वेद',
              subtitle: 'Rigveda - Knowledge of Hymns',
              description:
                  'प्राचीनतम वैदिक ग्रंथ, मंत्रों और स्तुतियों का संग्रह',
              icon: Icons.book,
              sectionId: 'rigveda',
            ),
            _buildVedicScriptureCard(
              context,
              title: 'यजुर्वेद',
              subtitle: 'Yajurveda - Knowledge of Rituals',
              description: 'यज्ञ और अनुष्ठानों से संबंधित ज्ञान',
              icon: Icons.auto_awesome,
              sectionId: 'yajurveda',
            ),
            _buildVedicScriptureCard(
              context,
              title: 'सामवेद',
              subtitle: 'Samaveda - Knowledge of Melodies',
              description: 'संगीत और मंत्रों के सामवेदिक स्वर',
              icon: Icons.music_note,
              sectionId: 'samaveda',
            ),
            _buildVedicScriptureCard(
              context,
              title: 'अथर्ववेद',
              subtitle: 'Atharvaveda - Knowledge of Daily Life',
              description: 'दैनिक जीवन, चिकित्सा और जादू-टोना से संबंधित',
              icon: Icons.healing,
              sectionId: 'atharvaveda',
            ),

            const SizedBox(height: DesignTokens.spacingL),

            // Upanishads Section
            _buildSectionHeader('उपनिषद (Upanishads)'),
            const SizedBox(height: 12),
            _buildVedicScriptureCard(
              context,
              title: 'मुख्य उपनिषद',
              subtitle: 'Principal Upanishads',
              description: 'दार्शनिक ज्ञान और आत्म-साक्षात्कार के ग्रंथ',
              icon: Icons.self_improvement,
              sectionId: 'upanishads',
            ),

            const SizedBox(height: DesignTokens.spacingL),

            // Vedic Philosophy Section
            _buildSectionHeader('वैदिक दर्शन (Vedic Philosophy)'),
            const SizedBox(height: 12),
            _buildVedicScriptureCard(
              context,
              title: 'सांख्य दर्शन',
              subtitle: 'Samkhya Philosophy',
              description: 'सृष्टि और चेतना के तत्वों का विश्लेषण',
              icon: Icons.psychology,
              sectionId: 'samkhya',
            ),
            _buildVedicScriptureCard(
              context,
              title: 'योग दर्शन',
              subtitle: 'Yoga Philosophy',
              description: 'पतंजलि के योग सूत्र और आत्म-साक्षात्कार',
              icon: Icons.self_improvement,
              sectionId: 'yoga',
            ),
            _buildVedicScriptureCard(
              context,
              title: 'वेदांत दर्शन',
              subtitle: 'Vedanta Philosophy',
              description: 'ब्रह्म और आत्मा की एकता का ज्ञान',
              icon: Icons.lightbulb,
              sectionId: 'vedanta',
            ),

            const SizedBox(height: DesignTokens.spacingL),

            // Vedic Values Section
            _buildSectionHeader('वैदिक मूल्य (Vedic Values)'),
            const SizedBox(height: 12),
            _buildValueCard(
              context,
              title: 'धर्म (Dharma)',
              description: 'धार्मिक कर्तव्य और नैतिकता',
              sectionId: 'dharma',
            ),
            _buildValueCard(
              context,
              title: 'अर्थ (Artha)',
              description: 'धन और भौतिक समृद्धि',
              sectionId: 'artha',
            ),
            _buildValueCard(
              context,
              title: 'काम (Kama)',
              description: 'इच्छाएं और सुख',
              sectionId: 'kama',
            ),
            _buildValueCard(
              context,
              title: 'मोक्ष (Moksha)',
              description: 'मुक्ति और आत्म-साक्षात्कार',
              sectionId: 'moksha',
            ),

            const SizedBox(height: DesignTokens.spacingL),

            // Learning Resources
            _buildSectionHeader('शिक्षा संसाधन (Learning Resources)'),
            const SizedBox(height: 12),
            _buildResourceCard(
              context,
              title: 'वैदिक मंत्र और स्तुतियाँ',
              subtitle: 'Vedic Mantras & Hymns',
              icon: Icons.volume_up,
              onTap: () {
                // Navigate to mantras section
              },
            ),
            _buildResourceCard(
              context,
              title: 'वैदिक कहानियाँ',
              subtitle: 'Vedic Stories',
              icon: Icons.menu_book,
              onTap: () {
                // Navigate to stories section
              },
            ),
            _buildResourceCard(
              context,
              title: 'वैदिक विडियो',
              subtitle: 'Vedic Videos',
              icon: Icons.video_library,
              onTap: () {
                // Navigate to videos section
              },
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildVedicScriptureCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String description,
    required IconData icon,
    required String sectionId,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primaryOrange.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppColors.primaryOrange,
            size: 28,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subtitle,
              style: const TextStyle(
                color: AppColors.primaryOrange,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          final detail = VedicSikshaData.getDetailById(sectionId);
          if (detail != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VedicSikshaDetailScreen(data: detail),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildValueCard(
    BuildContext context, {
    required String title,
    required String description,
    required String sectionId,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          final detail = VedicSikshaData.getDetailById(sectionId);
          if (detail != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VedicSikshaDetailScreen(data: detail),
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryOrange.withValues(alpha: 0.2),
                      AppColors.primaryOrange.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.star,
                  color: AppColors.primaryOrange,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResourceCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                icon,
                color: AppColors.primaryOrange,
                size: 32,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
