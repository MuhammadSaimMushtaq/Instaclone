import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:instaclone/serices/firebaseserice.dart';

class Registeruser extends StatefulWidget {
  const Registeruser({super.key});

  @override
  State<Registeruser> createState() => _RegisteruserState();
}

class _RegisteruserState extends State<Registeruser> {
  File? image;

  double? _width, _height;

  FirebaseSerice? firebase;

  String? _email, _password, _name;

  final GlobalKey<FormState> _regform = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    firebase = GetIt.instance.get<FirebaseSerice>();
  }

  Widget _profileimage() {
    ImageProvider? imageProvider;
    imageProvider = image != null
        ? FileImage(image!)
        : const NetworkImage('https://i.pravatar.cc/300');
    return GestureDetector(
      onDoubleTap: () {
        FilePicker.platform.pickFiles().then((value) {
          if (value != null) {
            setState(() {
              image = File(value.files.first.path!);
            });
          }
        });
      },
      child: Container(
        height: _height! * 0.15,
        width: _height! * 0.15,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: imageProvider as ImageProvider,
          ),
        ),
      ),
    );
  }

  Widget registerform() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: _width! * 0.05,
      ),
      height: _height! * 0.35,
      child: Form(
        key: _regform,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            _namefield(),
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
        return pass.length > 6 ? null : 'Enter password greater than six';
      },
      onSaved: (pass) {
        setState(() {
          _password = pass;
        });
      },
    );
  }

  Widget _namefield() {
    return TextFormField(
      obscureText: true,
      decoration: const InputDecoration(
        labelText: 'Name',
        hintText: "Enter your name",
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
          ),
        ),
      ),
      validator: (name) {
        if (name!.isEmpty) {
          return 'Please enter a name';
        }
        return name.length > 3 ? null : 'Enter name greater than 3 characters';
      },
      onSaved: (pass) {
        setState(() {
          _password = pass;
        });
      },
    );
  }

  Widget _registerButton() {
    return MaterialButton(
      onPressed: _submitform,
      color: Colors.red,
      minWidth: _width! * 0.7,
      height: _height! * 0.09,
      child: const Text(
        'Register',
        style: TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _submitform() async {
    if (_regform.currentState!.validate() && image != null) {
      try {
        _regform.currentState!.save();
        bool result = await firebase!.registerUser(
          email: _email!,
          password: _password!,
          name: _name!,
          image: image!,
        );
        if (result) {
          Navigator.pop(context);
        }
      } catch (e) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Error'),
                content: Text(e.toString()),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('OK'))
                ],
              );
            });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instaclone'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            _profileimage(),
            registerform(),
            _registerButton(),
          ],
        ),
      ),
    );
  }
}
