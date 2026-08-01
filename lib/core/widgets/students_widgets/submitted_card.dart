import 'package:flutter/material.dart';

class SubmittedCard extends StatelessWidget {
  const SubmittedCard({super.key, required this.submission});

  final Map<String, dynamic> submission;

  @override
  Widget build(BuildContext context) {
    final submissionText = submission['submissionText'] ?? '';
    final submissionUrl = submission['submissionUrl'] ?? '';

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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),

                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),

                child: const Icon(
                  Icons.hourglass_top_rounded,
                  color: Colors.blue,
                  size: 24,
                ),
              ),

              const SizedBox(width: 12),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      'Submitted — Awaiting Review',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),

                    Text(
                      'Your teacher will grade your submission soon.',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          const Text(
            'Your Submission',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 8),

          Container(
            width: double.infinity,

            padding: const EdgeInsets.all(14),

            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),

              border: Border.all(color: Colors.grey[200]!),
            ),

            child: Text(
              submissionText,
              style: const TextStyle(fontSize: 13, height: 1.5),
            ),
          ),

          if (submissionUrl.isNotEmpty) ...[
            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),

              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(10),
              ),

              child: Row(
                children: [
                  const Icon(Icons.link_rounded, size: 16, color: Colors.blue),

                  const SizedBox(width: 8),

                  Expanded(
                    child: Text(
                      submissionUrl,

                      style: const TextStyle(fontSize: 12, color: Colors.blue),

                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
