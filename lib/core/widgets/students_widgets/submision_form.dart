import 'package:flutter/material.dart';

import '../../constants/theme.dart';


class SubmissionForm extends StatelessWidget {
  const SubmissionForm({
    super.key,
    required this.textController,
    required this.urlController,
    required this.submitting,
    required this.onSubmit,
  });

  final TextEditingController textController;
  final TextEditingController urlController;
  final bool submitting;
  final VoidCallback onSubmit;

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
          const Row(
            children: [
              Icon(Icons.upload_rounded, color: ThemeColors.primary),

              SizedBox(width: 8),

              Text(
                'Submit Your Project',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ],
          ),

          const SizedBox(height: 20),

          const Text(
            'Project Write-up *',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 8),

          TextField(
            controller: textController,
            maxLines: 6,
            textCapitalization: TextCapitalization.sentences,

            decoration: InputDecoration(
              hintText: 'Describe what you built, the approach you took, challenges you faced, and what you learned...',

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),

              filled: true,
              fillColor: Colors.grey[50],
            ),
          ),

          const SizedBox(height: 16),

          const Text(
            'Project Link (optional)',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 8),

          TextField(
            controller: urlController,
            keyboardType: TextInputType.url,

            decoration: InputDecoration(
              hintText: 'https://github.com/... or Google Drive link',

              prefixIcon: const Icon(Icons.link_rounded),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),

              filled: true,
              fillColor: Colors.grey[50],
            ),
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,

            child: FilledButton.icon(
              onPressed: submitting ? null : onSubmit,

              style: FilledButton.styleFrom(
                backgroundColor: ThemeColors.primary,

                padding: const EdgeInsets.symmetric(vertical: 16),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),

              icon: submitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.send_rounded),

              label: Text(
                submitting ? 'Submitting…' : 'Submit Project',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
