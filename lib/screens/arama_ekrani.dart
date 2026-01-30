import 'package:flutter/material.dart';
import '../models/video_model.dart';
import '../widgets/video_list_item.dart';
import '../services/search_service.dart';

class AramaEkrani extends StatefulWidget {
  const AramaEkrani({super.key});

  @override
  _AramaEkraniState createState() => _AramaEkraniState();
}

class _AramaEkraniState extends State<AramaEkrani> {
  // Videoları tutacak listemiz
  List<VideoModel> _videolar = [];
  bool _yukleniyor = false;
  final SearchService _searchService = SearchService();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Başlangıçta boş liste
  }

  Future<void> _aramaYap(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _yukleniyor = true;
    });

    try {
      final results = await _searchService.searchVideos(query);
      setState(() {
        _videolar = results;
        _yukleniyor = false;
      });
    } catch (e) {
      setState(() {
        _yukleniyor = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Arama hatası: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("YouTube İndirme Yöneticisi"),
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
        child: Column(
          children: [
            // Arama çubuğu
            Container(
              margin: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Video ara...',
                  prefixIcon: Icon(Icons.search, color: Colors.red[400]),
                  suffixIcon: _yukleniyor
                      ? Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                            ),
                          ),
                        )
                      : IconButton(
                          icon: Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _videolar = [];
                            });
                          },
                        ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
                onSubmitted: _aramaYap,
              ),
            ),

            // Video listesi
            Expanded(
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
                            'Aranıyor...',
                            style: TextStyle(color: Colors.red[600], fontSize: 16),
                          ),
                        ],
                      ),
                    )
                  : _videolar.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 80,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Video bulunamadı',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.only(bottom: 16),
                      itemCount: _videolar.length,
                      itemBuilder: (context, index) {
                        final video = _videolar[index];
                        return VideoListItem(video: video);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
