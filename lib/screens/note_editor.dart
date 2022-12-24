import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notesapp/screens/fullimage.dart';
import 'package:notesapp/style/app_style.dart';

class NoteEditorScreen extends StatefulWidget {
  const NoteEditorScreen({Key? key}) : super(key: key);

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  bool isFile = false;
  String path = "";
  String id = "";
  int color_id = Random().nextInt(appstyle.cardsColor.length);
  String tdate = DateTime.now().toString();
  dynamic docid = 20;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _mainController = TextEditingController();
  String txt = "";
  String date = "";

  void initState() {
    super.initState();
    txt = "Add img";
    date = tdate.substring(0, 19);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appstyle.cardsColor[color_id],
      appBar: AppBar(
        backgroundColor: appstyle.cardsColor[color_id],
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Add a new Note",
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () async {
                FirebaseFirestore.instance.collection("Notes").add({
                  "note_title": _titleController.text,
                  "creation_date": date,
                  "note_content": _mainController.text,
                  "color_id": color_id,
                  "ipath": path,
                }).then((value) {
                  id = value.id;

                  Navigator.pop(context);
                }).catchError(
                    (error) => print("Failed to add new Node due to $error"));
              },
              child: const Icon(Icons.save),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (path != "") buildFileImage(),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: 'Note Title'),
                style: appstyle.mainTitle,
              ),
              const SizedBox(height: 8.0),
              Text(
                date,
                style: appstyle.dataTitle,
              ),
              const SizedBox(height: 28.0),
              TextField(
                controller: _mainController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: 'Note content'),
                style: appstyle.mainContent,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: appstyle.accentColor,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: ((builder) => bottomsheet()),
          );
        },
        icon: const Icon(Icons.image),
        label: Text(txt),
      ),
    );
  }

  Widget buildFileImage() {
    return Center(
      child: Stack(children: [
        CircleAvatar(
          radius: 120,
          child: ClipOval(
            child: Image.file(
              File(path),
              width: 240,
              height: 240,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: Padding(
              padding: EdgeInsets.all(5.0),
              child: IconButton(
                icon: Icon(Icons.zoom_in_rounded),
                color: Colors.black,
                padding: EdgeInsets.all(5.0),
                visualDensity: VisualDensity.adaptivePlatformDensity,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => fullimage(path)));
                },
              )),
        ),
      ]),
    );
  }

  Widget bottomsheet() {
    return Container(
      height: 125.0,
      width: MediaQuery.of(context).size.width,
      color: appstyle.cardsColor[color_id],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (path == "")
            FloatingActionButton.extended(
                label: Text("Camera"),
                onPressed: () async {
                  final pickfile =
                      await ImagePicker().pickImage(source: ImageSource.camera);
                  if (pickfile == null) {
                    Navigator.pop(context);
                    return;
                  } else {
                    setState(() {
                      path = pickfile.path;
                      txt = "Edit img";
                    });
                  }
                  Navigator.pop(context);
                },
                icon: Icon(Icons.camera),
                backgroundColor: Colors.black87),
          if (path == "")
            SizedBox(
              width: 69.0,
            ),
          if (path == "")
            FloatingActionButton.extended(
                label: Text("Gallery"),
                onPressed: () async {
                  final pickfile = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (pickfile == null) {
                    Navigator.pop(context);
                    return;
                  } else {
                    setState(() {
                      path = pickfile.path;
                      txt = "Edit img";
                    });
                  }
                  Navigator.pop(context);
                },
                icon: Icon(Icons.image_search_sharp),
                backgroundColor: Colors.black87),
          if (path != "")
            FloatingActionButton.extended(
                label: Text("delete"),
                onPressed: () {
                  setState(() {
                    path = "";
                    txt = "Add img";
                  });
                  Navigator.pop(context);
                },
                icon: Icon(Icons.delete),
                backgroundColor: Colors.black),
          if (path != "")
            SizedBox(
              width: 69.0,
            ),
          if (path != "")
            FloatingActionButton.extended(
                label: Text("replace"),
                onPressed: () async {
                  final pickfile = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (pickfile == null) {
                    Navigator.pop(context);
                    return;
                  } else {
                    setState(() {
                      path = pickfile.path;
                      txt = "Edit img";
                    });
                  }
                  Navigator.pop(context);
                },
                icon: Icon(Icons.image_search),
                backgroundColor: Colors.black87),
        ],
      ),
    );
  }
}
