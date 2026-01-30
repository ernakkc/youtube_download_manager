import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import '../models/video_model.dart';

class SearchService {
  final YoutubeExplode _yt = YoutubeExplode();

  Future<List<VideoModel>> searchVideos(String query) async {
    if (query.isEmpty) return [];

    try {
      print('YouTube araması başlatılıyor: $query');
      // YouTube'da arama yap
      var searchResults = await _yt.search.search(query);
      
      List<VideoModel> videos = [];
      
      // İlk 10 sonucu işle (sadece temel bilgiler, manifest aşamasında alınacak)
      for (var result in searchResults.take(10)) {
        try {
          // Standart kalite seçenekleri (manifest indirme sırasında gerçek değerler alınacak)
          List<VideoQualityModel> kaliteler = [
            VideoQualityModel(
              label: '1080p',
              resolution: '1920x1080',
              sizeBytes: 150000000, // ~150 MB (tahmini)
            ),
            VideoQualityModel(
              label: '720p',
              resolution: '1280x720',
              sizeBytes: 80000000, // ~80 MB (tahmini)
            ),
            VideoQualityModel(
              label: '480p',
              resolution: '854x480',
              sizeBytes: 40000000, // ~40 MB (tahmini)
            ),
            VideoQualityModel(
              label: '360p',
              resolution: '640x360',
              sizeBytes: 25000000, // ~25 MB (tahmini)
            ),
          ];
          
          videos.add(VideoModel(
            id: result.id.value,
            baslik: result.title,
            resimUrl: result.thumbnails.highResUrl,
            videoUrl: '', // URL dinamik olarak alınacak
            kaliteler: kaliteler,
          ));
        } catch (e) {
          print('Video ekleme hatası: $e');
          continue;
        }
      }
      
      print('Toplam ${videos.length} video bulundu');
      return videos;
    } catch (e) {
      print('Arama hatası: $e');
      return [];
    }
  }
  
  void dispose() {
    _yt.close();
  }
}
