import 'package:flutter/material.dart';
// Henüz bu dosyaları oluşturmadık ama birazdan yapacağız, hata verirse korkma:
import 'screens/arama_ekrani.dart';
import 'screens/kutuphane_ekrani.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Youtube Download Manager',
      theme: ThemeData(
        // Biraz daha modern, karanlık bir tema yapalım
        brightness: Brightness.dark,
        primarySwatch: Colors.red,
      ),
      home: AnaSayfa(),
    );
  }
}

class AnaSayfa extends StatefulWidget {
  @override
  _AnaSayfaState createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  int _seciliSayfaIndex = 0;

  // Sayfalarımızı burada listeliyoruz
  final List<Widget> _sayfalar = [
    AramaEkrani(), // 0. İndex
    KutuphaneEkrani(), // 1. İndex
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _sayfalar[_seciliSayfaIndex], // Seçili sayfayı göster
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _seciliSayfaIndex,
        onTap: (index) {
          setState(() {
            _seciliSayfaIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Keşfet & İndir',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.playlist_play),
            label: 'Kütüphanem',
          ),
        ],
      ),
    );
  }
}
