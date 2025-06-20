

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:learn_flutter/data/models/user_model.dart';

abstract class IUserRepository{
    Future<List<UserModel>> fetchUsers();
}

class UserRepositoryImpl implements IUserRepository {
  final String baseUrl;

  UserRepositoryImpl({
    this.baseUrl = 'https://jsonplaceholder.typicode.com'
  });

  @override
  Future<List<UserModel>> fetchUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/users'),
        headers: {
          'Content-Type': 'application/json',
        },
    );

    if(response.statusCode == 200){
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => UserModel.fromJson(json)).toList();
    }else{
      throw Exception("Failed to load users");
    }
  }

}