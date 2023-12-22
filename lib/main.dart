import 'package:flutter/material.dart';

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo App',
      home: TodoList(),
    );
  }
}

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<TodoTask> todos = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime selectedStartDate = DateTime.now();
  DateTime selectedDueDate = DateTime.now().add(Duration(days: 1));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        title: Text('Todo List', style: TextStyle( color: Colors.white,fontWeight: FontWeight.w900),),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                return _buildTaskItem(todos[index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                  ),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Start Date: ${selectedStartDate.toLocal()}'.split(' ')[0]),
                          ElevatedButton(
                            onPressed: () => _selectStartDate(context),
                            child: Text('Select Start Date'),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Due Date: ${selectedDueDate.toLocal()}'.split(' ')[0]),
                          ElevatedButton(
                            onPressed: () => _selectDueDate(context),
                            child: Text('Select Due Date'),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 18.00,
                          )
                          ,ElevatedButton(
                            onPressed: () {
                              _addTodo();
                            },
                            child: Text('Add Todo'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(TodoTask task) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(10),
      child: ListTile(
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.completed ? TextDecoration.lineThrough : TextDecoration.none,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.description),
            Text(
              'Due Date: ${task.formattedDueDate}',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                _editTodoDialog(task);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _deleteTodoDialog(task);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _addTodo() {
    String title = titleController.text.trim();
    String description = descriptionController.text.trim();
    if (title.isNotEmpty) {
      TodoTask newTask = TodoTask(
        title: title,
        description: description,
        startDate: selectedStartDate,
        dueDate: selectedDueDate,
      );

      setState(() {
        todos.add(newTask);
        titleController.clear();
        descriptionController.clear();
        selectedStartDate = DateTime.now();
        selectedDueDate = DateTime.now().add(Duration(days: 1));
      });
    }
  }

  void _editTodoDialog(TodoTask task) {
    titleController.text = task.title;
    descriptionController.text = task.description;
    selectedStartDate = task.startDate;
    selectedDueDate = task.dueDate;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Task'),
          content: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Start Date: ${selectedStartDate.toLocal()}'.split(' ')[0]),
                      ElevatedButton(
                        onPressed: () => _selectStartDate(context),
                        child: Text('Select Start Date'),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Due Date: ${selectedDueDate.toLocal()}'.split(' ')[0]),
                        ElevatedButton(
                          onPressed: () => _selectDueDate(context),
                          child: Text('Select Due Date'),
                        ),
                        SizedBox(
                          width: 10.00,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _updateTodo(task);
                Navigator.of(context).pop();
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _updateTodo(TodoTask task) {
    setState(() {
      task.title = titleController.text.trim();
      task.description = descriptionController.text.trim();
      task.startDate = selectedStartDate;
      task.dueDate = selectedDueDate;
    });
  }

  void _deleteTodoDialog(TodoTask task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Task'),
          content: Text('Are you sure you want to delete this task?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteTodo(task);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _deleteTodo(TodoTask task) {
    setState(() {
      todos.remove(task);
    });
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedStartDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedStartDate) {
      setState(() {
        selectedStartDate = picked;
      });
    }
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDueDate) {
      setState(() {
        selectedDueDate = picked;
      });
    }
  }
}

class TodoTask {
  String title;
  String description;
  DateTime startDate;
  DateTime dueDate;
  bool completed;

  TodoTask({
    required this.title,
    required this.description,
    required this.startDate,
    required this.dueDate,
    this.completed = false,
  });

  String get formattedStartDate {
    return "${startDate.day}/${startDate.month}/${startDate.year}";
  }

  String get formattedDueDate {
    return "${dueDate.day}/${dueDate.month}/${dueDate.year}";
  }
}
