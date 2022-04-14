extension DurationToString on Duration {
  String get toStringForPlayer {
    String time = toString();
    time = time.substring(0, time.indexOf('.'));
    time = time[0] == '0' ? time.substring(2) : time;
    time = time.substring(0, 2) == '00' ? time.substring(1) : time;
    return time;
  }
}
