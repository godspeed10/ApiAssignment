import 'package:assign_project/models/user.dart';
import 'package:assign_project/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  List<User> users = [];
  ApiService _apiService;
  @override
  void initState() {
    super.initState();
    _apiService = context.read<ApiService>();
    getUsers();
  }

  getUsers() {
    Future.wait([_apiService.listUsers(), _apiService.listUsers(page: 2)])
        .then((values) => setState(() {
              users = [...values[0], ...values[1]];
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Login"),
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text('Drawer Header'),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
            ]),
      ),
      body: ListView.builder(
          itemCount: users.length,
          reverse: true,
          itemBuilder: (context, index) => Dismissible(
                key: ObjectKey(users[index].id),
                background: Container(color: Colors.red),
                direction: DismissDirection.endToStart,
                onDismissed: (_) {
                  setState(() {
                    users.removeAt(index);
                  });
                  _apiService.deleteUser("${users[index].id}");
                },
                child: ListTile(
                  leading: Image.network(users[index].avatar),
                  title: Text(
                      '${users[index].firstName} ${users[index].lastName}'),
                  subtitle: Text(users[index].email),
                ),
              )),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final data = await showModalBottomSheet(
              context: context, builder: (context) => AddUserSheet());
          if (data != null) {
            await _apiService.addUser(name: data["name"], job: data["job"]);
            getUsers();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddUserSheet extends StatefulWidget {
  @override
  _AddUserSheetState createState() => _AddUserSheetState();
}

class _AddUserSheetState extends State<AddUserSheet> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _jobController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _jobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(hintText: "name"),
          ),
          TextField(
            controller: _jobController,
            decoration: InputDecoration(hintText: "job"),
          ),
          TextButton(
            onPressed: () {
              final _name = _nameController.text.trim();
              final _job = _jobController.text.trim();
              if (_name.isNotEmpty && _job.isNotEmpty) {
                Navigator.of(context).pop({"name": _name, "job": _job});
              }
            },
            style: ButtonStyle(
                alignment: Alignment.center,
                padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(vertical: 16)),
                backgroundColor: MaterialStateProperty.all(Colors.blue),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ))),
            child: Text(
              "Add User",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
