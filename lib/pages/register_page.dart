import 'dart:developer';

import 'package:flutter/material.dart';

import '../services/auth/auth_service.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final void Function()? onTap;
  RegisterPage({super.key, required this.onTap});

  void register(BuildContext context){
    final _auth = AuthService();
    //if(_confirmPasswordController == _passwordController.text){
      try{
        _auth.signupWithEmailPAssword(_emailController.text, _confirmPasswordController.text);
      }catch (e){
        showDialog(context: context, builder: (context)=>AlertDialog(
          title: Text(e.toString()),
        ));
      }
    //}
    //else{
      //showDialog(context: context, builder: (context)=>AlertDialog(
      //  title: Text('Password does not match !'),
      //));
    //}

  }
  @override
  Widget build(BuildContext context) {
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
                onChanged: (val) {
                  log(val);
                },
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
              TextField(
                obscureText: true,
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                    hintText: 'Confirm password',
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
                  onPressed: () {register(context);},
                  style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                          Theme.of(context).colorScheme.inversePrimary)),
                  child: Text("Register")),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account? "),
                  GestureDetector(
                    onTap: onTap,
                    child: Text(
                          "Login",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(context).colorScheme.inversePrimary),
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
