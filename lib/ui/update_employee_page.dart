import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../model/employee_model.dart';
import '../viewmodel/employee_viewmodel.dart';

class UpdateEmployeePage extends StatefulWidget {
  final Employee employee;

  const UpdateEmployeePage({super.key, required this.employee});

  @override
  _UpdateEmployeePageState createState() => _UpdateEmployeePageState();
}

class _UpdateEmployeePageState extends State<UpdateEmployeePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController nameController;
  late final TextEditingController phoneController;
  late final TextEditingController addressController;
  String? gender;
  int? level;
  String? status;
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with current employee data
    nameController = TextEditingController(text: widget.employee.name);
    phoneController = TextEditingController(text: widget.employee.phone);
    addressController = TextEditingController(text: widget.employee.address);
    gender = widget.employee.gender;
    level = widget.employee.level;
    status = widget.employee.status;

    // Load current profile image if needed
    if (widget.employee.profilePic.isNotEmpty) {
      _profileImage = File(widget.employee.profilePic);
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Employee"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!)
                      : const AssetImage('assets/profile_placeholder.png')
                          as ImageProvider,
                  child: const Icon(Icons.camera_alt, size: 30),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Gender'),
                value: gender, // Initialize with the current value
                items: ['Male', 'Female'].map((String gender) {
                  return DropdownMenuItem<String>(
                    value: gender,
                    child: Text(gender),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    gender = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Address'),
              ),
              const SizedBox(height: 10),
// For Level dropdown
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: 'Level'),
                value: level, // Initialize with the current value
                items: [1, 2, 3, 4].map((int level) {
                  return DropdownMenuItem<int>(
                    value: level,
                    child: Text("Level $level"),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    level = value;
                  });
                },
              ),
              const SizedBox(height: 10),
// For Status dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Status'),
                value: status, // Initialize with the current value
                items: ['Present', 'Absent', 'Active', 'Terminated']
                    .map((String status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    status = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Create updated employee object
                    final updatedEmployee = Employee(
                      id: widget.employee.id, // Keep the same ID
                      name: nameController.text,
                      gender: gender ?? 'Not specified',
                      phone: phoneController.text,
                      address: addressController.text,
                      profilePic:
                          _profileImage != null ? _profileImage!.path : '',
                      level: level ?? 1,
                      salary: widget
                          .employee.salary, // Assuming you keep the same salary
                      status: status ?? 'Active',
                      qualifications: widget.employee
                          .qualifications, // Assuming you keep the same qualifications
                    );

                    // Update the employee in the EmployeeViewModel
                    final employeeViewModel =
                        Provider.of<EmployeeViewModel>(context, listen: false);
                    employeeViewModel.updateEmployee(
                        widget.employee.id, updatedEmployee);

                    // Show confirmation message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Employee updated successfully!')),
                    );

                    // Navigate back
                    Navigator.pop(context);
                  }
                },
                child: const Text("Update"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
