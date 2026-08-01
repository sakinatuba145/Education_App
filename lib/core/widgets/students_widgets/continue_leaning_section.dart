import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import '../../../student/enrollment_service.dart';
import '../../I18n/messages.dart';
import '../../constants/theme.dart';
import '../glass_card.dart';
import 'horizontal_course_card.dart';


class ContinueLearningSection extends StatelessWidget {

  const ContinueLearningSection({
    super.key,
    required this.enrollment,
    required this.onNavigate,
  });


  final EnrollmentService enrollment;
  final void Function(int index) onNavigate;


  @override
  Widget build(BuildContext context) {

    return StreamBuilder<List<EnrolledCourse>>(
      stream: enrollment.streamMyEnrollments(),

      builder: (context, snapshot) {


        if(snapshot.connectionState == ConnectionState.waiting){

          return const Padding(
            padding: EdgeInsets.all(20),
            child: Center(
              child: CircularProgressIndicator(
                color: ThemeColors.primary,
              ),
            ),
          );
        }


        final courses = snapshot.data ?? [];


        if(courses.isEmpty){

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal:20),
            child: GlassCard(
              padding: const EdgeInsets.all(28),

              child: Column(
                children: [

                  Icon(
                    Icons.school_outlined,
                    size:40,
                    color:ThemeColors.primary.withValues(alpha:0.6),
                  ),


                  const SizedBox(height:14),


                  Text(
                    AppMessages.noCoursesYet.tr,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize:17,
                    ),
                  ),


                  const SizedBox(height:8),


                  Text(
                    AppMessages.exploreToStart.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color:Colors.grey.shade500,
                      fontSize:13,
                    ),
                  ),

                ],
              ),
            ),
          );
        }


        return SizedBox(
          height:185,

          child: ListView.builder(

            padding: const EdgeInsets.symmetric(horizontal:20),

            scrollDirection: Axis.horizontal,

            itemCount:courses.length,


            itemBuilder:(context,index){

              return HorizontalCourseCard(
                course:courses[index],
              );

            },
          ),
        );
      },
    );
  }
}