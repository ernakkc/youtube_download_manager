import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';

class KutuphaneEkrani extends StatefulWidget {
  @override
  _KutuphaneEkraniState createState() => _KutuphaneEkraniState();
}

class _KutuphaneEkraniState extends State<KutuphaneEkrani> {
  List<FileSystemEntity> _dosyalar = [];
  bool _yukleniyor = true;

  @override
  void initState() {
    super.initState();
    _dosyalariGetir();
  }

  Future<void> _dosyalariGetir() async {
    setState(() {
      _yukleniyor = true;
    });

    // Yapay bir gecikme ekleyelim ki "Çek-Yenile" animasyonunu görebilelim
    await Future.delayed(Duration(milliseconds: 500));

    final directory = await getApplicationDocumentsDirectory();
    final tumDosyalar = directory.listSync();

    final videoDosyalari = tumDosyalar.where((dosya) {
      return dosya.path.endsWith('.mp4');
    }).toList();

    // En son indirilen en üstte görünsün (Tarihe göre ters sırala)
    // Not: Dosya sisteminden tarih bilgisi almak biraz daha kod gerektirir,
    // şimdilik listeyi ters çevirelim (basit yöntem).
    setState(() {
      _dosyalar = videoDosyalari.reversed.toList();
      _yukleniyor = false;
    });
  }

  Future<void> _dosyayiSil(FileSystemEntity dosya) async {
    try {
      await dosya.delete();
      // Listeden de silmeliyiz ki ekran güncellensin
      setState(() {
        _dosyalar.remove(dosya);
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Video silindi.")));
    } catch (e) {
      print("Silinemedi: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Kütüphanem 🎬")),
      // 1. ÖZELLİK: RefreshIndicator (Çek-Yenile)
      body: RefreshIndicator(
        onRefresh: _dosyalariGetir, // Aşağı çekince bu fonksiyon çalışsın
        color: Colors.red, // Yükleme ikonu rengi
        child: _yukleniyor
            ? Center(child: CircularProgressIndicator())
            : _dosyalar.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.movie_creation_outlined,
                      size: 80,
                      color: Colors.grey,
                    ),
                    Text("Kütüphane boş."),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: _dosyalar.length,
                itemBuilder: (context, index) {
                  final dosya = _dosyalar[index];
                  final dosyaAdi = dosya.path.split('/').last;

                  // 2. ÖZELLİK: Dismissible (Kaydır-Sil)
                  return Dismissible(
                    key: Key(
                      dosya.path,
                    ), // Her satırın benzersiz kimliği olmalı
                    direction:
                        DismissDirection.endToStart, // Sadece sağdan sola
                    // Arkadaki Kırmızı Fon (Kaydırınca görünen)
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Icon(
                        Icons.delete_forever,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),

                    // Silme işlemi onaylanırsa ne olsun?
                    onDismissed: (direction) {
                      _dosyayiSil(dosya);
                    },

                    // Kartın kendisi
                    child: Card(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      elevation: 2,
                      child: ListTile(
                        leading: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.play_arrow, color: Colors.red),
                        ),
                        title: Text(
                          dosyaAdi,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text("Videoyu açmak için tıkla"),
                        onTap: () => OpenFilex.open(dosya.path),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
