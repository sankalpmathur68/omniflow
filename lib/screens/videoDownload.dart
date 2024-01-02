import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:youtube_downloader/youtube_downloader.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class VideoDownloader extends StatefulWidget {
  const VideoDownloader({Key? key}) : super(key: key);

  @override
  State<VideoDownloader> createState() => _VideoDownloaderState();
}

class _VideoDownloaderState extends State<VideoDownloader> {
  TextEditingController _linkController = TextEditingController();
  bool downloadin = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: downloadin
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text("Downloading....")
                ],
              )
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          controller: _linkController,
                          decoration: InputDecoration(
                            labelText: 'Enter Youtube Video Link',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          downloadin = true;
                        });
                        // dwnload(_linkController.text);
                        bool dwnld_cmplt = await downloadYouTubeVideo(
                            _linkController.text, context);
                        if (dwnld_cmplt) {
                          setState(() {
                            downloadin = false;
                          });
                        }
                      },
                      child: Text("Download"),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

Future<String?> getDownloadPath() async {
  Directory? directory;
  try {
    if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      directory = Directory('/storage/emulated/0/Download');
      // Put file in global download folder, if for an unknown reason it didn't exist, we fallback
      // ignore: avoid_slow_async_io
      if (!await directory.exists())
        directory = await getExternalStorageDirectory();
    }
  } catch (err, stack) {
    print("Cannot get download folder path");
  }
  return directory?.path;
}

Future<bool> mergeVideoWithAudio(
    String videoPath, String audioPath, context, title) async {
  final flutterFFmpeg = FlutterFFmpeg();
  DateTime today = DateTime.now();
  final date = "${today.day}-${today.month}-${today.year}";
  final downloadPath = await getDownloadPath();
  Directory dir = await getTemporaryDirectory();
  final tempPath =
      "${dir.path}-temp-${title.toString().replaceAll(" ", '').replaceAll(".", '').replaceAll('/', '')}";
  final outputFilePath =
      "${downloadPath}/${title.toString().replaceAll(" ", '').replaceAll(".", '').replaceAll('/', '')}-$date-${today.second}.mp4";

  try {
    await flutterFFmpeg.execute(
      '-i $videoPath -i $audioPath -c:v copy -c:a aac -strict experimental $outputFilePath',
    );
    await flutterFFmpeg.execute(
      '-i $videoPath -i $audioPath -c:v copy -c:a aac -strict experimental $tempPath',
    );

    print('Video merged successfully: $outputFilePath');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Video Downloaded successfully: $outputFilePath')));
    OpenFile.open(tempPath);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    print('Error merging video and audio: $e');
  }
  return true;
}

Future<bool> downloadYouTubeVideo(String videoUrl, context) async {
  try {
    var yt = YoutubeExplode();
    String videoId;
    if (videoUrl.contains('shorts')) {
      videoId = videoUrl.substring(
          videoUrl.indexOf('/shorts/') + 8, videoUrl.indexOf('?'));
      print(videoId);
    } else {
      // videoId = VideoId(videoUrl);
      videoId = videoUrl.substring(
          videoUrl.indexOf('.be') + 4, videoUrl.indexOf('?'));
      print(videoId);
    }
    // final videoId = videoUrl.split('/').last;
    // print(videoId);
    final video = await yt.videos.get(videoId);
    // await Permission.storage.request();

    final manifest = await yt.videos.streamsClient.getManifest(videoId);
    final videoStream = manifest.videoOnly.withHighestBitrate();
    final audio = manifest.audioOnly.withHighestBitrate();

    // final dir = await getDownloadPath();
    final dir = await getTemporaryDirectory();
    final tempPath = dir.path;
    final filePathV =
        "$tempPath/video-${video.id}.${videoStream.container.name}";
    final filePathA =
        "$tempPath/audio-${video.id}.${videoStream.container.name}";

    final fileV = File(filePathV);
    final fileA = File(filePathA);
    final fileStreamA = fileA.openWrite();
    final fileStreamV = fileV.openWrite();

    await yt.videos.streamsClient.get(audio).pipe(fileStreamA);
    await yt.videos.streamsClient.get(videoStream).pipe(fileStreamV);

    await fileStreamA.flush();
    await fileStreamA.close();
    await fileStreamV.flush();
    await fileStreamV.close();

    print('Video downloaded successfully: ${fileA.path}');
    print(fileA);
    print(fileV);
    // OpenFile.open(filePathV);
    return mergeVideoWithAudio(filePathV, filePathA, context, videoId);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    print('Error downloading video: $e');
  }
  return true;
}

dwnload(url) {
  // YoutubeDownloader youtubeDownloader = YoutubeDownloader();

  try {
    // final snapshot = youtubeDownloader.downloadYoutubeVideo(url, 'mp4');
  } catch (e) {
    print(e);
  }
}
