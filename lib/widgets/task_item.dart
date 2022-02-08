import 'package:basic_todo_app/data/local_storage.dart';
import 'package:basic_todo_app/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/task_model.dart';

class TaskItem extends StatefulWidget {
  Task task;

  TaskItem({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  late LocalStorage _localStorage;

  @override
  void initState() {
    super.initState();
    _localStorage = locator<LocalStorage>();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 0),
          child: ExpansionTile(
            leading: GestureDetector(
              onTap: (() {
                _localStorage.updateTask(task: widget.task);
                setState(() {
                  widget.task.isCompleted = !widget.task.isCompleted;
                });
              }),
              child: Container(
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                ),
                decoration: BoxDecoration(
                    color:
                        widget.task.isCompleted ? Colors.green : Colors.white,
                    border: Border.all(color: Colors.grey, width: 0.8),
                    shape: BoxShape.circle),
              ),
            ),
            title: widget.task.isCompleted
                ? Text(
                    widget.task.name,
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  )
                : Text(
                    widget.task.name,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
            children: [
              Text(
                widget.task.detail,
                style: const TextStyle(
                    fontSize: 17, fontWeight: FontWeight.normal),
              )
            ],
            subtitle: Text(
              DateFormat('hh:mm a').format(widget.task.createdAt),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }
}
