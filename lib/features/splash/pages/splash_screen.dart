import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:student_test/core/helpers/db_helper.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  TextEditingController titleController = TextEditingController();
  late Database? db;

  int dataTotal = 0;
  List<Map<String, dynamic>> tasks = [];

  bool isUpdate = false;
  String? updatedId;

  Future<void> listTasks() async {
    tasks = await db!.query('tasks', columns: ['id', 'title']);
    dataTotal = tasks.length;
    setState(() {});
  }

  Future<void> update() async {
    await db!.update(
      'tasks',
      {'title': titleController.text},
      where: 'id=?',
      whereArgs: [int.parse(updatedId ?? '0')],
    );
    listTasks();
    titleController.text = '';
    isUpdate = false;
    setState(() {});
  }

  Future<void> load() async {
    db = await DBHelper().db;
  }

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          TextFormField(
            controller: titleController,
          ),
          ElevatedButton(
            onPressed: () {
              if (isUpdate) {
                update();
              } else {
                db!.insert('tasks', {'title': titleController.text});
              }
              listTasks();
            },
            child: Text(isUpdate ? 'Update Task' : ' Add Task'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: dataTotal,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  onTap: () {
                    updatedId = tasks[index]['id'].toString();

                    isUpdate = true;
                    titleController.text = tasks[index]['title'];
                    setState(() {});
                  },
                  title:
                      Text('${tasks[index]['id']} - ${tasks[index]['title']}'),
                  trailing: IconButton(
                    onPressed: () {
                      db!.delete('tasks',
                          where: 'id=?', whereArgs: [tasks[index]['id']]);
                      listTasks();
                    },
                    icon: Icon(Icons.delete),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          listTasks();
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}
