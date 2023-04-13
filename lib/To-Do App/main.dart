import 'package:flutter/material.dart';

import 'NoteList.dart';

void main()
{
  runApp(const MyTodoAPP());
}

class MyTodoAPP extends StatelessWidget {
  const MyTodoAPP({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "NoteKeeper",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.deepPurple
      ),
      home: const NoteList(),
    );
  }
}
