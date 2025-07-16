class EmployeeDetails {
  final int id;
  final String employeeName;
  final String firstName;
  final String lastName;
  final String middleName;
  final String email;
  final String contactNumber;
  final String plNo;
  final int departmentId;
  final int designationId;
  final bool accessibility;
  final bool employeeStatus;
  final int role;
  final String createdDate;
  final String updateDate;
  final int status;

  EmployeeDetails({
    required this.id,
    required this.employeeName,
    required this.firstName,
    required this.lastName,
    required this.middleName,
    required this.email,
    required this.contactNumber,
    required this.plNo,
    required this.departmentId,
    required this.designationId,
    required this.accessibility,
    required this.employeeStatus,
    required this.role,
    required this.createdDate,
    required this.updateDate,
    required this.status,
  });

  // Factory method to create an instance from JSON
  factory EmployeeDetails.fromJson(Map<String, dynamic> json) {
    return EmployeeDetails(
      id: json["id"] ?? 0,
      employeeName: json["employee_name"] ?? "",
      firstName: json["first_name"] ?? "",
      lastName: json["last_name"] ?? "",
      middleName: json["middle_name"] ?? "",
      email: json["email"] ?? "",
      contactNumber: json["contact_number"] ?? "",
      plNo: json["pl_no"] ?? "",
      departmentId: json["department_id"] ?? 0,
      designationId: json["designation_id"] ?? 0,
      accessibility: json["accessibility"] ?? false,
      employeeStatus: json["employee_status"] ?? false,
      role: json["role"] ?? 0,
      createdDate: json["created_date"] ?? "",
      updateDate: json["update_date"] ?? "",
      status: json["status"] ?? 0,
    );
  }

  // Convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "employee_name": employeeName,
      "first_name": firstName,
      "last_name": lastName,
      "middle_name": middleName,
      "email": email,
      "contact_number": contactNumber,
      "pl_no": plNo,
      "department_id": departmentId,
      "designation_id": designationId,
      "accessibility": accessibility,
      "employee_status": employeeStatus,
      "role": role,
      "created_date": createdDate,
      "update_date": updateDate,
      "status": status,
    };
  }
}
