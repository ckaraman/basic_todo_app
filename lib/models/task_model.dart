import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
part 'task_model.g.dart';

@HiveType(typeId: 1)
class Task extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  final String detail;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  bool isCompleted;

  Task(
      {required this.id,
      required this.name,
      required this.detail,
      required this.createdAt,
      required this.isCompleted});

  factory Task.create({
    required String name,
    required String detail,
    required DateTime createdAt,
  }) {
    return Task(
      id: const Uuid().v1(),
      name: name,
      detail: detail,
      createdAt: createdAt,
      isCompleted: false,
    );
  }
}
