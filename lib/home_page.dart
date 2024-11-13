

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:reorderablelistview_exam2/todo/todo.dart';
import 'package:uuid/uuid.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  TextEditingController titleTextController = TextEditingController();
  // List itemList = [];
  var uuid = Uuid();
  Box<Todo> todoBox = Hive.box<Todo>("todoBox");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('reorderable list view example'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ReorderableListView.builder(
              itemCount: todoBox.values.length,
              itemBuilder: (context, index) {
                return Column(
                  key: ValueKey(todoBox.values.toList()[index].id),
                  children: [
                    ListTile(
                      title: Text(todoBox.values.toList()[index].title),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              showDialog(context: context, builder: (context) {
                                return AlertDialog(
                                  title: const Text('edit todo'),
                                  content: TextField(
                                    controller: titleTextController,
                                    autofocus: true,
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          var copiedTodo = todoBox.values
                                              .toList()[index]
                                              .copyWith(
                                              title:
                                              titleTextController.text);
                                          todoBox.putAt(index, copiedTodo);
                                          titleTextController.clear();
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: const Text('edit'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                  ],
                                );
                              });
                            },
                            icon: Icon(Icons.edit),
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                  ],
                );
              },
              onReorder: (int oldIndex, int newIndex) {
                if (newIndex > oldIndex) {
                  newIndex -= 1;
                }

                // final item = itemList.removeAt(oldIndex);
                // itemList.insert(newIndex, item);

                final oldItem = todoBox.values.toList()[oldIndex];
                final newItem = todoBox.values.toList()[newIndex];
                print("old : ${oldItem.title}");
                print("new : ${newItem.title}");
                todoBox.putAt(newIndex, oldItem);
                todoBox.putAt(oldIndex, newItem);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Add Item'),
                content: TextField(
                  controller: titleTextController,
                  autofocus: true,
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        // itemList.add(titleTextController.text);
                        todoBox.add(Todo(id: uuid.v4(), title: titleTextController.text));
                        titleTextController.clear();
                      });
                      Navigator.pop(context);
                    },
                    child: const Text('Add'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}











