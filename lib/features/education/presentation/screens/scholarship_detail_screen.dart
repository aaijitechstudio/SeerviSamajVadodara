import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/models/scholarship_model.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_app_bar.dart';

class ScholarshipDetailScreen extends StatelessWidget {
  final ScholarshipModel scholarship;

  const ScholarshipDetailScreen({
    super.key,
    required this.scholarship,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: CustomAppBar(
        title: 'Scholarship Details',
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
                      Icons.account_balance_wallet,
                      color: AppColors.primaryOrange,
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        scholarship.title,
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
                  scholarship.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 24),
                _buildInfoRow('Type', scholarship.type.toUpperCase()),
                const Divider(),
                _buildSectionTitle('Eligibility'),
                const SizedBox(height: 8),
                Text(
                  scholarship.eligibility,
                  style: const TextStyle(fontSize: 14),
                ),
                if (scholarship.amount != null) ...[
                  const SizedBox(height: 16),
                  const Divider(),
                  _buildSectionTitle('Amount'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryOrange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      scholarship.amount!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryOrange,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
                if (scholarship.documents.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Divider(),
                  _buildSectionTitle('Required Documents'),
                  const SizedBox(height: 8),
                  ...scholarship.documents.map((doc) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.description,
                              size: 20,
                              color: AppColors.primaryOrange,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                doc,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
                if (scholarship.applicationProcess != null) ...[
                  const SizedBox(height: 16),
                  const Divider(),
                  _buildSectionTitle('Application Process'),
                  const SizedBox(height: 8),
                  Text(
                    scholarship.applicationProcess!,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
                if (scholarship.officialWebsite != null) ...[
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final uri = Uri.parse(scholarship.officialWebsite!);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri, mode: LaunchMode.externalApplication);
                        }
                      },
                      icon: const Icon(Icons.open_in_new),
                      label: const Text('Visit Official Website'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryOrange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 14),
          ),
        ],
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

