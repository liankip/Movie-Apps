import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:movie/models/movie.dart';

final String baseUrl = 'http://localhost/db_api/index.php';

Future<List<Movie>> getMovie(http.Client client) async {
  final response = await http.Client().get("$baseUrl");
  return compute(parseData, response.body);
}

List<Movie> parseData(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  List<Movie> list = parsed.map<Movie>((json) => Movie.fromJson(json)).toList();
  return list;
}

Future<bool> addMovie(body) async {
  final response = await http.Client().post("$baseUrl", body: body);
  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

Future<bool> updateRate(id) async {
  final response = await http.Client().patch("$baseUrl?id=$id");
  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}
