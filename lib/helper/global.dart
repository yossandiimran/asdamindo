// ignore_for_file: file_names, prefer_const_constructors, prefer_interpolation_to_compose_strings, use_build_context_synchronously, deprecated_member_use
import 'dart:convert';
import 'dart:io';
import 'package:asdamindo/helper/preference.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

final pb = PocketBase('http://203.175.10.169:9090');
Preference preference = Preference();
Global global = Global();
var selectIndexNow = 0, appVersion = '2.6.0';
Codec<String, String> stringToBase64 = utf8.fuse(base64);
var now = DateTime.now();

//Default Theme Color
Color defaultBlue = const Color(0xff1572e8),
    defaultRed = const Color(0xffea4d56);
Color defaultOrange = const Color(0xffff910a),
    defaultGreen = const Color(0xff2bb930);
Color defWhite = Colors.white;
Color defBlue = const Color(0xff1572e8), defRed = const Color(0xffea4d56);
Color defOrange = const Color(0xffff910a), defGreen = const Color(0xff2bb930);
Color defGrey = const Color(0xff8d9498), defBlack1 = const Color(0xff1a2035);
Color defBlack2 = const Color(0xff202940);
Color defPurple = const Color(0xff6861ce), defPurple2 = const Color(0xff5c55bf);
Color defOrange2 = const Color(0xffe7a92c), defblue2 = const Color(0xff22328f);
Color defTaro1 = const Color(0xff8894c4), defTaro2 = const Color(0xffa4a9cf);
Color defTaro3 = const Color(0xff7c8cbc), defwheat = const Color(0xfff6d99c);
var defblue3 = Colors.blue[100],
    defred2 = Colors.red[100],
    defgreen2 = Colors.green[100];
var deforg3 = Colors.orange[200],
    defyel = Colors.yellow[100],
    defteal = Colors.teal[100];

//Global Temp Variable
var qrVariable = "-", qrSpk = "-", qrRakAwl = "-", qrRakAkh = "-", zplBar = "";
var tempDate = DateTime.now();

class Global {
  late String name, email, token, typeUser;
  getWidth(context) => MediaQuery.of(context).size.width;
  getHeight(context) => MediaQuery.of(context).size.height;

  //Handle Service ===============================================================
  var baseUrl = '/user-center/public/api/';
  // var baseUrl = '/sum-app/public/api/';
  var trxUrl = '/busaprod/public/api/';

  //BASE IP PUBLIC DEFAULT PRD
  // var baseIp = '192.168.1.128';
  //BASE IP PUBLIC DEFAULT DEV
  var baseIp = 'http://203.175.10.169:9090';

  defaulterrorResponsePop(context, message) => alertWarning(context, message);

  defaultsuccessResponsePop(context, message) => alertSuccess(context, message);

  errorResponse(context, message) {
    alertWarning(context, message);
  }

  errorResponseNavigate(context, message, route) {
    Navigator.pushNamed(context, route);
    alertWarning(context, message);
  }

  successResponse(context, message) {
    alertSuccess(context, message);
  }

  successResponseNavigate(context, message, route) {
    Navigator.pushNamed(context, route);
    alertSuccess(context, message);
  }

  errorResponsePop(context, message) {
    Navigator.pop(context);
    alertWarning(context, message);
  }

  successResponsePop(context, message) {
    Navigator.pop(context);
    alertSuccess(context, message);
  }

  //Simple Alert =================================================================
  alertWarning(context, text) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          contentPadding: const EdgeInsets.only(top: 10.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange[400],
                size: getWidth(context) / 8,
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: Text(
                  "$text",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: getWidth(context) / 20),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  alertSuccess(context, text) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          contentPadding: const EdgeInsets.only(top: 10.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle_outline_outlined,
                color: Colors.greenAccent,
                size: getWidth(context) / 8,
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: Text(
                  "$text",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: getWidth(context) / 20),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  loadingAlert(context, text, disabled) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          child: AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            contentPadding: const EdgeInsets.only(top: 10.0),
            content: Container(
              height: getWidth(context) / 3,
              margin: const EdgeInsets.all(10),
              child: Column(
                children: [
                  const Spacer(),
                  const CircularProgressIndicator(),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: Text(
                      "$text",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: getWidth(context) / 20),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
          onWillPop: () => disabled,
        );
      },
    );
  }

  alertConfirmExit(context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          contentPadding: const EdgeInsets.only(top: 10.0),
          content: SizedBox(
            height: getWidth(context) / 3,
            child: Column(
              children: [
                Spacer(),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: Text(
                    "Keluar dari Aplikasi ?",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: getWidth(context) / 20),
                  ),
                ),
                Spacer(),
                Row(
                  children: [
                    Spacer(),
                    GestureDetector(
                      onTap: () => exit(0),
                      child: Container(
                        decoration: decCont2(defaultRed, 10, 10, 10, 10),
                        padding: EdgeInsets.only(
                            left: 25, right: 25, top: 10, bottom: 10),
                        child:
                            Text("   Ya   ", style: styleText6(14, defWhite)),
                      ),
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        decoration: decCont2(defaultBlue, 10, 10, 10, 10),
                        padding: EdgeInsets.only(
                            left: 20, right: 20, top: 10, bottom: 10),
                        child: Text("Tidak", style: styleText6(14, defWhite)),
                      ),
                    ),
                    Spacer(),
                  ],
                ),
                Spacer(),
              ],
            ),
          ),
        );
      },
    );
  }

  alertLogout(context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          contentPadding: const EdgeInsets.only(top: 10.0),
          content: SizedBox(
            height: getWidth(context) / 3,
            child: Column(
              children: [
                Spacer(),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: Text(
                    "Keluar dari akun anda ?",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: getWidth(context) / 20),
                  ),
                ),
                Spacer(),
                Row(
                  children: [
                    Spacer(),
                    GestureDetector(
                      onTap: () async {
                        preference.clearPreference();
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: decCont2(defaultRed, 10, 10, 10, 10),
                        padding: EdgeInsets.only(
                            left: 25, right: 25, top: 10, bottom: 10),
                        child:
                            Text("   Ya   ", style: styleText6(14, defWhite)),
                      ),
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        decoration: decCont2(defaultBlue, 10, 10, 10, 10),
                        padding: EdgeInsets.only(
                            left: 20, right: 20, top: 10, bottom: 10),
                        child: Text("Tidak", style: styleText6(14, defWhite)),
                      ),
                    ),
                    Spacer(),
                  ],
                ),
                const Spacer(),
              ],
            ),
          ),
        );
      },
    );
  }
  //End Of Alert =================================================================

  //Styling ======================================================================
  styleText1() => const TextStyle(color: Colors.grey);
  styleText2(double size) =>
      TextStyle(color: defWhite, fontWeight: FontWeight.bold, fontSize: size);
  styleText3(double size) => TextStyle(color: defWhite, fontSize: size);
  styleText4(double size) => TextStyle(color: Colors.black, fontSize: size);
  styleText5(double size, Color color) =>
      TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: size);
  styleText6(double size, Color color) =>
      TextStyle(color: color, fontSize: size);
  radiusVal(radius) => Radius.circular(radius);

  decorationContainer1(color, radius) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.all(radiusVal(radius)),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 2,
          blurRadius: 7,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }

  decorationContainer2(color, radius) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.all(radiusVal(radius)),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 5,
          blurRadius: 7,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }

  decorationContainer3(color, radius) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.all(radiusVal(radius)),
    );
  }

  decorationContainerGradient(color1, color2, radius) {
    return BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color1, color2]),
      borderRadius: BorderRadius.all(radiusVal(radius)),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 2,
          blurRadius: 7,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }

  decorationGradient3Color(color1, color2, bl, br, tl, tr) {
    return BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color1, color2]),
      borderRadius: BorderRadius.only(
        bottomLeft: radiusVal(bl),
        topLeft: radiusVal(tl),
        topRight: radiusVal(tr),
        bottomRight: radiusVal(br),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 2,
          blurRadius: 7,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }

  decorationGradient4Color(color1, color2, color3, bl, br, tl, tr) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [defBlack1, defblue2, defWhite],
        // colors: [Colors.red, Colors.yellow, Colors.green, Colors.blue],
      ),
      // gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [color1, color2, color3]),
      borderRadius: BorderRadius.only(
        bottomLeft: radiusVal(bl),
        topLeft: radiusVal(tl),
        topRight: radiusVal(tr),
        bottomRight: radiusVal(br),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 2,
          blurRadius: 7,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }

  decCont2(color, double radiusBl, double radiusBr, double radiusTl,
      double radiusTr) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.only(
        bottomLeft: radiusVal(radiusBl),
        bottomRight: radiusVal(radiusBr),
        topLeft: radiusVal(radiusTl),
        topRight: radiusVal(radiusTr),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 5,
          blurRadius: 7,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }

  decCont(color, double radiusBl, double radiusBr, double radiusTl,
      double radiusTr) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.only(
        bottomLeft: radiusVal(radiusBl),
        bottomRight: radiusVal(radiusBr),
        topLeft: radiusVal(radiusTl),
        topRight: radiusVal(radiusTr),
      ),
    );
  }

  textInputDecoration(name, icon, colors) {
    return InputDecoration(
      prefixIcon: icon != null ? Icon(icon, color: colors) : null,
      labelText: name,
      labelStyle: TextStyle(color: defaultBlue),
      enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
    );
  }

  textInputDecoration2(name, icon, colors) {
    return InputDecoration(
      prefixIcon: icon != null ? Icon(icon, color: colors) : null,
      hintText: name,
      labelStyle: TextStyle(color: defaultBlue),
      enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
    );
  }

  String formatRupiah(double amount) {
    // Konversi angka ke string dan pecah menjadi bagian ribuan
    String amountString = amount.toStringAsFixed(0); // Menghilangkan desimal
    List<String> parts = [];

    for (int i = amountString.length; i > 0; i -= 3) {
      int start = (i - 3 < 0) ? 0 : i - 3;
      parts.insert(0, amountString.substring(start, i));
    }

    // Gabungkan dengan tanda titik sebagai pemisah ribuan
    String formatted = parts.join('.');

    // Tambahkan simbol Rp di depan
    return 'Rp $formatted';
  }

  // Keranjang Belanja
  Future<void> addToCart(object, context, cntCart) async {
    var checkCart = await preference.getData("cart"), msg = "menambahkan ke";
    object["qty"] = cntCart;
    Map tempCart;

    if (checkCart == null) {
      tempCart = {
        "cart": [object]
      };
    } else {
      tempCart = jsonDecode(utf8.decode(base64.decode(checkCart)));
      Map<String, dynamic>? targetElemen = tempCart['cart'].firstWhere(
        (elemen) => elemen['id'] == object["id"],
        orElse: () => null,
      );
      if (targetElemen != null) {
        if (cntCart == 0) {
          tempCart['cart']
              .removeWhere((elemen) => elemen['id'] == object["id"]);
          msg = "menghapus dari";
        } else {
          msg = "mengupdate ke";
          targetElemen["qty"] = cntCart;
        }
      } else {
        tempCart["cart"].add(object);
      }
    }
    await preference.setString(
        "cart", base64Encode(utf8.encode(jsonEncode(tempCart))));
    if (msg != "menghapus dari") {
      alertSuccess(context, "Berhasil $msg keranjang");
    }
  }

  alertConfirmation({
    required BuildContext context,
    required var action,
    required String message,
    String ok = '   Ya   ',
    String no = 'Tidak',
    bool isPop = true,
  }) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            return isPop;
          },
          child: AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: global.getWidth(context) / 20),
                  ),
                ),
                Row(
                  children: [
                    Spacer(),
                    GestureDetector(
                      onTap: action,
                      child: Container(
                        decoration: decCont2(defBlue, 10, 10, 10, 10),
                        padding: EdgeInsets.only(
                            left: 25, right: 25, top: 10, bottom: 10),
                        child: Text(" $ok ", style: styleText5(14, defWhite)),
                      ),
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        decoration: decCont2(defRed, 10, 10, 10, 10),
                        padding: EdgeInsets.only(
                            left: 20, right: 20, top: 10, bottom: 10),
                        child: Text(" $no ", style: styleText5(14, defWhite)),
                      ),
                    ),
                    Spacer(),
                  ],
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }
}
