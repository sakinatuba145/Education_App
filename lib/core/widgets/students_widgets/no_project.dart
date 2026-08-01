import 'package:flutter/material.dart';

class NoProject extends StatelessWidget {
  const NoProject({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [

          Icon(
            Icons.assignment_outlined,
            size: 64,
            color: Colors.grey[300],
          ),


          const SizedBox(height:16),


          Text(
            'No final project set',

            style: TextStyle(
              fontSize:18,
              fontWeight:FontWeight.bold,
              color:Colors.grey[700],
            ),
          ),


          const SizedBox(height:8),


          Text(
            'Your teacher hasn\'t added a project for this course yet.',

            textAlign:TextAlign.center,

            style:TextStyle(
              fontSize:13,
              color:Colors.grey[500],
            ),
          ),

        ],
      ),
    );
  }
}