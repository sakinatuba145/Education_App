import 'package:education_app/core/widgets/students_widgets/premium_stat_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

import '../../../student/progress_service.dart';
import '../../I18n/messages.dart';
import '../../constants/theme.dart';


class StatsRow extends StatelessWidget {

  const StatsRow({
    super.key,
    required this.loading,
    required this.stats,
  });


  final bool loading;
  final StudentStats? stats;


  @override
  Widget build(BuildContext context) {


    if(loading){
      return const Padding(
        padding: EdgeInsets.symmetric(vertical:24),
        child: Center(
          child:CircularProgressIndicator(
            color: ThemeColors.primary,
          ),
        ),
      );
    }



    return Row(
      children:[

        PremiumStatCard(
          icon: Icons.menu_book_rounded,
          value:'${stats?.enrolledCourses ?? 0}',
          label:AppMessages.enrolled.tr,
        ),


        const SizedBox(width:12),


        PremiumStatCard(
          icon:Icons.quiz_rounded,
          value:'${stats?.quizzesTaken ?? 0}',
          label:AppMessages.quizzes.tr,
        ),


        const SizedBox(width:12),


        PremiumStatCard(
          icon:Icons.trending_up_rounded,
          value:'${stats?.avgProgressPercent ?? 0}%',
          label:AppMessages.avgProgress.tr,
        ),


      ],
    );

  }

}