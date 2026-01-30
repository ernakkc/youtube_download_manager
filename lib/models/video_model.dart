class VideoModel {
  final String id;
  final String baslik;
  final String resimUrl; // Thumbnail
  final String videoUrl; // İndirilecek link
  bool indirildiMi; // Durum takibi için
  String? yerelDosyaYolu; // İndirilince nereye kaydettik?

  VideoModel({
    required this.id,
    required this.baslik,
    required this.resimUrl,
    required this.videoUrl,
    this.indirildiMi = false,
    this.yerelDosyaYolu,
  });
}
