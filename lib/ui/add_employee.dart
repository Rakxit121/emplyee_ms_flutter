import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../model/employee_model.dart';
import '../viewmodel/employee_viewmodel.dart';
import '../widget/upload_certificate.dart';

class AddEmployeePage extends StatefulWidget {
  const AddEmployeePage({super.key});

  @override
  _AddEmployeePageState createState() => _AddEmployeePageState();
}

class _AddEmployeePageState extends State<AddEmployeePage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  String? gender;
  int? level;
  String? status;

  File? _profileImage;
  File? _certificateImage; // File for the certificate image
  final ImagePicker _picker = ImagePicker();

  // Function to pick image from gallery for profile picture
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  // Function to capture image for profile picture
  Future<void> _captureImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  // Function to handle certificate image selection
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Employee"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Picture Upload Section
                  Column(
                    children: [
                      GestureDetector(
                        onTap: _pickImage, // Trigger image picking
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: _profileImage != null
                              ? FileImage(_profileImage!)
                              : const AssetImage(
                                      'assets/profile_placeholder.png')
                                  as ImageProvider,
                          child: const Icon(Icons.camera_alt, size: 30),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _captureImage, // Capture image from camera
                        child: const Text("Capture Profile Image"),
                      ),
                    ],
                  ),
                  const SizedBox(width: 40),
                  // Employee Details Form Section
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: nameController,
                          decoration: const InputDecoration(labelText: 'Name'),
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          decoration:
                              const InputDecoration(labelText: 'Gender'),
                          items: ['Male', 'Female'].map((String gender) {
                            return DropdownMenuItem<String>(
                              value: gender,
                              child: Text(gender),
                            );
                          }).toList(),
                          onChanged: (value) {
                            gender = value;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: phoneController,
                          decoration:
                              const InputDecoration(labelText: 'Phone Number'),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: addressController,
                          decoration:
                              const InputDecoration(labelText: 'Address'),
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<int>(
                          decoration: const InputDecoration(labelText: 'Level'),
                          items: [1, 2, 3, 4].map((int level) {
                            return DropdownMenuItem<int>(
                              value: level,
                              child: Text("Level $level"),
                            );
                          }).toList(),
                          onChanged: (value) {
                            level = value;
                          },
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          decoration:
                              const InputDecoration(labelText: 'Status'),
                          items: ['Present', 'Absent', 'Active', 'Terminated']
                              .map((String status) {
                            return DropdownMenuItem<String>(
                              value: status,
                              child: Text(status),
                            );
                          }).toList(),
                          onChanged: (value) {
                            status = value;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Upload Certificates Button and Preview Section
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Trigger certificate upload pop-up
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const UploadCertificatesDialog();
                        },
                      );
                    },
                    child: const Text("Upload Certificates"),
                  ),
                  const SizedBox(width: 20),
                  _certificateImage != null
                      ? Image.file(
                          _certificateImage!,
                          width: 80,
                          height: 80,
                        )
                      : const Text("No certificate selected"),
                ],
              ),
              const SizedBox(height: 20),
              // Submit Button
// Submit Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Create an Employee object
                    final employee = Employee(
                      id: DateTime.now().toString(), // Generate a unique ID
                      name: nameController.text,
                      gender: gender ?? 'Not specified',
                      phone: phoneController.text,
                      address: addressController.text,
                      profilePic: _profileImage != null
                          ? _profileImage!.path
                          : '', // Assuming an empty string if no profile image is selected
                      level: level ?? 1, // Default to level 1 if not selected
                      salary: 0.0, // Default salary, adjust as needed
                      status:
                          status ?? 'Active', // Default status if not specified
                      qualifications: [], // Provide an empty list or fetch the actual qualifications
                    );

                    // Add employee to the EmployeeViewModel
                    final employeeViewModel =
                        Provider.of<EmployeeViewModel>(context, listen: false);
                    employeeViewModel.addEmployee(employee);

                    // Show confirmation message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Employee added successfully!')),
                    );

                    // Optionally, navigate back or clear the form
                    Navigator.pop(context);
                  }
                },
                child: const Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
