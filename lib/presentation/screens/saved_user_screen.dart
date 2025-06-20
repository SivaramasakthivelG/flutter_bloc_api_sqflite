
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_flutter/data/repository/local_db_helper.dart';
import 'package:learn_flutter/domain/entities/user.dart';

class SavedUserScreen extends StatefulWidget {

  @override
  _SavedUserScreenState createState() => _SavedUserScreenState();

}

class _SavedUserScreenState extends State<SavedUserScreen> {
  late Future<List<User>> savedUsers;

  @override
  void initState(){
    super.initState();
    savedUsers = LocalDBHelper.getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Saved Users"),),
      body: FutureBuilder<List<User>> (future: savedUsers, builder: (context,snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
        if (!snapshot.hasData || snapshot.data!.isEmpty) return Center(child: Text("No saved users."));

        final users = snapshot.data!;
        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (_,i) => ListTile(
            title: Text(users[i].name),
            subtitle: Text(users[i].email),
          ),
        );

      }),
    );
  }

}