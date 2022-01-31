import 'dart:convert';
import 'dart:io';

import 'package:commerceapp/constant.dart';
import 'package:commerceapp/models/api_response.dart';
import 'package:http/http.dart' as http;
import 'package:commerceapp/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<ApiResponse> login(String email, String password) async {
  ApiResponse apiresponse = ApiResponse();
  try {
    final response = await http.post(Uri.parse(loginURL),
        headers: {'Accept': 'Application/json'},
        body: {'email': email, 'password': password});
    switch (response.statusCode) {
      case 200:
        apiresponse.data = User.fromJson(jsonDecode(response.body));
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiresponse.error = errors[errors.keys.elementAt(0)](0);
        break;
      case 403:
        apiresponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiresponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiresponse.error = serverError;
  }

  return apiresponse;
}

Future<ApiResponse> register(
    String email, String password, String name, String tel) async {
  ApiResponse apiresponse = ApiResponse();
  try {
    final response = await http.post(Uri.parse(registerURL), headers: {
      'Accept': 'Application/json'
    }, body: {
      'name': name,
      'email': email,
      'tel': tel,
      'password': password,
      'password_confirmation': password
    });
    switch (response.statusCode) {
      case 200:
        apiresponse.data = User.fromJson(jsonDecode(response.body));
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiresponse.error = errors[errors.keys.elementAt(0)](0);
        break;
      case 403:
        apiresponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiresponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiresponse.error = serverError;
  }

  return apiresponse;
}

Future<ApiResponse> getUserDetail() async {
  ApiResponse apiresponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(
      Uri.parse(userURL),
      headers: {'Accept': 'Application/json', 'Authorization': 'Bearer $token'},
    );
    switch (response.statusCode) {
      case 200:
        apiresponse.data = User.fromJson(jsonDecode(response.body));
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiresponse.error = errors[errors.keys.elementAt(0)](0);
        break;
      case 403:
        apiresponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiresponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiresponse.error = serverError;
  }

  return apiresponse;
}

//get token
Future<String> getToken() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('token') ?? '';
}

//get user id

Future<int> getUserId() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getInt('userId') ?? 0;
}

Future<bool> logout() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return await pref.remove('token');
}

String? getStringImage(File? file) {
  if (file == null) return null;
  return base64Encode(file.readAsBytesSync());
}
