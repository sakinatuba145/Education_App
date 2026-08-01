import 'package:flutter/material.dart';
import 'flip_card_face.dart';
import 'dart:math';

import 'model_flashcard.dart';

class FlipCard extends StatefulWidget {
  const FlipCard({
    super.key,
    required this.card,
  });

  final Flashcard card;

  @override
  State<FlipCard> createState() => _FlipCardState();
}


class _FlipCardState extends State<FlipCard>
    with SingleTickerProviderStateMixin {


  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  bool _showFront = true;


  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );


    _anim = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: Curves.easeInOut,
      ),
    );
  }



  @override
  void dispose() {

    _ctrl.dispose();

    super.dispose();
  }



  void _flip() {

    if (_ctrl.isAnimating) return;


    if (_showFront) {

      _ctrl.forward();

    } else {

      _ctrl.reverse();

    }


    setState(() {
      _showFront = !_showFront;
    });
  }



  @override
  Widget build(BuildContext context) {

    return GestureDetector(

      onTap: _flip,

      child: AnimatedBuilder(

        animation: _anim,

        builder: (context, child) {

          final angle = _anim.value * pi;


          return Transform(

            alignment: Alignment.center,

            transform: Matrix4.identity()

              ..setEntry(3, 2, 0.001)

              ..rotateY(angle),


            child: _showFront

                ? FlipCardFace(
              card: widget.card,
              isFront: true,
            )

                : Transform(

              alignment: Alignment.center,

              transform:
              Matrix4.identity()
                ..rotateY(pi),


              child: FlipCardFace(
                card: widget.card,
                isFront: false,
              ),
            ),
          );
        },
      ),
    );
  }
}