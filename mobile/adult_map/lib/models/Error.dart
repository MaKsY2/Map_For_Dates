import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HttpError {
  String? error;

  HttpError({this.error});

  HttpError.fromJson(Map<String, dynamic> json) {
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['error'] = error;
    return data;
  }
}
