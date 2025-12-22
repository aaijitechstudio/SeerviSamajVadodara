import 'package:flutter/material.dart';
import '../../domain/models/skill_model.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_app_bar.dart';

class SkillDetailScreen extends StatelessWidget {
  final SkillModel skill;

  const SkillDetailScreen({
    super.key,
    required this.skill,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: CustomAppBar(
        title: skill.title,
        showLogo: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.build,
                      color: AppColors.primaryOrange,
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        skill.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  skill.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                if (skill.duration != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryOrange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          color: AppColors.primaryOrange,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Duration: ${skill.duration}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryOrange,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (skill.whoShouldLearn.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  _buildSectionTitle('Who Should Learn'),
                  const SizedBox(height: 8),
                  ...skill.whoShouldLearn.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.person,
                              size: 20,
                              color: AppColors.primaryOrange,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                item,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
                if (skill.freeResources.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  _buildSectionTitle('Free Learning Resources'),
                  const SizedBox(height: 8),
                  ...skill.freeResources.map((resource) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.link,
                              size: 20,
                              color: AppColors.primaryOrange,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                resource,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
                if (skill.careerOutcomes.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  _buildSectionTitle('Career Outcomes'),
                  const SizedBox(height: 8),
                  ...skill.careerOutcomes.map((outcome) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.work,
                              size: 20,
                              color: AppColors.primaryOrange,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                outcome,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

