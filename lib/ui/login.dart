import 'package:assign_project/services/api_service.dart';
import 'package:assign_project/ui/user_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool showPass = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _apiService = context.watch<ApiService>();
    return Scaffold(
      appBar: AppBar(
        title: Text("User Login"),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 80,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextField(
                controller: _emailController,
                decoration: InputDecoration(hintText: "email"),
              ),
              TextField(
                obscureText: showPass,
                controller: _passwordController,
                decoration: InputDecoration(hintText: "password"),
              ),
              TextButton(
                onPressed: () async {
                  final _email = _emailController.text.trim();
                  final _password = _passwordController.text.trim();
                  if (_email.isNotEmpty && _password.isNotEmpty) {
                    final result = await _apiService.login(
                        email: _email, password: _password);
                    if (result.error.isEmpty) {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => UserList()));
                    } else {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(result.error)));
                    }
                  }
                },
                style: ButtonStyle(
                    alignment: Alignment.center,
                    padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(vertical: 16)),
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ))),
                child: Text(
                  "Login",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
