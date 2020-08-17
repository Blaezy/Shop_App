import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryTime;
  String _userId;
  Timer authTimer;

  bool get isAuth {
    return token != null;
  }

  String get userId {
    return _userId;
  }

  String get token {
    if (_expiryTime != null &&
        _expiryTime.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }

    return null;
  }

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
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryTime = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'expiryDate': _expiryTime.toIso8601String(),
        'userId': _userId
      });
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUpUser(String email, String password) async {
    return authenticate(email, password, 'signUp');
  }

  Future<bool> autoLoginUser() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("userData")) {
      return false;
    }
    final extractedData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedData['token'];
    _userId = extractedData['userId'];
    _expiryTime = expiryDate;
    notifyListeners();
    autoLogout(); //to set the timers again
    return true;
  }

//
  Future<void> logInUser(String email, String password) async {
    return authenticate(email, password, 'signInWithPassword');
  }

  Future<void> logout() async {
    _userId = null;
    _token = null;
    _expiryTime = null;
    if (authTimer != null) {
      authTimer.cancel();
      authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void autoLogout() {
    if (authTimer != null) {
      authTimer.cancel();
    }
    final timeToExpiry = _expiryTime.difference(DateTime.now()).inSeconds;
    Timer(Duration(seconds: timeToExpiry), logout);
  }
}
