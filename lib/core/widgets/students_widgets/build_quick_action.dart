import 'package:education_app/core/widgets/students_widgets/quick_action_title.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../I18n/messages.dart';



class QuickActions extends StatelessWidget {
  const QuickActions({
    super.key,
    required this.onNavigate,
  });

  final ValueChanged<int> onNavigate;

  @override
  Widget build(BuildContext context) {

    final actions = [
      QuickAction(
        Icons.explore_rounded,
        AppMessages.exploreTab.tr,
        'Browse courses',
        1,
        const Color(0xFF6C63FF),
      ),
      QuickAction(
        Icons.quiz_rounded,
        AppMessages.quizzes.tr,
        'Test yourself',
        2,
        const Color(0xFF00B4D8),
      ),
      QuickAction(
        Icons.style_rounded,
        AppMessages.flashcards.tr,
        'Review cards',
        2,
        const Color(0xFF06D6A0),
      ),
      QuickAction(
        Icons.leaderboard_rounded,
        AppMessages.ranking.tr,
        'Top students',
        2,
        const Color(0xFFFFB703),
      ),
    ];


    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.3,
        children: actions.map((action) {

          return QuickActionTile(
            action: action,
            onTap: () => onNavigate(action.tabIndex),
          );

        }).toList(),
      ),
    );
  }
}


class QuickAction {

  final IconData icon;
  final String label;
  final String sublabel;
  final int tabIndex;
  final Color color;


  const QuickAction(
      this.icon,
      this.label,
      this.sublabel,
      this.tabIndex,
      this.color,
      );

}