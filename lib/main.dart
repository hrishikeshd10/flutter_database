import 'package:flutter/material.dart';
import 'package:flutter_database/models/User.dart';
import 'package:flutter_database/utils/database_helper.dart';

List _users;

void main() async {
  var db = new DataBaseHelper();

//! ADDING THE USERS TO THE DATABASE

  int savedUser = await db.saveUser(new User("Lewis Hamilton", "Mercedes@44"));
  savedUser = await db.saveUser(new User("Sebastian Vettel", "SuderiaFerrari@05"));
  savedUser = await db.saveUser(new User("Kimi Raikkonnen", "AlfaRomeo@07"));
  print("User Saved $savedUser");

//! GETTING ALL THE USERS FROM THE DATABASE

  _users = await db.getAllUSers();
  for (int i = 0; i < _users.length; i++) {
    User users = User.map(_users[i]);
    print("Username:  ${users.username}");
    print("Password: ${users.password}");
    print("ID: ${users.id}");
  }

  //! GETTING TH USER COUNT IN THE DATABASE TABLE

  int usercount = await db.getCount();
  print("The userCOunt is : $usercount");

  //! UPDATING A USER IN THE DATABASE

  User hrishikesh = User.fromMap(
      {"username": "Valtteri Bottas", "password": "Mercedes@77", "id": 1});
  //! DELETING A USER IN THE DATABASE AND THEN RETRIEVING THE UPDATED USER LIST

  int hrishi = await db.deleteUser(1);
  print('----------------------------------------------');
  _users = await db.getAllUSers();
  for (int i = 0; i < _users.length; i++) {
    User users = User.map(_users[i]);
    print("Username:  ${users.username}");
    print("Password: ${users.password}");
    print("ID: ${users.id}");
  }

  int usercounts = await db.getCount();
  print("The userCOunt is : $usercounts");

//! THE UI CODE FOR APP GOES HERE

  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Database',
    home: new Home(),
  ));
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Database'),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: new ListView.builder(
        itemCount: _users.length,
        itemBuilder: (_, int i) {
          return new Card(
            color: Colors.white,
            elevation: 2.0,
            child: new ListTile(
              leading: new CircleAvatar(
                child: new Text('${User.fromMap(_users[i]).id}'),
                backgroundColor: Colors.red,
              ),
              title: new Text(
                "${User.fromMap(_users[i]).username}",
                style:
                    new TextStyle(fontStyle: FontStyle.italic, fontSize: 20.0),
              ),
              subtitle: new Text("${User.fromMap(_users[i]).password}"),
            ),
          );
        },
      ),
    );
  }
}
