import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes/repository/notesrepository.dart';
import 'package:notes/utils/utils.dart';

import '../models/note.dart';


class AddNoteScreen extends StatefulWidget {
  Note? note;
  AddNoteScreen({this.note, super.key});
  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.note.toString());
    if(widget.note!=null){
      _titleController.text=widget.note!.title;
      _contentController.text=widget.note!.content;
      _selectedColor=Color(widget.note!.color);
    }

  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                NoteRepository noteRepository=NoteRepository();
                await  noteRepository.deleteNote(widget.note!.id);
                Navigator.pop(context);
                Navigator.pop(context,1);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }


  final _titleController = TextEditingController();

  final _contentController = TextEditingController();

  // Define available color options
  final List<Color> _colorOptions = [
    Colors.white,
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.teal,
    Colors.indigo,
    Colors.brown,
  ];

  // Track the selected color
  Color _selectedColor = Colors.white; // Set an initial selected color (you can choose any default color)

  void _selectColor() {
    showModalBottomSheet<Color>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _colorOptions.map((color) {
                final isSelected = _selectedColor == color;

                return InkWell(
                  onTap: () {
                    Navigator.pop(context, color); // Pass the selected color back to the parent context
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        margin: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.black ,
                            width: isSelected ?  2.0:0.1,
                          ),
                        ),
                        child: isSelected
                            ? Icon(
                          Icons.check,
                          color: Colors.black,
                        )
                            : null,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    ).then((selectedColor) {
      if (selectedColor != null) {
        if(mounted) {
          setState(() {
            _selectedColor =
                selectedColor; // Update the state in the parent widget
          });
        }
      }
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _selectedColor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(onPressed: () {
                  if(_titleController.text!='' || _contentController.text!=''){
                    print(widget.note.toString());
                  if(widget.note==null)
                  {
                    NoteRepository noteRepository=NoteRepository();
                    Note note=Note(id: '', title: _titleController.text, content: _contentController.text, color: _selectedColor.value,uploadedby: FirebaseAuth.instance.currentUser!.email);
                    noteRepository.addNote(note);
                    print('insert');
                  }
                  else
                  {
                    NoteRepository noteRepository=NoteRepository();
                    Note note=Note(id: widget.note!.id, title: _titleController.text, content: _contentController.text, color: _selectedColor.value,uploadedby: FirebaseAuth.instance.currentUser!.email);
                    noteRepository.updateNote(widget.note!.id,note);
                    print('update');
                  }
                  }
Navigator.pop(context,1);
                }, icon: Icon(Icons.arrow_back)),
                Row(
                  children: [

                    IconButton(onPressed: _selectColor
                    ,icon: Icon(Icons.color_lens_outlined),),
                    IconButton(onPressed: () {
                      showModalBottomSheet<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: Icon(Icons.delete),
                                  title: Text('Delete',),
                                  onTap: () async {
                                    Navigator.pop(context);
                                    _showDeleteConfirmationDialog(context);
                                  },
                                ),

                              ],
                            ),
                          );
                        },
                      );
                    }, icon: Icon(Icons.more_vert))
                  ],
                ),
              ],),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  TextFormField(
                    style:const TextStyle(fontSize:22 ),
                    controller: _titleController,
                    // autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'Title',
                        border: InputBorder.none
                    ),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    style:const TextStyle(fontSize:18 ),
                    controller: _contentController,
                    maxLines: getMaxLines(context),
                    decoration:const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Note',
                    ),
                  ),
                  SizedBox(height: 16),


                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
