import 'package:education_app/core/widgets/students_widgets/submision_form.dart';
import 'package:flutter/material.dart';
import 'project_card.dart';
import 'submission_result_card.dart';
import 'certificate_button.dart';
import 'submitted_card.dart';



class ProjectContent extends StatelessWidget {
  const ProjectContent({
    super.key,

    required this.project,
    required this.submission,

    required this.courseId,
    required this.courseTitle,

    required this.textController,
    required this.urlController,

    required this.submitting,

    required this.onRefresh,
    required this.onSubmit,
    required this.onResubmit,
  });


  final Map<String,dynamic> project;
  final Map<String,dynamic>? submission;

  final String courseId;
  final String courseTitle;


  final TextEditingController textController;
  final TextEditingController urlController;


  final bool submitting;


  final Future<void> Function() onRefresh;

  final VoidCallback onSubmit;
  final VoidCallback onResubmit;



  @override
  Widget build(BuildContext context) {


    final status = submission?['status'] as String?;

    final graded =
        status == 'passed' || status == 'failed';



    return RefreshIndicator(

      onRefresh: onRefresh,


      child: SingleChildScrollView(

        physics:
        const AlwaysScrollableScrollPhysics(),


        padding:
        const EdgeInsets.all(20),


        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,


          children:[


            ProjectCard(
              project: project,
            ),


            const SizedBox(height:20),



            if(graded)...[


              SubmissionResultCard(

                feedback:
                submission?['feedback'] ?? '',


                passed:
                submission?['passed'] ?? false,


                onResubmit:
                onResubmit,
              ),



              const SizedBox(height:20),



              if(status == 'passed')

                CertificateButton(

                  courseId: courseId,

                  courseTitle: courseTitle,

                ),



              const SizedBox(height:20),

            ],




            if(submission != null && !graded)


              SubmittedCard(
                submission: submission!,
              )



            else if(submission == null)


              SubmissionForm(

                textController:textController,

                urlController:urlController,

                submitting:submitting,

                onSubmit:onSubmit,

              ),


          ],
        ),
      ),
    );
  }
}