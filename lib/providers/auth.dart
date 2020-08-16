import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryTime;
  String _userId;

  Future<void> authenticate(
      String email, String password, String urlSegment) async {
    try {
      final url =
          'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyDoWUPGOTvwWiA1BK5rfKG9KMjajgGV4eg';
      final response = await http.post(
        url,
        body: json.encode(
          {'email': email, 'password': password, 'returnSecureToken': true},
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        print(responseData['error']['message']);

        throw HttpException(responseData['error']['message']);
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUpUser(String email, String password) async {
    return authenticate(email, password, 'signUp');
  }

//
  Future<void> logInUser(String email, String password) async {
    return authenticate(email, password, 'signInWithPassword');
  }
}
