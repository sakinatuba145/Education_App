import 'package:flutter/material.dart';

import '../../constants/theme.dart';
import 'model_flashcard.dart';


class FlipCardFace extends StatelessWidget {

  const FlipCardFace({
    super.key,
    required this.card,
    required this.isFront,
  });


  final Flashcard card;
  final bool isFront;



  @override
  Widget build(BuildContext context) {

    return Container(

      width: double.infinity,
      height: double.infinity,


      decoration: BoxDecoration(

        gradient: LinearGradient(

          colors: isFront

              ? [
            ThemeColors.primary,
            ThemeColors.secondary,
          ]

              : [
            const Color(0xFF1565C0),
            const Color(0xFF1976D2),
          ],

          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),


        borderRadius:
        BorderRadius.circular(24),


        boxShadow: [

          BoxShadow(

            color:
            (isFront
                ? ThemeColors.primary
                : const Color(0xFF1565C0))
                .withValues(alpha:0.4),

            blurRadius:20,

            offset:
            const Offset(0,8),
          ),
        ],
      ),


      child: Padding(

        padding:
        const EdgeInsets.all(28),


        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,


          children: [

            Text(
              isFront
                  ? '📖 TOPIC'
                  : '📝 NOTES',

              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),


            Expanded(

              child: Center(

                child: SingleChildScrollView(

                  child: Text(

                    isFront
                        ? card.front
                        : card.back,


                    style: TextStyle(

                      color: Colors.white,

                      fontSize:
                      isFront ? 22 : 16,

                      height:1.5,
                    ),

                    textAlign:
                    TextAlign.center,
                  ),
                ),
              ),
            ),


            const Center(

              child: Text(
                'Tap to flip',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize:12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}