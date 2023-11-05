import 'dart:convert';

import 'package:quranschool/pages/Auth/Model/users.dart';

List<SubscriptionsPrice> parseSubscriptionsPricesfromjson(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed
      .map<SubscriptionsPrice>((json) => SubscriptionsPrice.fromJson(json))
      .toList();
}

List<SubscriptionsPrice> parseSubscriptionsPricesfromListofMap(
    List<Map<String, dynamic>> jsonList) {
  return jsonList
      .map<SubscriptionsPrice>((json) => SubscriptionsPrice.fromJson(json))
      .toList();
}

class SubscriptionsPrice {
  int? id;
  String? description;
  String? subscriptionName;
  String? price;
  int? sessionCount;

  SubscriptionsPrice({
    this.id,
    this.description,
    this.price,
    this.sessionCount,
    this.subscriptionName,
  });

  SubscriptionsPrice.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? -1;
    price = json['price'] ?? "";
    sessionCount = json['sessionCount'] ?? -1;
    subscriptionName = json["subscriptionName"] ?? "";
    description = json['description'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();

    data['id'] = id;
    data['price'] = price;
    data['sessionCount'] = sessionCount;
    data["subscriptionName"] = subscriptionName;
    data['description'] = description;

    return data;
  }
}
