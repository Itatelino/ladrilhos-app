/*import 'package:ladrilho_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:ladrilho_app/controlles/sqlite_controller.dart';
import 'package:ladrilho_app/models/imgs_model.dart';

class ImagsPage extends StatefulWidget {
  final UserModel user;
  const ImagsPage({super.key});

  @override
  State<ImagsPage> createState() => _ImagsPageState();
}

class _ImagsPageState extends State<ImagsPage> {
  List<ImagsModel> images = [];
  final SqliteController _sqliteController = SqliteController();

  final TextEditingController _imageEditController = TextEditingController();

  // ignore: unused_field
  ImagsModel? _imageToEdit;

  @override
  void initState() {
    super.initState();
    _sqliteController.initDb().then((_) {
      _getUserImages();
    });
  }

  _getUserImages() {
    _sqliteController.getUserImages().then((value) {
      setState(() {
        images = imageList.map((json) => ImgModel.fromJson(json)).toList();
      });
    });
  }

  _deleteImage(int imageId) {
    _sqliteController.deleteImage(imageId).then((value) {
      _getUserImages();
    });
  }

  _createImage() {
    _sqliteController.insertImage(ImgsModel(id: -1, text: text, userId: widget.user.id)).then((value) {
      _getUserImages();
    });
  }

  _updateImage(ImgsModel image) {
    _sqliteController.updateImage(image).then((value) {
      _getUserImages();
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
                itemCount: images.length,
                itemBuilder: (context, index) => ListTile(
                  subtitle: Text(images[index].text),
                  onTap: () {

                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          _imageToEdit = images[index];
                          _imageEditController.text = images[index].text;
                          _showImagsBottomSheet();
                        },
                        icon: const Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () {
                          _deleteImage(images[index].id);
                        },
                        icon: const Icon(Icons.delete)),

                    ],
                  ),
                ),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _showImagsBottomSheet();
                    },
                  child: const Text("Adicionar Imagem")),
                )
               ],
            ),
        ),
      );
    
  }

  _showImagsBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              TextField(
              controller: _imageEditController,
              decoration: const InputDecoration(labelText: 'Texto da Imagem'),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_imageToEdit != null) {
                    _updateImage(ImgsModel(id: _imageToEdit!.id, text: _imageEditController.text));
                  } else {
                    _createImage();
                  }
                  Navigator.pop(context);
                },
                child: Text(_imageToEdit == null ? 'Criar' : 'Atualizar')),
              
            )
          ],
        ),
      );
    }).then((_) {
      _imageEditController.clear();
      _imageToEdit = null;
    });
  }
}
*/
