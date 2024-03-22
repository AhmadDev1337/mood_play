// ignore_for_file: must_be_immutable, prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:blurrycontainer/blurrycontainer.dart';

class LogPage extends StatefulWidget {
  const LogPage({super.key});

  @override
  State<LogPage> createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
  bool _showLogin = true;

  void _toggleForm() {
    setState(() {
      _showLogin = !_showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "WeHome",
      home: Scaffold(
        body: Stack(
          children: [
            Image.asset(
              "assets/images/cover.jpeg",
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF8F1D1E),
                    Colors.transparent,
                  ],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                ),
              ),
              child: Center(
                child: BlurryContainer(
                  color: Colors.black.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  width: 250,
                  height: 400,
                  blur: 5,
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child: _showLogin
                          ? LoginForm(_toggleForm)
                          : RegisterForm(_toggleForm),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();
  final Function _toggleForm;
  LoginForm(this._toggleForm);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Login',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              TextField(
                style: TextStyle(color: Colors.white),
                controller: loginEmailController,
                decoration: const InputDecoration(
                    labelText: "Email", focusColor: Colors.white),
              ),
              TextField(
                controller: loginPasswordController,
                decoration: const InputDecoration(labelText: "Password"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                child: const Text("Login"),
              ),
            ],
          ),
        ),
        Spacer(),
        TextButton(
          onPressed: () {
            _toggleForm();
          },
          child: Text('Don\'t have account? Click here'),
        ),
      ],
    );
  }
}

class RegisterForm extends StatefulWidget {
  final Function _toggleForm;
  RegisterForm(this._toggleForm);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Register',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              TextField(
                style: TextStyle(color: Colors.white),
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              TextField(
                style: TextStyle(color: Colors.white),
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              TextField(
                style: TextStyle(color: Colors.white),
                controller: passwordController,
                decoration: const InputDecoration(labelText: "Password"),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {},
                child: const Text("Register"),
              ),
            ],
          ),
        ),
        Spacer(),
        TextButton(
          onPressed: () {
            widget._toggleForm();
          },
          child: Text('Already have account? Click here'),
        ),
      ],
    );
  }
}
