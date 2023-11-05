import 'package:flutter/material.dart';
import 'package:get/get.dart';

mySnackbar(title, message, type) {
  if (type == false) {
    return Get.snackbar(title, message,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.grey,
        colorText: Colors.red);
  }

  return Get.snackbar(title, message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.grey,
      colorText: Colors.white);
}
