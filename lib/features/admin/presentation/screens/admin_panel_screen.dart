import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../../members/domain/models/user_model.dart';
import 'add_member_screen.dart';
import '../../../news/presentation/screens/add_announcement_screen.dart';
import '../../../events/presentation/screens/add_event_screen.dart';

class AdminPanelScreen extends ConsumerWidget {
  const AdminPanelScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final user = authState.user;

    // Check if user is admin
    if (user == null || !user.isAdmin) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Admin Panel'),
        ),
        body: const Center(
          child: Text('Access Denied. Admin privileges required.'),
        ),
      );
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Panel'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.people), text: 'Members'),
              Tab(icon: Icon(Icons.newspaper), text: 'Announcements'),
              Tab(icon: Icon(Icons.event), text: 'Events'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _MembersAdminTab(),
            _AnnouncementsAdminTab(),
            _EventsAdminTab(),
          ],
        ),
        floatingActionButton: Builder(
          builder: (context) {
            final currentTab = DefaultTabController.of(context).index;
            return FloatingActionButton(
              onPressed: () {
                if (currentTab == 0) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AddMemberScreen(),
                    ),
                  );
                } else if (currentTab == 1) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AddAnnouncementScreen(),
                    ),
                  );
                } else if (currentTab == 2) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AddEventScreen(),
                    ),
                  );
                }
              },
              child: const Icon(Icons.add),
            );
          },
        ),
      ),
    );
  }
}

class _MembersAdminTab extends StatelessWidget {
  const _MembersAdminTab();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No members found'));
        }

        final members = snapshot.data!.docs
            .map((doc) =>
                UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList();

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: members.length,
          itemBuilder: (context, index) {
            final member = members[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(member.name.isNotEmpty
                      ? member.name[0].toUpperCase()
                      : 'M'),
                ),
                title: Text(member.name),
                subtitle: Text(member.email),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!member.isVerified)
                      IconButton(
                        icon: const Icon(Icons.check_circle_outline),
                        color: Colors.green,
                        onPressed: () => _verifyMember(context, member.id),
                      ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      color: Colors.red,
                      onPressed: () => _deleteMember(context, member.id),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _verifyMember(BuildContext context, String memberId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(memberId)
        .update({'isVerified': true});
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Member verified')),
      );
    }
  }

  Future<void> _deleteMember(BuildContext context, String memberId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Member'),
        content: const Text('Are you sure you want to delete this member?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(memberId)
          .delete();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Member deleted')),
        );
      }
    }
  }
}

class _AnnouncementsAdminTab extends StatelessWidget {
  const _AnnouncementsAdminTab();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('announcements')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No announcements found'));
        }

        final announcements = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: announcements.length,
          itemBuilder: (context, index) {
            final doc = announcements[index];
            final data = doc.data() as Map<String, dynamic>;
            final title = data['title'] ?? 'No title';
            final isActive = data['isActive'] ?? true;

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                title: Text(title),
                subtitle: Text(data['content'] ?? ''),
                trailing: IconButton(
                  icon: Icon(
                    isActive ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () =>
                      _toggleAnnouncement(context, doc.id, !isActive),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _toggleAnnouncement(
      BuildContext context, String announcementId, bool isActive) async {
    await FirebaseFirestore.instance
        .collection('announcements')
        .doc(announcementId)
        .update({'isActive': isActive});
  }
}

class _EventsAdminTab extends StatelessWidget {
  const _EventsAdminTab();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('events')
          .orderBy('eventDate', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No events found'));
        }

        final events = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: events.length,
          itemBuilder: (context, index) {
            final doc = events[index];
            final data = doc.data() as Map<String, dynamic>;
            final title = data['title'] ?? 'No title';
            final isActive = data['isActive'] ?? true;

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                title: Text(title),
                subtitle: Text(data['description'] ?? ''),
                trailing: IconButton(
                  icon: Icon(
                    isActive ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () => _toggleEvent(context, doc.id, !isActive),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _toggleEvent(
      BuildContext context, String eventId, bool isActive) async {
    await FirebaseFirestore.instance
        .collection('events')
        .doc(eventId)
        .update({'isActive': isActive});
  }
}
