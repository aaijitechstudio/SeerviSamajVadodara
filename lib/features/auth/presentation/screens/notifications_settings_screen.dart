import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/design_tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/widgets/responsive_page.dart';

class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  State<NotificationsSettingsScreen> createState() =>
      _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState
    extends State<NotificationsSettingsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _eventNotifications = true;
  bool _announcementNotifications = true;
  bool _memberUpdates = false;
  bool _newsUpdates = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _pushNotifications = prefs.getBool('push_notifications') ?? true;
      _emailNotifications = prefs.getBool('email_notifications') ?? true;
      _eventNotifications = prefs.getBool('event_notifications') ?? true;
      _announcementNotifications =
          prefs.getBool('announcement_notifications') ?? true;
      _memberUpdates = prefs.getBool('member_updates') ?? false;
      _newsUpdates = prefs.getBool('news_updates') ?? true;
    });
  }

  Future<void> _saveSetting(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.notifications),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ResponsivePage(
        useSafeArea: false,
        child: ListView(
          padding: const EdgeInsets.all(DesignTokens.spacingM),
          children: [
          _buildSectionHeader(l10n.pushNotifications),
          _buildSwitchTile(
            l10n.enablePushNotifications,
            l10n.pushNotificationsDescription,
            _pushNotifications,
            (value) {
              setState(() => _pushNotifications = value);
              _saveSetting('push_notifications', value);
            },
          ),
          const SizedBox(height: DesignTokens.spacingL),
          _buildSectionHeader(l10n.emailNotifications),
          _buildSwitchTile(
            l10n.enableEmailNotifications,
            l10n.emailNotificationsDescription,
            _emailNotifications,
            (value) {
              setState(() => _emailNotifications = value);
              _saveSetting('email_notifications', value);
            },
          ),
          const SizedBox(height: DesignTokens.spacingL),
          _buildSectionHeader(l10n.notificationTypes),
          _buildSwitchTile(
            l10n.events,
            l10n.eventsNotificationDescription,
            _eventNotifications,
            (value) {
              setState(() => _eventNotifications = value);
              _saveSetting('event_notifications', value);
            },
          ),
          _buildSwitchTile(
            l10n.announcements,
            l10n.announcementsNotificationDescription,
            _announcementNotifications,
            (value) {
              setState(() => _announcementNotifications = value);
              _saveSetting('announcement_notifications', value);
            },
          ),
          _buildSwitchTile(
            l10n.memberUpdates,
            l10n.memberUpdatesDescription,
            _memberUpdates,
            (value) {
              setState(() => _memberUpdates = value);
              _saveSetting('member_updates', value);
            },
          ),
          _buildSwitchTile(
            l10n.newsUpdates,
            l10n.newsUpdatesDescription,
            _newsUpdates,
            (value) {
              setState(() => _newsUpdates = value);
              _saveSetting('news_updates', value);
            },
          ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: DesignTokens.spacingM),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: DesignTokens.fontSizeXL,
          fontWeight: DesignTokens.fontWeightBold,
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
    );
  }
}
