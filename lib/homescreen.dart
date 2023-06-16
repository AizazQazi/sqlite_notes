import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqlite_notes/database_handler.dart';
import 'package:sqlite_notes/notes.dart';

class homescreen extends StatefulWidget {
  const homescreen({Key? key}) : super(key: key);

  @override
  State<homescreen> createState() => _homescreenState();
}

class _homescreenState extends State<homescreen> {
  DBHelper? dbhelper;
  late Future<List<notesmodel>?> noteslist;

  onPressed() {
    dbhelper
        ?.insert(notesmodel(
      title: 'my first note',
      age: 21,
      email: 'azi@gmail.com', description: 'notess',

    ))
        .then((value) {
      if (kDebugMode) {
        print("data added");
      }
      setState(() {
        noteslist=dbhelper!.getnodesList();
      });
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }

  loaddata() async {
    noteslist = dbhelper!.getnodesList();
  }

  @override
  void initState() {
    super.initState();
    dbhelper = DBHelper();
    loaddata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sql notes"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
                future: noteslist,
                builder: (context, AsyncSnapshot<List<notesmodel>?> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) {
                          return Dismissible(
                            direction: DismissDirection.endToStart,
                            onDismissed: (DismissDirection direction){
                              setState(() {
                                dbhelper!.delete(snapshot.data![index].id!);
                                noteslist=dbhelper!.getnodesList();
                                snapshot.data!.remove(snapshot.data![index]);
                              });
                            },
                            background: Container(
                              child: const Icon(Icons.delete_forever),
                              color: Colors.red,
                            ),
                            key: ValueKey<int>(snapshot.data![index].id!),
                            child: Card(
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(0),
                                title: Text(snapshot.data![index].title.toString()),
                                subtitle: Text(snapshot.data![index].email.toString()),
                                trailing: Text(snapshot.data![index].age.toString()),
                              ),
                            ),
                          );
                        });
                  }
                  else{
                    return const CircularProgressIndicator(

                    );
                  }

                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onPressed,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
