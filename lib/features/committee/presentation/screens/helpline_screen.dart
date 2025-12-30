import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../core/widgets/responsive_page.dart';

class HelplineScreen extends StatelessWidget {
  const HelplineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Helpline'),
      ),
      body: ResponsivePage(
        useSafeArea: false,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
          _buildSection(
            context,
            title: 'Emergency Contacts',
            contacts: [
              _HelplineContact(
                name: 'Emergency',
                phone: '108',
                type: 'Emergency',
              ),
              _HelplineContact(
                name: 'Police',
                phone: '100',
                type: 'Emergency',
              ),
              _HelplineContact(
                name: 'Fire',
                phone: '101',
                type: 'Emergency',
              ),
              _HelplineContact(
                name: 'Ambulance',
                phone: '102',
                type: 'Emergency',
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            context,
            title: 'Medical Emergency',
            contacts: [
              _HelplineContact(
                name: 'Civil Hospital Vadodara',
                phone: '+91-265-2424848',
                type: 'Hospital',
              ),
              _HelplineContact(
                name: 'SSG Hospital Vadodara',
                phone: '+91-265-2424848',
                type: 'Hospital',
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            context,
            title: 'Samaj Helpline',
            contacts: [
              _HelplineContact(
                name: 'Samaj Office',
                phone: '+91-XXXXXXXXXX',
                type: 'Office',
              ),
            ],
          ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<_HelplineContact> contacts,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...contacts.map((contact) => _buildContactItem(context, contact)),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(BuildContext context, _HelplineContact contact) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
          child: Icon(
            Icons.phone,
            color: Theme.of(context).primaryColor,
          ),
        ),
        title: Text(
          contact.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(contact.phone),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.phone),
              color: Theme.of(context).primaryColor,
              onPressed: () => _makePhoneCall(contact.phone),
            ),
            IconButton(
              icon: const Icon(Icons.chat),
              color: Colors.green,
              onPressed: () => _sendWhatsApp(contact.phone),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  Future<void> _sendWhatsApp(String phoneNumber) async {
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    final Uri whatsappUri = Uri.parse('https://wa.me/$cleanPhone');
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    }
  }
}

class _HelplineContact {
  final String name;
  final String phone;
  final String type;

  _HelplineContact({
    required this.name,
    required this.phone,
    required this.type,
  });
}
