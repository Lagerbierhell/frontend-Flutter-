import 'package:flutter/material.dart';
import '../api/api_service.dart';
import '../models/task.dart';

class TaskPage extends StatefulWidget {
  final ApiService apiService;

  TaskPage({required this.apiService});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  List<Task> tasks = [];
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  void fetchTasks() async {
    try {
      tasks = await widget.apiService.getTasks();
      setState(() {});
    } catch (e) {
      print("Fehler beim Laden der Tasks: $e");
    }
  }

  void addTask(String description) async {
    if (description.isEmpty) return;
    try {
      Task task = Task(description: description);
      Task newTask = await widget.apiService.createTask(task);
      setState(() {
        tasks.add(newTask);
        controller.clear();
      });
    } catch (e) {
      print("Fehler beim Erstellen: $e");
    }
  }

  void deleteTask(Task task) async {
    try {
      await widget.apiService.deleteTask(task.id!);
      setState(() {
        tasks.remove(task);
      });
    } catch (e) {
      print("Fehler beim Löschen: $e");
    }
  }

  void toggleDone(Task task) async {
    try {
      Task updated = await widget.apiService.toggleTaskDone(task.id!);
      setState(() {
        task.done = updated.done;
      });
    } catch (e) {
      print("Fehler beim Markieren als erledigt: $e");
    }
  }

  void showEditDialog(Task task) {
    final editController = TextEditingController(text: task.description);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Task'),
          content: TextField(controller: editController),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                String newName = editController.text.trim();
                if (newName.isNotEmpty) {
                  Task updated = await widget.apiService
                      .updateTaskDescription(task.id!, newName);
                  setState(() {
                    task.description = updated.description;
                  });
                }
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Task Tracker")),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    // Input row
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: controller,
                              decoration: InputDecoration(
                                hintText: 'Enter task',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () => addTask(controller.text),
                            child: const Text("Add"),
                          ),
                        ],
                      ),
                    ),
                    // Task list
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return ListTile(
                          title: GestureDetector(
                            onTap: () => showEditDialog(task),
                            child: Text(task.description),
                          ),
                          leading: Checkbox(
                            value: task.done,
                            onChanged: (value) => toggleDone(task),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => deleteTask(task),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
