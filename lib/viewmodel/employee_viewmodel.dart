import 'dart:convert';

import 'package:employee_ms/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/employee_model.dart';

class EmployeeViewModel extends ChangeNotifier {
  final List<Employee> _employees = [];
  final DBHelper _dbHelper = DBHelper(); // Instance of SQLite DB Helper
  List<Employee> get employees => _employees;

  // Add Employee to SQLite and list
  Future<void> addEmployee(Employee employee) async {
    _employees.add(employee);

    // Insert employee into SQLite DB
    await _dbHelper.insertEmployee(employee);
    notifyListeners();
  }

  // Update Employee in SQLite and list
  Future<void> updateEmployee(String id, Employee updatedEmployee) async {
    final index = _employees.indexWhere((emp) => emp.id == id);
    if (index != -1) {
      _employees[index] = updatedEmployee;

      // Update employee in SQLite DB
      await _dbHelper.updateEmployee(updatedEmployee);
      notifyListeners();
    }
  }

  // Delete Employee from SQLite and list
  Future<void> deleteEmployee(String id) async {
    _employees.removeWhere((emp) => emp.id == id);

    // Delete employee from SQLite DB
    await _dbHelper.deleteEmployee(id);
    notifyListeners();
  }

  // Search Employees (from in-memory list)
  List<Employee> searchEmployees(String query) {
    return _employees
        .where((employee) =>
            employee.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  // Sort Employees by Status
  void sortEmployeesByStatus(String status) {
    _employees.sort((a, b) => a.status.compareTo(b.status));
    notifyListeners();
  }

  // Sort Employees by Level
  void sortEmployeesByLevel(int level) {
    _employees.sort((a, b) => a.level.compareTo(b.level));
    notifyListeners();
  }

  // Load Employees from SQLite
  Future<void> loadEmployees() async {
    List<Employee> localEmployees = await _dbHelper.getEmployees();
    _employees.addAll(localEmployees);
    notifyListeners(); // Notify UI to update the view
  }

  // Sync local employees with the Django server
  Future<void> syncWithServer() async {
    List<Employee> localEmployees = await _dbHelper.getEmployees();

    for (Employee employee in localEmployees) {
      final response = await http.post(
        Uri.parse(
            'http://your-server-url/add_employee/'), // Change with your actual API URL
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(employee.toMap()), // Convert Employee object to JSON
      );

      if (response.statusCode == 201) {
        print('Employee synced with server: ${employee.name}');
      } else {
        print('Failed to sync employee: ${response.body}');
      }
    }
  }
}
