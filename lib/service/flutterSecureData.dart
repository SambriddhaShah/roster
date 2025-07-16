import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FlutterSecureData {
  static const _storage = FlutterSecureStorage();

  // static const String contentId = "1";
  static const String useName = "userName";
  static const String password = "password";
  static const String checked = "isChecked";
  static const String isLoggedIn = 'isLoggedIn';
  static const String isCheckdIn = 'isCheckdIn';
  static const String userData = 'userData';
  static const String doneTask = 'doneTask';
  static const String toDoTask = 'todoTask';
  static const String notesTasks = 'noteTasks';
  static const String isHired = "isHired";
  static const accessToken = 'accessToken';
  static const refreshToken = 'refreshToken';
  static const String candidateId = 'candidateId';
  static const String candidateJobId = "candidateJobId";

  //set get and delete the access token
  static Future<void> setAccessToken(String accessToken) {
    return _storage.write(
        key: FlutterSecureData.accessToken, value: accessToken);
  }

  static Future<String?> getAccessToken() {
    return _storage.read(key: FlutterSecureData.accessToken);
  }

  static Future<void> deleteAccessToken() {
    return _storage.delete(key: FlutterSecureData.accessToken);
  }

  //set get and delete the refresh token
  static Future<void> setRefreshToken(String refreshToken) {
    return _storage.write(
        key: FlutterSecureData.refreshToken, value: refreshToken);
  }

  static Future<String?> getRefreshToken() {
    return _storage.read(key: FlutterSecureData.refreshToken);
  }

  static Future<void> deleteRefreshToken() {
    return _storage.delete(key: FlutterSecureData.refreshToken);
  }

// set get and delete candidteJobId

  static Future<void> setCandidateJobId(String refreshToken) {
    return _storage.write(
        key: FlutterSecureData.candidateJobId, value: refreshToken);
  }

  static Future<String?> getCandidateJobId() {
    return _storage.read(key: FlutterSecureData.candidateJobId);
  }

  static Future<void> deleteCandidateJobId() {
    return _storage.delete(key: FlutterSecureData.candidateJobId);
  }

  //set get and delete the candidateId
  static Future<void> setCandidateId(String candidateId) {
    return _storage.write(
        key: FlutterSecureData.candidateId, value: candidateId);
  }

  static Future<String?> getCandidateId() {
    return _storage.read(key: FlutterSecureData.candidateId);
  }

  static Future<void> deleteCandidateId() {
    return _storage.delete(key: FlutterSecureData.candidateId);
  }

  // set get and delete the username
  static Future<void> setTodo(String data) {
    return _storage.write(key: toDoTask, value: data);
  }

  static Future<String?> getTodo() {
    return _storage.read(key: toDoTask);
  }

  static Future<void> deleteTodo() {
    return _storage.delete(key: toDoTask);
  }

  // set get and delete the username
  static Future<void> setUserData(String userDataa) {
    return _storage.write(key: userData, value: userDataa);
  }

  static Future<String?> getUserData() {
    return _storage.read(key: userData);
  }

  static Future<void> deleteUserData() {
    return _storage.delete(key: userData);
  }

  static Future<void> setTasks(String tasks) {
    return _storage.write(key: notesTasks, value: tasks);
  }

  static Future<String?> getTasks() {
    return _storage.read(key: notesTasks);
  }

  static Future<void> deleteTasks() {
    return _storage.delete(key: notesTasks);
  }

  // set get and delete the username
  static Future<void> setDoneTask(String userDataa) {
    return _storage.write(key: doneTask, value: userDataa);
  }

  static Future<String?> getDoneTask() {
    return _storage.read(key: doneTask);
  }

  static Future<void> deleteDoneTask() {
    return _storage.delete(key: doneTask);
  }

  //set get and delete isHired
  static Future<void> setIsHired(bool isHired) {
    return _storage.write(
        key: FlutterSecureData.isHired, value: isHired.toString());
  }

  static Future<String> getIsHired() async {
    String? value = await _storage.read(key: FlutterSecureData.isHired);
    return value == 'true' ? "true" : "false";
  }

  static Future<void> deleteIsHired() {
    return _storage.delete(key: FlutterSecureData.isHired);
  }

  // set get and delete the username
  static Future<void> setUserName(String usename) {
    return _storage.write(key: useName, value: usename);
  }

  static Future<String?> getUserName() {
    return _storage.read(key: useName);
  }

  static Future<void> deleteUserName() {
    return _storage.delete(key: useName);
  }

  // set get and delete the password

  static Future<void> setPassword(String passWord) {
    return _storage.write(key: password, value: passWord);
  }

  static Future<String?> getPassword() {
    return _storage.read(key: password);
  }

  static Future<void> deletePassword() {
    return _storage.delete(key: password);
  }

  // set get and delete remember me

  static Future<void> setRememberMe(bool isChecked) {
    return _storage.write(key: checked, value: isChecked.toString());
  }

  static Future<String?> getRememberMe() {
    return _storage.read(key: checked);
  }

  static Future<void> deleteRememberMe() {
    return _storage.delete(key: checked);
  }

  // set get and delete the is logged in boolean
  static Future<void> setIsLoggedIn(String isLogged) {
    return _storage.write(key: isLoggedIn, value: isLogged);
  }

  static Future<String?> getIsLoggedIn() {
    return _storage.read(key: isLoggedIn);
  }

  static Future<void> deleteIsLoggedIn() {
    return _storage.delete(key: isLoggedIn);
  }

  // set get and delete the isCheckdIn
  static Future<void> setisCheckdIn(String isCheckdIn) {
    return _storage.write(key: isCheckdIn, value: isCheckdIn);
  }

  static Future<String?> getisCheckdIn() {
    return _storage.read(key: isCheckdIn);
  }

  static Future<void> deleteisCheckdIn() {
    return _storage.delete(key: isCheckdIn);
  }

  // delete all the secureStorage information\
  static Future<void> deleteWholeSecureData() {
    return _storage.deleteAll();
  }
}
