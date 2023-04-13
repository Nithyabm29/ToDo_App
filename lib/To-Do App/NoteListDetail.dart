import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'models/database_helper.dart';
import 'models/note.dart';


class NoteDetail extends StatefulWidget {
  final String appBarTitle;
  final Note note;

  const NoteDetail(this.note, this.appBarTitle);

  //const NoteDetail({Key? key}) : super(key: key);

  @override
  State<NoteDetail> createState() => _NoteDetailState(note, appBarTitle);
}

class _NoteDetailState extends State<NoteDetail> {
  String appBarTitle;
  Note note;

  _NoteDetailState(this.note, this.appBarTitle);

  DatabaseHelper databaseHelper = DatabaseHelper();
  var pri = ["High", "Low"];

  //var dropDownValue = "High";

  TextEditingController titleCon = TextEditingController();
  TextEditingController desCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    titleCon.text = note.title;
    desCon.text = note.description;
    //TextStyle textStyle = Theme.of(context).textTheme as TextStyle;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              moveToLastPage();
            },
            icon: const Icon(Icons.arrow_back)),
        title: Text(appBarTitle),
      ),
      body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: [
              ListTile(
                title: DropdownButton(
                    items: pri.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                          value: value, child: Text(value));
                    }).toList(),
                    value: getPriorityAsString(note.priority),
                    onChanged: (String? selectedValue) {
                      setState(() {
                        //dropDownValue = selectedValue!;
                        updatePriorityAsInt(selectedValue!);
                      });
                    }),
              ),

              Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: TextField(
                    controller: titleCon,
                    onChanged: (value) {
                      updateTitle();
                    },
                    decoration: InputDecoration(
                        labelText: "Title",
                        hintText: "Enter the title",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  )),
              Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: TextField(
                    controller: desCon,
                    onChanged: (value) {
                      updateDescription();
                    },
                    decoration: InputDecoration(
                        labelText: "Description",
                        hintText: "Enter the Description",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  )),
              Row(
                children: [
                  Expanded(
                      child: ElevatedButton(
                        child: const Text("Save"),
                        onPressed: () {
                          _save();
                        },
                      )),
                  Container(width: 5.0),
                  Expanded(
                      child: ElevatedButton(
                        child: const Text("Delete"),
                        onPressed: () {
                          _delete();
                        },
                      )),
                ],
              )
            ],
          )),
    );
  }

  void moveToLastPage() {
    Navigator.pop(context, true);
  }

  //Convert the string priority to int before saving to database
  void updatePriorityAsInt(String value) {
    switch (value) {
      case 'High':
        note.priority = 1;
        break;
      case 'Low':
        note.priority = 2;
        break;
    }
  }

  //Convert the int priority to String before displaying to user
  String getPriorityAsString(int value) {
    String priority = 'Low';
    switch (value) {
      case 1:
        priority = pri[0];
        break;
      case 2:
        priority = pri[1];
        break;
    }
    return priority;
  }

  //Update the title to note
  void updateTitle() {
    note.title = titleCon.text;
  }

  //update the desc to note object
  void updateDescription() {
    note.description = desCon.text;
  }

  //Save data to database
  void _save() async {
    moveToLastPage();
    note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (note.id != 0) {
      result = (await databaseHelper.updateNote(note));
      debugPrint("Updated");
    } else {
      result = (await databaseHelper.insertNote(note));
      debugPrint("Inserted");
    }
    if (result != 0) {
      _showAlertDialog('status', 'Note saved Successfully');
    } else {
      _showAlertDialog('status', "Don't have any Note to save");
    }
  }

  //Delete data from database
  void _delete() async {
    moveToLastPage();
    if (note.id == 0) {
      _showAlertDialog('status', 'Error Occurred while deleting a Note');
      return;
    }
    int result = await databaseHelper.deleteNote(note.id);
    if (result != 0) {
      _showAlertDialog('status', 'Note Deleted Successfully');
    }
    else {
      _showAlertDialog('status', 'Error Occurred while deleting a Note');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }
}
