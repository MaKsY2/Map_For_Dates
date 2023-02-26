import 'dart:convert';
import 'package:adult_map/models/HttpResponsePerson.dart';
import 'package:http/http.dart' as http;
import 'package:multiple_result/multiple_result.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:adult_map/models/PersonToken.dart';
import 'package:adult_map/models/Person.dart';
import 'package:adult_map/models/Error.dart';
import 'package:adult_map/models/Placemark.dart';

const SERVER = 'http://127.0.0.1:8084';


Future<Placemarks> fetchPlacemarks (FlutterSecureStorage storage) async
{
  final response = await http.get(
      Uri.parse('$SERVER/placemarks/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-access-token': (await storage.read(key:"jwt"))!,
      });
  if (response.statusCode == 200) {
    return Placemarks.fromJson(jsonDecode(response.body));
  }
  else {
    throw Exception('Invalid request');
  }
}

Future<PersonToken> signInPerson (
    String phone,
    String password,
    )
async
{
  final response = await http.post(
    Uri.parse('$SERVER/login/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "phone": phone,
      "password": password,
    }),
  );

  if (response.statusCode == 201) {
    return PersonToken.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 400) {
    throw Exception('Invalid request');
  }
  else if (response.statusCode == 401) {
    throw Exception('User does not exist');
  }
  else if (response.statusCode == 403) {
    throw Exception('User is non active or password is wrong');
  }
  else {
    throw Exception('Failed to sign in');
  }
}

Future<HttpResponseUser> createPerson (
    String phone,
    String firstName,
    String password
    )
async
{
    final response = await http.post(
      Uri.parse('$SERVER/reg/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "phone": phone,
        "name": firstName,
        "password": password,
      }),
    );

    if (response.statusCode == 201) {
      return HttpResponseUser.fromJson(jsonDecode(response.body));
    } else {
      return HttpResponseUser.fromJson(jsonDecode(response.body));
    }
}