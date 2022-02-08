// ignore_for_file: prefer_const_constructors

import 'package:basic_todo_app/data/local_storage.dart';
import 'package:basic_todo_app/main.dart';
import 'package:basic_todo_app/models/task_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import '../widgets/task_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Task> _allTasks;
  TextEditingController name = TextEditingController();
  TextEditingController detail = TextEditingController();
  late LocalStorage _localStorage;

  @override
  void initState() {
    super.initState();
    _allTasks = <Task>[];
    _localStorage = locator<LocalStorage>();
    _getAllTaskFromDb();
  }

  @override
  void dispose() {
    super.dispose();
    name;
    detail;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Yapılacak Bir Şey Ekle',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
            ),
          ),
          IconButton(
              onPressed: () {
                _showAddTaskBottomSheet(context);
              },
              icon: const Icon(
                Icons.add,
              ))
        ],
      ),
      body: _allTasks.isNotEmpty
          ? ListView.builder(
              itemCount: _allTasks.length,
              itemBuilder: (context, index) {
                var currentIndex = _allTasks[index];
                return Dismissible(
                  background: Row(
                    children: const [
                      Icon(
                        Icons.delete,
                        color: Colors.grey,
                      )
                    ],
                  ),
                  key: Key(currentIndex.id),
                  onDismissed: (direction) {
                    _localStorage.deletedTask(task: currentIndex);
                    setState(() {
                      _allTasks.removeAt(index);
                    });
                  },
                  child: TaskItem(
                    task: currentIndex,
                  ),
                );
              },
            )
          : Center(
              child: Text(
                ' Görev Oluştur!',
                style: TextStyle(fontSize: 30),
              ),
            ),
    );
  }

  void _showAddTaskBottomSheet(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Form(
              key: _formKey,
              child: SizedBox(
                height: 300,
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: _buildInterestText(
                          name, 'Eklemek İstediğiniz Notu Girin'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: _buildInterestText(detail, 'Detay Giriniz.'),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                      child: MaterialButton(
                        child: Text('Ekle'),
                        color: Color(0xFFB9182A),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        onPressed: () {
                          if (name.value.text.length > 3) {
                            DatePicker.showTimePicker(context,
                                showSecondsColumn: false,
                                onConfirm: (time) async {
                              var newAddTask = Task.create(
                                  name: name.value.text,
                                  detail: detail.value.text,
                                  createdAt: time);

                              _allTasks.insert(0, newAddTask);
                              await _localStorage.addTask(task: newAddTask);
                              setState(() {
                                Navigator.of(context).pop();
                              });
                              _formKey.currentState?.reset();
                            });
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  TextFormField _buildInterestText(
    TextEditingController controller,
    String hintText,
  ) {
    return TextFormField(
      controller: controller,
      validator: (value) =>
          value!.isEmpty ? 'Bu alanı boş geçemezsiniz.' : null,
      style: TextStyle(fontSize: 18),
      keyboardType: TextInputType.multiline,
      decoration: inputDecoration(hintText),
    );
  }

  InputDecoration inputDecoration(String hintText) {
    return InputDecoration(
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.amber),
      ),
      focusedBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
      hintText: hintText,
    );
  }

  void _getAllTaskFromDb() async {
    _allTasks = await _localStorage.getAllTask();
    setState(() {});
  }
}
