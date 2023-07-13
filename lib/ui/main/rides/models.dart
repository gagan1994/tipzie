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

List<RideListItem> getRideList() {
  return [
    RideListItem(
        'https://images.indianexpress.com/2019/01/leh-ladakh-getty-images-759.jpg',
        "Leh ladakh",
        DateTime.now(),
        isAvailable: true),
    RideListItem(
        'https://www.nationsonline.org/gallery/India/Tea-Gardens-Munnar-Kerala-India.jpg',
        "Kerala",
        DateTime.now().add(Duration(days: -10))),
    RideListItem(
        'https://static.toiimg.com/thumb/93105946/rajasthan.jpg?width=1200&height=900',
        "Rajasthan",
        DateTime.now().add(Duration(hours: -10))),
    RideListItem(
        'https://static.toiimg.com/thumb/93105946/rajasthan.jpg?width=1200&height=900',
        "Ride Name",
        DateTime.now().add(Duration(days: -366, hours: -10))),
  ];
}
