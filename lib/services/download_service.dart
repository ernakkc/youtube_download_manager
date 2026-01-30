import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import '../models/video_model.dart';

class DownloadService {
  final Dio _dio = Dio();
  CancelToken? _currentCancelToken;

  // Video indirme fonksiyonu
  Future<String?> downloadVideo(
    VideoModel video,
    VideoQualityModel quality,
    Function(double) onProgress,
  ) async {
    // YouTube API sınırlamaları nedeniyle test videosu indir
    return await _downloadTestVideo(video, quality, onProgress);
  }

  // İndirmeyi durdur
  void cancelDownload() {
    if (_currentCancelToken != null) {
      _currentCancelToken!.cancel('İndirme kullanıcı tarafından durduruldu');
      _currentCancelToken = null;
    }
  }

  // Test videosu indir (fallback)
  Future<String?> _downloadTestVideo(
    VideoModel video,
    VideoQualityModel quality,
    Function(double) onProgress,
  ) async {
    _currentCancelToken = CancelToken();

    try {
      String testVideoUrl = 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';
      String fileName = _sanitizeFileName(video.baslik) + '_${quality.label}.mp4';

      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';

      await _dio.download(
        testVideoUrl,
        filePath,
        cancelToken: _currentCancelToken,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            double progress = received / total;
            onProgress(progress);
          }
        },
      );

      print("Test indirme başarılı: $filePath");
      return filePath;
    } catch (e) {
      if (e is DioException && e.type == DioExceptionType.cancel) {
        print("İndirme durduruldu");
        return null;
      }
      print("Test indirme hatası: $e");
      return null;
    } finally {
      _currentCancelToken = null;
    }
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
