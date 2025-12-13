import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../core/constants/design_tokens.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/animated_card.dart';
import '../../domain/models/committee_model.dart';
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
      padding: const EdgeInsets.all(DesignTokens.spacingM),
      children: [
        // Executive Committee Section
        if (executiveCommittee.isNotEmpty) ...[
          _buildSectionHeader('कार्यकारणी कमीटी', 'Executive Committee'),
          const SizedBox(height: DesignTokens.spacingM),
          ...executiveCommittee.asMap().entries.map((entry) {
            return _buildCommitteeCard(context, entry.value, l10n, entry.key);
          }),
          const SizedBox(height: DesignTokens.spacingL),
        ],

        // Executive Members Section
        if (executiveMembers.isNotEmpty) ...[
          _buildSectionHeader('कार्यकारणी सदस्य', 'Executive Members'),
          const SizedBox(height: DesignTokens.spacingM),
          ...executiveMembers.asMap().entries.map((entry) {
            return _buildCommitteeCard(
              context,
              entry.value,
              l10n,
              executiveCommittee.length + entry.key,
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

  Widget _buildCommitteeCard(BuildContext context, CommitteeModel member,
      AppLocalizations l10n, int index) {
    return AnimatedCard(
      index: index,
      onTap:
          member.phone.isNotEmpty ? () => _makePhoneCall(member.phone) : null,
      child: Row(
        children: [
          // Profile Image with Badge - Redesigned
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      DesignTokens.primaryOrange.withValues(alpha: 0.2),
                      DesignTokens.primaryOrangeLight.withValues(alpha: 0.1),
                    ],
                  ),
                  border: Border.all(
                    color: DesignTokens.primaryOrange.withValues(alpha: 0.4),
                    width: 2.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: DesignTokens.primaryOrange.withValues(alpha: 0.3),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.transparent,
                  backgroundImage: member.imageUrl != null
                      ? NetworkImage(member.imageUrl!)
                      : null,
                  child: member.imageUrl == null
                      ? Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                DesignTokens.primaryOrange
                                    .withValues(alpha: 0.15),
                                DesignTokens.primaryOrangeLight
                                    .withValues(alpha: 0.1),
                              ],
                            ),
                          ),
                          child: Center(
                            child: Text(
                              member.name.isNotEmpty
                                  ? member.name[0].toUpperCase()
                                  : 'C',
                              style: TextStyle(
                                fontSize: DesignTokens.fontSizeH4,
                                color: DesignTokens.primaryOrange,
                                fontWeight: DesignTokens.fontWeightBold,
                              ),
                            ),
                          ),
                        )
                      : null,
                ),
              ),
              // Position Badge
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: DesignTokens.spacingXS,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: DesignTokens.primaryOrange,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: DesignTokens.backgroundWhite,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.verified,
                    size: 16,
                    color: DesignTokens.textOnPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: DesignTokens.spacingL),
          // Member Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name with Shree and Gotra
                Text(
                  '${l10n.shree} ${member.name}${member.gotra != null && member.gotra!.isNotEmpty ? ' ${member.gotra}' : ''}',
                  style: TextStyle(
                    fontSize: DesignTokens.fontSizeXXL,
                    fontWeight: DesignTokens.fontWeightBold,
                    color: DesignTokens.textPrimary,
                  ),
                ),
                const SizedBox(height: DesignTokens.spacingXS),
                // Position Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: DesignTokens.spacingM,
                    vertical: DesignTokens.spacingXS / 2,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        DesignTokens.primaryOrange.withValues(alpha: 0.15),
                        DesignTokens.primaryOrange.withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(DesignTokens.radiusS),
                    border: Border.all(
                      color: DesignTokens.primaryOrange.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    member.position,
                    style: TextStyle(
                      fontSize: DesignTokens.fontSizeS,
                      color: DesignTokens.primaryOrange,
                      fontWeight: DesignTokens.fontWeightSemiBold,
                    ),
                  ),
                ),
                // Father's Name (S/O)
                if (member.fatherName != null &&
                    member.fatherName!.isNotEmpty) ...[
                  const SizedBox(height: DesignTokens.spacingXS),
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 14,
                        color: DesignTokens.textSecondary,
                      ),
                      const SizedBox(width: DesignTokens.spacingXS),
                      Text(
                        'S/O ${member.fatherName}',
                        style: TextStyle(
                          fontSize: DesignTokens.fontSizeS,
                          color: DesignTokens.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
                // Location
                if (member.location != null && member.location!.isNotEmpty) ...[
                  const SizedBox(height: DesignTokens.spacingXS),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: DesignTokens.textSecondary,
                      ),
                      const SizedBox(width: DesignTokens.spacingXS),
                      Expanded(
                        child: Text(
                          member.location!,
                          style: TextStyle(
                            fontSize: DesignTokens.fontSizeS,
                            color: DesignTokens.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                // Area (for executive members)
                if (member.area != null && member.area!.isNotEmpty) ...[
                  const SizedBox(height: DesignTokens.spacingXS),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: DesignTokens.spacingS,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: DesignTokens.grey100,
                      borderRadius: BorderRadius.circular(DesignTokens.radiusS),
                    ),
                    child: Text(
                      member.area!,
                      style: TextStyle(
                        fontSize: DesignTokens.fontSizeXS,
                        color: DesignTokens.textSecondary,
                        fontWeight: DesignTokens.fontWeightMedium,
                      ),
                    ),
                  ),
                ],
                if (member.email != null && member.email!.isNotEmpty) ...[
                  const SizedBox(height: DesignTokens.spacingM),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: DesignTokens.grey100,
                          borderRadius:
                              BorderRadius.circular(DesignTokens.radiusS),
                        ),
                        child: Icon(
                          Icons.email_outlined,
                          size: DesignTokens.iconSizeS,
                          color: DesignTokens.grey600,
                        ),
                      ),
                      const SizedBox(width: DesignTokens.spacingS),
                      Expanded(
                        child: Text(
                          member.email!,
                          style: TextStyle(
                            fontSize: DesignTokens.fontSizeS,
                            color: DesignTokens.grey600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: DesignTokens.spacingS),
                // Phone Number
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: DesignTokens.grey100,
                        borderRadius:
                            BorderRadius.circular(DesignTokens.radiusS),
                      ),
                      child: Icon(
                        Icons.phone_outlined,
                        size: DesignTokens.iconSizeS,
                        color: DesignTokens.grey600,
                      ),
                    ),
                    const SizedBox(width: DesignTokens.spacingS),
                    Expanded(
                      child: Text(
                        member.phone,
                        style: TextStyle(
                          fontSize: DesignTokens.fontSizeS,
                          color: DesignTokens.textPrimary,
                          fontWeight: DesignTokens.fontWeightMedium,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Call Button (only show if phone number is available)
          if (member.phone.isNotEmpty)
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    DesignTokens.primaryOrange,
                    DesignTokens.primaryOrangeDark,
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: DesignTokens.primaryOrange.withValues(alpha: 0.4),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _makePhoneCall(member.phone),
                  borderRadius: BorderRadius.circular(DesignTokens.radiusRound),
                  child: Container(
                    padding: const EdgeInsets.all(DesignTokens.spacingM),
                    child: Icon(
                      Icons.phone,
                      color: DesignTokens.textOnPrimary,
                      size: DesignTokens.iconSizeM,
                    ),
                  ),
                ),
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
