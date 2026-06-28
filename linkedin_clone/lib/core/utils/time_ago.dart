String timeAgo(DateTime postedDate) {
  final duration = DateTime.now().difference(postedDate);
  if (duration.inDays > 30) {
    return "${(duration.inDays / 30).floor()} months ago";
  }
  if (duration.inDays > 7) {
    return "${(duration.inDays / 7).floor()} weeks ago";
  }
  if (duration.inDays > 0) return "${duration.inDays} days ago";
  if (duration.inHours > 0) return "${duration.inHours} hours ago";
  return "Just now";
}
