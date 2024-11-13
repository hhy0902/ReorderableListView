

import 'package:hive_flutter/adapters.dart';

part 'todo.g.dart';

@HiveType(typeId: 0)
class Todo {

  @HiveField(0)
  var id;

  @HiveField(1)
  String title;

  Todo({
    required this.id,
    required this.title,
  });


  Todo copyWith({
    var id,
    String? title,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
    );
  }
}







