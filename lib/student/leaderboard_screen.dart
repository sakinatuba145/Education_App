import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:education_app/core/constants/app_colors.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  bool _loading = true;
  List<_LeaderEntry> _entries = [];
  String? _currentUid;

  @override
  void initState() {
    super.initState();
    _currentUid = FirebaseAuth.instance.currentUser?.uid;
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      // Fetch all quiz results across all users via collectionGroup
      final snap = await FirebaseFirestore.instance
          .collectionGroup('quiz_results')
          .get();

      // Group by userId → compute average score
      final Map<String, _UserAgg> agg = {};
      for (final doc in snap.docs) {
        final data = doc.data();
        final uid = data['userId'] as String? ?? '';
        if (uid.isEmpty) continue;
        final score = (data['score'] ?? 0) as int;
        final total = (data['totalQuestions'] ?? 1) as int;
        final pct = total > 0 ? score / total * 100 : 0.0;
        if (!agg.containsKey(uid)) {
          agg[uid] = _UserAgg(uid: uid);
        }
        agg[uid]!.totalPct += pct;
        agg[uid]!.count++;
      }

      // Fetch user display names
      final entries = <_LeaderEntry>[];
      for (final a in agg.values) {
        String displayName = 'Student';
        try {
          final userDoc = await FirebaseFirestore.instance.collection('users').doc(a.uid).get();
          if (userDoc.exists) {
            final raw = userDoc.data()?['name'] as String? ?? '';
            displayName = raw.split('|').first.trim();
            if (displayName.isEmpty) displayName = 'Student';
          }
        } catch (_) {}
        entries.add(_LeaderEntry(
          uid: a.uid,
          displayName: displayName,
          avgScore: a.count > 0 ? a.totalPct / a.count : 0,
          quizzesTaken: a.count,
        ));
      }

      entries.sort((a, b) => b.avgScore.compareTo(a.avgScore));

      if (mounted) setState(() { _entries = entries; _loading = false; });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              child: Row(
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.leaderboard_rounded, color: AppColors.primary, size: 28),
                          SizedBox(width: 10),
                          Text('Leaderboard', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.dark)),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text('Top students by quiz average', style: TextStyle(fontSize: 14, color: Colors.grey)),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.refresh_rounded, color: AppColors.primary),
                    onPressed: _load,
                  ),
                ],
              ),
            ),

            if (_loading)
              const Expanded(child: Center(child: CircularProgressIndicator(color: AppColors.primary)))
            else if (_entries.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.leaderboard_outlined, size: 80, color: Colors.grey.shade300),
                      const SizedBox(height: 16),
                      const Text('No scores yet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black54)),
                      const SizedBox(height: 8),
                      Text('Be the first to take a quiz!', style: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: Column(
                  children: [
                    if (_entries.length >= 3) _buildPodium(),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        itemCount: _entries.length,
                        itemBuilder: (_, i) => _buildRankTile(_entries[i], i),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPodium() {
    final top3 = _entries.take(3).toList();
    final colors = [const Color(0xFFFFD700), const Color(0xFFC0C0C0), const Color(0xFFCD7F32)];
    final heights = [110.0, 85.0, 70.0];
    final order = [1, 0, 2]; // show 2nd, 1st, 3rd

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF1A237E), Color(0xFF283593)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: order.map((idx) {
          if (idx >= top3.length) return const SizedBox();
          final entry = top3[idx];
          final isFirst = idx == 0;
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (isFirst) const Text('👑', style: TextStyle(fontSize: 20)),
              CircleAvatar(
                radius: isFirst ? 28 : 22,
                backgroundColor: colors[idx].withValues(alpha: 0.3),
                child: Text(entry.displayName.isNotEmpty ? entry.displayName[0].toUpperCase() : '?',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: isFirst ? 20 : 16)),
              ),
              const SizedBox(height: 6),
              Text(entry.displayName.split(' ').first, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12)),
              Text('${entry.avgScore.toStringAsFixed(0)}%', style: TextStyle(color: colors[idx], fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 6),
              Container(
                width: 70, height: heights[idx],
                decoration: BoxDecoration(
                  color: colors[idx].withValues(alpha: 0.25),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                ),
                child: Center(child: Text('${idx + 1}', style: TextStyle(color: colors[idx], fontWeight: FontWeight.bold, fontSize: 18))),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRankTile(_LeaderEntry entry, int index) {
    final isMe = entry.uid == _currentUid;
    final rank = index + 1;
    final medal = rank == 1 ? '🥇' : rank == 2 ? '🥈' : rank == 3 ? '🥉' : null;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isMe ? AppColors.primary.withValues(alpha: 0.08) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: isMe ? Border.all(color: AppColors.primary, width: 1.5) : null,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: medal != null
            ? Text(medal, style: const TextStyle(fontSize: 24))
            : Container(
                width: 32, height: 32,
                decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
                child: Center(child: Text('$rank', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey.shade600))),
              ),
        title: Row(
          children: [
            Text(entry.displayName, style: TextStyle(fontWeight: isMe ? FontWeight.bold : FontWeight.w600, fontSize: 15)),
            if (isMe) ...[const SizedBox(width: 8), Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(10)), child: const Text('You', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)))],
          ],
        ),
        subtitle: Text('${entry.quizzesTaken} quiz${entry.quizzesTaken == 1 ? '' : 'zes'} taken'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('${entry.avgScore.toStringAsFixed(1)}%', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: entry.avgScore >= 80 ? AppColors.success : entry.avgScore >= 60 ? AppColors.warning : AppColors.error)),
            Text('avg score', style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
          ],
        ),
      ),
    );
  }
}

class _UserAgg {
  final String uid;
  double totalPct = 0;
  int count = 0;
  _UserAgg({required this.uid});
}

class _LeaderEntry {
  final String uid;
  final String displayName;
  final double avgScore;
  final int quizzesTaken;
  const _LeaderEntry({required this.uid, required this.displayName, required this.avgScore, required this.quizzesTaken});
}
