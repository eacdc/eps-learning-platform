import 'package:intl/intl.dart';

String? formatDateTimeString(String? isoDateString) {
  if (isoDateString == null || isoDateString.isEmpty) return null;
  try {
    final dateTime = DateTime.parse(isoDateString).toLocal(); // Convert to local time
    final dateFormat = DateFormat("d MMMM h:mm a"); // Example: 28 July 5:56 PM
    return dateFormat.format(dateTime);
  } catch (e) {
    return null; // Return null if parsing fails
  }
}