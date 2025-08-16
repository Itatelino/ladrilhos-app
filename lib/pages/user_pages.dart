/*import 'package:flutter/material.dart';
import 'package:ladrilho_app/controlles/sqlite_controller.dart';
import 'package:ladrilho_app/models/user_model.dart';
import 'package:ladrilho_app/models/imgs_model.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final SqliteController _sqliteController = SqliteController();

  final TextEditingController _userController = TextEditingController();

  // ignore: unused_field
  UserModel? _userToEdit;

  @override
  void initState() {
    super.initState();
    _sqliteController.initDb().then((_) {
      _getUsers();
    });
  }

  void _getUsers() {
    _sqliteController.getUsers().then((userList) {
      setState(() {
        users = userList.map((json) => UserModel.fromJson(json)).toList();
      });
    });
  }

  // ignore: no_leading_underscores_for_local_identifiers
  _deleteUser(int userId) {
    _sqliteController.deleteUser(userId).then((_) {
      _getUsers();
    });
  }

  createUser() {
    _sqliteController.insertUser(UserModel(id: -1, name: _userController.text)).then((value) {
      _getUsers();
    });
  }

  // ignore: unused_element
  _updateUser(UserModel user) {
    _sqliteController.updateUser(user).then((value) {
      _getUsers()
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(users[index].name),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserPage(user: users[index])));
                  },
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                                _userController.text = users[index].name;
                                _userToEdit = users[index];
                                _showUserBottomSheet();
                            },
                            icon: const Icon(Icons.edit)),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              _deleteUser(users[index].id);
                            },
                          icon: const Icon(Icons.delete)),
                        ],
                      ),
              ))),

              SizedBox( 
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _showUserBottomSheet();
                  },
                  child: const Text('Criar novo usuário')),
              )
          ],
        ),
      ),
    );
  }
        
           
 _showUserBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _userController,
              decoration: const InputDecoration(labelText: 'Nome do usuário'),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
              onPressed: () {
                if (_userToEdit != null) {
                  _updateUser(UserModel(id: _userToEdit!.id, name: _userEditController.text));
                } else {
                  _createUser(_userController.text);
                }
                Navigator.pop(context);
              },
              child: Text(_userToEdit == null ? 'Criar' : 'Atualizar')),
            )
          ],
        ),
      );
        }).then((_) {
      _userEditController.clear();
      _userToEdit = null;
    });
  }
}
*/


  //List<UserModel> users = [];
  //
  //
                 