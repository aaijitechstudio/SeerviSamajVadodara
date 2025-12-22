import 'package:flutter/material.dart';
import '../../domain/models/career_model.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_app_bar.dart';

class CareerDetailScreen extends StatelessWidget {
  final String category;
  final List<CareerModel> careers;

  const CareerDetailScreen({
    super.key,
    required this.category,
    required this.careers,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: CustomAppBar(
        title: _getCategoryTitle(category),
        showLogo: false,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: careers.length,
        itemBuilder: (context, index) {
          return _buildCareerDetailCard(context, careers[index]);
        },
      ),
    );
  }

  String _getCategoryTitle(String category) {
    switch (category) {
      case 'after10':
        return 'After 10th';
      case 'after12':
        return 'After 12th';
      case 'college':
        return 'College';
      case 'working':
        return 'Working Youth';
      default:
        return 'Career Guidance';
    }
  }

  Widget _buildCareerDetailCard(BuildContext context, CareerModel career) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              career.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              career.description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 16),
            if (career.requiredSubjects.isNotEmpty) ...[
              _buildSectionTitle('Required Subjects'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: career.requiredSubjects
                    .map((subject) => Chip(
                          label: Text(subject),
                          backgroundColor: AppColors.primaryOrange.withOpacity(0.1),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 16),
            ],
            if (career.careerOptions.isNotEmpty) ...[
              _buildSectionTitle('Career Options'),
              const SizedBox(height: 8),
              ...career.careerOptions.map((option) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 20,
                          color: AppColors.primaryOrange,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            option,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 16),
            ],
            if (career.freeResources.isNotEmpty) ...[
              _buildSectionTitle('Free Resources'),
              const SizedBox(height: 8),
              ...career.freeResources.map((resource) => Padding(
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
              const SizedBox(height: 16),
            ],
            if (career.commonMistakes.isNotEmpty) ...[
              _buildSectionTitle('Common Mistakes to Avoid'),
              const SizedBox(height: 8),
              ...career.commonMistakes.map((mistake) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.warning,
                          size: 20,
                          color: Colors.orange,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            mistake,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 16),
            ],
            if (career.salaryRange != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryOrange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.attach_money,
                      color: AppColors.primaryOrange,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Salary Range: ${career.salaryRange}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryOrange,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
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

