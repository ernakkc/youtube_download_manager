import 'package:youtube_results/youtube_results.dart';

void main() async {
  final youtube = YoutubeResults();
  List<Video>? results = await youtube.fetchVideos("Flutter tutorial");

  if (results != null) {
    for (var video in results) {
      var text =
          '''
      title: ${video.title}
      videoId: ${video.videoId}
      duration: ${video.duration}
      viewCount: ${video.viewCount}
      publishedTime: ${video.publishedTime}
      channelName: ${video.channelName}
      channelUrl: ${video.channelUrl}
      description: ${video.description}
      thumbnails: ${video.thumbnails}
      channelThumbnails: ${video.channelThumbnails}
      ''';
      print(text);
      print("----------------");
    }
  } else {
    print("----------------");
  }
}
