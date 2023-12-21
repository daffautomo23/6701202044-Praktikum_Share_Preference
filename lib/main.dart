import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kalkulator',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HalamanUtama(),
    );
  }
}

class HalamanUtama extends StatefulWidget {
  @override
  _HalamanUtamaState createState() => _HalamanUtamaState();
}

class _HalamanUtamaState extends State<HalamanUtama> {
  TextEditingController controllerAngkaPertama = TextEditingController();
  TextEditingController controllerAngkaKedua = TextEditingController();
  TextEditingController controllerOperasi = TextEditingController();

  _simpanHasilOperasi(double hasil, String operasi) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('hasil', hasil);
    await prefs.setString('operasi', operasi);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kalkulator')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: controllerAngkaPertama,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Angka Pertama"),
            ),
            TextField(
              controller: controllerAngkaKedua,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Angka Kedua"),
            ),
            TextField(
              controller: controllerOperasi,
              decoration: InputDecoration(labelText: "Operasi (+, -, *, /)"),
            ),
            ElevatedButton(
              onPressed: () {
                double angkaPertama = double.parse(controllerAngkaPertama.text);
                double angkaKedua = double.parse(controllerAngkaKedua.text);
                double hasil = 0.0;
                switch (controllerOperasi.text) {
                  case "+":
                    hasil = angkaPertama + angkaKedua;
                    break;
                  case "-":
                    hasil = angkaPertama - angkaKedua;
                    break;
                  case "*":
                    hasil = angkaPertama * angkaKedua;
                    break;
                  case "/":
                    hasil = angkaPertama / angkaKedua;
                    break;
                }
                _simpanHasilOperasi(hasil, controllerOperasi.text);
              },
              child: Text('Hitung'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HalamanHasil()));
              },
              child: Text('Tampilkan Hasil'),
            )
          ],
        ),
      ),
    );
  }
}

class HalamanHasil extends StatefulWidget {
  @override
  _HalamanHasilState createState() => _HalamanHasilState();
}

class _HalamanHasilState extends State<HalamanHasil> {
  double? hasil;
  String? operasi;

  @override
  void initState() {
    super.initState();
    _muatHasilOperasi();
  }

  _muatHasilOperasi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      hasil = prefs.getDouble('hasil');
      operasi = prefs.getString('operasi');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hasil')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text('Operasi yang dilakukan: $operasi'),
            Text('Hasil: $hasil'),
          ],
        ),
      ),
    );
  }
}
