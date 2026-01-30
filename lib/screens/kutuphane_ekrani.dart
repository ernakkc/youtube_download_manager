import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';

class KutuphaneEkrani extends StatefulWidget {
  const KutuphaneEkrani({super.key});

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
      ).showSnackBar(
        SnackBar(
          content: Text("Video silindi."),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print("Silinemedi: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(
          content: Text("Silme hatası: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _dosyaBoyutunuAl(FileSystemEntity dosya) {
    try {
      if (dosya is File) {
        final bytes = dosya.lengthSync();
        if (bytes < 1024 * 1024) {
          return '${(bytes / 1024).toStringAsFixed(1)} KB';
        } else if (bytes < 1024 * 1024 * 1024) {
          return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
        } else {
          return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
        }
      }
      return 'Bilinmiyor';
    } catch (e) {
      return 'Bilinmiyor';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kütüphanem"),
        backgroundColor: Colors.red[700],
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.red[50]!, Colors.white],
          ),
        ),
        child: RefreshIndicator(
          onRefresh: _dosyalariGetir,
          color: Colors.red[700],
          child: _yukleniyor
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Yükleniyor...',
                        style: TextStyle(color: Colors.red[600], fontSize: 16),
                      ),
                    ],
                  ),
                )
              : _dosyalar.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.video_library,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Henüz indirilen video yok',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Videoları indirmek için arama yapın',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.only(top: 8, bottom: 16),
                  itemCount: _dosyalar.length,
                  itemBuilder: (context, index) {
                    final dosya = _dosyalar[index];
                    final dosyaAdi = dosya.path.split('/').last;
                    final dosyaBoyutu = _dosyaBoyutunuAl(dosya);

                    return Dismissible(
                      key: Key(dosya.path),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.red[400],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Icon(
                          Icons.delete_forever,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      onDismissed: (direction) {
                        _dosyayiSil(dosya);
                      },
                      child: Card(
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16),
                          leading: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red[100],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.play_arrow, color: Colors.red[700]),
                          ),
                          title: Text(
                            dosyaAdi,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                              fontSize: 14,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 4),
                              Text(
                                dosyaBoyutu,
                                style: TextStyle(
                                  color: Colors.red[600],
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                "Videoyu açmak için dokunun",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          trailing: Icon(
                            Icons.chevron_right,
                            color: Colors.grey[400],
                          ),
                          onTap: () => OpenFilex.open(dosya.path),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
