import 'package:flutter/material.dart';
import '../services/mock_data.dart';
import '../models/video_model.dart';
import '../widgets/video_list_item.dart';

class AramaEkrani extends StatefulWidget {
  @override
  _AramaEkraniState createState() => _AramaEkraniState();
}

class _AramaEkraniState extends State<AramaEkrani> {
  // Videoları tutacak listemiz
  List<VideoModel> _videolar = [];

  @override
  void initState() {
    super.initState();
    _videolar = MockData.getFakeVideos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Youtube Download Manager"),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              print("Arama butonuna basıldı");
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Arama çubuğu
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Video ara...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              onSubmitted: (query) {
                // Arama işlemi burada yapılacak
                print("Arama yapıldı: $query");
              },
            ),
          ),

          // 2. Değişken Alan (Liste veya Yükleniyor)
          // Expanded kullanmazsak Column içinde ListView hata verir!
          Expanded(
            child: _videolar.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _videolar.length,
                    itemBuilder: (context, index) {
                      final video = _videolar[index];
                      return VideoListItem(video: video);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
