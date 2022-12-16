class OurTimeLeft {
  List<String> timeLeft(DateTime due) {
    List<String> retVal = ["",""];

    Duration _timeUntilDue = due.difference(DateTime.now());

    int _daysUntil = _timeUntilDue.inDays;
    int _hoursUntil = _timeUntilDue.inHours - (_daysUntil * 24);
    int _minUntil = _timeUntilDue.inMinutes - (_daysUntil * 24 * 60) - (_hoursUntil * 60);
    int _secUntil = _timeUntilDue.inSeconds - (_daysUntil * 24 * 60 * 60) - (_hoursUntil * 60 * 60) - (_minUntil * 60);

    if (_daysUntil > 0) {
      retVal[0] = _daysUntil.toString() + " d\n" + _hoursUntil.toString() + " h\n"
          + _minUntil.toString() + " m\n" + _secUntil.toString() + " s";

    } else if (_hoursUntil > 0) {
      retVal[0] = _hoursUntil.toString() + " h\n"
          + _minUntil.toString() + " m\n" + _secUntil.toString() + " s";
    } else if (_minUntil > 0) {
      retVal[0] = _minUntil.toString() + " m\n" + _secUntil.toString() + " s";
    } else if (_secUntil > 0) {
      retVal[0] = _secUntil.toString() + " s";
    } else if (_secUntil == 0) {
      retVal[0] = "almost there ";
    } else {
      retVal[0] = "error";
    }

    Duration _timeUntilReveal = due.subtract(Duration(days: 3)).difference(DateTime.now());
    int _daysUntilReveal = _timeUntilReveal.inDays;
    int _hoursUntilReveal = _timeUntilReveal.inHours
        - (_daysUntilReveal * 24);
    int _minUntilReveal = _timeUntilReveal.inMinutes
        - (_daysUntilReveal * 24 * 60)
        - (_hoursUntilReveal * 60);
    int _secUntilReveal = _timeUntilReveal.inSeconds
        - (_daysUntilReveal * 24 * 60 * 60)
        - (_hoursUntilReveal * 60 * 60)
        - (_minUntilReveal * 60);

    if (_daysUntilReveal > 0) {
      retVal[1] = _daysUntilReveal.toString() + " d\n" + _hoursUntilReveal.toString() + " h\n"
          + _minUntilReveal.toString() + " m\n" + _secUntilReveal.toString() + " s";
    } else if (_hoursUntilReveal > 0) {
      retVal[1] = _hoursUntilReveal.toString() + " h\n"
          + _minUntilReveal.toString() + " m\n" + _secUntilReveal.toString() + " s";
    } else if (_minUntilReveal > 0) {
      retVal[1] = _minUntilReveal.toString() + " m\n" + _secUntilReveal.toString() + " s";
    } else if (_secUntilReveal > 0) {
      retVal[1] = _secUntilReveal.toString() + " s";
    } else if (_secUntilReveal == 0) {
      retVal[1] = "almost there ";
    } else {
      retVal[1] = "error";
    }

    return retVal;
  }
}