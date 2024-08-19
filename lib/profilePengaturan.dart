import 'package:animate_do/animate_do.dart';
import 'package:asdamindo/helper/global.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

class PengaturanProfile extends StatefulWidget {
  const PengaturanProfile({super.key, required this.title});
  final String title;
  @override
  State<PengaturanProfile> createState() => _PengaturanProfileState();
}

class _PengaturanProfileState extends State<PengaturanProfile> {
  TextEditingController email = TextEditingController(text: "");
  TextEditingController user = TextEditingController(text: "");
  TextEditingController pass = TextEditingController(text: "");
  TextEditingController nama = TextEditingController(text: "");
  TextEditingController noHp = TextEditingController(text: "");
  TextEditingController alamat = TextEditingController(text: "");
  TextEditingController npwp = TextEditingController(text: "");
  TextEditingController kota = TextEditingController(text: "");
  TextEditingController sk = TextEditingController(text: "");
  TextEditingController kodePos = TextEditingController(text: "");

  @override
  void initState() {
    getInitDataPreference();
    super.initState();
  }

  getInitDataPreference() async {
    email.text = preference.getData("email");
    user.text = preference.getData("username");
    pass.text = preference.getData("pass") ?? "9999999";
    nama.text = preference.getData("nama");
    noHp.text = preference.getData("nomor_hp");
    alamat.text = preference.getData("alamat");
    npwp.text = preference.getData("npwp");
    kota.text = preference.getData("kota");
    sk.text = preference.getData("sk");
    kodePos.text = preference.getData("kodePos");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Profile")),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            Container(
              child: Stack(
                children: <Widget>[
                  Positioned(
                    child: FadeInUp(
                      duration: Duration(milliseconds: 1600),
                      child: Container(
                        child: Center(
                          child: Text(
                            "Profile",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
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
                        border: Border.all(
                          color: Color.fromRGBO(143, 148, 251, 1),
                        ),
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
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Color.fromRGBO(143, 148, 251, 1),
                                ),
                              ),
                            ),
                            child: TextField(
                              controller: email,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Email",
                                hintStyle: TextStyle(color: Colors.grey[700]),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Color.fromRGBO(143, 148, 251, 1),
                                ),
                              ),
                            ),
                            child: TextField(
                              controller: user,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Username",
                                hintStyle: TextStyle(color: Colors.grey[700]),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Color.fromRGBO(143, 148, 251, 1),
                                ),
                              ),
                            ),
                            child: TextField(
                              controller: pass,
                              obscureText: true,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Password",
                                hintStyle: TextStyle(color: Colors.grey[700]),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Color.fromRGBO(143, 148, 251, 1),
                                ),
                              ),
                            ),
                            child: TextField(
                              controller: nama,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Nama",
                                hintStyle: TextStyle(color: Colors.grey[700]),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Color.fromRGBO(143, 148, 251, 1),
                                ),
                              ),
                            ),
                            child: TextField(
                              controller: sk,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "SK",
                                hintStyle: TextStyle(color: Colors.grey[700]),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Color.fromRGBO(143, 148, 251, 1),
                                ),
                              ),
                            ),
                            child: TextField(
                              controller: npwp,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "NPWP",
                                hintStyle: TextStyle(color: Colors.grey[700]),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Color.fromRGBO(143, 148, 251, 1),
                                ),
                              ),
                            ),
                            child: TextField(
                              controller: noHp,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Nomor Hp",
                                hintStyle: TextStyle(color: Colors.grey[700]),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Color.fromRGBO(143, 148, 251, 1),
                                ),
                              ),
                            ),
                            child: TextField(
                              controller: alamat,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Alamat",
                                hintStyle: TextStyle(color: Colors.grey[700]),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Color.fromRGBO(143, 148, 251, 1),
                                ),
                              ),
                            ),
                            child: TextField(
                              controller: kota,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Kota",
                                hintStyle: TextStyle(color: Colors.grey[700]),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8.0),
                            child: TextField(
                              controller: kodePos,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Kode Pos",
                                hintStyle: TextStyle(
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                          ),
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
                      onTap: () => prosesUbahData(),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            colors: [
                              Color.fromRGBO(143, 148, 251, 1),
                              Color.fromRGBO(143, 148, 251, .6),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Ubah Data",
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
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> prosesUbahData() async {
    global.loadingAlert(context, "Mohon tunggu...", true);
    // example create body
    final body = <String, dynamic>{
      "username": user.text,
      "email": email.text,
      "emailVisibility": true,
      "password": pass.text,
      "passwordConfirm": pass.text,
      "nama": nama.text,
      "nomor_hp": noHp.text,
      "npwp": npwp.text,
      "sk": sk.text,
      "alamat": alamat.text,
      "kota": kota.text,
      "kode_pos": kodePos.text,
      "is_member": true
    };

    await pb.collection('users').create(body: body).then((value) {
      print(value);
      Navigator.pop(context);
      Navigator.pop(context);
      global.alertSuccess(context, "Registrasi Berhasil");
    }).catchError((err) {
      ClientException error = err;
      Navigator.pop(context);
      var dynamicData = error.response["data"];
      for (var key in dynamicData.keys) {
        var valueList = dynamicData[key]!;
        return global.alertWarning(context, valueList["message"].toString());
      }
    });
  }
}
