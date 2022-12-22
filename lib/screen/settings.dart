import 'dart:convert';

import 'package:dailymemedigest_160419024_160719022/class/profile.dart';
import 'package:dailymemedigest_160419024_160719022/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

// Week 12
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

File? _image;
File? _imageProses;

bool isChecked = false;
int name_hidden = 0;

class Settings extends StatefulWidget {
  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  // Profile? _pr;
  TextEditingController _firstnameCont = TextEditingController();
  TextEditingController _lastnameCont = TextEditingController();

  @override
  void initState() {
    super.initState();
    bacaData();
  }

  Profile _pr = Profile(
      id: 0,
      username: '',
      first_name: '',
      last_name: '',
      register_date: '',
      avatar: '',
      name_hidden: 0);

  Future<String> fetchData() async {
    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160419024/uas/profile.php"),
        body: {'id': user_id.toString()});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  bacaData() {
    fetchData().then((value) {
      Map json = jsonDecode(value);
      _pr = Profile.fromJson(json['data']);
      setState(() {
        _firstnameCont.text = _pr.first_name;
        _lastnameCont.text = _pr.last_name;
        name_hidden = _pr.name_hidden;
        if (name_hidden == 0) {
          isChecked = false;
        } else {
          isChecked = true;
        }
      });
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              color: Colors.white,
              child: new Wrap(
                children: <Widget>[
                  ListTile(
                      tileColor: Colors.white,
                      leading: Icon(Icons.photo_library),
                      title: Text('Galeri'),
                      onTap: () {
                        _imgGaleri();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: new Text('Kamera'),
                    onTap: () {
                      _imgKamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _imgGaleri() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 600,
        maxWidth: 600);
    if (image == null) return;
    // setState(() {
    _image = File(image.path);
    // untuk menampilkan foto nya di layar edit hrs di proses dl
    prosesFoto();
    // });
  }

  _imgKamera() async {
    final picker = ImagePicker();
    final image =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 20);
    if (image == null) return;
    // setState(() {
    _image = File(image.path);
    prosesFoto();
    // });
  }

  void prosesFoto() {
    Future<Directory?> extDir = getTemporaryDirectory();
    extDir.then((value) {
      String _timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final String filePath = '${value?.path}/$_timestamp.jpg';
      _imageProses = File(filePath);
      img.Image? temp = img.readJpg(_image!.readAsBytesSync());
      img.Image temp2 = img.copyResize(temp!, width: 480, height: 640);
      setState(() {
        _imageProses?.writeAsBytesSync(img.writeJpg(temp2));
      });
    });
  }

  void doLogout() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // (key)
      _imageProses = null;
      prefs.remove("user_id");
      prefs.remove("user_name");
      prefs.remove("first_name");
      prefs.remove("last_name");
      main();
    });
  }

  void submit() async {
    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160419024/uas/editprofile.php"),
        body: {
          'name_hidden': isChecked.toString(),
          'firstname': _pr.first_name,
          'lastname': _pr.last_name,
          'id': user_id.toString(),
        });

    if (_imageProses == null) return;
    List<int> imageBytes = _imageProses!.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    final response2 = await http.post(
        Uri.parse('https://ubaya.fun/flutter/160419024/uas/uploadavatar.php'),
        body: {
          'id': user_id.toString(),
          'image': base64Image,
        });
    if (response2.statusCode == 200) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response2.body)));
    }

    if (response.statusCode == 200) {
      print(response.body);
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Sukses mengubah Data')));
      }
    } else {
      throw Exception('Failed to read API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: const Text('Settings'),
        // ),
        body: SingleChildScrollView(
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: FloatingActionButton(
              onPressed: doLogout,
              backgroundColor: Colors.orange,
              child: const Icon(Icons.logout),
            ),
          ),
          Center(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 30, bottom: 20),
                  child: CircleAvatar(
                    radius: 60, // Image radius
                    // backgroundImage: NetworkImage("https://ubaya.fun/flutter/160419024/uas/images/angry_cat.jpg"),
                    child: GestureDetector(
                        onTap: () {
                          _showPicker(context);
                        },
                        child: _imageProses != null
                            ? CircleAvatar(
                                radius: 60,
                                backgroundImage:
                                    Image.file(_imageProses!).image)
                            : CircleAvatar(
                                radius: 60,
                                backgroundImage: NetworkImage(_pr.avatar))),
                  ),
                ),
                Text("$firstname $lastname",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Text("Active since " + _pr.register_date,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text("$activeUsername"),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: TextField(
                    onChanged: (value) {
                      _pr.first_name = value;
                    },
                    controller: _firstnameCont,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'First Name',
                        hintText: 'Enter your first name'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: TextField(
                    onChanged: (value) {
                      _pr.last_name = value;
                    },
                    controller: _lastnameCont,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Last Name',
                        hintText: 'Enter your last name'),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, left: 20),
            child: Row(
              children: [
                Checkbox(
                  checkColor: Colors.white,
                  value: isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      isChecked = value!;
                    });
                  },
                ),
                Text("Hide my name")
              ],
            ),
          ),
          Padding(
              padding: EdgeInsets.only(top: 50),
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
                    'Save Changes',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              )),
        ],
      ),
    ));
  }
}
