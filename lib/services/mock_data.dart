import '../models/video_model.dart';

class MockData {
  static List<VideoModel> getFakeVideos() {
    return [
      VideoModel(
        id: '1',
        baslik: 'Flutter ile Mobil Uygulama Geliştirme - Başlangıç Seviyesi',
        resimUrl:
            'https://i.ytimg.com/vi/VPvVD8t02U8/hqdefault.jpg',
        videoUrl:
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
        kaliteler: [
          VideoQualityModel(
            label: '1080p',
            resolution: '1920x1080',
            sizeBytes: 158000000, // ~158 MB
          ),
          VideoQualityModel(
            label: '720p',
            resolution: '1280x720',
            sizeBytes: 89000000, // ~89 MB
          ),
          VideoQualityModel(
            label: '480p',
            resolution: '854x480',
            sizeBytes: 42000000, // ~42 MB
          ),
          VideoQualityModel(
            label: '360p',
            resolution: '640x360',
            sizeBytes: 28000000, // ~28 MB
          ),
        ],
      ),
      VideoModel(
        id: '2',
        baslik: 'Doğa Manzaraları ve Rahatlatıcı Müzik 4K Ultra HD',
        resimUrl:
            'https://images.unsplash.com/photo-1472214103451-9374bd1c798e',
        videoUrl:
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
        kaliteler: [
          VideoQualityModel(
            label: '2160p 4K',
            resolution: '3840x2160',
            sizeBytes: 524000000, // ~524 MB
          ),
          VideoQualityModel(
            label: '1080p',
            resolution: '1920x1080',
            sizeBytes: 145000000, // ~145 MB
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
        ],
      ),
      VideoModel(
        id: '3',
        baslik: 'Hızlı ve Öfkeli - Aksiyon Dolu Sahne Derlemesi',
        resimUrl:
            'https://images.unsplash.com/photo-1533473359331-0135ef1b58bf',
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
        id: '4',
        baslik: 'Kod Yazma Teknikleri ve İpuçları - Yazılım Geliştirme',
        resimUrl:
            'https://images.unsplash.com/photo-1542831371-29b0f74f9713',
        videoUrl:
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
        kaliteler: [
          VideoQualityModel(
            label: '1080p',
            resolution: '1920x1080',
            sizeBytes: 95000000, // ~95 MB
          ),
          VideoQualityModel(
            label: '720p',
            resolution: '1280x720',
            sizeBytes: 52000000, // ~52 MB
          ),
          VideoQualityModel(
            label: '480p',
            resolution: '854x480',
            sizeBytes: 28000000, // ~28 MB
          ),
        ],
      ),
      VideoModel(
        id: '5',
        baslik: 'Müzik Dinleyerek Çalışmak - Lo-Fi Beats Mix',
        resimUrl:
            'https://images.unsplash.com/photo-1511379938547-c1f69419868d',
        videoUrl:
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
        kaliteler: [
          VideoQualityModel(
            label: '720p',
            resolution: '1280x720',
            sizeBytes: 85000000, // ~85 MB
          ),
          VideoQualityModel(
            label: '480p',
            resolution: '854x480',
            sizeBytes: 45000000, // ~45 MB
          ),
          VideoQualityModel(
            label: '360p',
            resolution: '640x360',
            sizeBytes: 25000000, // ~25 MB
          ),
        ],
      ),
    ];
  }
}
