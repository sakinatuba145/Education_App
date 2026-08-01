import 'package:flutter/material.dart';

class SubmissionResultCard extends StatelessWidget {
  const SubmissionResultCard({
    super.key,
    required this.feedback,
    required this.passed,
    required this.onResubmit,
  });

  final String feedback;
  final bool passed;
  final VoidCallback onResubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          const Text(
            'Teacher Feedback',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),


          Container(
            width: double.infinity,

            padding: const EdgeInsets.all(14),

            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),

              border: Border.all(
                color: Colors.blue.withValues(alpha: 0.2),
              ),
            ),

            child: Text(
              feedback,

              style: const TextStyle(
                fontSize: 13,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
          ),



          if (!passed) ...[

            const SizedBox(height:16),


            SizedBox(
              width:double.infinity,

              child:OutlinedButton.icon(
                onPressed:onResubmit,

                icon:const Icon(
                  Icons.refresh_rounded,
                ),

                label:const Text(
                  'Resubmit Project',
                ),


                style:OutlinedButton.styleFrom(

                  side:const BorderSide(
                    color:Colors.red,
                  ),

                  foregroundColor:Colors.red,

                  padding:
                  const EdgeInsets.symmetric(
                    vertical:14,
                  ),

                  shape:RoundedRectangleBorder(
                    borderRadius:BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],

        ],
      ),
    );
  }
}