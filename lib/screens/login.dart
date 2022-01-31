import 'package:commerceapp/models/api_response.dart';
import 'package:commerceapp/models/user.dart';
import 'package:commerceapp/screens/home.dart';
import 'package:commerceapp/screens/register.dart';
import 'package:commerceapp/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
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
                  "Blog Account !",
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Login into your account here",
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
                  "Login",
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
  bool loading = false;
  RegExp exp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  void _loginUser() async {
    ApiResponse response = await login(txtEmail.text, txtPassword.text);
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Fill the field please";
                } else if (!exp.hasMatch(value)) {
                  return "Email invalid";
                }
                return null;
              },
              controller: txtEmail,
              decoration: InputDecoration(
                hintText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              obscureText: obstext,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please fill the field";
                } else if (value.length < 8) {
                  return "Password length must be more than 8";
                }
                return null;
              },
              controller: txtPassword,
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
            loading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ElevatedButton(
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        setState(() {
                          loading = true;
                          _loginUser();
                        });
                      }
                    },
                    child: Text("Login"),
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 40),
                        primary: Colors.black87),
                  ),
            Row(
              children: [
                SizedBox(
                  height: 40,
                ),
                Text("I don't have  an account"),
                GestureDetector(
                  child: Text(
                    " sign in ",
                    style: TextStyle(color: Colors.cyan),
                  ),
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => Register()),
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
