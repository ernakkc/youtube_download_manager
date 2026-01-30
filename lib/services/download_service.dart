import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';

class DownloadService {
  final Dio _dio = Dio();

  // Dosya indirme fonksiyonu
  // onProgress: Yüzdelik dilimi (0.1, 0.5 gibi) arayüze bildirmek için kullanacağız
  Future<String?> downloadVideo(
    String url,
    String fileName,
    Function(double) onProgress,
  ) async {
    try {
      // 1. Kayıt yerini bul
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';

      // 2. İndirmeyi başlat
      await _dio.download(
        url,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            // Yüzdeyi hesapla ve arayüze haber ver
            double progress = received / total;
            onProgress(progress);
          }
        },
      );

      print("İndirme başarılı: $filePath");
      return filePath; // Dosyanın indiği yolu geri döndür
    } catch (e) {
      print("Hata oluştu: $e");
      return null;
    }
  }

  // Dosyayı açmak için yardımcı fonksiyon
  Future<void> openFile(String filePath) async {
    await OpenFilex.open(filePath);
  }
}
