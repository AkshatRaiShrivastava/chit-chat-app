import 'dart:developer';

import 'package:flutter/material.dart';

import '../services/auth/auth_service.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _resetEmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  void Function()? onTap;
  LoginPage({super.key, required this.onTap});

  void login(BuildContext context) async {
    final authService = AuthService();
    // try login
    try {
      await authService.signInWithEmailPassword(
          _emailController.text, _passwordController.text);
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(e.toString()),
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthService _authService = AuthService();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.message, size: 100),
              SizedBox(
                height: 20,
              ),
              Text(
                "Welcome Back, you've been missed",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary, fontSize: 16),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                    hintText: 'Email',
                    fillColor: Theme.of(context).colorScheme.tertiary,
                    filled: true,
                    hintStyle: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary)),
                style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                obscureText: true,
                controller: _passwordController,
                decoration: InputDecoration(
                    hintText: 'Password',
                    fillColor: Theme.of(context).colorScheme.tertiary,
                    filled: true,
                    hintStyle: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary)),
                style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    login(context);
                  },
                  style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                          Theme.of(context).colorScheme.inversePrimary)),
                  child: Text("Login")),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                height: 10,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color:
                                      Theme.of(context).colorScheme.inversePrimary,
                                ),
                                width: 100,
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              TextField(
                                controller: _resetEmailController,
                                decoration: InputDecoration(
                                    hintText: 'Email',
                                    fillColor:
                                        Theme.of(context).colorScheme.tertiary,
                                    filled: true,
                                    hintStyle: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .inversePrimary)),
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    _authService.resetPassword(
                                        _resetEmailController.text);
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Reset link sent to your email id')));
                                  },
                                  style: ButtonStyle(
                                      backgroundColor: WidgetStatePropertyAll(
                                          Theme.of(context)
                                              .colorScheme
                                              .inversePrimary)),
                                  child: Text("Reset")),
                            ],
                          ),
                        );
                      });
                },
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Not a member, "),
                  GestureDetector(
                    onTap: onTap,
                    child: Text(
                      "Register now",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.inversePrimary),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
