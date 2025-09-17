class FundraisingEvent {
  final String date;
  final String organiser;
  final String time;
  final String? tickets;
  final String? ticketLink;
  final String location;
  final String event;

  const FundraisingEvent({
    required this.date,
    required this.organiser,
    required this.time,
    this.tickets,
    this.ticketLink,
    required this.location,
    required this.event,
  });

  Map<String, Object?> toMap() {
    return {
      'date': date,
      'organiser': organiser,
      'time': time,
      'tickets': tickets,
      'ticketLink': ticketLink,
      'event': event,
    };
  }

  factory FundraisingEvent.fromCsv(Map<dynamic, dynamic> dict) {
    return FundraisingEvent(
      date: dict['date'],
      organiser: dict['organiser'],
      time: dict['time'],
      tickets: dict['tickets'],
      ticketLink: dict['ticket link'],
      location: dict['location'],
      event: dict['event'],
    );
  }

  String getdateLength(String? date) {
    if (date == null || date == '' || date.length != 10) {
      return '3000-13';
    }
    return date.substring(0, 7);
  }

  static String formatTime(String time) {
    return time.substring(0, 5);
  }

  static String getYear(String date) {
    return date.substring(0, 4);
  }

  String formatDate() {
    return date.toUpperCase();
  }
}
