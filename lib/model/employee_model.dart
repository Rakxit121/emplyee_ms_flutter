class Employee {
  final String id;
  final String name;
  final String gender;
  final String phone;
  final String address;
  final String profilePic; // Change from profile_pic to profilePic
  final int level;
  final double salary;
  final String status;
  final List<String> qualifications; // Assuming qualifications is a list

  Employee({
    required this.id,
    required this.name,
    required this.gender,
    required this.phone,
    required this.address,
    required this.profilePic, // Ensure this matches the constructor
    required this.level,
    required this.salary,
    required this.status,
    required this.qualifications, // Ensure this matches the constructor
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'gender': gender,
      'phone': phone,
      'address': address,
      'profile_pic': profilePic,
      'level': level,
      'salary': salary,
      'status': status,
    };
  }

  static Employee fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['id'],
      name: map['name'],
      gender: map['gender'],
      phone: map['phone'],
      address: map['address'],
      profilePic: map['profile_pic'],
      level: map['level'],
      salary: map['salary'],
      status: map['status'],
      qualifications: [],
    );
  }
}
