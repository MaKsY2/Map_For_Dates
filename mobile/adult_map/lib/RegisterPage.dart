import 'package:adult_map/models/HttpResponsePerson.dart';
import 'package:flutter/material.dart';
import 'package:multiple_result/multiple_result.dart';

import 'LoginPage.dart';

import 'package:adult_map/widgets/inputTextField.dart';

import 'models/Person.dart';

import 'IOfunctions/IOFunc.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final _phoneController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _passwordController = TextEditingController();
  Future<HttpResponseUser>? _futurePerson;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF462255),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Hello, user!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Welcome, please register',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 50),
                  inputTextField(
                      textController: _phoneController, hintText: "Phone"),
                  SizedBox(height: 25),
                  inputTextField(textController: _firstNameController,
                      hintText: "First Name"),
                  SizedBox(height: 25),
                  inputTextField(textController: _passwordController,
                      hintText: "Password"),
                  SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        LoginPage()),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Color(0xA138023B),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                    'Back',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    )
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              setState(() {
                                _futurePerson = createPerson(
                                  _phoneController.text,
                                  _firstNameController.text,
                                  _passwordController.text,
                                );
                              });
                              var user = await _futurePerson;
                              showDialog(
                                  context: context,
                                  builder: (BuildContext) {
                                    if (user!.statusCode == 1) {
                                      return AlertDialog(
                                        title: Text('Registration'),
                                        content: Text('Success, ${user.user!
                                            .name}, registered!'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('Ok'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        LoginPage()),
                                              );
                                            },
                                          ),
                                        ],
                                      );
                                    }
                                    else {
                                      return AlertDialog(
                                        title: Text('Registration'),
                                        content: Text('Error: ${user.status} !'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('Ok'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    }
                                  });
                            },
                            child: Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Color(0xA138023B),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                    'Register',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    )
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }
}

