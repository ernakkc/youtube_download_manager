import 'dart:async';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import '../models/video_model.dart';

class DownloadInfo {
  final String videoId;
  final String videoTitle;
  final String quality;
  double progress;
  bool isDownloading;
  String? filePath;
  CancelToken? cancelToken;

  DownloadInfo({
    required this.videoId,
    required this.videoTitle,
    required this.quality,
    this.progress = 0.0,
    this.isDownloading = true,
    this.filePath,
    this.cancelToken,
  });
}

class DownloadService {
  // Singleton pattern
  static final DownloadService _instance = DownloadService._internal();
  factory DownloadService() => _instance;
  DownloadService._internal();

  final Dio _dio = Dio();
  final YoutubeExplode _yt = YoutubeExplode();
  
  // Aktif indirmeler
  final Map<String, DownloadInfo> _activeDownloads = {};
  
  // Progress stream controller
  final StreamController<Map<String, DownloadInfo>> _downloadStreamController =
      StreamController<Map<String, DownloadInfo>>.broadcast();
  
  Stream<Map<String, DownloadInfo>> get downloadStream => _downloadStreamController.stream;
  
  Map<String, DownloadInfo> get activeDownloads => Map.unmodifiable(_activeDownloads);

  // Video indirme fonksiyonu (arka planda çalışır)
  Future<String?> downloadVideo(
    VideoModel video,
    VideoQualityModel quality,
  ) async {
    final downloadKey = '${video.id}_${quality.label}';
    
    // Zaten indiriliyorsa, aynı indirmeyi başlatma
    if (_activeDownloads.containsKey(downloadKey)) {
      print('Bu video zaten indiriliyor: ${video.baslik}');
      return null;
    }

    final cancelToken = CancelToken();
    
    // İndirme bilgisini kaydet
    _activeDownloads[downloadKey] = DownloadInfo(
      videoId: video.id,
      videoTitle: video.baslik,
      quality: quality.label,
      cancelToken: cancelToken,
    );
    _notifyListeners();

    try {
      print('Video indiriliyor: ${video.baslik} - ${quality.label}');
      
      // YouTube video manifest al
      var manifest = await _yt.videos.streamsClient.getManifest(video.id);
      
      // İstenen kaliteye en yakın video stream'i bul
      var streamInfo = manifest.muxed.where((s) => s.videoQualityLabel == quality.label);
      
      var selectedStream = streamInfo.isNotEmpty 
        ? streamInfo.first 
        : manifest.muxed.first;

      print('Stream bulundu: ${selectedStream.videoQualityLabel} - ${selectedStream.size.totalBytes} bytes');

      String fileName = '${_sanitizeFileName(video.baslik)}_${selectedStream.videoQualityLabel}.mp4';
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';

      // Video indir (arka planda devam eder)
      await _dio.download(
        selectedStream.url.toString(),
        filePath,
        cancelToken: cancelToken,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            double progress = received / total;
            
            // İndirme iptali kontrol edilmiş olabilir
            if (_activeDownloads.containsKey(downloadKey)) {
              _activeDownloads[downloadKey]!.progress = progress;
              _notifyListeners();
            }
          }
        },
      );

      print("İndirme başarılı: $filePath");
      
      // İndirme tamamlandı
      if (_activeDownloads.containsKey(downloadKey)) {
        _activeDownloads[downloadKey]!.progress = 1.0;
        _activeDownloads[downloadKey]!.isDownloading = false;
        _activeDownloads[downloadKey]!.filePath = filePath;
        _notifyListeners();
        
        // Tamamlanan indirmeyi 2 saniye sonra listeden kaldır
        Future.delayed(Duration(seconds: 2), () {
          _activeDownloads.remove(downloadKey);
          _notifyListeners();
        });
      }
      
      return filePath;
    } catch (e) {
      if (e is DioException && e.type == DioExceptionType.cancel) {
        print("İndirme durduruldu");
      } else {
        print("İndirme hatası: $e");
      }
      
      // Hatalı veya iptal edilen indirmeyi kaldır
      _activeDownloads.remove(downloadKey);
      _notifyListeners();
      
      return null;
    }
  }

  // İndirmeyi durdur
  void cancelDownload(String videoId, String quality) {
    final downloadKey = '${videoId}_$quality';
    
    if (_activeDownloads.containsKey(downloadKey)) {
      _activeDownloads[downloadKey]!.cancelToken?.cancel('İndirme kullanıcı tarafından durduruldu');
      _activeDownloads.remove(downloadKey);
      _notifyListeners();
      print('İndirme durduruldu: $downloadKey');
    }
  }
  
  // Belirli bir videonun indirilip indirilmediğini kontrol et
  bool isDownloading(String videoId, String quality) {
    final downloadKey = '${videoId}_$quality';
    return _activeDownloads.containsKey(downloadKey);
  }
  
  // Belirli bir videonun indirme ilerlemesini al
  double? getProgress(String videoId, String quality) {
    final downloadKey = '${videoId}_$quality';
    return _activeDownloads[downloadKey]?.progress;
  }
  
  // Listener'ları bilgilendir
  void _notifyListeners() {
    _downloadStreamController.add(Map.from(_activeDownloads));
  }

  // Dosya adını güvenli hale getir
  String _sanitizeFileName(String fileName) {
    return fileName
        .replaceAll(RegExp(r'[<>:"/\\|?*]'), '')
        .replaceAll(RegExp(r'\s+'), '_')
        .substring(0, fileName.length > 50 ? 50 : fileName.length);
  }

  // Dosyayı açmak için yardımcı fonksiyon
  Future<void> openFile(String filePath) async {
    await OpenFilex.open(filePath);
  }
}
