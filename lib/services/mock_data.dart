import '../models/video_model.dart';

class MockData {
  static List<VideoModel> getFakeVideos() {
    return [
      VideoModel(
        id: '1',
        baslik: 'Flutter ile Mobil Uygulama Geliştirme Ders 1',
        resimUrl:
            'https://i.ytimg.com/vi/VPvVD8t02U8/hqdefault.jpg', // Temsili resim
        videoUrl:
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4', // Test videosu
      ),
      VideoModel(
        id: '2',
        baslik: 'Doğa Manzaraları ve Rahatlatıcı Müzik 4K',
        resimUrl:
            'https://images.unsplash.com/photo-1472214103451-9374bd1c798e',
        videoUrl:
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
      ),
      VideoModel(
        id: '3',
        baslik: 'Hızlı ve Öfkeli Fragman (Fan Made)',
        resimUrl:
            'https://images.unsplash.com/photo-1533473359331-0135ef1b58bf',
        videoUrl:
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
      ),
    ];
  }
}
