import 'package:flutter/material.dart';
import 'package:sqlite/db_handler.dart';
import 'package:sqlite/notes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  DBHelper? dbHelper;
  late Future<List<NotesModel>> notesList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper = DBHelper();
    loadData();
  }
  loadData()async{
    notesList = dbHelper!.getNotesList();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes SQL"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: notesList,
                builder: (context,AsyncSnapshot<List<NotesModel>> snapshot)
                {

                  if(snapshot.hasData){
                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder:(context,index)
                        {
                          return InkWell(
                            onTap: (){
                              dbHelper!.update(
                                NotesModel(
                                id: snapshot.data![index].id!,
                                  title: "helloworld",
                                  email: "hello@gmail.com",
                                  age:22,
                                  description: "This is my first sql app",
                                )
                              );
                              setState(() {
                                notesList = dbHelper!.getNotesList();
                              });
                            },

                            child: Dismissible(
                              direction: DismissDirection.endToStart,
                              onDismissed: (_){
                                setState(() {
                                  dbHelper!.delete(snapshot.data![index].id!);
                                  notesList = dbHelper!.getNotesList();
                                  snapshot.data!.remove(snapshot.data![index]);
                                });

                              },

                              key: ValueKey<int>(snapshot.data![index].id!) ,
                              child: Card(
                                  child: ListTile(
                                    title:Text( snapshot.data![index].title.toString()),
                                    subtitle:Text( snapshot.data![index].email.toString()),
                                    trailing: Text( snapshot.data![index].description.toString()),

                                  )
                              ),
                            ),
                          );
                        }
                    );

                  }else{

                     return CircularProgressIndicator();

                  }



                }
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          dbHelper!.insert(
            NotesModel(
             title: "3rd Note",
             age:22,
             description: "This is my first sql app",
             email: "asad@gmail.com"
            )
          ).then((value){
            setState(() {
              notesList = dbHelper!.getNotesList();
            });
            print("data added");
          }).onError((error, stackTrace){
            print(error.toString());
          });
        },
        child:const Icon(Icons.add),
      ),
    );
  }
}
