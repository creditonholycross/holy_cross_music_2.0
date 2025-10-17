class FundraisingEvent {
  final String? date;
  final String organiser;
  final String time;
  final String? tickets;
  final String? ticketLink;
  final String location;
  final String event;
  final String? day;

  const FundraisingEvent({
    this.date,
    required this.organiser,
    required this.time,
    this.tickets,
    this.ticketLink,
    required this.location,
    required this.event,
    this.day,
  });

  Map<String, Object?> toMap() {
    return {
      'date': date,
      'organiser': organiser,
      'time': time,
      'tickets': tickets,
      'ticketLink': ticketLink,
      'event': event,
      'day': 'day',
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
      day: dict['day'],
    );
  }

  static bool isWeekDay(String? date) {
    return [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday',
    ].contains(date?.toLowerCase());
  }

  String getdateLength(String? date, String? day) {
    if (isWeekDay(day)) {
      return '0000-00';
    }
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
    return date!.toUpperCase();
  }
}
