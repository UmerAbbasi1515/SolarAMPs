// ignore_for_file: file_names

class CustomerSupportInboxModal {
  String ticketNumber, title, message, priority, duration;
  bool isRead, isOpened;

  CustomerSupportInboxModal(
      {required this.ticketNumber,
      required this.title,
      required this.message,
      required this.priority,
      required this.duration,
      required this.isRead,
      required this.isOpened});
}
