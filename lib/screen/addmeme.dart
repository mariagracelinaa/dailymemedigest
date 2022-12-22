import 'dart:convert';

import 'package:dailymemedigest_160419024_160719022/class/Meme.dart';
import 'package:dailymemedigest_160419024_160719022/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String url = 'https://www.shutterstock.com/shutterstock/videos/2578430/thumb/1.jpg?ip=x480';
String top_text = '';
String bottom_text = '';

class AddMemes extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddMemesState();
  }
}

class _AddMemesState extends State<AddMemes> {
  final _formKey = GlobalKey<FormState>();

  Meme _m = Meme(id: 0,image: '', up_text: '', down_text: '', users_id: 0, like: 0, comments: [], visible: 1);

  @override
  void initState() {
    super.initState();
  }

  void submit() async {
      final response = await http.post(
          Uri.parse("https://ubaya.fun/flutter/160419024/uas/newmeme.php"),
          body: {
            'image': url,
            'up_text': top_text,
            'down_text': bottom_text,
            'users_id': user_id.toString(),
          });
      if (response.statusCode == 200) {
        Map json = jsonDecode(response.body);
        if (json['result'] == 'success') {
          if (!mounted) return;
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Sukses Menambah Data')));
        }
      } else {
        throw Exception('Failed to read API');
      }
    }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Create Your Meme'),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
              child: Column(
            children: [
              Padding(
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 5),
                child: Stack(children: [
                  Image(
                      image: NetworkImage(url),
                      fit: BoxFit.fill,
                      width: 500,
                      height: 300),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Text(top_text,
                        style: TextStyle(
                            fontSize: 25,
                            fontFamily: 'Impact',
                            color: Colors.white)),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 290,
                    alignment: Alignment.bottomCenter,
                    child: Stack(
                      children: [
                        Text(
                          bottom_text,
                          style: TextStyle(
                              fontSize: 25,
                              fontFamily: 'Impact',
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
              Padding(
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 5),
                child: TextField(
                  // controller: _urlController,
                  onChanged: (value) {
                    setState(() {
                      url = value;
                    });
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Image URL',
                      hintText: 'Enter your image URL'),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      top_text = value;
                    });
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Top Text',
                      hintText: 'Enter top text of meme'),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      bottom_text = value;
                    });
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Bottom Text',
                      hintText: 'Enter bottom text of meme'),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Container(
                    height: 50,
                    width: 200,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20)),
                    child: ElevatedButton(
                      onPressed: () {
                        submit();
                      },
                      child: Text(
                        'Submit',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  )),
            ],
          )),
        ));
  }

  Color getButtonColor(Set<MaterialState> states) {
    if (states.contains(MaterialState.pressed)) {
      return Colors.pink;
    } else {
      return Colors.blue;
    }
  }
}
