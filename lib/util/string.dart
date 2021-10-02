import 'package:intl/intl.dart';

String? dateString(DateTime? dateTime) {
  if (dateTime == null) {
    return null;
  }

  final DateFormat formatter = DateFormat('yyyy年MM月dd日');
  return formatter.format(dateTime);
}

String? dateStringWithWeek(DateTime? dateTime) {
  if (dateTime == null) {
    return null;
  }

  final weekString = toWeek(dateTime.weekday);

  final DateFormat formatter = DateFormat('yyyy年MM月dd日($weekString)');
  return formatter.format(dateTime);
}

String toWeek(int weekday) {
  switch (weekday) {
    case 1:
      return '月';
    case 2:
      return '火';
    case 3:
      return '水';
    case 4:
      return '木';
    case 5:
      return '金';
    case 6:
      return '土';
    case 7:
      return '日';
  }

  return '';
}
