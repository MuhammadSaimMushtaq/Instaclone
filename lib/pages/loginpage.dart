import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:instaclone/pages/register.dart';
import 'package:instaclone/serices/firebaseserice.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  double? _width;
  double? _height;
  // ignore: unused_field
  String? _email, _password;
  FirebaseSerice? firebaseSerice;

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    firebaseSerice = GetIt.instance.get<FirebaseSerice>();
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: _width! * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              _title(),
              _form(),
              _loginButton(),
              _gotoregisterpage(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _title() {
    return const Text(
      'instaclone',
      style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _loginButton() {
    return MaterialButton(
      onPressed: _submitform,
      color: Colors.red,
      minWidth: _width! * 0.7,
      height: _height! * 0.09,
      child: const Text(
        'Login',
        style: TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _gotoregisterpage() {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Registeruser(),
          ),
        );
      },
      child: const Text(
        'Don\'t have an account?',
        style: TextStyle(
          color: Colors.blue,
          fontSize: 15,
          fontWeight: FontWeight.w200,
        ),
      ),
    );
  }

  void _submitform() async {
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();
      bool result = await firebaseSerice!.loginUser(
        email: _email!,
        password: _password!,
      );
      if (result) Navigator.popAndPushNamed(context, 'home');
    }
  }

  Widget _form() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: _width! * 0.01,
      ),
      height: _height! * 0.25,
      child: Form(
        key: _formkey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _emailfield(),
            _passwordfield(),
          ],
        ),
      ),
    );
  }

  Widget _emailfield() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Email',
        hintText: "Enter your email",
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
          ),
        ),
      ),
      validator: (email) {
        if (email!.isEmpty) {
          return 'please enter email';
        } else {
          RegExp check = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
          return email.contains(check) ? null : "enter a valid email";
        }
      },
      onSaved: (email) {
        setState(() {
          _email = email;
        });
      },
    );
  }

  Widget _passwordfield() {
    return TextFormField(
      obscureText: true,
      decoration: const InputDecoration(
        labelText: 'Password',
        hintText: "Enter your password",
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
          ),
        ),
      ),
      validator: (pass) {
        if (pass!.isEmpty) {
          return 'Please enter a password';
        }
        return pass.length > 3 ? null : 'Enter password greater than three';
      },
      onSaved: (pass) {
        setState(() {
          _password = pass;
        });
      },
    );
  }
}
