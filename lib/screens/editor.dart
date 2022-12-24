import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notesapp/screens/fullimage.dart';
import 'package:notesapp/style/app_style.dart';

class editer extends StatefulWidget {
  final QueryDocumentSnapshot doc;
  const editer(this.doc, {Key? key}) : super(key: key);
  @override
  State<editer> createState() => _editerState();
}

class _editerState extends State<editer> {
  TextEditingController titleController = TextEditingController();
  TextEditingController mainController = TextEditingController();
  String paths = "";
  String txt = "";

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.doc['note_title']);
    mainController = TextEditingController(text: widget.doc['note_content']);
    paths = widget.doc['ipath'];
    if (paths == "")
      txt = "Add img";
    else
      txt = "Edit img";
  }

  Widget build(BuildContext context) {
    int color_id = widget.doc['color_id'];

    return Scaffold(
      backgroundColor: appstyle.cardsColor[color_id],
      appBar: AppBar(
        backgroundColor: appstyle.cardsColor[color_id],
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Edit Note",
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () async {
                widget.doc.reference.update({
                  "note_title": titleController.text,
                  "note_content": mainController.text,
                  "ipath": paths,
                }).then((value) {
                  Navigator.pop(context);
                }).catchError(
                    (error) => print("Failed to update Node due to $error"));
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
              if (paths != "") buildFileImage(),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: 'Note Title'),
                style: appstyle.mainTitle,
              ),
              const SizedBox(height: 8.0),
              Text(
                widget.doc['creation_date'],
                style: appstyle.dataTitle,
              ),
              const SizedBox(height: 28.0),
              TextField(
                controller: mainController,
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
              File(paths),
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
                color: Colors.white,
                padding: EdgeInsets.all(5.0),
                visualDensity: VisualDensity.adaptivePlatformDensity,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              fullimage(widget.doc['ipath'])));
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
      color: appstyle.cardsColor[widget.doc['color_id']],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (paths != "")
            FloatingActionButton.extended(
                label: Text("delete"),
                onPressed: () {
                  setState(() {
                    paths = "";
                    txt = "Add img";
                  });
                  Navigator.pop(context);
                },
                icon: Icon(Icons.delete),
                backgroundColor: Colors.black87),
          if (paths != "")
            SizedBox(
              width: 69.0,
            ),
          if (paths != "")
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
                      paths = pickfile.path;
                      txt = "Edit img";
                    });
                  }
                  Navigator.pop(context);
                },
                icon: Icon(Icons.image_search),
                backgroundColor: Colors.black87),
          if (paths == "")
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
                      paths = pickfile.path;
                      txt = "Edit img";
                    });
                  }
                  Navigator.pop(context);
                },
                icon: Icon(Icons.camera),
                backgroundColor: Colors.black87),
          if (paths == "")
            SizedBox(
              width: 69.0,
            ),
          if (paths == "")
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
                      paths = pickfile.path;
                      txt = "Edit img";
                    });
                  }
                  Navigator.pop(context);
                },
                icon: Icon(Icons.image_search_sharp),
                backgroundColor: Colors.black87),
        ],
      ),
    );
  }
}
