import 'package:commerceapp/models/api_response.dart';
import 'package:commerceapp/models/user.dart';
import 'package:commerceapp/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:commerceapp/services/user_service.dart';
import 'package:commerceapp/screens/home.dart';
import 'package:flutter/material.dart';

class Register extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(100))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome !",
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Create your account here",
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  "and use all of our services . just fill formuler",
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  "Buy here articles like bag , watches , ",
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  "samartphones , computer sciences articles and so on ...",
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 25, top: 10),
                child: Text(
                  "Registration",
                  style: TextStyle(fontSize: 30),
                ),
              ),
            ],
          ),
          Container(
              child: Padding(padding: EdgeInsets.all(10), child: MyForm()))
        ],
      ),
    )));
  }
}

class MyForm extends StatefulWidget {
  @override
  MyFormState createState() {
    return MyFormState();
  }
}

class MyFormState extends State<MyForm> {
  final _formkey = GlobalKey<FormState>();
  bool obstext = true;
  RegExp exp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtUsername = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtTel = TextEditingController();
  TextEditingController txtConfirmed = TextEditingController();
  bool loading = false;
  void _registerUser() async {
    ApiResponse response = await register(
        txtEmail.text, txtPassword.text, txtUsername.text, txtTel.text);
    if (response.error == null) {
      _saveAndRedirectToHome(response.data as User);
    } else {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
    }
  }

  void _saveAndRedirectToHome(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('userId', user.id ?? 0);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Home()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: txtUsername,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please fill the field";
                } else if (value.length < 6) {
                  return "Username lenght must be more than 6";
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: "Username",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: txtEmail,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Fill the field please";
                } else if (!exp.hasMatch(value)) {
                  return "Email invalid";
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: txtPassword,
              obscureText: obstext,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please fill the field";
                } else if (value.length < 8) {
                  return "Password length must be more than 8";
                }
                return null;
              },
              decoration: InputDecoration(
                  hintText: "password",
                  border: OutlineInputBorder(),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        obstext = !obstext;
                      });
                      FocusScope.of(context).unfocus();
                    },
                    child: Icon(
                      obstext == true ? Icons.visibility : Icons.visibility_off,
                      color: Colors.black,
                    ),
                  )),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: txtConfirmed,
              obscureText: obstext,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please fill the field";
                } else if (value != txtPassword.text) {
                  return "Password not confirmed";
                }
                return null;
              },
              decoration: InputDecoration(
                  hintText: "Confirm your password",
                  border: OutlineInputBorder(),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        obstext = !obstext;
                      });
                      FocusScope.of(context).unfocus();
                    },
                    child: Icon(
                      obstext == true ? Icons.visibility : Icons.visibility_off,
                      color: Colors.black,
                    ),
                  )),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: txtTel,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please fill the field";
                } else if (value.length < 8) {
                  return "Number length must be more than 8";
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: "Phone number",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            loading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ElevatedButton(
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        setState(() {
                          loading = true;
                          _registerUser();
                        });
                      }
                    },
                    child: Text("Sign in"),
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 40),
                        primary: Colors.black87),
                  ),
            Row(
              children: [
                SizedBox(
                  height: 40,
                ),
                Text("I have already an account"),
                GestureDetector(
                  child: Text(
                    " login ",
                    style: TextStyle(color: Colors.cyan),
                  ),
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => Login()),
                        (route) => false);
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
