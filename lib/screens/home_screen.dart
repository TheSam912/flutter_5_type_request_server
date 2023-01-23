import 'package:flutter/material.dart';
import 'package:flutter_application_dio/controller/todo_controller.dart';
import 'package:flutter_application_dio/model/todo.dart';
import 'package:flutter_application_dio/repository/todo_repository.dart';

class MyHomeScreen extends StatelessWidget {
  const MyHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var todoController = TodoController(TodoRepository());
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        title: Text(
          'Todo',
          style: TextStyle(color: Colors.grey.shade900),
        ),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Todo todo = Todo(3, 'sample post', false);
                todoController.postTodo(todo);
              },
              icon: Icon(
                Icons.add,
                color: Colors.grey.shade900,
              ))
        ],
      ),
      body: FutureBuilder<List<Todo>>(
        future: todoController.fetchListTodo(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Error !'),
            );
          }
          return bodyContent(snapshot, todoController);
        }),
      ),
    );
  }

  SafeArea bodyContent(
      AsyncSnapshot<List<Todo>> snapshot, TodoController todoController) {
    return SafeArea(
      child: ListView.separated(
        itemBuilder: (context, index) {
          var todo = snapshot.data?[index];
          return Container(
            height: 100,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text('${todo?.id}'),
                ),
                Expanded(flex: 3, child: Text('${todo?.title}')),
                Expanded(
                    flex: 3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                            onTap: () {
                              todoController
                                  .updatePatchCompleted(todo!)
                                  .then((value) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        duration:
                                            const Duration(milliseconds: 1000),
                                        content: Text("$value")));
                              });
                            },
                            child: buildContainer('patch', Colors.amber)),
                        InkWell(
                            onTap: () {
                              todoController.updatePutCompleted(todo!);
                            },
                            child: buildContainer('put', Colors.purple)),
                        InkWell(
                            onTap: () {
                              todoController.deleteTodo(todo!).then((value) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        duration:
                                            const Duration(milliseconds: 1000),
                                        content: Text("$value")));
                              });
                            },
                            child: buildContainer('Del', Colors.red)),
                      ],
                    ))
              ],
            ),
          );
        },
        separatorBuilder: (context, index) {
          return const Divider(
            thickness: 0.5,
            height: 0.5,
          );
        },
        itemCount: snapshot.data?.length ?? 0,
      ),
    );
  }

  Container buildContainer(String title, Color color) {
    return Container(
      width: 40,
      height: 40,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(8), color: color),
      child: Center(
        child: Text(
          title,
          style: TextStyle(fontSize: 10, color: Colors.grey.shade100),
        ),
      ),
    );
  }
}
