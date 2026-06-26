import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:education_app/core/constants/app_colors.dart';
import 'package:education_app/student/services/enrollment_service.dart';

class WordPuzzleScreen extends StatefulWidget {
  const WordPuzzleScreen({super.key});

  @override
  State<WordPuzzleScreen> createState() => _WordPuzzleScreenState();
}

class _WordPuzzleScreenState extends State<WordPuzzleScreen> with TickerProviderStateMixin {
  final _enrollment = EnrollmentService();
  bool _loading = true;
  List<_PuzzleWord> _words = [];
  int _currentIndex = 0;
  int _score = 0;
  int _streak = 0;
  bool _revealed = false;
  bool _sessionDone = false;
  List<String> _selectedLetters = [];
  List<String> _shuffledLetters = [];
  late AnimationController _shakeCtrl;
  late Animation<double> _shakeAnim;
  bool _correct = false;
  bool _wrong = false;

  // Fallback educational words if no courses are enrolled
  static const _fallbackWords = [
    _PuzzleWord(word: 'ALGORITHM', hint: 'A step-by-step procedure for solving a problem'),
    _PuzzleWord(word: 'VARIABLE', hint: 'A named container that holds a value in programming'),
    _PuzzleWord(word: 'FUNCTION', hint: 'A reusable block of code that performs a task'),
    _PuzzleWord(word: 'SYNTAX', hint: 'The set of rules that define the structure of a language'),
    _PuzzleWord(word: 'DATABASE', hint: 'An organized collection of structured data'),
    _PuzzleWord(word: 'NETWORK', hint: 'A group of connected computers that share resources'),
    _PuzzleWord(word: 'INTERFACE', hint: 'A boundary where two systems interact'),
    _PuzzleWord(word: 'FLUTTER', hint: 'Google\'s UI toolkit for building apps'),
    _PuzzleWord(word: 'FIREBASE', hint: 'Google\'s platform for app development and backend'),
    _PuzzleWord(word: 'FRAMEWORK', hint: 'A pre-built structure for building software'),
    _PuzzleWord(word: 'DEBUGGING', hint: 'The process of finding and fixing errors in code'),
    _PuzzleWord(word: 'ITERATION', hint: 'Repeating a process until a condition is met'),
  ];

  @override
  void initState() {
    super.initState();
    _shakeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _shakeAnim = Tween<double>(begin: 0, end: 10)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_shakeCtrl);
    _loadWords();
  }

  @override
  void dispose() { _shakeCtrl.dispose(); super.dispose(); }

  Future<void> _loadWords() async {
    setState(() => _loading = true);
    final wordList = <_PuzzleWord>[];
    try {
      final courses = await _enrollment.streamMyEnrollments().first;
      for (final course in courses.take(3)) {
        final snap = await FirebaseFirestore.instance
            .collection('courses').doc(course.courseId).collection('lessons')
            .limit(10).get();
        for (final doc in snap.docs) {
          final title = (doc.data()['title'] as String? ?? '').trim().toUpperCase();
          final words = title.split(RegExp(r'\s+'))
              .where((w) => w.length >= 4 && w.length <= 12)
              .where((w) => w.contains(RegExp(r'^[A-Z]+$')));
          for (final w in words) {
            wordList.add(_PuzzleWord(word: w, hint: 'From "${course.courseTitle}"'));
          }
        }
      }
    } catch (_) {}

    final finalWords = wordList.isEmpty ? List<_PuzzleWord>.from(_fallbackWords) : wordList;
    finalWords.shuffle(Random());

    if (mounted) {
      setState(() {
        _words = finalWords.take(10).toList();
        _loading = false;
        _currentIndex = 0;
        _score = 0;
        _streak = 0;
        _sessionDone = false;
      });
      _setupCurrent();
    }
  }

  void _setupCurrent() {
    if (_currentIndex >= _words.length) { setState(() => _sessionDone = true); return; }
    final letters = _words[_currentIndex].word.split('');
    final shuffled = List<String>.from(letters)..shuffle(Random());
    // Ensure shuffled is different from original for short words
    var attempts = 0;
    while (shuffled.join() == letters.join() && attempts < 10) {
      shuffled.shuffle(Random());
      attempts++;
    }
    setState(() {
      _selectedLetters = [];
      _shuffledLetters = shuffled;
      _revealed = false;
      _correct = false;
      _wrong = false;
    });
  }

  void _tapLetter(int i) {
    if (_revealed || _correct) return;
    final letter = _shuffledLetters[i];
    setState(() {
      _selectedLetters.add(letter);
      _shuffledLetters.removeAt(i);
    });
    _checkAnswer();
  }

  void _removeLetter(int i) {
    if (_revealed || _correct) return;
    final letter = _selectedLetters[i];
    setState(() {
      _selectedLetters.removeAt(i);
      _shuffledLetters.add(letter);
    });
  }

  void _checkAnswer() {
    final attempt = _selectedLetters.join();
    final target = _words[_currentIndex].word;
    if (attempt.length < target.length) return;
    if (attempt == target) {
      setState(() { _correct = true; _score += 10 + _streak * 2; _streak++; });
      Future.delayed(const Duration(milliseconds: 1200), _advance);
    } else {
      setState(() { _wrong = true; _streak = 0; });
      _shakeCtrl.forward(from: 0);
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) setState(() { _wrong = false; _selectedLetters = []; _shuffledLetters = _words[_currentIndex].word.split('')..shuffle(Random()); });
      });
    }
  }

  void _reveal() {
    setState(() { _revealed = true; _streak = 0; });
    Future.delayed(const Duration(milliseconds: 1500), _advance);
  }

  void _advance() {
    setState(() => _currentIndex++);
    if (_currentIndex < _words.length) _setupCurrent();
    else setState(() => _sessionDone = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
            : _sessionDone
                ? _buildDoneScreen()
                : _buildPuzzle(),
      ),
    );
  }

  Widget _buildPuzzle() {
    final puzzle = _words[_currentIndex];
    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Row(
            children: [
              const Row(children: [
                Icon(Icons.extension_rounded, color: AppColors.primary, size: 22),
                SizedBox(width: 8),
                Text('Word Puzzle', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ]),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
                child: Row(children: [
                  const Icon(Icons.star_rounded, color: AppColors.primary, size: 16),
                  const SizedBox(width: 4),
                  Text('$_score pts', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                ]),
              ),
              if (_streak > 1) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(color: Colors.orange.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
                  child: Row(children: [
                    const Text('🔥', style: TextStyle(fontSize: 14)),
                    const SizedBox(width: 4),
                    Text('$_streak', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
                  ]),
                ),
              ],
            ],
          ),
        ),
        // Progress
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Word ${_currentIndex + 1} of ${_words.length}', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                  Text('${((_currentIndex / _words.length) * 100).round()}%', style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: _currentIndex / _words.length,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  minHeight: 6,
                ),
              ),
            ],
          ),
        ),
        // Hint card
        Container(
          margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryLight], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('💡 HINT', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)),
              const SizedBox(height: 6),
              Text(puzzle.hint, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              Text('${puzzle.word.length} letters', style: const TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
        ),
        // Answer slots
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: AnimatedBuilder(
            animation: _shakeAnim,
            builder: (_, child) => Transform.translate(
              offset: Offset(_shakeAnim.value * (_wrong ? ((_shakeCtrl.value * 10) % 2 == 0 ? 1 : -1) : 0), 0),
              child: child,
            ),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: List.generate(puzzle.word.length, (i) {
                final filled = i < _selectedLetters.length;
                final letter = filled ? _selectedLetters[i] : '';
                return GestureDetector(
                  onTap: filled ? () => _removeLetter(i) : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 42, height: 42,
                    decoration: BoxDecoration(
                      color: _correct
                          ? AppColors.success.withValues(alpha: 0.2)
                          : _wrong && filled
                              ? AppColors.error.withValues(alpha: 0.1)
                              : filled ? AppColors.primary.withValues(alpha: 0.1) : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: _correct ? AppColors.success : _wrong && filled ? AppColors.error : filled ? AppColors.primary : Colors.grey.shade300,
                        width: 2,
                      ),
                    ),
                    child: Center(child: Text(letter, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: _correct ? AppColors.success : _wrong ? AppColors.error : AppColors.dark))),
                  ),
                );
              }),
            ),
          ),
        ),
        if (_correct)
          const Padding(
            padding: EdgeInsets.only(top: 12),
            child: Text('✅ Correct! Well done!', style: TextStyle(color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        if (_revealed)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text('The word was: ${puzzle.word}', style: const TextStyle(color: Colors.grey, fontSize: 14)),
          ),
        const Spacer(),
        // Letter tiles
        if (!_correct && !_revealed)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 10,
              runSpacing: 10,
              children: List.generate(_shuffledLetters.length, (i) {
                return GestureDetector(
                  onTap: () => _tapLetter(i),
                  child: Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 1.5),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 4, offset: const Offset(0, 2))],
                    ),
                    child: Center(child: Text(_shuffledLetters[i], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.dark))),
                  ),
                );
              }),
            ),
          ),
        // Controls
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _correct || _revealed ? null : () { setState(() { _selectedLetters = []; _shuffledLetters = _words[_currentIndex].word.split('')..shuffle(Random()); }); },
                  icon: const Icon(Icons.shuffle_rounded, size: 18),
                  label: const Text('Shuffle'),
                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 13), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _correct || _revealed ? null : _reveal,
                  icon: const Icon(Icons.visibility_rounded, size: 18),
                  label: const Text('Reveal'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    foregroundColor: Colors.orange,
                    side: const BorderSide(color: Colors.orange),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _correct || _revealed ? _advance : null,
                  icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                  label: const Text('Next'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary, foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDoneScreen() {
    final pct = _words.isEmpty ? 0 : _score;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100, height: 100,
              decoration: const BoxDecoration(color: AppColors.primarySubtle, shape: BoxShape.circle),
              child: const Icon(Icons.emoji_events_rounded, size: 54, color: AppColors.primary),
            ),
            const SizedBox(height: 24),
            const Text('Puzzle Complete! 🎊', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text('Your score: $pct points', style: const TextStyle(fontSize: 18, color: AppColors.primary, fontWeight: FontWeight.w600)),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadWords,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Play Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary, foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PuzzleWord {
  final String word;
  final String hint;
  const _PuzzleWord({required this.word, required this.hint});
}
