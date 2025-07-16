
class BookList {
  final String id;
  final String title;
  final String publisher;
  final String subject;
  final String language;
  final String grade;
  final String bookCoverImgLink;
  final String createdAt;
  final String updatedAt;
  final String bookId;
  bool subscribed; // 🔑 New field (mutable)

  BookList({
    required this.id,
    required this.title,
    required this.publisher,
    required this.subject,
    required this.language,
    required this.grade,
    required this.bookCoverImgLink,
    required this.createdAt,
    required this.updatedAt,
    required this.bookId,
    this.subscribed = false, // 🔑 Default false
  });

  factory BookList.fromJson(Map<String, dynamic> json) {
    return BookList(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      publisher: json['publisher'] ?? '',
      subject: json['subject'] ?? '',
      language: json['language'] ?? '',
      grade: json['grade'] ?? '',
      bookCoverImgLink: json['bookCoverImgLink'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      bookId: json['bookId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'publisher': publisher,
      'subject': subject,
      'language': language,
      'grade': grade,
      'bookCoverImgLink': bookCoverImgLink,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'bookId': bookId,
      'subscribed': subscribed,
    };
  }

  static List<BookList> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => BookList.fromJson(json)).toList();
  }
}










class IncidentFormResponse {
  final String message;
  final int status;
  final int totalItems;
  final int totalPages;
  final int currentPage;
  final int pageSize;
  final List<Incident> data;

  IncidentFormResponse({
    required this.message,
    required this.status,
    required this.totalItems,
    required this.totalPages,
    required this.currentPage,
    required this.pageSize,
    required this.data,
  });

  factory IncidentFormResponse.fromJson(Map<String, dynamic> json) {
    return IncidentFormResponse(
      message: json['message'] ?? '',
      status: json['status'] ?? 0,
      totalItems: json['total_items'] ?? 0,
      totalPages: json['total_pages'] ?? 0,
      currentPage: json['current_page'] ?? 0,
      pageSize: json['page_size'] ?? 0,
      data: (json['data'] as List<dynamic>)
          .map((e) => Incident.fromJson(e))
          .toList(),
    );
  }
}

class Incident {
  final int id;
  final String incidentNumber;
  final String eventLoggedDate;
  final String eventLoggedTime;
  final String shift;
  final String eventOccurrenceDate;
  final String eventOccurrenceTime;
  final int departmentId;
  final String departmentName;
  final String departmentHead;
  final String eventDescription;
  final String severity;
  final String? nearmissCause;
  final String employeeName;
  final String employeeEmail;
  final String contactNumber;
  final String plNo;
  final String eventLocation;
  final List<String> uploadPhoto;
  final String createdDate;
  final String updateDate;
  final int status;

  Incident({
    required this.id,
    required this.incidentNumber,
    required this.eventLoggedDate,
    required this.eventLoggedTime,
    required this.shift,
    required this.eventOccurrenceDate,
    required this.eventOccurrenceTime,
    required this.departmentId,
    required this.departmentName,
    required this.departmentHead,
    required this.eventDescription,
    required this.severity,
    required this.employeeName,
    required this.employeeEmail,
    required this.contactNumber,
    required this.plNo,
    required this.eventLocation,
    required this.uploadPhoto,
    required this.createdDate,
    required this.updateDate,
    required this.status,
    this.nearmissCause,
  });

  factory Incident.fromJson(Map<String, dynamic> json) {
    return Incident(
      id: json['id'] ?? 0,
      incidentNumber: json['incident_number'] ?? '',
      eventLoggedDate: json['event_logged_date'] ?? '',
      eventLoggedTime: json['event_logged_time'] ?? '',
      shift: json['shift'] ?? '',
      eventOccurrenceDate: json['event_occurence_date'] ?? '',
      eventOccurrenceTime: json['event_occurence_time'] ?? '',
      departmentId: json['department_id'] ?? 0,
      departmentName: json['department_name'] ?? '',
      departmentHead: json['department_head'] ?? '',
      eventDescription: json['event_description'] ?? '',
      severity: json['severity'] ?? '',
      employeeName: json['employee_name'] ?? '',
      employeeEmail: json['employee_email'] ?? '',
      contactNumber: json['contact_number'] ?? '',
      plNo: json['pl_no'] ?? '',
      eventLocation: json['event_location'] ?? '',
      uploadPhoto: (json['upload_photo'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      createdDate: json['created_date'] ?? '',
      updateDate: json['update_date'] ?? '',
      status: json['status'] ?? 0,
      nearmissCause: json['nearmiss_cause'],
    );
  }
}
