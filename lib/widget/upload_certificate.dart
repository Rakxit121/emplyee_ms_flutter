import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadCertificatesDialog extends StatefulWidget {
  const UploadCertificatesDialog({super.key});

  @override
  _UploadCertificatesDialogState createState() =>
      _UploadCertificatesDialogState();
}

class _UploadCertificatesDialogState extends State<UploadCertificatesDialog> {
  final ImagePicker _picker = ImagePicker();
  File? _certificateImage;
  final TextEditingController qualificationController = TextEditingController();
  final TextEditingController organizationController = TextEditingController();

  Future<void> _pickCertificateImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _certificateImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Upload Certificates"),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: qualificationController,
              decoration: const InputDecoration(labelText: 'Qualification Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: organizationController,
              decoration: const InputDecoration(labelText: 'Organization'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _pickCertificateImage,
              child: const Text("Select Certificate Image"),
            ),
            const SizedBox(height: 10),
            _certificateImage != null
                ? Image.file(
                    _certificateImage!,
                    width: 100,
                    height: 100,
                  )
                : const Text("No image selected"),
          ],
        ),
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
            // Handle certificate upload logic (e.g., save certificate)
            Navigator.of(context).pop();
          },
          child: const Text("Upload"),
        ),
      ],
    );
  }
}
