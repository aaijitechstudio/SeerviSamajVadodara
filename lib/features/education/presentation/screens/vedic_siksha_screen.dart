import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_app_bar.dart';

/// Vedic Siksha Screen - Vedic Knowledge & Wisdom in Hindi
class VedicSikshaScreen extends StatelessWidget {
  const VedicSikshaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: CustomAppBar(
        title: 'वैदिक शिक्षा',
        showLogo: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryOrange.withOpacity(0.15),
                    AppColors.primaryOrange.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primaryOrange.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.menu_book,
                    size: 56,
                    color: AppColors.primaryOrange,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'वैदिक ज्ञान और बुद्धिमत्ता',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryOrange,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
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

            const SizedBox(height: 24),

            // Vedic Scriptures Section
            _buildSectionHeader('वैदिक ग्रंथ (Vedic Scriptures)'),
            const SizedBox(height: 12),
            _buildVedicScriptureCard(
              context,
              title: 'ऋग्वेद',
              subtitle: 'Rigveda - Knowledge of Hymns',
              description: 'प्राचीनतम वैदिक ग्रंथ, मंत्रों और स्तुतियों का संग्रह',
              icon: Icons.book,
            ),
            _buildVedicScriptureCard(
              context,
              title: 'यजुर्वेद',
              subtitle: 'Yajurveda - Knowledge of Rituals',
              description: 'यज्ञ और अनुष्ठानों से संबंधित ज्ञान',
              icon: Icons.auto_awesome,
            ),
            _buildVedicScriptureCard(
              context,
              title: 'सामवेद',
              subtitle: 'Samaveda - Knowledge of Melodies',
              description: 'संगीत और मंत्रों के सामवेदिक स्वर',
              icon: Icons.music_note,
            ),
            _buildVedicScriptureCard(
              context,
              title: 'अथर्ववेद',
              subtitle: 'Atharvaveda - Knowledge of Daily Life',
              description: 'दैनिक जीवन, चिकित्सा और जादू-टोना से संबंधित',
              icon: Icons.healing,
            ),

            const SizedBox(height: 24),

            // Upanishads Section
            _buildSectionHeader('उपनिषद (Upanishads)'),
            const SizedBox(height: 12),
            _buildVedicScriptureCard(
              context,
              title: 'मुख्य उपनिषद',
              subtitle: 'Principal Upanishads',
              description: 'दार्शनिक ज्ञान और आत्म-साक्षात्कार के ग्रंथ',
              icon: Icons.self_improvement,
            ),

            const SizedBox(height: 24),

            // Vedic Philosophy Section
            _buildSectionHeader('वैदिक दर्शन (Vedic Philosophy)'),
            const SizedBox(height: 12),
            _buildVedicScriptureCard(
              context,
              title: 'सांख्य दर्शन',
              subtitle: 'Samkhya Philosophy',
              description: 'सृष्टि और चेतना के तत्वों का विश्लेषण',
              icon: Icons.psychology,
            ),
            _buildVedicScriptureCard(
              context,
              title: 'योग दर्शन',
              subtitle: 'Yoga Philosophy',
              description: 'पतंजलि के योग सूत्र और आत्म-साक्षात्कार',
              icon: Icons.self_improvement,
            ),
            _buildVedicScriptureCard(
              context,
              title: 'वेदांत दर्शन',
              subtitle: 'Vedanta Philosophy',
              description: 'ब्रह्म और आत्मा की एकता का ज्ञान',
              icon: Icons.lightbulb,
            ),

            const SizedBox(height: 24),

            // Vedic Values Section
            _buildSectionHeader('वैदिक मूल्य (Vedic Values)'),
            const SizedBox(height: 12),
            _buildValueCard(
              context,
              title: 'धर्म (Dharma)',
              description: 'धार्मिक कर्तव्य और नैतिकता',
            ),
            _buildValueCard(
              context,
              title: 'अर्थ (Artha)',
              description: 'धन और भौतिक समृद्धि',
            ),
            _buildValueCard(
              context,
              title: 'काम (Kama)',
              description: 'इच्छाएं और सुख',
            ),
            _buildValueCard(
              context,
              title: 'मोक्ष (Moksha)',
              description: 'मुक्ति और आत्म-साक्षात्कार',
            ),

            const SizedBox(height: 24),

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
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primaryOrange.withOpacity(0.1),
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
              style: TextStyle(
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
          // Navigate to detail screen
        },
      ),
    );
  }

  Widget _buildValueCard(
    BuildContext context, {
    required String title,
    required String description,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryOrange.withOpacity(0.2),
                    AppColors.primaryOrange.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
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
          ],
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

