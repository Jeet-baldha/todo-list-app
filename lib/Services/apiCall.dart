import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Screens/models/todo.dart';

var headers = {
  'Content-Type': 'application/json',
  'Authorization':
      'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwNzAzMmU2YjA4NDMzNmRlMWQ1MTVhMmJhMTEyYmFkOCIsInN1YiI6IjY0ZDNlNDcwZGQ5MjZhMDFlOTg3YmQ1NSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.nf3OISp0W87cprwZXdkN-4hgY0-dHR7k4w6o_TokVbI'
};

class APICall {
  static addTask(int id, String task) async {
    var request = http.Request(
        'POST', Uri.parse('https://node-todo-api-yjo3.onrender.com/todos/'));
    request.body = json.encode({"id": id, "task": task});

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  static fechTasks() async {
    List<Todo> todo = [];

    http.Response response = await http
        .get(Uri.parse('https://node-todo-api-yjo3.onrender.com/todos/'));

    if (response.statusCode == 200) {
      print(await response.body.toString());
      todo = todoFromJson(response.body);
    } else {
      print(response.reasonPhrase);
    }
    return todo;
  }

  static updateTask(int id, bool completed) async {
    var headers = {'content-type': 'application/json'};
    var body = json.encode({"completed": completed});
    http.Response response = await http.put(
        Uri.parse('https://node-todo-api-yjo3.onrender.com/todos/$id'),
        body: body,
        headers: headers);

    if (response.statusCode == 200) {
      print(await response.body.toString());
    } else {
      print(response.reasonPhrase);
    }
  }

  static deleteTassk(int id) async {
    http.Response response = await http.delete(
      Uri.parse('https://node-todo-api-yjo3.onrender.com/todos/$id'),
    );

    if (response.statusCode == 200) {
      print(await response.body.toString());
    } else {
      print(response.reasonPhrase);
    }
  }
}
