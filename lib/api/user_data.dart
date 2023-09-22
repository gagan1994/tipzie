class UserProfile {
  String? userId;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? bio;
  String? email;
  String? imageUri;
  String? firebaseUid;
/*
*  "_id": "649e80a17f729edf3809f3f2",
        "FirstName": "punith",
        "SurName": "degavi",
        "phone": 999999999,
        "__v": 0
* */
  UserProfile({this.userId, this.firstName, this.lastName, this.phoneNumber});
/*
{
        'first_name': fName,
        'last_name': lName,
        'phone': phoneNumber,
        'bio': bio,
        'email': email,
        'image_uri': imageUri,
        'firebase_uid': uid,
        'firebase_login_token': idToken
      }
* */
  UserProfile.fromJson(Map<String, dynamic> json) {
    userId = json['_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    phoneNumber = json['phone'];
    bio = json['bio'];
    email = json['email'];
    imageUri = json['image_uri'];
    firebaseUid = json['firebase_uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.userId;
    data['FirstName'] = this.firstName;
    data['SurName'] = this.lastName;
    data['phone'] = this.phoneNumber;
    data['bio'] = this.bio;
    data['email'] = this.email;
    data['image_uri'] = this.imageUri;
    data['firebase_uid'] = this.firebaseUid;
    return data;
  }

  @override
  String toString() {
    return "$firstName $lastName $phoneNumber";
  }
}
