class RideListItem {
  String imageUri;
  String name;
  DateTime lastSeen;
  bool isAvailable;
  String despription = "E-wing, Kendriya Sadan, Santhopura...";
  RideListItem(this.imageUri, this.name, this.lastSeen,
      {this.isAvailable = false});
}

String timeAgo(DateTime d) {
  Duration diff = DateTime.now().difference(d);
  if (diff.inDays > 365)
    return "${(diff.inDays / 365).floor()}${(diff.inDays / 365).floor() == 1 ? "y" : "y"} ago";
  if (diff.inDays > 30)
    return "${(diff.inDays / 30).floor()}${(diff.inDays / 30).floor() == 1 ? "M" : "M"} ago";
  if (diff.inDays > 7)
    return "${(diff.inDays / 7).floor()}${(diff.inDays / 7).floor() == 1 ? "w" : "w"} ago";
  if (diff.inDays > 0)
    return "${diff.inDays}${diff.inDays == 1 ? "d" : "d"} ago";
  if (diff.inHours > 0)
    return "${diff.inHours}${diff.inHours == 1 ? "h" : "h"} ago";
  if (diff.inMinutes > 0)
    return "${diff.inMinutes}${diff.inMinutes == 1 ? "min" : "min"} ago";
  return "just now";
}
