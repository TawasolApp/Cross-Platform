import 'package:intl/intl.dart';

String formatTime(String connectionDate) {
  if (DateTime.tryParse(connectionDate) == null) {
    return 'Unknown';
  }
  DateTime date = DateTime.parse(connectionDate);
  if (date.isAfter(DateTime.now())) {
    return connectionDate;
  }
  Duration difference = DateTime.now().difference(date);
  if (difference.inSeconds < 60) {
    return '${difference.inSeconds} seconds ago';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes} minutes ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours} hours ago';
  } else if (difference.inDays < 7) {
    return '${difference.inDays} days ago';
  } else if (difference.inDays < 30) {
    return '${(difference.inDays / 7).floor()} weeks ago';
  } else if (difference.inDays < 365) {
    return '${(difference.inDays / 30).floor()} months ago';
  } else {
    return '${(difference.inDays / 365).floor()} years ago';
  }
}

String returnDateAfterDays(int days) {
  DateTime now = DateTime.now();
  DateTime futureDate = now.add(Duration(days: days));
  return '${futureDate.day} ${DateFormat.MMMM().format(futureDate)} ${futureDate.year}';
}
