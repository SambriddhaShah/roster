import 'package:intl/intl.dart';

/// Pure helper. Safe parse -> 'yyyy MMM dd' fallback.
/// Same behavior as your current function; just reusable.
String formatInterviewDateUtil(String dateTimeStr,
    {String pattern = 'yyyy MMM dd'}) {
  try {
    final dateTime = DateTime.parse(dateTimeStr);
    return DateFormat(pattern).format(dateTime);
  } catch (_) {
    return dateTimeStr;
  }
}
