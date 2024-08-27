import 'package:animate_do/animate_do.dart';
import 'package:asdamindo/helper/global.dart';
import 'package:asdamindo/home.dart';
import 'package:asdamindo/registrasi.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    checkInit();
    super.initState();
  }

  checkInit() async {
    await preference.initialization();
    if (preference.getData("token") != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (ctx) {
          return HomePage(title: "Asdamindo E-Commerce");
        }),
      );
    }
  }

  TextEditingController user = TextEditingController(text: "");
  TextEditingController pass = TextEditingController(text: "");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 400,
              // decoration: BoxDecoration(
              //   image: DecorationImage(
              //     image: AssetImage('assets/images/background.png'),
              //     fit: BoxFit.fill,
              //   ),
              // ),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    child: FadeInUp(
                      duration: Duration(milliseconds: 1600),
                      child: Container(
                        margin: EdgeInsets.only(top: 0),
                        child: Center(
                          child: Text(
                            "Asdamindo\nE-Commerce",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color.fromRGBO(0, 162, 232, 1),
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(30.0),
              child: Column(
                children: <Widget>[
                  FadeInUp(
                    duration: Duration(milliseconds: 1800),
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        // border: Border.all(
                        //   color: Color.fromRGBO(0, 162, 232, 1),
                        // ),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(143, 148, 251, .2),
                            blurRadius: 20.0,
                            offset: Offset(0, 10),
                          )
                        ],
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(8.0),
                            // decoration: BoxDecoration(
                            //   border: Border(
                            //     bottom: BorderSide(
                            //       color: Color.fromRGBO(0, 162, 232, 1),
                            //     ),
                            //   ),
                            // ),
                            child: TextField(
                              controller: user,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Username / Email",
                                hintStyle: TextStyle(color: Colors.grey[700]),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8.0),
                            child: TextField(
                              controller: pass,
                              obscureText: true,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Password",
                                hintStyle: TextStyle(
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  FadeInUp(
                    duration: Duration(milliseconds: 1900),
                    child: GestureDetector(
                      onTap: () {
                        prosesLogin();
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (ctx) {
                        //     return HomePage(title: "Asdamindo");
                        //   }),
                        // );
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            colors: [
                              Color.fromRGBO(0, 162, 232, 1),
                              Color.fromRGBO(153, 217, 234, 1),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 70,
                  ),
                  Row(
                    children: [
                      FadeInUp(
                        duration: Duration(milliseconds: 2000),
                        child: GestureDetector(
                          onTap: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (ctx) {
                                return RegistrasiPage(title: "Regis");
                              }),
                            );
                          },
                          child: Text(
                            "Butuh akun?",
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Color.fromRGBO(0, 162, 232, 1),
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      // FadeInUp(
                      //   duration: Duration(milliseconds: 2000),
                      //   child: GestureDetector(
                      //     onTap: () async {
                      //       print("Login Nih");
                      //     },
                      //     child: Text(
                      //       "Lupa sandi?",
                      //       style: TextStyle(
                      //         fontStyle: FontStyle.italic,
                      //         color: Color.fromRGBO(251, 204, 143, 1),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> prosesLogin() async {
    global.loadingAlert(context, "Mohon tunggu...", true);
    await pb.collection('users').authWithPassword(user.text, pass.text).then((value) async {
      var vals = value.toJson();
      await preference.setString("token", vals["token"]);
      for (var key in vals["record"].keys) {
        await preference.setString(key, vals["record"][key].toString());
      }
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (ctx) {
          return HomePage(title: "Asdamindo E-Commerce");
        }),
      );
      global.alertSuccess(context, "Berhasil Login");
    }).catchError((err) {
      print(err);
      try {
        ClientException error = err;
        print(error);
        Navigator.pop(context);
        // var dynamicData = error.response["data"];
        // for (var key in dynamicData.keys) {
        //   var valueList = dynamicData[key]!;
        //   global.alertWarning(context, valueList["message"].toString());
        // }
        global.alertWarning(context, "Username / Email & Password salah");
      } catch (err2) {
        Navigator.pop(context);
        print(err2);
      }
    });

    // print(pb.authStore.isValid);
    // print(pb.authStore.token);
    // print(pb.authStore.model.id);
  }
}
