import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token = null;
  DateTime? _expiryDate;
  String? _userId;
  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyBATaz1O7Mfjsy-0bCRU75SI-Swyd_e4CY');
    try {
      print("started try");
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        print(responseData['error']['message']);
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      notifyListeners();
    } catch (error) {
      print("error");
      throw error;
    }
  }

  Future<void> singup(String? email, String? password) async {
    if (email != null && password != null) {
      String urlSegment = 'signUp';
      return _authenticate(email, password, urlSegment);
    }
  }

  Future<void> singin(String? email, String? password) async {
    if (email != null && password != null) {
      String urlSegment = 'signInWithPassword';
      return _authenticate(email, password, urlSegment);
    }
  }
}
