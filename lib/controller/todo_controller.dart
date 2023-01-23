import 'package:flutter_application_dio/model/todo.dart';
import 'package:flutter_application_dio/repository/repository.dart';

class TodoController {
  final Repository _repository;
  TodoController(this._repository);

  Future<List<Todo>> fetchListTodo() async {
    return _repository.getTodoList();
  }

  Future updatePatchCompleted(Todo todo) async {
    return _repository.patchCompleted(todo);
  }

  Future updatePutCompleted(Todo todo) async {
    return _repository.putCompleted(todo);
  }

  Future deleteTodo(Todo todo) async {
    return _repository.deleteTodo(todo);
  }

  Future postTodo(Todo todo) async {
    return _repository.postTodo(todo);
  }
}
