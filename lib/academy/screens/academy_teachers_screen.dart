import 'package:flutter/material.dart';
import 'package:education_app/core/constants/app_colors.dart';
import 'package:education_app/academy/services/academy_service.dart';

class AcademyTeachersScreen extends StatefulWidget {
  const AcademyTeachersScreen({super.key});

  @override
  State<AcademyTeachersScreen> createState() => _AcademyTeachersScreenState();
}

class _AcademyTeachersScreenState extends State<AcademyTeachersScreen>
    with SingleTickerProviderStateMixin {
  final AcademyService _service = AcademyService();
  List<AcademyTeacher> _teachers = [];
  List<AcademyInvite> _invites = [];
  bool _loading = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _load();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final results = await Future.wait([
      _service.getTeachers(),
      _service.getPendingInvites(),
    ]);
    if (mounted) {
      setState(() {
        _teachers = results[0] as List<AcademyTeacher>;
        _invites = results[1] as List<AcademyInvite>;
        _loading = false;
      });
    }
  }

  // ── Invite dialog ────────────────────────────────────────────────────────
  void _showInviteDialog() {
    final emailCtrl = TextEditingController();
    final nameCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool sending = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.person_add_alt_1, color: AppColors.primary),
              SizedBox(width: 10),
              Text('Invite Teacher'),
            ],
          ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Send an invitation to a teacher to join your academy.',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email address *',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Email is required';
                    }
                    if (!v.contains('@')) return 'Enter a valid email';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: nameCtrl,
                  decoration: InputDecoration(
                    labelText: 'Name (optional)',
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            FilledButton.icon(
              onPressed: sending
                  ? null
                  : () async {
                      if (!formKey.currentState!.validate()) return;
                      setS(() => sending = true);
                      try {
                        await _service.inviteTeacher(
                          emailCtrl.text,
                          nameCtrl.text.isEmpty
                              ? emailCtrl.text.split('@').first
                              : nameCtrl.text,
                        );
                        if (ctx.mounted) Navigator.pop(ctx);
                        _load();
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('✓ Invitation sent'),
                              backgroundColor: AppColors.success,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          _tabController.animateTo(1);
                        }
                      } catch (e) {
                        setS(() => sending = false);
                        if (ctx.mounted) {
                          ScaffoldMessenger.of(ctx).showSnackBar(
                            SnackBar(content: Text('Error: $e')),
                          );
                        }
                      }
                    },
              icon: sending
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.send),
              label: const Text('Send Invite'),
            ),
          ],
        ),
      ),
    );
  }

  // ── Remove teacher dialog ───────────────────────────────────────────────
  void _confirmRemove(AcademyTeacher t) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Remove Teacher'),
        content: Text(
            'Remove ${t.name} from your academy? They will lose access to academy resources.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _service.removeTeacher(t.uid);
              _load();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${t.name} removed from academy'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: const Text('Remove',
                style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Teachers'),
        centerTitle: true,
        actions: [
          IconButton(
              icon: const Icon(Icons.refresh), onPressed: _load),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Active (${_teachers.length})'),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Pending'),
                  if (_invites.isNotEmpty) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${_invites.length}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showInviteDialog,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.person_add_alt_1),
        label: const Text('Invite Teacher'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildActiveTeachers(),
                _buildPendingInvites(),
              ],
            ),
    );
  }

  Widget _buildActiveTeachers() {
    if (_teachers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text('No teachers yet',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: Colors.grey[600])),
            const SizedBox(height: 8),
            Text(
              'Invite teachers to join your academy.',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.grey[400]),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _showInviteDialog,
              icon: const Icon(Icons.person_add_alt_1),
              label: const Text('Invite a Teacher'),
            ),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        itemCount: _teachers.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) => _teacherCard(_teachers[i]),
      ),
    );
  }

  Widget _teacherCard(AcademyTeacher t) {
    return Card(
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.primary.withValues(alpha: 0.12),
              backgroundImage: (t.photoUrl != null && t.photoUrl!.isNotEmpty)
                  ? NetworkImage(t.photoUrl!)
                  : null,
              child: (t.photoUrl == null || t.photoUrl!.isEmpty)
                  ? Text(
                      t.name.isNotEmpty ? t.name[0].toUpperCase() : 'T',
                      style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    )
                  : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.name,
                      style: Theme.of(context).textTheme.titleMedium),
                  Text(t.email,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.grey[500])),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _chip(Icons.menu_book, '${t.courseCount} courses',
                          Colors.blue),
                      const SizedBox(width: 8),
                      _chip(Icons.people, '${t.studentCount} students',
                          Colors.green),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: t.status == 'active'
                        ? AppColors.success.withValues(alpha: 0.15)
                        : Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    t.status,
                    style: TextStyle(
                      fontSize: 11,
                      color: t.status == 'active'
                          ? AppColors.success
                          : Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline,
                      color: Colors.red, size: 20),
                  tooltip: 'Remove from academy',
                  onPressed: () => _confirmRemove(t),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingInvites() {
    if (_invites.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.mail_outline, size: 72, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text('No pending invitations',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Colors.grey[600])),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        itemCount: _invites.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) => _inviteCard(_invites[i]),
      ),
    );
  }

  Widget _inviteCard(AcademyInvite inv) {
    final sent = _formatDate(inv.createdAt);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.orange.withValues(alpha: 0.12),
          child: Text(
            inv.name.isNotEmpty ? inv.name[0].toUpperCase() : '?',
            style: const TextStyle(
                color: Colors.orange, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(inv.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(inv.email,
                style: const TextStyle(fontSize: 12)),
            Text('Sent $sent',
                style: TextStyle(fontSize: 11, color: Colors.grey[500])),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('Pending',
                  style: TextStyle(
                      fontSize: 11,
                      color: Colors.orange,
                      fontWeight: FontWeight.w600)),
            ),
            IconButton(
              icon: const Icon(Icons.close, size: 18, color: Colors.red),
              tooltip: 'Cancel invite',
              onPressed: () async {
                await _service.cancelInvite(inv.id);
                _load();
              },
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }

  Widget _chip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(label,
              style: TextStyle(
                  fontSize: 11,
                  color: color,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inDays == 0) return 'today';
    if (diff.inDays == 1) return 'yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}
