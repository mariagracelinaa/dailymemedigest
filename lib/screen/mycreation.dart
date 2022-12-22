import 'dart:convert';
import 'package:dailymemedigest_160419024_160719022/main.dart';
import 'package:dailymemedigest_160419024_160719022/screen/detailmeme.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../class/Meme.dart';

class MyCreation extends StatefulWidget {
  @override
  State<MyCreation> createState() => _MyCreationState();
}

class _MyCreationState extends State<MyCreation> {
  String _temp = 'waiting API respond…';
  List<Meme> Ms = [];

  Future<String> fetchData() async {
    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160419024/uas/mymemes.php"),
        body: {'id': user_id.toString()});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  Widget DaftarMemes(data) {
    // List<PopMovie> PMs2 = [];
    Map json = jsonDecode(data);
    for (var mov in json['data']) {
      Meme pm = Meme.fromJson(mov);
      Ms.add(pm);
    }
    return ListView.builder(
        itemCount: Ms.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return new Card(
              child: Container(
            color: Ms[index].visible == 0 ? Colors.red : Colors.white,
            child: Column(
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 5),
                  child: Stack(children: [
                    Image(
                        image: NetworkImage(Ms[index].image),
                        fit: BoxFit.fill,
                        width: 500,
                        height: 300),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Text(Ms[index].up_text,
                          style: TextStyle(
                            fontSize: 25,
                            fontFamily: 'Impact',
                            color: Colors.white,
                          )),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 290,
                      alignment: Alignment.bottomCenter,
                      child: Stack(
                        children: [
                          Text(
                            Ms[index].down_text,
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
                                Icon(Icons.favorite,
                                    size: 30, color: Colors.red),
                                Text(Ms[index].like.toString() + " likes"),
                              ],
                            ),
                            Row(
                              children: [
                                Text("x comments"),
                                IconButton(
                                  icon: Icon(
                                    Icons.comment,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => DetailMemes(
                                                memesID: Ms[index].id)));
                                  },
                                ),
                              ],
                            )
                          ]),
                    ))
              ],
            ),
          ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("Daily Meme Digest")),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                height: MediaQuery.of(context).size.height,
                child: FutureBuilder(
                    future: fetchData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          return Text("Error! ${snapshot.error}");
                        } else if (snapshot.hasData) {
                          return DaftarMemes(snapshot.data.toString());
                        } else {
                          return const Text("No data");
                        }
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    })),
          )
        ],
      ),
    );
  }
}
