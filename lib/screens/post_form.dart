import 'dart:io';

import 'package:commerceapp/constant.dart';
import 'package:commerceapp/models/api_response.dart';
import 'package:commerceapp/screens/loading.dart';
import 'package:commerceapp/screens/login.dart';
import 'package:commerceapp/services/post_service.dart';
import 'package:commerceapp/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PostForm extends StatefulWidget {
  @override
  PostFormState createState() {
    return PostFormState();
  }
}

class PostFormState extends State<PostForm> {

  final TextEditingController _txtPost = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  bool _loading = false;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  Future getImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _createPost() async {
    String? image = _imageFile == null ? null : getStringImage(_imageFile);
    ApiResponse response = await createPost(_txtPost.text, image);

    if (response.error == null) {
      Navigator.of(context).pop();
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Login()),
                (route) => false)
          });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
      setState(() {
        _loading = !_loading;
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add new Post"),
          backgroundColor: Colors.black87,
        ),
        body: _loading
            ? Center(child: CircularProgressIndicator())
            : ListView(
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      decoration: BoxDecoration(
                          image: _imageFile == null
                              ? null
                              : DecorationImage(
                                  image: FileImage(_imageFile ?? File('')),
                                  fit: BoxFit.cover)),
                      child: Center(
                        child: IconButton(
                            onPressed: () {
                              getImage();
                            },
                            icon: Icon(
                              Icons.image,
                              size: 50,
                            )),
                      )),
                  SizedBox(
                    height: 30,
                  ),
                  Form(
                    key: _key,
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: TextFormField(
                        controller: _txtPost,
                        keyboardType: TextInputType.multiline,
                        maxLines: 9,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "The field must not be empty";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            hintText: "Post body",
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 1, color: Colors.black))),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_key.currentState!.validate()) {
                          setState(() {
                            _loading = !_loading;
                          });
                          _createPost();
                        }
                      },
                      child: Text("Post "),
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 40),
                          primary: Colors.black87),
                    ),
                  )
                ],
              ));
  }
}
