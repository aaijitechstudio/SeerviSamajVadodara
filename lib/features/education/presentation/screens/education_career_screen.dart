import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/education_repository.dart';
import '../../domain/models/career_model.dart';
import '../../domain/models/scholarship_model.dart';
import '../../domain/models/skill_model.dart';
import '../../domain/models/exam_model.dart';
import '../../domain/models/success_story_model.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/design_tokens.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/providers/ui_state_provider.dart';
import 'career_detail_screen.dart';
import 'scholarship_detail_screen.dart';
import 'skill_detail_screen.dart';
import 'exam_detail_screen.dart';
import 'success_story_detail_screen.dart';
import 'vedic_siksha_screen.dart';

// Helper class for flattened search results
class _SearchResultItem {
  final String? title;
  final CareerModel? career;
  final ScholarshipModel? scholarship;
  final SkillModel? skill;
  final ExamModel? exam;
  final SuccessStoryModel? story;
  final bool isHeader;

  _SearchResultItem._({
    this.title,
    this.career,
    this.scholarship,
    this.skill,
    this.exam,
    this.story,
    required this.isHeader,
  });

  factory _SearchResultItem.header(String title) {
    return _SearchResultItem._(title: title, isHeader: true);
  }

  factory _SearchResultItem.career(CareerModel career) {
    return _SearchResultItem._(career: career, isHeader: false);
  }

  factory _SearchResultItem.scholarship(ScholarshipModel scholarship) {
    return _SearchResultItem._(scholarship: scholarship, isHeader: false);
  }

  factory _SearchResultItem.skill(SkillModel skill) {
    return _SearchResultItem._(skill: skill, isHeader: false);
  }

  factory _SearchResultItem.exam(ExamModel exam) {
    return _SearchResultItem._(exam: exam, isHeader: false);
  }

  factory _SearchResultItem.story(SuccessStoryModel story) {
    return _SearchResultItem._(story: story, isHeader: false);
  }
}

/// Provider for Education Repository
final educationRepositoryProvider = Provider<EducationRepository>((ref) {
  return EducationRepository();
});

class EducationCareerScreen extends ConsumerStatefulWidget {
  const EducationCareerScreen({super.key});

  @override
  ConsumerState<EducationCareerScreen> createState() =>
      _EducationCareerScreenState();
}

class _EducationCareerScreenState
    extends ConsumerState<EducationCareerScreen> {
  final TextEditingController _searchController = TextEditingController();
  final EducationRepository _repository = EducationRepository();
  Map<String, List<dynamic>> _searchResults = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = {};
      });
      ref.read(searchActiveProvider.notifier).state = false;
      return;
    }

    ref.read(searchActiveProvider.notifier).state = true;

    final results = await _repository.search(query);
    setState(() {
      _searchResults = results;
    });
    ref.read(searchActiveProvider.notifier).state = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: CustomAppBar(
        title: 'Education & Career',
        showLogo: false,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search careers, scholarships, skills...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _performSearch('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: _performSearch,
            ),
          ),

          // Content
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                final isSearching = ref.watch(searchActiveProvider);
                return isSearching
                    ? const Center(child: CircularProgressIndicator())
                    : _searchController.text.isNotEmpty
                        ? _buildSearchResults()
                        : _buildMainContent();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return const Center(
        child: Text('No results found'),
      );
    }

    // Build flattened list for ListView.builder
    final List<_SearchResultItem> items = [];

    if (_searchResults['careers']!.isNotEmpty) {
      items.add(_SearchResultItem.header('Careers'));
      for (var career in _searchResults['careers'] as List<CareerModel>) {
        items.add(_SearchResultItem.career(career));
      }
    }
    if (_searchResults['scholarships']!.isNotEmpty) {
      items.add(_SearchResultItem.header('Scholarships'));
      for (var scholarship in _searchResults['scholarships'] as List<ScholarshipModel>) {
        items.add(_SearchResultItem.scholarship(scholarship));
      }
    }
    if (_searchResults['skills']!.isNotEmpty) {
      items.add(_SearchResultItem.header('Skills'));
      for (var skill in _searchResults['skills'] as List<SkillModel>) {
        items.add(_SearchResultItem.skill(skill));
      }
    }
    if (_searchResults['exams']!.isNotEmpty) {
      items.add(_SearchResultItem.header('Exams'));
      for (var exam in _searchResults['exams'] as List<ExamModel>) {
        items.add(_SearchResultItem.exam(exam));
      }
    }
    if (_searchResults['stories']!.isNotEmpty) {
      items.add(_SearchResultItem.header('Success Stories'));
      for (var story in _searchResults['stories'] as List<SuccessStoryModel>) {
        items.add(_SearchResultItem.story(story));
      }
    }

    return ListView.builder(
      padding: const EdgeInsets.all(DesignTokens.spacingM),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        if (item.isHeader) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: index > 0 ? DesignTokens.spacingM : 0,
            ),
            child: _buildSectionHeader(item.title!),
          );
        } else {
          return RepaintBoundary(
            child: _buildSearchResultItem(item),
          );
        }
      },
    );
  }

  Widget _buildSearchResultItem(_SearchResultItem item) {
    if (item.career != null) {
      return _buildCareerCard(item.career!);
    } else if (item.scholarship != null) {
      return _buildScholarshipCard(item.scholarship!);
    } else if (item.skill != null) {
      return _buildSkillCard(item.skill!);
    } else if (item.exam != null) {
      return _buildExamCard(item.exam!);
    } else if (item.story != null) {
      return _buildSuccessStoryCard(item.story!);
    }
    return const SizedBox.shrink();
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(DesignTokens.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Banner
          _buildHeroBanner(),

          SizedBox(height: DesignTokens.spacingL),

          // Career by Stage
          _buildSectionHeader('Career Guidance by Stage'),
          SizedBox(height: DesignTokens.spacingM * 0.75),
          _buildCareerByStage(),

          SizedBox(height: DesignTokens.spacingL),

          // Scholarships
          _buildSectionHeader('Scholarships & Financial Help'),
          SizedBox(height: DesignTokens.spacingM * 0.75),
          _buildScholarshipsSection(),

          SizedBox(height: DesignTokens.spacingL),

          // Career Paths
          _buildSectionHeader('Career Paths'),
          SizedBox(height: DesignTokens.spacingM * 0.75),
          _buildCareerPaths(),

          SizedBox(height: DesignTokens.spacingL),

          // Skills
          _buildSectionHeader('Skill Development'),
          SizedBox(height: DesignTokens.spacingM * 0.75),
          _buildSkillsSection(),

          SizedBox(height: DesignTokens.spacingL),

          // Exams
          _buildSectionHeader('Exams & Competitive'),
          SizedBox(height: DesignTokens.spacingM * 0.75),
          _buildExamsSection(),

          SizedBox(height: DesignTokens.spacingL),

          // Success Stories
          _buildSectionHeader('Success Stories'),
          SizedBox(height: DesignTokens.spacingM * 0.75),
          _buildSuccessStoriesSection(),

          SizedBox(height: DesignTokens.spacingL),

          // Parent Guidance
          _buildSectionHeader('Parent Guidance'),
          SizedBox(height: DesignTokens.spacingM * 0.75),
          _buildParentGuidance(),

          SizedBox(height: DesignTokens.spacingL),

          // Vedic Siksha Section
          _buildSectionHeader('वैदिक शिक्षा (Vedic Siksha)'),
          SizedBox(height: DesignTokens.spacingM * 0.75),
          _buildVedicSikshaSection(),
        ],
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(DesignTokens.spacingL - 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryOrange.withOpacity(0.1),
            AppColors.primaryOrange.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(DesignTokens.radiusL),
      ),
      child: Column(
        children: [
          Icon(
            Icons.school,
            size: 48,
            color: AppColors.primaryOrange,
          ),
          SizedBox(height: DesignTokens.spacingM * 0.75),
          SizedBox(
            width: double.infinity,
            child: Text(
              'शिक्षा ही सबसे बड़ा धन है',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryOrange,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: DesignTokens.spacingS),
          SizedBox(
            width: double.infinity,
            child: Text(
              'For Students & Parents',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
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

  Widget _buildCareerByStage() {
    return FutureBuilder<List<CareerModel>>(
      future: _repository.getCareers(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final careers = snapshot.data!;
        final categories = ['after10', 'after12', 'college', 'working'];
        final categoryTitles = {
          'after10': 'After 10th',
          'after12': 'After 12th',
          'college': 'College',
          'working': 'Working Youth',
        };

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            final categoryCareers = careers
                .where((c) => c.category == category)
                .toList();

            return _buildCategoryCard(
              title: categoryTitles[category]!,
              icon: _getCategoryIcon(category),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CareerDetailScreen(
                      category: category,
                      careers: categoryCareers,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildCategoryCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: const EdgeInsets.all(DesignTokens.spacingM),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primaryOrange.withOpacity(0.1),
                Colors.white,
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: AppColors.primaryOrange),
              SizedBox(height: DesignTokens.spacingS),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'after10':
        return Icons.school;
      case 'after12':
        return Icons.emoji_events;
      case 'college':
        return Icons.account_balance;
      case 'working':
        return Icons.work;
      default:
        return Icons.school;
    }
  }

  Widget _buildScholarshipsSection() {
    return FutureBuilder<List<ScholarshipModel>>(
      future: _repository.getScholarships(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final scholarships = snapshot.data!.take(3).toList();

        return Column(
          children: scholarships
              .map((scholarship) => _buildScholarshipCard(scholarship))
              .toList(),
        );
      },
    );
  }

  Widget _buildScholarshipCard(ScholarshipModel scholarship) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const Icon(Icons.account_balance_wallet,
            color: AppColors.primaryOrange),
        title: Text(scholarship.title),
        subtitle: Text(
          scholarship.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ScholarshipDetailScreen(
                scholarship: scholarship,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCareerPaths() {
    return Row(
      children: [
        Expanded(
          child: _buildCategoryCard(
            title: 'Govt Jobs',
            icon: Icons.business_center,
            onTap: () {
              // Navigate to government jobs
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildCategoryCard(
            title: 'Private Jobs',
            icon: Icons.work,
            onTap: () {
              // Navigate to private jobs
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSkillsSection() {
    return FutureBuilder<List<SkillModel>>(
      future: _repository.getSkills(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final skills = snapshot.data!.take(4).toList();

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.3,
          ),
          itemCount: skills.length,
          itemBuilder: (context, index) {
            return _buildSkillCard(skills[index]);
          },
        );
      },
    );
  }

  Widget _buildSkillCard(SkillModel skill) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SkillDetailScreen(skill: skill),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.build,
                color: AppColors.primaryOrange,
                size: 32,
              ),
              SizedBox(height: DesignTokens.spacingS),
              Text(
                skill.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExamsSection() {
    return FutureBuilder<List<ExamModel>>(
      future: _repository.getExams(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final exams = snapshot.data!.take(4).toList();

        return Column(
          children: exams.map((exam) => _buildExamCard(exam)).toList(),
        );
      },
    );
  }

  Widget _buildExamCard(ExamModel exam) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const Icon(Icons.quiz, color: AppColors.primaryOrange),
        title: Text(exam.title),
        subtitle: Text(
          exam.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ExamDetailScreen(exam: exam),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSuccessStoriesSection() {
    return FutureBuilder<List<SuccessStoryModel>>(
      future: _repository.getSuccessStories(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final stories = snapshot.data!.take(3).toList();

        return SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: stories.length,
            itemBuilder: (context, index) {
              return SizedBox(
                width: 280,
                child: _buildSuccessStoryCard(stories[index]),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildSuccessStoryCard(SuccessStoryModel story) {
    return Card(
      margin: const EdgeInsets.only(right: 12),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SuccessStoryDetailScreen(story: story),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(DesignTokens.spacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.star, color: AppColors.primaryOrange, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      story.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: DesignTokens.spacingS),
              Text(
                story.field,
                style: TextStyle(
                  color: AppColors.primaryOrange,
                  fontSize: 12,
                ),
              ),
              SizedBox(height: DesignTokens.spacingS),
              Expanded(
                child: Text(
                  story.journey,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCareerCard(CareerModel career) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(_getCareerIcon(career.icon),
            color: AppColors.primaryOrange),
        title: Text(career.title),
        subtitle: Text(
          career.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CareerDetailScreen(
                category: career.category,
                careers: [career],
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _getCareerIcon(String iconName) {
    switch (iconName) {
      case 'science':
        return Icons.science;
      case 'account_balance':
        return Icons.account_balance;
      case 'palette':
        return Icons.palette;
      case 'engineering':
        return Icons.engineering;
      case 'medical_services':
        return Icons.medical_services;
      case 'business_center':
        return Icons.business_center;
      case 'work':
        return Icons.work;
      default:
        return Icons.school;
    }
  }

  Widget _buildParentGuidance() {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.family_restroom,
                color: AppColors.primaryOrange),
            title: const Text('How to Support Children'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Show parent guidance content
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.psychology,
                color: AppColors.primaryOrange),
            title: const Text('Career Myths vs Reality'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Show career myths content
            },
          ),
        ],
      ),
    );
  }

  Widget _buildVedicSikshaSection() {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const VedicSikshaScreen(),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(DesignTokens.spacingM),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryOrange.withOpacity(0.2),
                      AppColors.primaryOrange.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                ),
                child: const Icon(
                  Icons.menu_book,
                  color: AppColors.primaryOrange,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'वैदिक शिक्षा',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryOrange,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Vedic Knowledge & Wisdom in Hindi',
                      style: TextStyle(
                        fontSize: 14,
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

