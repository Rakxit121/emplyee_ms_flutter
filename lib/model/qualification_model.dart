class Qualification {
  String id;
  String name;
  String organization;
  String certificateImage;
  String employeeId;

  Qualification({
    required this.id,
    required this.name,
    required this.organization,
    required this.certificateImage,
    required this.employeeId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'organization': organization,
      'certificate_image': certificateImage,
      'employee_id': employeeId,
    };
  }

  static Qualification fromMap(Map<String, dynamic> map) {
    return Qualification(
      id: map['id'],
      name: map['name'],
      organization: map['organization'],
      certificateImage: map['certificate_image'],
      employeeId: map['employee_id'],
    );
  }
}
