class VideoModel {
  final String id;
  final String baslik;
  final String resimUrl; // Thumbnail
  final String videoUrl; // İndirilecek link
  bool indirildiMi; // Durum takibi için
  String? yerelDosyaYolu; // İndirilince nereye kaydettik?
  List<VideoQualityModel>? kaliteler; // Çözünürlük seçenekleri

  VideoModel({
    required this.id,
    required this.baslik,
    required this.resimUrl,
    required this.videoUrl,
    this.indirildiMi = false,
    this.yerelDosyaYolu,
    this.kaliteler,
  });
}

class VideoQualityModel {
  final String label; // "720p", "1080p" vb.
  final String resolution; // "1280x720"
  final int? sizeBytes; // Dosya boyutu bytes
  final String format; // "mp4"

  VideoQualityModel({
    required this.label,
    required this.resolution,
    this.sizeBytes,
    this.format = 'mp4',
  });

  String get sizeText {
    if (sizeBytes == null) return 'Bilinmiyor';
    if (sizeBytes! < 1024 * 1024) {
      return '${(sizeBytes! / 1024).round()} KB';
    } else if (sizeBytes! < 1024 * 1024 * 1024) {
      return '${(sizeBytes! / (1024 * 1024)).round()} MB';
    } else {
      return '${(sizeBytes! / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }
}
