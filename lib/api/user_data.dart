class UserProfile {
  String? userId;
  String? firstName;
  String? surName;
  dynamic? phone;
/*
*  "_id": "649e80a17f729edf3809f3f2",
        "FirstName": "punith",
        "SurName": "degavi",
        "phone": 999999999,
        "__v": 0
* */
  UserProfile({this.userId, this.firstName, this.surName, this.phone});

  UserProfile.fromJson(Map<String, dynamic> json) {
    userId = json['_id'];
    firstName = json['FirstName'];
    surName = json['SurName'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.userId;
    data['FirstName'] = this.firstName;
    data['SurName'] = this.surName;
    data['phone'] = this.phone;
    return data;
  }

  @override
  String toString() {
    return "$firstName $surName $phone";
  }
}
