import 'package:flutter/material.dart';
import '../../constants/theme.dart';
import 'empty_state.dart';
import 'flashcard_done_state.dart';

class CardSession extends StatelessWidget {
  const CardSession({
    super.key,

    required this.courseTitle,
    required this.cards,
    required this.currentIndex,
    required this.loadingCards,
    required this.sessionDone,

    required this.onBack,
    required this.onRestart,
    required this.onChooseAnother,
    required this.onPrev,
    required this.onNext,

    required this.cardWidget,
  });

  final String courseTitle;

  final List cards;

  final int currentIndex;

  final bool loadingCards;

  final bool sessionDone;

  final VoidCallback onBack;

  final VoidCallback onRestart;

  final VoidCallback onChooseAnother;

  final VoidCallback? onPrev;

  final VoidCallback onNext;

  final Widget Function(dynamic card) cardWidget;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),

          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),

                onPressed: onBack,
              ),

              Expanded(
                child: Text(
                  courseTitle,

                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),

                  overflow: TextOverflow.ellipsis,
                ),
              ),

              if (cards.isNotEmpty && !sessionDone)
                Text(
                  '${currentIndex + 1} / ${cards.length}',

                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
            ],
          ),
        ),

        if (loadingCards)
          const Expanded(
            child: Center(
              child: CircularProgressIndicator(color: ThemeColors.primary),
            ),
          )
        else if (cards.isEmpty)
          const Expanded(
            child: EmptyState(
              title: 'No lessons found',

              subtitle: 'This course has no lessons yet',

              icon: Icons.style_outlined,
            ),
          )
        else if (sessionDone)
          Expanded(
            child: FlashcardDoneState(
              cardCount: cards.length,

              courseTitle: courseTitle,

              onRestart: onRestart,

              onChooseAnother: onChooseAnother,
            ),
          )
        else
          Expanded(
            child: Column(
              children: [
                const SizedBox(height: 8),

                LinearProgressIndicator(
                  value: (currentIndex + 1) / cards.length,

                  backgroundColor: Colors.grey.shade200,

                  valueColor: const AlwaysStoppedAnimation<Color>(
                    ThemeColors.primary,
                  ),

                  minHeight: 4,
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24),

                    child: cardWidget(cards[currentIndex]),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),

                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onPrev,

                          icon: const Icon(Icons.arrow_back_rounded),

                          label: const Text('Prev'),
                        ),
                      ),
                      const SizedBox(width: 16),

                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: onNext,

                          icon: Icon(
                            currentIndex < cards.length - 1
                                ? Icons.arrow_forward_rounded
                                : Icons.check_circle_rounded,
                          ),

                          label: Text(
                            currentIndex < cards.length - 1 ? 'Next' : 'Finish',
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
}
