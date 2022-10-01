class UserModel {
  String? uid;
  String? firstName;
  String? secondName;
  String? email;
  String? phonenumber;
  String? dateofbirth;

  UserModel({
    this.uid,
    this.email,
    this.firstName,
    this.secondName,
    this.phonenumber,
    this.dateofbirth,
  });

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      firstName: map['firstName'],
      secondName: map['secondName'],
      email: map['email'],
      phonenumber: map['phonenumber'],
      dateofbirth: map['dateofbirth'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'firstName': firstName,
      'secondName': secondName,
      'email': email,
      'phonenumber': phonenumber,
      'dateofbirth': dateofbirth,
    };
  }
}
