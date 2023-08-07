
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notes/repository/notesrepository.dart';
import 'package:notes/repository/userauthrepository.dart';
import 'package:notes/screens/login_screen.dart';
import '../models/note.dart';
import 'add_notes_screen.dart';



class NotesScreen extends StatefulWidget {
  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {

  final TextEditingController _searchEditingController = TextEditingController();


  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


bool isLoading=false;

  List<Note> _notes = [];
  List<Note> _filteredNotes = []; // New list for filtered notes

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getNote();
    });
  }

  getNote() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    NoteRepository noteRepository = NoteRepository();
    _notes = await noteRepository.getNotes();

    // Create a copy of the _notes list to _filteredNotes
    _filteredNotes = List.from(_notes);

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }


  bool  list=false;

  void _addNote() async {
    int result = await Navigator.push(
      context,
    MaterialPageRoute(
        builder: (context) => AddNoteScreen(),
      ),
    );

    if(result==1){
      getNote();
    }

  }

  @override
  void dispose() {
    _searchEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width=MediaQuery.sizeOf(context).width;
    final height=MediaQuery.sizeOf(context).height;
    return

      GestureDetector(
        onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        drawer: Drawer(
          child: SafeArea(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                SizedBox(height: 20),
                Icon(Icons.person,size: 60),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(FirebaseAuth.instance.currentUser!.email.toString()),
                  ],
                ),
                SizedBox(height: 20),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                  onTap: () async {
UserAuthRepository userAuthRepository=UserAuthRepository();
     await userAuthRepository.signOut();
     if(userAuthRepository.getCurrentUser() == null){
       Navigator.pushAndRemoveUntil(
           context, MaterialPageRoute(builder: (context) => LoginPage(),), (
           route) => false);
     }


                    },
                ),

              ],
            ),
          ),
        ),
        body:
        isLoading
            ?
        Center(child: CircularProgressIndicator())
            :

        SafeArea(
          child:
          Container(
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  constraints: BoxConstraints(maxWidth: double.infinity),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SearchBar(
onChanged: (searchValue) {
  setState(() {
    if (searchValue.isNotEmpty) {
      _filteredNotes = _notes.where((note) {
        return note.title.toLowerCase().contains(searchValue.toLowerCase()) ||
            note.content.toLowerCase().contains(searchValue.toLowerCase());
      }).toList();
    } else {
      // Reset the filter when the search value is empty
      _filteredNotes = List.from(_notes);
    }
  });
},
                            controller: _searchEditingController,
                            hintText: 'Search here',
                            leading: IconButton(
                              onPressed: () {
                                _scaffoldKey.currentState?.openDrawer();
                              },
                              icon: Icon(Icons.person),
                            ),
                            trailing: [
                              IconButton(
                                onPressed: () {
                                  if(mounted){
                                  setState(() {
                                    list=!list;
                                  });
                                  }
                                },
                                icon: Icon(list?Icons.list:Icons.grid_view_outlined),
                              ),

                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                _filteredNotes.length==0
                    ?
                SizedBox(height: height*0.7,child: Center(child: Text('Notes not found'),))
                    :
                    Flexible(
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                          list?
                          ListView.builder(
                            itemCount: _filteredNotes.length,
                            itemBuilder: (context, index) {
                              final note = _filteredNotes[index];
                              return
                                InkWell(onTap: () async {

                                  FocusManager.instance.primaryFocus?.unfocus();
                                int result=await  Navigator.push(context, MaterialPageRoute(builder: (context) => AddNoteScreen(note: _filteredNotes[index]),));

                                  if(result==1){
                                    getNote();
                                  }
                                },
                                  child: Card(
                                    color: Color(note.color),
                                    semanticContainer: true,elevation: 10,
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(note.title,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                                          SizedBox(height: 10,),
                                          Text(note.content,maxLines: 12,overflow: TextOverflow.ellipsis,)
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                            },
                          )
                              :
                          MasonryGridView.builder(
                            gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                            ),
                            itemCount: _filteredNotes.length,
                            itemBuilder: (context, index) {
                              final note = _filteredNotes[index];
                              return InkWell(
                                onTap: () async {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  int result= await Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => AddNoteScreen(note: _filteredNotes[index])),
                                  );
                                  if(result==1){
                                    getNote();
                                  }
                                },
                                child: Card(
                                  color: Color(note.color),
                                  semanticContainer: true,
                                  elevation: 10,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          note.title,
                                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(height: 10),
                                        Text(note.content,
                                        maxLines: 14,overflow: TextOverflow.ellipsis,),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                      ),
                    )
              ],
            ),
          ),

        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _addNote,
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}