// To parse this JSON data, do
//
//     final searchWords = searchWordsFromJson(jsonString);

import 'dart:convert';

SearchWords searchWordsFromJson(String str) =>
    SearchWords.fromJson(json.decode(str));

String searchWordsToJson(SearchWords data) => json.encode(data.toJson());

class SearchWords {
  SearchWords({
    this.searchWord = "",
    this.from = 0,
    this.to = 1,
    this.accountType = "",
    this.nationality = "",
    this.gender = "",
    this.country = "",
    this.birthdayfrom = "",
    this.birthdayto = "",
    this.game = "",
  });

  String searchWord;
  int from;
  int to;
  String accountType;
  String nationality;
  String gender;
  String country;
  String birthdayfrom;
  String birthdayto;
  String game;

  factory SearchWords.fromJson(Map<String, dynamic> json) => SearchWords(
        searchWord: json["searchWord"] ?? "",
        from: json["from"] ?? 0,
        to: json["to"] ?? 0,
        accountType: json["accountType"] ?? "",
        nationality: json["nationality"] ?? "",
        gender: json["gender"] ?? "",
        country: json["country"] ?? "",
        birthdayfrom: json["birthdayfrom"] ?? "",
        birthdayto: json["birthdayto"] ?? "",
        game: json["game"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "searchWord": searchWord,
        "from": from,
        "to": to,
        "accountType": accountType,
        "nationality": nationality,
        "gender": gender,
        "country": country,
        "birthdayfrom": birthdayfrom,
        "birthdayto": birthdayto,
        "game": game,
      };
}
