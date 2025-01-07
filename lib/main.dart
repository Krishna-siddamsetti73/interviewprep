import 'package:aichatroom/vidumeupload.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String code = '';
  String password = '';
  final TextEditingController _controller = TextEditingController();

  bool _isValidCode = false;
  @override
  void initState() {
    super.initState();
    _controller.addListener(_checkCode);
  }

  void _checkCode() {
    setState(() {
      _isValidCode = _controller.text == "0123";
    });
  }

  Future<void> login() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:5000/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User logged in successfully')));
      print('Login successful');
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => VidumeUpload()));
    } else {
      // Handle login error
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to login: ${response.body}')));
    }
  }

  Future<void> register() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:5000/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      // Registration successful
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User registered successfully')),
      );
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => VidumeUpload()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to register: ${response.body}')));
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_checkCode);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _controller,
                decoration: const InputDecoration(labelText: 'code'),
                onChanged: (value) {
                  setState(() {
                    code = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your code';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    login();
                  }
                },
                child: const Text('Login'),
              ),
              const SizedBox(height: 20),
              // Button is only visible if _isValidCode is true
              Visibility(
                visible: _isValidCode,
                child: ElevatedButton(
                  onPressed: () {
                    register();
                    print("Registering...");
                  },
                  child: const Text("Register"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
