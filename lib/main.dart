import 'dart:convert';

import 'package:dailymemedigest_160419024_160719022/screen/addmeme.dart';
import 'package:dailymemedigest_160419024_160719022/screen/home.dart';
import 'package:dailymemedigest_160419024_160719022/screen/leaderboard.dart';
import 'package:dailymemedigest_160419024_160719022/screen/mycreation.dart';
import 'package:dailymemedigest_160419024_160719022/screen/settings.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'screen/register.dart';

String error_login = "";
bool error_login_show = false;
String activeUsername = "";
String firstname = "";
String lastname = "";
int user_id = 0;

// Cek user sudah pernah login atau belum
Future<int> checkUser() async {
  final prefs = await SharedPreferences.getInstance();
  int userID = prefs.getInt("user_id") ?? 0;
  return userID;
}

Future<String> checkUsername() async {
  final prefs = await SharedPreferences.getInstance();
  String username = prefs.getString("user_name") ?? '';
  return username;
}

Future<String> checkFirstname() async {
  final prefs = await SharedPreferences.getInstance();
  String firstname = prefs.getString("first_name") ?? '';
  return firstname;
}

Future<String> checkLastname() async {
  final prefs = await SharedPreferences.getInstance();
  String lastname = prefs.getString("last_name") ?? '';
  return lastname;
}

void main() {
  // runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  checkUser().then((int result) {
    // Jika di shared preference blm ada isinya maka tampilkan halaman login, kalau sudah tampilkan home.
    if (result == 0)
      runApp(MyLogin());
    else {
      // activeUser = result;
      runApp(MyApp());
      user_id = result;
    }
  });

  checkUsername().then((String result) {
    activeUsername = result;
  });

  checkFirstname().then((String result) {
    firstname = result;
  });

  checkLastname().then((String result) {
    lastname = result;
  });
}

//Login
class MyLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Login(),
    );
  }
}

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  String _userName = "";
  String _userPassword = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Sign In'),
        ),
        body: Container(
          child: Column(children: [
            Image(
                image: AssetImage("images/memes_face.jpeg"),
                fit: BoxFit.fitWidth,
                width: 200,
                height: 240),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text("Daily Meme Digest",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                onChanged: (value) {
                  _userName = value;
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
                  _userPassword = value;
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
              // child: Text(error_login_show ? "$error_login" : "",
              //         style: TextStyle(color: Colors.red),
              //       ),
            ),
            Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  height: 50,
                  width: 300,
                  decoration: BoxDecoration(
                      // color: Colors.blue,
                      borderRadius: BorderRadius.circular(20)),
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Register()));
                    },
                    child: Text(
                      'Create Account',
                      style: TextStyle(color: Colors.blue, fontSize: 25),
                    ),
                  ),
                )),
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
                      doLogin();
                    },
                    child: Text(
                      'Sign In',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                )),
          ]),
        ));
  }

  void doLogin() async {
    final prefs = await SharedPreferences.getInstance();

    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160419024/uas/login.php"),
        body: {'username': _userName, 'password': _userPassword});
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        final prefs = await SharedPreferences.getInstance();
        prefs.setInt("user_id", json['id']);
        prefs.setString("user_name", _userName);
        prefs.setString("first_name", json['first_name']);
        prefs.setString("last_name", json['last_name']);
        main();
      } else {
        setState(() {
          error_login = "Incorrect user or password";
          error_login_show = !error_login_show;
        });
      }
    } else {
      throw Exception('Failed to read API');
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      routes: {
        'settings': (context) => Settings(),
        'addmeme': (context) => AddMemes(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int _currentIndex = 0;
  final List<Widget> _screens = [
    Home(),
    MyCreation(),
    Leaderboard(),
    Settings(),
  ];

// Buat nama pagenya, diambil sesuai index
  final List<String> _title = [
    'Home',
    'My Creations',
    'Leaderboards',
    'Settings'
  ];

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.

        // Nama halaman sesuai index list yang sudah dibuat
        title: Text(_title[_currentIndex]),
      ),
      body: _screens[_currentIndex],
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ),

      bottomNavigationBar: myBottomNavBar(),
      drawer: myDrawer(),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  // Method
  BottomNavigationBar myBottomNavBar() {
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        fixedColor: Colors.blue,
        items: const [
          BottomNavigationBarItem(
            label: "Home",
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: "My Creations",
            icon: Icon(Icons.face_unlock_sharp),
          ),
          BottomNavigationBarItem(
            label: "Leaderboards",
            icon: Icon(Icons.leaderboard_outlined),
          ),
          BottomNavigationBarItem(label: "Setting", icon: Icon(Icons.settings)),
        ],
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        });
  }

  Drawer myDrawer() {
    return Drawer(
      elevation: 16.0,
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
              accountName: Text("$firstname $lastname"),
              accountEmail: Text("$activeUsername"),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://ubaya.fun/flutter/160419024/uas/images/$user_id.jpg"),
              ),
              otherAccountsPictures: [
                Align(
                  alignment: Alignment.topRight,
                  child: FloatingActionButton(
                    onPressed: doLogout,
                    backgroundColor: Colors.orange,
                    child: const Icon(Icons.logout),
                  ),
                ),
              ]),
          ListTile(
            title: Text("Home "),
            leading: Icon(Icons.home),
            onTap: () {
              Navigator.pushNamed(context, "home");
            },
          ),
          ListTile(
            title: Text("My Creation"),
            leading: Icon(Icons.face_unlock_sharp),
            onTap: () {
              // Navigator.pushNamed(context, "my_creation");
              Navigator.pushNamed(context, "addmeme");
            },
          ),
          ListTile(
            title: Text("Leaderboards "),
            leading: Icon(Icons.leaderboard),
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder: (context) => About()));
              Navigator.pushNamed(context, "leaderboards");
            },
          ),
          ListTile(
            title: Text("Settings "),
            leading: Icon(Icons.settings),
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder: (context) => About()));
              Navigator.pushNamed(context, "settings");
            },
          ),
          // ListTile(
          //   title: Text("Logout"),
          //   leading: Icon(Icons.logout),
          //   onTap: () {
          //     // Navigator.push(context, MaterialPageRoute(builder: (context) => About()));
          //     doLogout();
          //   },
          // ),
        ],
      ),
    );
  }

  void doLogout() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // (key)
      // _imageProses = null;
      prefs.remove("user_id");
      prefs.remove("user_name");
      prefs.remove("first_name");
      prefs.remove("last_name");
      main();
    });
  }
}
