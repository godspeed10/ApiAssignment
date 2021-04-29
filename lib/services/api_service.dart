import 'package:assign_project/models/login_response.dart';
import 'package:assign_project/models/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'api.config.dart' as config;

class ApiService {
  final Dio _client = Dio(BaseOptions(baseUrl: config.BASE_URL));

  Future<LoginResponse> login(
      {@required String email, @required String password}) async {
    final response = await _client.post(config.LOGIN_EP, data: {
      "email": email,
      "password": password,
    });
    return LoginResponse.fromJson(response.data);
  }

  Future<void> addUser({@required String name, @required String job}) =>
      _client.post(config.ADD_USER_EP, data: {
        "name": name,
        "job": job,
      });

  Future<void> deleteUser(String userId) =>
      _client.delete('${config.DELETE_USERS_EP}/$userId');

  Future<List<User>> listUsers({int page = 0}) async {
    final response = await _client.get('${config.GET_USERS_EP}?page=$page');
    return (response.data["data"] as List)
        .map<User>((json) => User.fromJson(json))
        .toList(growable: false);
  }
}
