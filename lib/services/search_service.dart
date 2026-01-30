import '../models/video_model.dart';

class SearchService {
  // YouTube arama servisi (şimdilik mock)

  Future<List<VideoModel>> searchVideos(String query) async {
    // Mock arama sonuçları (YouTube API sınırlamaları nedeniyle)
    await Future.delayed(Duration(milliseconds: 800)); // Simüle edilmiş gecikme

    if (query.isEmpty) return [];

    List<VideoModel> mockVideos = [
      VideoModel(
        id: 'search_1',
        baslik: '$query - Detaylı Eğitim Videosu',
        resimUrl: 'https://i.ytimg.com/vi/dQw4w9WgXcQ/hqdefault.jpg',
        videoUrl:
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
        kaliteler: [
          VideoQualityModel(
            label: '1080p',
            resolution: '1920x1080',
            sizeBytes: 142000000, // ~142 MB
          ),
          VideoQualityModel(
            label: '720p',
            resolution: '1280x720',
            sizeBytes: 78000000, // ~78 MB
          ),
          VideoQualityModel(
            label: '480p',
            resolution: '854x480',
            sizeBytes: 38000000, // ~38 MB
          ),
          VideoQualityModel(
            label: '360p',
            resolution: '640x360',
            sizeBytes: 22000000, // ~22 MB
          ),
        ],
      ),
      VideoModel(
        id: 'search_2',
        baslik: 'En İyi $query Derlemesi 2024',
        resimUrl: 'https://images.unsplash.com/photo-1551434678-e076c223a692',
        videoUrl:
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
        kaliteler: [
          VideoQualityModel(
            label: '1080p',
            resolution: '1920x1080',
            sizeBytes: 168000000, // ~168 MB
          ),
          VideoQualityModel(
            label: '720p',
            resolution: '1280x720',
            sizeBytes: 92000000, // ~92 MB
          ),
          VideoQualityModel(
            label: '480p',
            resolution: '854x480',
            sizeBytes: 45000000, // ~45 MB
          ),
        ],
      ),
      VideoModel(
        id: 'search_3',
        baslik: '$query - Başlangıç Rehberi',
        resimUrl: 'https://images.unsplash.com/photo-1498050108023-c5249f4df085',
        videoUrl:
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
        kaliteler: [
          VideoQualityModel(
            label: '1080p',
            resolution: '1920x1080',
            sizeBytes: 125000000, // ~125 MB
          ),
          VideoQualityModel(
            label: '720p',
            resolution: '1280x720',
            sizeBytes: 68000000, // ~68 MB
          ),
          VideoQualityModel(
            label: '480p',
            resolution: '854x480',
            sizeBytes: 35000000, // ~35 MB
          ),
        ],
      ),
      VideoModel(
        id: 'search_4',
        baslik: 'Profesyonel $query Teknikleri',
        resimUrl: 'https://images.unsplash.com/photo-1460925895917-afdab827c52f',
        videoUrl:
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
        kaliteler: [
          VideoQualityModel(
            label: '720p',
            resolution: '1280x720',
            sizeBytes: 85000000, // ~85 MB
          ),
          VideoQualityModel(
            label: '480p',
            resolution: '854x480',
            sizeBytes: 42000000, // ~42 MB
          ),
          VideoQualityModel(
            label: '360p',
            resolution: '640x360',
            sizeBytes: 25000000, // ~25 MB
          ),
        ],
      ),
      VideoModel(
        id: 'search_5',
        baslik: '$query İçin İpuçları ve Püf Noktaları',
        resimUrl: 'https://images.unsplash.com/photo-1516321497487-e288fb19713f',
        videoUrl:
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
        kaliteler: [
          VideoQualityModel(
            label: '1080p',
            resolution: '1920x1080',
            sizeBytes: 155000000, // ~155 MB
          ),
          VideoQualityModel(
            label: '720p',
            resolution: '1280x720',
            sizeBytes: 82000000, // ~82 MB
          ),
          VideoQualityModel(
            label: '480p',
            resolution: '854x480',
            sizeBytes: 40000000, // ~40 MB
          ),
        ],
      ),
    ];

    return mockVideos;
  }
}
