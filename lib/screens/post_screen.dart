import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  @override 
  PostScreenState createState() {
    return PostScreenState();
  }
}

class PostScreenState extends State<PostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("post screen"),
      ),
    );
  }
}
