import 'dart:convert';
import 'dart:html';

import 'package:dailymemedigest_160419024_160719022/class/Meme.dart';
import 'package:dailymemedigest_160419024_160719022/main.dart';
import 'package:dailymemedigest_160419024_160719022/screen/addreport.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String comment = '';

class DetailMemes extends StatefulWidget {
  int memesID;
  DetailMemes({super.key, required this.memesID});
  @override
  State<StatefulWidget> createState() {
    return _DetailMemesState();
  }
}

class _DetailMemesState extends State<DetailMemes> {
  final _formKey = GlobalKey<FormState>();
  Meme? _m;

  @override
  void initState() {
    super.initState();
    bacaData();
  }

  void submit() async {
    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160419024/uas/newcomment.php"),
        body: {
          'users_id': user_id.toString(),
          'memes_id': widget.memesID.toString(),
          'comment': comment,
        });
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Sukses Menambah Komentar')));
        bacaData();
      }
    } else {
      throw Exception('Failed to read API');
    }
  }

  bacaData() {
    fetchData().then((value) {
      Map json = jsonDecode(value);
      _m = Meme.fromJson(json['data']);
      setState(() {});
    });
  }

  Future<String> fetchData() async {
    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160419024/uas/detail_memes.php"),
        body: {'id': widget.memesID.toString()});
    if (response.statusCode == 200) {
      return response.body;
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
                      image: NetworkImage(_m!.image),
                      fit: BoxFit.fill,
                      width: 500,
                      height: 300),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Text(_m!.up_text,
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
                          _m!.down_text,
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
                  padding: const EdgeInsets.all(10.0),
                  child: Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.favorite,
                                  size: 30,
                                  color: Colors.red,
                                ),
                                onPressed: () {},
                              ),
                              Text(_m!.like.toString() + " likes"),
                              IconButton(
                                icon: Icon(
                                  Icons.flag,
                                  size: 30,
                                  color: Color.fromARGB(255, 156, 135, 133),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AddReport(
                                                memesID: _m!.id)));
                                },
                              ),
                            ],
                          )
                        ]),
                  )),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  height: MediaQuery.of(context).size.height - 450,
                  child: daftarComment(_m!.comments),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(children: [
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        style: TextStyle(fontSize: 16.0),
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          hintText: "Write Comments",
                          suffixIcon: Align(
                            widthFactor: 1.0,
                            heightFactor: 1.0,
                            child: IconButton(
                              icon: Icon(
                                Icons.send,
                              ),
                              onPressed: () {
                                submit();
                              },
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            comment = value;
                          });
                        },
                      ))
                ]),
              )
            ],
          )),
        ));
  }

  Widget daftarComment(com) {
    if (com != null) {
      return ListView.builder(
          itemCount: com.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return Padding(
              padding: EdgeInsets.all(5),
              child: Card(
                color: Colors.grey.shade300,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                                _m!.comments?[index]['first_name'] +
                                    " " +
                                    _m!.comments?[index]['last_name'],
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_m?.comments?[index]['comment']),
                              Text(_m?.comments?[index]['date_comment'])
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          });
    } else {
      return CircularProgressIndicator();
    }
  }

  Color getButtonColor(Set<MaterialState> states) {
    if (states.contains(MaterialState.pressed)) {
      return Colors.pink;
    } else {
      return Colors.blue;
    }
  }
}
