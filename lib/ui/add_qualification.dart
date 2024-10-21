import 'package:flutter/material.dart';

class AddQualificationDialog extends StatelessWidget {
  const AddQualificationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add Qualification"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Qualification Name
          const TextField(
            decoration: InputDecoration(labelText: 'Qualification Name'),
          ),
          const SizedBox(height: 10),

          // Institution
          const TextField(
            decoration: InputDecoration(labelText: 'Institution'),
          ),
          const SizedBox(height: 10),

          // Certificate Upload
          ElevatedButton(
            onPressed: () {
              // Handle certificate upload
            },
            child: const Text("Upload Certificate"),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            // Handle qualification submission
          },
          child: const Text("Add"),
        ),
      ],
    );
  }
}
