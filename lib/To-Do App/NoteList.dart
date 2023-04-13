import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

import 'NoteListDetail.dart';
import 'models/database_helper.dart';
import 'models/note.dart';

class NoteList extends StatefulWidget {
  const NoteList({Key? key}) : super(key: key);

  @override
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  DatabaseHelper databaseHelper = DatabaseHelper();

  List<Note>? noteList;

  //NoteDetail nt = NoteDetail(note, appBarTitle);
  int count=0;

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = <Note>[];
      updateListView();
    }
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        title: const Text("Notes"),
      ),
      body: Notes(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToDetail(Note(1,'',''), "Add Note");
        },
        elevation: 2.0,
        tooltip: "Add Note",
        child: const Icon(Icons.add),
      ),
    );
  }

  ListView Notes() {
    //TextStyle textStyle = Theme.of(context).textTheme as TextStyle;

    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          return Card(
              color: Colors.white,
              elevation: 2.0,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor:
                      getPriorityColor(noteList![position].priority),
                  child: getPriorityIcon(noteList![position].priority),
                ),
                title: Text(noteList![position].description),
                subtitle: Text(noteList![position].date),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.grey),
                  onPressed: () {
                    _delete(context, noteList![position]);
                  },
                ),
                onTap: () {
                  navigateToDetail(noteList![position], "Edit Note");
                },
              ));
        });
  }

  //Returns the priority color
  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.yellow;
      default:
        return Colors.yellow;
    }
  }

  //Return Priority Icon
  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return const Icon(Icons.play_arrow_rounded);
      case 2:
        return const Icon(Icons.arrow_forward_ios);
      default:
        return const Icon(Icons.arrow_forward_ios);
    }
  }

  void _delete(BuildContext context, Note note) async {
    int result = await databaseHelper.deleteNote(note.id);
    if (result != 0) {
      _showSnackBar(context, "Note Deleted Successfully");
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    //Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(Note note, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetail(note, title);
    }));
    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          count = noteList.length;
        });
      });
    });
  }
}
