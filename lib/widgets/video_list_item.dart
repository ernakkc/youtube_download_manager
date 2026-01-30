import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../models/video_model.dart';
import '../services/download_service.dart';

class VideoListItem extends StatefulWidget {
  final VideoModel video;

  const VideoListItem({super.key, required this.video});

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

  Future<void> _showQualityDialog() async {
    if (widget.video.kaliteler == null || widget.video.kaliteler!.isEmpty) {
      // Kalite bilgisi yoksa direkt indir
      _startDownload(null);
      return;
    }

    var selectedQuality = await showDialog<VideoQualityModel>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.high_quality, color: Colors.red[700]),
            SizedBox(width: 8),
            Text(
              'Kalite Seçin',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: widget.video.kaliteler!.map((quality) {
              return Container(
                margin: EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.red[50],
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: CircleAvatar(
                    backgroundColor: Colors.red[700],
                    child: Icon(Icons.videocam, color: Colors.white, size: 20),
                  ),
                  title: Text(
                    quality.label,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4),
                      Text(
                        'Çözünürlük: ${quality.resolution}',
                        style: TextStyle(color: Colors.grey[700], fontSize: 12),
                      ),
                      Text(
                        'Boyut: ${quality.sizeText}',
                        style: TextStyle(
                          color: Colors.red[600],
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  trailing: Icon(
                    Icons.download_rounded,
                    color: Colors.red[700],
                  ),
                  onTap: () => Navigator.of(context).pop(quality),
                ),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey[700],
            ),
            child: Text('İptal'),
          ),
        ],
      ),
    );

    if (selectedQuality != null) {
      _startDownload(selectedQuality);
    }
  }

  Future<void> _startDownload(VideoQualityModel? quality) async {
    setState(() {
      _isDownloading = true;
      _progress = 0.0;
    });

    try {
      // Servisi çalıştır
      String? path = await _downloadService.downloadVideo(
        widget.video,
        quality ?? VideoQualityModel(label: '720p', resolution: '1280x720'), // Default
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
            
            // Başarı mesajı göster
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'İndirme tamamlandı!',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }
        });
      }
    } catch (e) {
      // Cancel exceptions are expected and should be ignored
      if (e is DioException && e.type == DioExceptionType.cancel) {
        // User cancelled the download, do nothing
      } else {
        // Handle other errors
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.white),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'İndirme hatası: $e',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.red[700],
              duration: Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      }
      if (mounted) {
        setState(() {
          _isDownloading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            // Sol tarafta resim
            Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    widget.video.resimUrl,
                    width: 100,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 100,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.broken_image, color: Colors.grey[600]),
                      );
                    },
                  ),
                ),
                // Eğer indirildiyse resmin üzerine küçük bir ikon koy
                if (_isDownloaded)
                  Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.check, color: Colors.white, size: 16),
                  ),
              ],
            ),
            SizedBox(width: 12),
            // Ortada başlık ve bilgi
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.video.baslik,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'YouTube Video',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  if (widget.video.kaliteler != null && widget.video.kaliteler!.isNotEmpty)
                    Text(
                      'Kullanılabilir: ${widget.video.kaliteler!.map((q) => q.label).join(', ')}',
                      style: TextStyle(
                        color: Colors.red[600],
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ),
            // Sağ tarafta akıllı buton alanı
            _buildTrailingWidget(),
          ],
        ),
      ),
    );
  }

  // Sağ tarafta ne göstereceğimize karar veren fonksiyon
  Widget _buildTrailingWidget() {
    // 1. Durum: İndiriliyor... (Yüzde çubuğu ve durdur butonu göster)
    if (_isDownloading) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 30,
            height: 30,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(value: _progress, strokeWidth: 2),
                Text(
                  "%${(_progress * 100).toStringAsFixed(0)}",
                  style: TextStyle(fontSize: 8),
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.cancel, color: Colors.red, size: 20),
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
            onPressed: () {
              try {
                _downloadService.cancelDownload();
                setState(() {
                  _isDownloading = false;
                  _progress = 0.0;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.cancel, color: Colors.white),
                        SizedBox(width: 12),
                        Text(
                          'İndirme durduruldu',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    backgroundColor: Colors.orange[700],
                    duration: Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              } catch (e) {
                print('Durdurma hatası: $e');
              }
            },
          ),
        ],
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
      onPressed: _showQualityDialog,
    );
  }
}
