import 'package:employee_ms/ui/update_employee_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodel/employee_viewmodel.dart';

class EmployeeListPage extends StatelessWidget {
  const EmployeeListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final employeeViewModel = Provider.of<EmployeeViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Employee Management"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/addEmployee');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search by name...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                employeeViewModel.searchEmployees(value);
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DropdownButton<String>(
                hint: const Text("Sort by Status"),
                items: ['Present', 'Absent', 'Active', 'Terminated']
                    .map((String status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    employeeViewModel.sortEmployeesByStatus(newValue);
                  }
                },
              ),
              DropdownButton<int>(
                hint: const Text("Sort by Level"),
                items: [1, 2, 3, 4].map((int level) {
                  return DropdownMenuItem<int>(
                    value: level,
                    child: Text("Level $level"),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  if (newValue != null) {
                    employeeViewModel.sortEmployeesByLevel(newValue);
                  }
                },
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: employeeViewModel.employees.length,
              itemBuilder: (context, index) {
                final employee = employeeViewModel.employees[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundImage:
                          AssetImage('assets/profile_placeholder.png'),
                    ),
                    title: Text(employee.name),
                    subtitle: Text(
                        "Gender: ${employee.gender} | Phone: ${employee.phone} | Level: ${employee.level}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    UpdateEmployeePage(employee: employee),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            employeeViewModel.deleteEmployee(employee.id);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
