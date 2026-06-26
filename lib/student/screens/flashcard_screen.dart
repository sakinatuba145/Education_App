import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:education_app/core/constants/app_colors.dart';
import 'package:education_app/student/services/enrollment_service.dart';

class FlashcardScreen extends StatefulWidget {
  const FlashcardScreen({super.key});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  final _enrollment = EnrollmentService();
  List<EnrolledCourse> _courses = [];
  bool _loadingCourses = true;
  EnrolledCourse? _selectedCourse;
  List<_Flashcard> _cards = [];
  bool _loadingCards = false;
  int _currentIndex = 0;
  bool _sessionDone = false;

  @override
  void initState() {
    super.initState();
    _enrollment.streamMyEnrollments().listen((courses) {
      if (mounted) setState(() { _courses = courses; _loadingCourses = false; });
    }, onError: (_) { if (mounted) setState(() => _loadingCourses = false); });
  }

  Future<void> _selectCourse(EnrolledCourse course) async {
    setState(() { _selectedCourse = course; _loadingCards = true; _sessionDone = false; _currentIndex = 0; });
    try {
      final snap = await FirebaseFirestore.instance
          .collection('courses').doc(course.courseId).collection('lessons')
          .orderBy('sequenceNumber').get();
      final cards = <_Flashcard>[];
      for (final doc in snap.docs) {
        final data = doc.data();
        final title = data['title'] as String? ?? '';
        final notes = data['notes'] as String? ?? '';
        final youtubeUrl = data['youtubeUrl'] as String? ?? '';
        if (title.isNotEmpty) {
          cards.add(_Flashcard(
            front: title,
            back: notes.isNotEmpty
                ? notes
                : youtubeUrl.isNotEmpty
                    ? '🎥 Video lesson\n\nWatch the video to learn about "$title"'
                    : 'Review this lesson in the Course Player.',
          ));
        }
      }
      if (mounted) setState(() { _cards = cards; _loadingCards = false; });
    } catch (_) {
      if (mounted) setState(() => _loadingCards = false);
    }
  }

  void _next() {
    if (_currentIndex < _cards.length - 1) {
      setState(() => _currentIndex++);
    } else {
      setState(() => _sessionDone = true);
    }
  }

  void _prev() {
    if (_currentIndex > 0) setState(() => _currentIndex--);
  }

  void _restart() => setState(() { _currentIndex = 0; _sessionDone = false; });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(child: _selectedCourse == null ? _buildCourseList() : _buildCardSession()),
    );
  }

  Widget _buildCourseList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.style_rounded, color: AppColors.primary, size: 28),
                  SizedBox(width: 10),
                  Text('Flashcards', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.dark)),
                ],
              ),
              const SizedBox(height: 4),
              Text('Pick a course to study with flip cards', style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
            ],
          ),
        ),
        Expanded(
          child: _loadingCourses
              ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
              : _courses.isEmpty
                  ? _emptyState('No courses enrolled', 'Enroll in a course to start studying with flashcards', Icons.style_outlined)
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _courses.length,
                      itemBuilder: (_, i) {
                        final c = _courses[i];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 2,
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            leading: Container(
                              width: 48, height: 48,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryLight], begin: Alignment.topLeft, end: Alignment.bottomRight),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.style_rounded, color: Colors.white, size: 22),
                            ),
                            title: Text(c.courseTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text('${c.progressPercent}% complete · tap to study'),
                            trailing: const Icon(Icons.chevron_right, color: AppColors.primary),
                            onTap: () => _selectCourse(c),
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }

  Widget _buildCardSession() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () => setState(() { _selectedCourse = null; _cards = []; }),
              ),
              Expanded(
                child: Text(_selectedCourse!.courseTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), overflow: TextOverflow.ellipsis),
              ),
              if (_cards.isNotEmpty && !_sessionDone)
                Text('${_currentIndex + 1} / ${_cards.length}', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
            ],
          ),
        ),
        if (_loadingCards)
          const Expanded(child: Center(child: CircularProgressIndicator(color: AppColors.primary)))
        else if (_cards.isEmpty)
          Expanded(child: _emptyState('No lessons found', 'This course has no lessons yet', Icons.style_outlined))
        else if (_sessionDone)
          Expanded(child: _buildDoneState())
        else
          Expanded(
            child: Column(
              children: [
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: (_currentIndex + 1) / _cards.length,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  minHeight: 4,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: _FlipCard(card: _cards[_currentIndex], key: ValueKey(_currentIndex)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _currentIndex > 0 ? _prev : null,
                          icon: const Icon(Icons.arrow_back_rounded),
                          label: const Text('Prev'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _next,
                          icon: Icon(_currentIndex < _cards.length - 1 ? Icons.arrow_forward_rounded : Icons.check_circle_rounded),
                          label: Text(_currentIndex < _cards.length - 1 ? 'Next' : 'Finish'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildDoneState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100, height: 100,
              decoration: const BoxDecoration(color: AppColors.primarySubtle, shape: BoxShape.circle),
              child: const Icon(Icons.celebration_rounded, size: 54, color: AppColors.primary),
            ),
            const SizedBox(height: 24),
            const Text('Session Complete! 🎉', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text('You reviewed all ${_cards.length} cards for\n"${_selectedCourse!.courseTitle}"',
                textAlign: TextAlign.center, style: TextStyle(fontSize: 15, color: Colors.grey.shade600)),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _restart,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Study Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary, foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => setState(() { _selectedCourse = null; _cards = []; }),
              icon: const Icon(Icons.arrow_back_rounded),
              label: const Text('Choose Another Course'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState(String title, String subtitle, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black54)),
          const SizedBox(height: 8),
          Text(subtitle, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
        ],
      ),
    );
  }
}

class _Flashcard {
  final String front;
  final String back;
  const _Flashcard({required this.front, required this.back});
}

class _FlipCard extends StatefulWidget {
  final _Flashcard card;
  const _FlipCard({required this.card, super.key});

  @override
  State<_FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<_FlipCard> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;
  bool _showFront = true;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _anim = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  void _flip() {
    if (_ctrl.isAnimating) return;
    if (_showFront) {
      _ctrl.forward();
    } else {
      _ctrl.reverse();
    }
    setState(() => _showFront = !_showFront);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flip,
      child: AnimatedBuilder(
        animation: _anim,
        builder: (_, __) {
          final angle = _anim.value * pi;
          final isFront = angle <= pi / 2;
          final displayAngle = isFront ? angle : angle - pi;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(displayAngle),
            child: isFront ? _buildFace(isFront: true) : Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()..rotateY(pi),
              child: _buildFace(isFront: false),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFace({required bool isFront}) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isFront
              ? [AppColors.primary, AppColors.primaryLight]
              : [const Color(0xFF1565C0), const Color(0xFF1976D2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: (isFront ? AppColors.primary : const Color(0xFF1565C0)).withValues(alpha: 0.4), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: Stack(
        children: [
          Positioned(top: -20, right: -20, child: Icon(isFront ? Icons.lightbulb_outline_rounded : Icons.notes_rounded, size: 120, color: Colors.white.withValues(alpha: 0.08))),
          Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(20)),
                  child: Text(isFront ? '📖 TOPIC' : '📝 NOTES', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)),
                ),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Text(
                        isFront ? widget.card.front : widget.card.back,
                        style: TextStyle(color: Colors.white, fontSize: isFront ? 22 : 16, fontWeight: isFront ? FontWeight.bold : FontWeight.normal, height: 1.5),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.touch_app_rounded, size: 16, color: Colors.white.withValues(alpha: 0.7)),
                      const SizedBox(width: 6),
                      Text('Tap to flip', style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

extension on EnrolledCourse {
  int get progressPercent => (progress * 100).round();
}
