import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  @override 
  ProfileState createState() {
    return ProfileState();
  }
}

class ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Profile screen"),
      ),
    );
  }
}