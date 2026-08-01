import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [

          Icon(
            icon,
            size: 80,
            color: Colors.grey.shade300,
          ),


          const SizedBox(height: 16),


          Text(
            title,

            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),


          const SizedBox(height: 8),


          Text(
            subtitle,

            textAlign: TextAlign.center,

            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 14,
            ),
          ),

        ],
      ),
    );
  }
}