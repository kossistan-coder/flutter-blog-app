import 'dart:convert';

import 'package:commerceapp/constant.dart';
import 'package:commerceapp/models/api_response.dart';
import 'package:commerceapp/models/post.dart';
import 'package:commerceapp/models/user.dart';
import 'package:commerceapp/services/user_service.dart';
import 'package:http/http.dart' as http;

Future<ApiResponse> getPosts() async {
  ApiResponse apiresponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse(postsURL), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    switch (response.statusCode) {
      case 200:
        apiresponse.data = jsonDecode(response.body)['posts']
            .map((p) => Post.fromJson(p))
            .toList();
        apiresponse.data as List<dynamic>;
        break;
      case 401:
        apiresponse.error = unauthorized;
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

Future<ApiResponse> createPost(String body, String? image) async {
  ApiResponse apiresponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.post(Uri.parse(postsURL),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: image != null ? {'body': body, 'image': image} : {'body': body});
    switch (response.statusCode) {
      case 200:
        apiresponse.data = jsonDecode(response.body);
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiresponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 401:
        apiresponse.error = unauthorized;
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

Future<ApiResponse> editPost(int postId, String body) async {
  ApiResponse apiresponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.put(Uri.parse('$postsURL/$postId'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    }, body: {
      'body': body,
    });
    switch (response.statusCode) {
      case 200:
        apiresponse.data = jsonDecode(response.body)['message'];
        break;
      case 403:
        apiresponse.data = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiresponse.error = unauthorized;
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

Future<ApiResponse> deletePost(int postId) async {
  ApiResponse apiresponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.delete(Uri.parse('$postsURL/$postId'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    switch (response.statusCode) {
      case 200:
        apiresponse.data = jsonDecode(response.body)['message'];
        break;
      case 403:
        apiresponse.data = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiresponse.error = unauthorized;
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
