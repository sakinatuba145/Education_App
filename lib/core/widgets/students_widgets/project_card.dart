import 'package:flutter/material.dart';

import '../../constants/theme.dart';


class ProjectCard extends StatelessWidget {
const ProjectCard({
super.key,
required this.project,
});

final Map<String, dynamic> project;

@override
Widget build(BuildContext context) {

final maxScore = project['maxScore'] ?? 100;
final passingScore = project['passingScore'] ?? 70;
final isRequired = project['isRequired'] ?? true;

final title = project['title'] ?? 'Final Project';
final description = project['description'] ?? '';
final instructions = project['instructions'] ?? '';


return Container(
padding: const EdgeInsets.all(20),

decoration: BoxDecoration(
gradient: LinearGradient(
colors: [
ThemeColors.primary.withValues(alpha: 0.8),
ThemeColors.primary,
],
begin: Alignment.topLeft,
end: Alignment.bottomRight,
),

borderRadius: BorderRadius.circular(20),

boxShadow: [
BoxShadow(
color: ThemeColors.primary.withValues(alpha: 0.3),
blurRadius: 16,
offset: const Offset(0, 6),
),
],
),


child: Column(
crossAxisAlignment: CrossAxisAlignment.start,

children: [

Row(
children: [

Container(
padding: const EdgeInsets.all(10),

decoration: BoxDecoration(
color: Colors.white.withValues(alpha: 0.2),
borderRadius: BorderRadius.circular(12),
),

child: const Icon(
Icons.assignment_rounded,
color: Colors.white,
size:24,
),
),


const SizedBox(width:12),


Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,

children: [

Text(
title,

style:const TextStyle(
fontSize:18,
fontWeight:FontWeight.bold,
color:Colors.white,
),
),


Row(
children:[

if(isRequired)

Container(
margin:
const EdgeInsets.only(right:8),

padding:
const EdgeInsets.symmetric(
horizontal:8,
vertical:2,
),

decoration:BoxDecoration(
color:Colors.red.withValues(alpha:0.3),
borderRadius:
BorderRadius.circular(6),
),


child:const Text(
'Required',

style:TextStyle(
fontSize:10,
color:Colors.white,
fontWeight:FontWeight.bold,
),
),
),


Text(
'Pass: $passingScore/$maxScore',

style:TextStyle(
fontSize:12,
color:Colors.white.withValues(alpha:0.85),
),
),

],
),

],
),
),

],
),


const SizedBox(height:16),


if(description.isNotEmpty)...[

Text(
description,

style:TextStyle(
color:Colors.white.withValues(alpha:0.9),
fontSize:13,
),
),
  const SizedBox(height:12),

],



  if(instructions.isNotEmpty)

    Container(

      padding:const EdgeInsets.all(14),

      decoration:BoxDecoration(
        color:Colors.white.withValues(alpha:0.15),
        borderRadius:BorderRadius.circular(12),
      ),


      child:Column(

        crossAxisAlignment:CrossAxisAlignment.start,

        children:[

          const Text(
            'Instructions',

            style:TextStyle(
              color:Colors.white,
              fontWeight:FontWeight.bold,
              fontSize:13,
            ),
          ),


          const SizedBox(height:6),


          Text(
            instructions,

            style:TextStyle(
              color:Colors.white.withValues(alpha:0.9),
              fontSize:12,
              height:1.5,
            ),
          ),

        ],
      ),
    ),

],
),
);
}
}