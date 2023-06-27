import 'dart:convert';
import 'dart:io';

import 'package:ChatGpt/components/buttonDefault.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ChangePhoto extends StatefulWidget {
  final storage = const FlutterSecureStorage();

  const ChangePhoto({super.key});

  @override
  State<ChangePhoto> createState() => _ChangePhotoState();
}

class _ChangePhotoState extends State<ChangePhoto> {
  File? _image;
  Map<String, dynamic> _user = {};

  Future _pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      File? img = File(image.path);
      img = await _cropImage(imageFile: img);
      setState(() {
        _image = img;
      });
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<File?> _cropImage({required File imageFile}) async {
    CroppedFile? croppedImage =
        await ImageCropper().cropImage(sourcePath: imageFile.path);
    if (croppedImage == null) return null;
    return File(croppedImage.path);
  }

  void _showImagePickerModal() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Selecionar da Galeria'),
                onTap: () {
                  Navigator.pop(context); // Fechar o modal
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Tirar Foto'),
                onTap: () {
                  Navigator.pop(context); // Fechar o modal
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  String? imageToBase64(File? image) {
    if (image == null) return null;

    List<int> imageBytes = image.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    return base64Image;
  }

  void _updatePhoto(context) async {
    final apiUrl = dotenv.env['API_URL'];

    String? base64Image = imageToBase64(_image);
    if (base64Image != null && base64Image.isNotEmpty) {
      final response = await http.put(
        Uri.parse('$apiUrl/update-password/${_user['id'].toString()}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{'profilePhoto': base64Image}),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Foto alterada com sucesso.'),
            duration: Duration(seconds: 4),
          ),
        );
      } else {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao alterar foto.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    widget.storage.read(key: 'user').then((value) {
      setState(() {
        _user = jsonDecode(value!);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: const Color.fromRGBO(32, 34, 34, 1.0),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromRGBO(32, 34, 34, 1.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text(
              'Selecione sua foto',
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: _image != null
                  ? CircleAvatar(
                      backgroundImage: FileImage(_image!),
                      radius: 150,
                    )
                  : Image.asset('assets/images/user.png'),
            ),
            Column(
              children: [
                ButtonDefault(
                    text: (_image != null ? 'Alterar Foto' : 'Selecionar Foto'),
                    onPressed: () {
                      _showImagePickerModal();
                    },
                    borderOutline: false,
                    disabled: false),
                const SizedBox(height: 16),
                _image != null
                    ? ButtonDefault(
                        text: 'Salvar',
                        onPressed: () {
                          _updatePhoto(context);
                        },
                        borderOutline: true,
                        disabled: false)
                    : const SizedBox(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
