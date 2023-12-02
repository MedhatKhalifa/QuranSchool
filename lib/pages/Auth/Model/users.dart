// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

// List<Product> productFromJson(String str) =>
//     List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

// String productToJson(List<Product> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

/*
{
  "id": 1,
  "firstName": "Ahmed2",
  "lastName": "Sayed",
  "phoneNumber": "+201009606610",
  "email": "ahmed@yahoo.com",
  "gender": "male",
  "birthYear": 1987,
  "city": "cairo",
  "country": "egypt",
  "userType": "student"
} 
*/

class User {
  User({
    this.id = -1,
    this.firstName = "",
    this.lastName = "",
    this.phoneNumber = "",
    this.email = "",
    this.gender = "male",
    this.birthYear = -1,
    this.city = "",
    this.country = "",
    this.nationality = "",
    this.userType = "",
    this.accountToken = "",
    this.token = "",
    this.password = "",
    this.fullName = "",
    this.username = "",
    this.image = "",
    this.enabledit = true,
    this.imagechanged = false,
    this.updateOld = false,
  });

  int id;
  String firstName;
  String lastName;
  String phoneNumber;
  String email;
  String gender;
  int birthYear;
  String city;
  String country;
  String userType;
  String accountToken;
  String token;
  String password;
  String fullName;
  String username;
  String nationality;
  bool enabledit;
  String image;
  bool imagechanged;
  bool updateOld;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"] ?? -1,
        firstName: json["firstName"] ?? "",
        email: json["email"] ?? "",
        phoneNumber: json["phoneNumber"] ?? "",
        lastName: json["lastName"] ?? "",
        gender: json["gender"] ?? "",
        birthYear: json["birthYear"] ?? -1,
        city: json["city"] ?? "",
        country: json["country"] ?? "",
        userType: json["userType"] ?? "",
        accountToken: json["accountToken"] ?? "",
        token: json["token"] ?? "",
        password: json["password"] ?? "",
        fullName: json["fullName"] ?? "",
        username: json["username"] ?? "",
        nationality: json["nationality"] ?? "",
        image: json["image"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "email": email,
        "phoneNumber": phoneNumber,
        "lastName": lastName,
        "gender": gender,
        "city": city,
        "country": country,
        "userType": userType,
        "birthYear": birthYear,
        "accountToken": accountToken,
        "token": token,
        "password": password,
        "fullName": fullName,
        "username": username,
        'nationality': nationality,
      };
}
