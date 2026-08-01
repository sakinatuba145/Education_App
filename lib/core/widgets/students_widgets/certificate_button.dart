import 'package:flutter/material.dart';

import '../../../student/certificate_screen.dart';


class CertificateButton extends StatelessWidget {
  const CertificateButton({
    super.key,
    required this.courseId,
    required this.courseTitle,
  });

  final String courseId;
  final String courseTitle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CertificateScreen(
            courseId: courseId,
            courseTitle: courseTitle,
          ),
        ),
      ),

      child: Container(
        padding: const EdgeInsets.all(16),

        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.amber[700]!,
              Colors.amber[400]!,
            ],
          ),

          borderRadius: BorderRadius.circular(16),

          boxShadow: [
            BoxShadow(
              color: Colors.amber.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),


        child: const Row(
          children: [

            Icon(
              Icons.workspace_premium_rounded,
              color: Colors.white,
              size: 32,
            ),


            SizedBox(width:14),


            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  Text(
                    'View Certificate',
                    style: TextStyle(
                      fontSize:16,
                      fontWeight:FontWeight.bold,
                      color:Colors.white,
                    ),
                  ),


                  Text(
                    'You\'ve earned your certificate of completion!',
                    style:TextStyle(
                      fontSize:12,
                      color:Colors.white,
                    ),
                  ),

                ],
              ),
            ),


            Icon(
              Icons.arrow_forward_ios_rounded,
              color:Colors.white,
              size:16,
            ),

          ],
        ),
      ),
    );
  }
}