class Event {
  final String? dateStart;
  final String? dateEnd;
  final String? time;
  final String? rehearsalTime;
  final String name;

  const Event(
      {this.dateStart,
      this.dateEnd,
      this.time,
      this.rehearsalTime,
      required this.name});

  Map<String, Object?> toMap() {
    return {
      'dateStart': dateStart,
      'dateEnd': dateEnd,
      'time': time,
      'rehearsalTime': rehearsalTime,
      'name': name
    };
  }

  factory Event.fromCsv(Map<dynamic, dynamic> dict) {
    return Event(
        dateStart: dict['date start'],
        dateEnd: dict['date end'],
        time: dict['time'],
        rehearsalTime: dict['rehearsal'],
        name: dict['name']);
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
}
