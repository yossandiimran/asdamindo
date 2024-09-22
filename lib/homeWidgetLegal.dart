import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:asdamindo/helper/global.dart';

class HomeWidgetLegal extends StatefulWidget {
  const HomeWidgetLegal({super.key});
  @override
  State<HomeWidgetLegal> createState() => _HomeWidgetLegalState();
}

class _HomeWidgetLegalState extends State<HomeWidgetLegal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Informasi Legalitas'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Title Section
            Text(
              'Kami Siap Membantu Kesulitan Dalam Mengurus Legalitas Depot Air Minum Seluruh Indonesia',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            // Information Section
            Text(
              'Legalitas Depot Air Minum diantaranya:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),

            // Legalitas List
            buildBulletList([
              'Izin Usaha Depot, NIB dan Sertifikat Standart',
              'Sertifikat Pelatihan Depot Air Minum',
              'Sertifikat Laik Hygienis Sehat DAMIU',
              'Uji Labkes',
              'Keanggotaan Registrasi Asosiasi',
            ]),

            SizedBox(height: 16),

            // Explanation Section
            Text(
              'Sulitnya Mengurus Legalitas Ini, Kami siap Bantu.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),

            Text(
              'Asosiasi Berfungsi Sebagai:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Mitra Pemerintah Terkait, Pengawas bagi Para Pengusaha DAMIU, dan Membantu dalam Legalitas. Adapun Pelanggaran dari Para Pengusaha DAMIU, Pihak Asosiasi berhak untuk Menegur dan Meneruskannya kepada Pemerintah yang Berwenang. Di Daerah Tertentu Sudah diadakan pemeriksaan oleh Instansi yang Berwenang. Kita Dari Pihak Asosiasi akan Membantu Keluhan Dalam Legalitas dan Dapat Membantu Mendapatkan Legalitas Tersebut.',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 16),

            // Acuan Sanksi Section
            Text(
              'Acuan Sanksi:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),

            // Acuan Sanksi List
            buildBulletList([
              'Kepmenperindag 651/2004',
              'Permenkes 43/2014',
              'UU No 8/1999 Tentang Perlindungan Konsumen',
            ]),

            SizedBox(height: 32),
            // Footer Section
            Text(
              'Kami siap bantu keluhan terkait legalitas dan mempermudah mendapatkan legalitas depot air minum.',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent),
            ),
            SizedBox(height: 10),
            Center(
              child: GestureDetector(
                onTap: () async {
                  var text =
                      'Halo Admin, saya ingin menanyakan tentang legalitas depot air minum.';

                  final encodedText = Uri.encodeComponent(text);
                  final url = 'https://wa.me/6282295246660?text=${encodedText}';
                  await launchUrlString(
                    url,
                    mode: LaunchMode.externalApplication,
                  );
                },
                child: Container(
                  width: global.getWidth(context) / 2,
                  padding: EdgeInsets.all(15),
                  decoration: global.decCont2(defGreen, 10, 10, 10, 10),
                  child: Row(
                    children: [
                      Spacer(),
                      Icon(Icons.message, color: defWhite),
                      Spacer(),
                      Text("Hubungi Via Whatsapp",
                          style: global.styleText5(14, defWhite)),
                      Spacer(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build a bullet point list
  Widget buildBulletList(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('• ', style: TextStyle(fontSize: 16)),
              Expanded(child: Text(item, style: TextStyle(fontSize: 14))),
            ],
          ),
        );
      }).toList(),
    );
  }
}
