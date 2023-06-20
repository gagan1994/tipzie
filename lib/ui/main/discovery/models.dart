class DiscoveryListItem {
  String imageUri;
  String destinationName;
  String destinationLocation;
  double rating;
  DiscoveryListItem(this.imageUri, this.destinationName,
      this.destinationLocation, this.rating);
}

List<DiscoveryListItem> getDiscoveryItems() {
  return [
    DiscoveryListItem(
        "https://www.timeoutdubai.com/cloud/timeoutdubai/2022/11/15/time-out-market-nye-2.png",
        "Burj Khalifa",
        "United Arab Emirates",
        5),
    DiscoveryListItem(
        "https://media.cntraveler.com/photos/53e2dd87dddaa35c30f61223/16:9/w_2560,c_limit/chicago-millenium-park-sculpture.jpg",
        "Millennium Park",
        "Chicago,USA",
        2.5),
    DiscoveryListItem(
        "https://upload.wikimedia.org/wikipedia/commons/thumb/e/eb/Machu_Picchu%2C_Peru.jpg/1200px-Machu_Picchu%2C_Peru.jpg",
        "Machu Picchu",
        "Peru",
        5),
    DiscoveryListItem(
        "https://img.freepik.com/premium-photo/view-manhattan-sunset-new-york-city_268835-463.jpg?w=2000",
        "Manhattan",
        "New York",
        5),
    DiscoveryListItem(
        "https://assets.traveltriangle.com/blog/wp-content/uploads/2020/01/Seychelles.jpg",
        "Seychelles",
        "East Africa",
        5),
    DiscoveryListItem(
        "https://assets.traveltriangle.com/blog/wp-content/uploads/2020/01/Mexico_9th-jun.jpg",
        "Mexico",
        "North America",
        5),
    DiscoveryListItem(
        "https://assets.traveltriangle.com/blog/wp-content/uploads/2018/11/France.jpg",
        "French Riviera",
        "France",
        5),
    DiscoveryListItem(
        "https://assets.traveltriangle.com/blog/wp-content/uploads/2018/11/Spain.jpg",
        "Barcelona",
        "Spain",
        5),
  ];
}
