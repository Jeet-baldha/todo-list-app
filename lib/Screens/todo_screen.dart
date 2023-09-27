import 'package:flutter/material.dart';
import 'package:todo_app/Screens/models/todo.dart';
import 'package:todo_app/Services/apiCall.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  late List<Todo> todos;
  TextEditingController _taskController = TextEditingController();

  @override
  void initState() {
    todos = [];
    fetchAllTasks();
    super.initState();
  }

  fetchAllTasks() async {
    todos = await APICall.fechTasks();

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Total Task: ${todos.length}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Todo App'),
        ),
        body: Column(
          children: [
            //add todos
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _taskController,
                      decoration: InputDecoration(
                        labelText: 'Enter Task',
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      if (_taskController.text.isNotEmpty) {
                        // todos.add(Todo(DateTime.now().millisecondsSinceEpoch,
                        //     _taskController.text, false));
                        await APICall.addTask(
                            DateTime.now().millisecondsSinceEpoch,
                            _taskController.text);
                        _taskController.clear();
                        fetchAllTasks();
                      }

                      setState(() {});
                    },
                    icon: Icon(Icons.done),
                  ),
                ],
              ),
            ),
            //display todos
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  fetchAllTasks();
                },
                child: ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (context, index) => CheckboxListTile(
                    value: todos[index].completed,
                    onChanged: (v) async {
                      // todos[index].completed = v!;
                      await APICall.updateTask(todos[index].id!, v!);
                      fetchAllTasks();
                      setState(() {});
                    },
                    title: Text(todos[index].task ?? "",
                        style: todos[index].completed
                            ? TextStyle(
                                color: Colors.red,
                                decoration: TextDecoration.lineThrough)
                            : TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                    controlAffinity: ListTileControlAffinity.leading,
                    secondary: IconButton(
                        onPressed: () async {
                          await APICall.deleteTassk(todos[index].id!);
                          fetchAllTasks();
                          setState(() {});
                        },
                        icon: Icon(Icons.delete)),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
