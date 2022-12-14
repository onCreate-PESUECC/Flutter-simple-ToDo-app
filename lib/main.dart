import 'package:flutter/material.dart';
import 'item_class.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TodoList(),
    );
  }
}

class TodoList extends StatefulWidget {
  const TodoList({
    Key? key,
  }) : super(key: key);

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final List<Todo> _todos = <Todo>[
    Todo(
        name: "Do laundry",
        description: "Your clothes stink",
        status: false,
        priority: 1),
    Todo(
        name: "Clean your room",
        description: "Your room also stinks",
        status: false,
        priority: 2),
    Todo(
        name: "Take a bath",
        description: "You stink",
        status: false,
        priority: 3)
  ];

  final TextEditingController _taskName = TextEditingController();
  final TextEditingController _taskDescription = TextEditingController();
  final TextEditingController _taskPriority = TextEditingController();

  void _handleChange(Todo todo) {
    setState(() {
      todo.status = !todo.status;
    });
  }

  void _handleDeletion(Todo todo) {
    setState(() {
      _todos.removeWhere((Todo item) => item.name == todo.name);
    });
  }

  void _addItem(String name, String desc, String priority) {
    setState(() {
      _todos.add(Todo(
          name: name,
          description: desc,
          priority: int.parse(priority),
          status: false));
      _todos.sort((a, b) {
        return a.priority.compareTo(b.priority);
      });
    });
    _taskName.clear();
    _taskDescription.clear();
    _taskPriority.clear();
  }

  Future<void> _displayDialog() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Add a new task"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _taskName,
                  decoration: const InputDecoration(hintText: 'Title'),
                ),
                TextField(
                  controller: _taskDescription,
                  decoration: const InputDecoration(hintText: 'Description'),
                ),
                TextField(
                  controller: _taskPriority,
                  decoration: const InputDecoration(hintText: 'Priority'),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _addItem(_taskName.text, _taskDescription.text,
                        _taskPriority.text);
                  },
                  child: const Text('Add'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: ListView(
        children: _todos.map((Todo todo) {
          return TodoElement(
            task: todo,
            onTodoChanged: _handleChange,
            onTodoDelete: _handleDeletion,
          );
        }).toList(),
        // children: const [
        //   ListTile(title: Text("Task 1"),),
        //   ListTile(title: Text("Task 2"),),
        //   ListTile(title: Text("Task 3"),),
        // ]
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TodoElement extends StatelessWidget {
  const TodoElement({
    Key? key,
    required this.task,
    required this.onTodoChanged,
    required this.onTodoDelete,
  }) : super(key: key);

  final Todo task;
  final onTodoChanged;
  final onTodoDelete;

  TextStyle? _getTextStyle(bool checked) {
    if (!checked) return null;

    return const TextStyle(
      color: Colors.black54,
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        task.name,
        style: _getTextStyle(task.status),
      ),
      subtitle: Text(
        task.description,
        style: _getTextStyle(task.status),
      ),
      leading: CircleAvatar(
        child: Text(task.priority.toString()),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
          onTodoDelete(task);
        },
      ),
      onTap: () {
        onTodoChanged(task);
      },
    );
  }
}
