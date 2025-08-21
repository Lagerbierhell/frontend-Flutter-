import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import '../models/task.dart';

class ApiService {
  final String baseUrl;

  ApiService()
      : baseUrl = kIsWeb
            ? 'http://localhost:4200'
            : Platform.isAndroid
                ? 'http://10.0.2.2:4200' // Android emulator
                : 'http://localhost:4200'; //broweser

  // GET all tasks
  Future<List<Task>> getTasks() async {
    final response = await http.get(Uri.parse('$baseUrl/tasks'));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => Task.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  // POST
  Future<Task> createTask(Task task) async {
    final response = await http.post(
      Uri.parse('$baseUrl/tasks'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'description': task.description}),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Task.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create task');
    }
  }

  // DELETE
  Future<void> deleteTask(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/tasks/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete task');
    }
  }

  // PATCH
  Future<Task> toggleTaskDone(int id) async {
    final response = await http.patch(Uri.parse('$baseUrl/tasks/$id/done'));
    if (response.statusCode == 200) {
      return Task.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to toggle task done');
    }
  }

  // PUT
  Future<Task> updateTaskDescription(int id, String newDescription) async {
    final response = await http.put(
      Uri.parse(
          '$baseUrl/tasks/$id/description?new_description=$newDescription'),
    );
    if (response.statusCode == 200) {
      return Task.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update description');
    }
  }
}
