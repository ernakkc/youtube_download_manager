import 'package:flutter/material.dart';
import '../models/video_model.dart';
import '../services/download_service.dart';

class VideoListItem extends StatefulWidget {
  final VideoModel video;

  const VideoListItem({required this.video});

  @override
  _VideoListItemState createState() => _VideoListItemState();
}

class _VideoListItemState extends State<VideoListItem> {
  // Kartın hafızası (Durum değişkenleri)
  bool _isDownloading = false;
  bool _isDownloaded = false;
  double _progress = 0.0;
  String? _localPath; // İndirilen dosyanın yolu

  // Servisimizi çağıralım
  final DownloadService _downloadService = DownloadService();

  Future<void> _startDownload() async {
    setState(() {
      _isDownloading = true;
      _progress = 0.0;
    });

    // Dosya ismini URL'den veya ID'den türetelim (örn: video_1.mp4)
    final fileName = "video_${widget.video.id}.mp4";

    // Servisi çalıştır
    String? path = await _downloadService.downloadVideo(
      widget.video.videoUrl,
      fileName,
      (newProgress) {
        // Servis her haber verdiğinde ekranı güncelle
        if (mounted) {
          setState(() {
            _progress = newProgress;
          });
        }
      },
    );

    // İşlem bitince
    if (mounted) {
      // Widget hala ekranda mı diye kontrol et
      setState(() {
        _isDownloading = false;
        if (path != null) {
          _isDownloaded = true;
          _localPath = path;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      elevation: 4,
      child: ListTile(
        // Sol tarafta resim
        leading: Stack(
          alignment: Alignment.center,
          children: [
            Image.network(
              widget.video.resimUrl,
              width: 100,
              height: 60,
              fit: BoxFit.cover,
            ),
            // Eğer indirildiyse resmin üzerine küçük bir ikon koy
            if (_isDownloaded)
              Icon(Icons.check_circle, color: Colors.green, size: 20),
          ],
        ),

        // Ortada başlık
        title: Text(
          widget.video.baslik,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),

        // Sağ tarafta akıllı buton alanı
        trailing: _buildTrailingWidget(),
      ),
    );
  }

  // Sağ tarafta ne göstereceğimize karar veren fonksiyon
  Widget _buildTrailingWidget() {
    // 1. Durum: İndiriliyor... (Yüzde çubuğu göster)
    if (_isDownloading) {
      return SizedBox(
        width: 40,
        height: 40,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CircularProgressIndicator(value: _progress, strokeWidth: 3),
            Text(
              "%${(_progress * 100).toStringAsFixed(0)}",
              style: TextStyle(fontSize: 10),
            ),
          ],
        ),
      );
    }

    // 2. Durum: İndirme Bitti (Oynat butonu göster)
    if (_isDownloaded) {
      return IconButton(
        icon: Icon(Icons.play_arrow, color: Colors.green, size: 30),
        onPressed: () {
          // Dosyayı aç
          if (_localPath != null) _downloadService.openFile(_localPath!);
        },
      );
    }

    // 3. Durum: Henüz İndirilmedi (İndir butonu göster)
    return IconButton(
      icon: Icon(Icons.download_rounded, color: Colors.redAccent),
      onPressed: _startDownload,
    );
  }
}
