import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:io';
import '../../providers/auth_provider.dart';
import '../../../../shared/data/samaj_id_generator.dart';

class SamajIdCardScreen extends ConsumerStatefulWidget {
  const SamajIdCardScreen({super.key});

  @override
  ConsumerState<SamajIdCardScreen> createState() => _SamajIdCardScreenState();
}

class _SamajIdCardScreenState extends ConsumerState<SamajIdCardScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Samaj ID Card'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              _shareIdCard(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              _downloadIdCard(context);
            },
          ),
        ],
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final authState = ref.watch(authControllerProvider);

          if (authState.user == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = authState.user!;
          final samajId = user.samajId ?? SamajIdGenerator.generateSamajId();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // ID Card with Screenshot capability
                Screenshot(
                  controller: _screenshotController,
                  child: _buildIdCard(context, user, samajId),
                ),
                const SizedBox(height: 24),

                // QR Code
                _buildQRCode(context, user, samajId),
                const SizedBox(height: 24),

                // Actions
                _buildActions(context, user, samajId),
                const SizedBox(height: 24),

                // Information
                _buildInformation(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildIdCard(BuildContext context, user, String samajId) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2E7D32),
            Color(0xFF4CAF50),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'SEERVI KSHTRIYA SAMAJ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.people,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Profile Section
            Row(
              children: [
                // Profile Picture
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  backgroundImage: user.profileImageUrl != null
                      ? NetworkImage(user.profileImageUrl!)
                      : null,
                  child: user.profileImageUrl == null
                      ? const Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.white,
                        )
                      : null,
                ),

                const SizedBox(width: 20),

                // User Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'VADODARA',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 14,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: user.isVerified ? Colors.green : Colors.orange,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          user.isVerified ? 'VERIFIED' : 'PENDING',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ID Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Text(
                    'MEMBER ID',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    samajId,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'JOINED: ${_formatDate(user.createdAt)}',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 12,
                  ),
                ),
                Text(
                  'VADODARA, GUJARAT',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context, user, String samajId) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _shareIdCard(context);
                    },
                    icon: const Icon(Icons.share),
                    label: const Text('Share'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _downloadIdCard(context);
                    },
                    icon: const Icon(Icons.download),
                    label: const Text('Download'),
                  ),
                ),
              ],
            ),
            if (!user.isVerified) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _requestVerification(context);
                  },
                  icon: const Icon(Icons.verified),
                  label: const Text('Request Verification'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInformation(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'About Samaj ID',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Your Samaj ID is a unique identifier that represents your membership in the Seervi Kshatriya Samaj community. This ID helps in:',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoItem('• Community verification and authentication'),
                _buildInfoItem('• Access to exclusive events and programs'),
                _buildInfoItem('• Member directory and networking'),
                _buildInfoItem('• Official communication and announcements'),
                _buildInfoItem('• Voting rights in community decisions'),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: const Text(
                'Keep your Samaj ID confidential and only share it when necessary for official community purposes.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildQRCode(BuildContext context, user, String samajId) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'QR Code',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            QrImageView(
              data: 'samaj_id:$samajId:${user.id}',
              version: QrVersions.auto,
              size: 200.0,
              backgroundColor: Colors.white,
            ),
            const SizedBox(height: 16),
            Text(
              'Scan this QR code to verify membership',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _shareIdCard(BuildContext context) async {
    try {
      final image = await _screenshotController.capture();
      if (image != null) {
        // Save to temporary directory
        final tempDir = Directory.systemTemp;
        final file = await File('${tempDir.path}/samaj_id_card.png').create();
        await file.writeAsBytes(image);

        // Share the image
        await Share.shareXFiles(
          [XFile(file.path)],
          text: 'My Seervi Kshatriya Samaj ID Card',
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to share: $e')),
      );
    }
  }

  Future<void> _downloadIdCard(BuildContext context) async {
    try {
      final image = await _screenshotController.capture();
      if (image != null) {
        // Save to downloads directory
        final downloadsDir = Directory('/storage/emulated/0/Download');
        if (!await downloadsDir.exists()) {
          await downloadsDir.create(recursive: true);
        }

        final file = File(
            '${downloadsDir.path}/samaj_id_card_${DateTime.now().millisecondsSinceEpoch}.png');
        await file.writeAsBytes(image);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ID Card saved to Downloads')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to download: $e')),
      );
    }
  }

  void _requestVerification(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Request Verification'),
        content: const Text(
          'To get your membership verified, please contact the Samaj administration with your documents.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (mounted) {
                Navigator.of(context).pop();
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
