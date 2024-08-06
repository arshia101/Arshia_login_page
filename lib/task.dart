class Task {
  final int? id;
  final String name;

  Task({this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  String toString() {
    return 'Task{id: $id, name: $name}';
  }
}
