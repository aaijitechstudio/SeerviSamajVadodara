import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../core/constants/design_tokens.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/membership_card.dart';
import '../../data/committee_data.dart';

class CommitteeScreen extends ConsumerWidget {
  const CommitteeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: CustomAppBar(
        title: l10n.committeeMembers,
        showLogo: false,
      ),
      body: _buildCommitteeList(context, l10n),
    );
  }

  Widget _buildCommitteeList(BuildContext context, AppLocalizations l10n) {
    final allMembers = CommitteeData.allMembers;

    if (allMembers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.groups_outlined,
              size: DesignTokens.iconSizeXL,
              color: DesignTokens.grey400,
            ),
            const SizedBox(height: DesignTokens.spacingM),
            Text(
              l10n.noCommitteeMembersYet,
              style: TextStyle(
                fontSize: DesignTokens.fontSizeXL,
                color: DesignTokens.grey600,
              ),
            ),
          ],
        ),
      );
    }

    // Separate executive committee and executive members
    final executiveCommittee = CommitteeData.executiveCommittee;
    final executiveMembers = CommitteeData.executiveMembers;

    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingM,
        vertical: DesignTokens.spacingM,
      ),
      children: [
        // Executive Committee Section
        if (executiveCommittee.isNotEmpty) ...[
          _buildSectionHeader('कार्यकारणी कमीटी', 'Executive Committee'),
          const SizedBox(height: DesignTokens.spacingM),
          ...executiveCommittee.map((member) {
            return MembershipCard(
              name: member.name,
              registrationNumber: member.id,
              role: member.position,
              location: member.location ?? member.area,
              profileImageUrl: member.imageUrl,
              gotra: member.gotra,
              isVerified: true,
              isCommitteeMember: true,
              onTap: member.phone.isNotEmpty
                  ? () => _makePhoneCall(member.phone)
                  : null,
            );
          }),
          const SizedBox(height: DesignTokens.spacingL),
        ],

        // Executive Members Section
        if (executiveMembers.isNotEmpty) ...[
          _buildSectionHeader('कार्यकारणी सदस्य', 'Executive Members'),
          const SizedBox(height: DesignTokens.spacingM),
          ...executiveMembers.map((member) {
            return MembershipCard(
              name: member.name,
              registrationNumber: member.id,
              role: member.position,
              location: member.location ?? member.area,
              profileImageUrl: member.imageUrl,
              gotra: member.gotra,
              isVerified: true,
              isCommitteeMember: true,
              onTap: member.phone.isNotEmpty
                  ? () => _makePhoneCall(member.phone)
                  : null,
            );
          }),
        ],
      ],
    );
  }

  Widget _buildSectionHeader(String titleHi, String titleEn) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingM,
        vertical: DesignTokens.spacingS,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            DesignTokens.primaryOrange.withValues(alpha: 0.1),
            DesignTokens.primaryOrange.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(DesignTokens.radiusM),
        border: Border.all(
          color: DesignTokens.primaryOrange.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.group,
            color: DesignTokens.primaryOrange,
            size: 20,
          ),
          const SizedBox(width: DesignTokens.spacingS),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titleHi,
                  style: TextStyle(
                    fontSize: DesignTokens.fontSizeL,
                    fontWeight: DesignTokens.fontWeightBold,
                    color: DesignTokens.textPrimary,
                  ),
                ),
                Text(
                  titleEn,
                  style: TextStyle(
                    fontSize: DesignTokens.fontSizeS,
                    color: DesignTokens.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }
}
