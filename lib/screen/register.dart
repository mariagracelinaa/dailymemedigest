import 'dart:convert';

import 'package:dailymemedigest_160419024_160719022/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // String _firstName = "";
  // String _lastName = "";
  String _username = "";
  String _password = "";
  String _rePassword = "";

  @override
  Widget build(BuildContext context) {
    void submit() async {
      final response = await http.post(
          Uri.parse("https://ubaya.fun/flutter/160419024/uas/register.php"),
          body: {
            // 'first_name': _firstName,
            // 'last_name': _lastName,
            'username': _username,
            'password': _password,
            'rePassword': _rePassword,
          });
      if (response.statusCode == 200) {
        Map json = jsonDecode(response.body);
        if (json['result'] == 'success') {
          if (!mounted) return;
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Sukses Registrasi Data')));

          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MyLogin()));
        } else {
          if (!mounted) return;
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(json['Error'])));
        }
      } else {
        throw Exception('Failed to read API');
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Student Detail'),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Text("Daily Meme Digest",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text("Create Account", style: TextStyle(fontSize: 20)),
            ),
            // Padding(
            //   padding: EdgeInsets.all(10),
            //   child: TextField(
            //     onChanged: (value) {
            //       _firstName = value;
            //     },
            //     decoration: InputDecoration(
            //         border: OutlineInputBorder(),
            //         labelText: 'First Name',
            //         hintText: 'Enter your first name'),
            //   ),
            // ),
            // Padding(
            //   padding: EdgeInsets.all(10),
            //   child: TextField(
            //     onChanged: (value) {
            //       _lastName = value;
            //     },
            //     decoration: InputDecoration(
            //         border: OutlineInputBorder(),
            //         labelText: 'Last Name',
            //         hintText: 'Enter your last name'),
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                onChanged: (value) {
                  _username = value;
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                    hintText: 'Enter your username'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                onChanged: (value) {
                  _password = value;
                },
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter secure password'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                onChanged: (value) {
                  _rePassword = value;
                },
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Repeat Password',
                    hintText: 'Repeat password'),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Container(
                      height: 50,
                      width: 300,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20)),
                      child: ElevatedButton(
                        onPressed: () {
                          submit();
                        },
                        child: Text(
                          'Create Account',
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                      ),
                    )),
              ],
            )
          ],
        ));
  }
}
