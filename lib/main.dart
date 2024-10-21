import 'package:employee_ms/ui/add_employee.dart';
import 'package:employee_ms/ui/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ui/employee_list.dart';
import 'viewmodel/employee_viewmodel.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => EmployeeViewModel(),
      child: EmployeeManagementApp(),
    ),
  );
}

class EmployeeManagementApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Employee Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),  // Splash Screen
        '/employeeList': (context) => EmployeeListPage(),
        '/addEmployee': (context) => AddEmployeePage(),
      },
    );
  }
}
