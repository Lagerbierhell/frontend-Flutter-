class Task {
  int? id;
  String description;
  bool done;

  Task({this.id, required this.description, this.done = false});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      description: json['description'],
      done: json['done'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'done': done,
    };
  }
}
