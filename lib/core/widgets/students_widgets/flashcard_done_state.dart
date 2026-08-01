import 'package:flutter/material.dart';

import '../../constants/theme.dart';


class FlashcardDoneState extends StatelessWidget {
  const FlashcardDoneState({
    super.key,
    required this.cardCount,
    required this.courseTitle,
    required this.onRestart,
    required this.onChooseAnother,
  });

  final int cardCount;
  final String courseTitle;

  final VoidCallback onRestart;
  final VoidCallback onChooseAnother;


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            Container(
              width: 100,
              height: 100,

              decoration: const BoxDecoration(
                color: ThemeColors.gradient1,
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.celebration_rounded,
                size:54,
                color:ThemeColors.primary,
              ),
            ),


            const SizedBox(height:24),


            const Text(
              'Session Complete! 🎉',

              style:TextStyle(
                fontSize:22,
                fontWeight:FontWeight.bold,
              ),
            ),


            const SizedBox(height:12),


            Text(
              'You reviewed all $cardCount cards for\n"$courseTitle"',

              textAlign:TextAlign.center,

              style:TextStyle(
                fontSize:15,
                color:Colors.grey.shade600,
              ),
            ),


            const SizedBox(height:32),


            ElevatedButton.icon(

              onPressed:onRestart,

              icon:const Icon(
                Icons.refresh_rounded,
              ),

              label:const Text(
                'Study Again',
              ),


              style:ElevatedButton.styleFrom(

                backgroundColor:ThemeColors.primary,

                foregroundColor:Colors.white,

                padding:
                const EdgeInsets.symmetric(
                  horizontal:32,
                  vertical:14,
                ),

                shape:
                RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(12),
                ),
              ),
            ),


            const SizedBox(height:12),



            OutlinedButton.icon(

              onPressed:onChooseAnother,

              icon:const Icon(
                Icons.arrow_back_rounded,
              ),

              label:const Text(
                'Choose Another Course',
              ),


              style:OutlinedButton.styleFrom(

                padding:
                const EdgeInsets.symmetric(
                  horizontal:32,
                  vertical:14,
                ),

                shape:
                RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(12),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}