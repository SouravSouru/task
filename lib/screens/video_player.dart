import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../controllers/darkThemeProviderController.dart';
import 'package:http/http.dart' as http;

import '../utilites/darkThemePreference.dart';

class Video_Player extends StatefulWidget {
  const Video_Player({Key? key}) : super(key: key);

  @override
  State<Video_Player> createState() => _Video_PlayerState();
}

class _Video_PlayerState extends State<Video_Player> {
  List<String> downloadedVideoPath = [];

  getDownloadedVideoPath() async {
    List<String>? lists = await DarkThemePreference().getDownloadedVideoPath();

    if (lists!.isNotEmpty) {
      setState(() {
        downloadedVideoPath = lists;
      });
    }

    print("video path-------------- $downloadedVideoPath");
  }

  int _index = 0;

  ///https://drive.google.com/uc?export=download&id=17msoNHVBDsJk9mrz2LeSf7omRr5f_GbL
  List _videoList = [
    "https://drive.google.com/uc?export=download&id=17msoNHVBDsJk9mrz2LeSf7omRr5f_GbL",
    "https://drive.google.com/uc?export=download&id=1iTBQwnXSQpqkLD4-f-IiAYapxYHGFazT",
    "https://drive.google.com/uc?export=download&id=1N8q-OPf4QLamb_B_h4JuRDSnFMjffkiy",
    "https://drive.google.com/uc?export=download&id=1eaAuXa8ijH66JpQNW5kp9wu_0dWGt95o",
  ];
  _loadNextVideo(
      {File? video = null, bool network = true, bool nextvideo = false}) {
    setState(() {
      if (nextvideo == true ? _index < _videoList.length - 1 : 0 < _index) {
        print("next  $nextvideo");
        nextvideo == false ? _index-- : _index++;

        isLoadeding = true;

        Future.delayed(Duration(seconds: 2)).then((value) {
          setState(() {
            isLoadeding = false;
          });
        });

        if (downloadedVideoPath.isNotEmpty) {
          String onlinrVideoId =
              _videoList[_index].toString().split("id=").last.toString();
          String p =
              "/data/user/0/com.example.video_player_lilac/app_flutter/1iTBQwnXSQpqkLD4-f-IiAYapxYHGFazTvideo.mp4";

          var isvideoAlreadyDownloaded = downloadedVideoPath.contains(
              "/data/user/0/com.example.video_player_lilac/app_flutter/${onlinrVideoId}video.mp4");

          if (isvideoAlreadyDownloaded) {
            print("---------------------------------------------------");

            downloadedVideoPath.forEach((element) {
              if (element.split("app_flutter/").last.split("video.mp4").first ==
                  onlinrVideoId) {
                print("---------------------------------------------------");
                final file = File(element);
                print("path -----------$file");

                _videoPlayerController = VideoPlayerController.file(file);
                _chewieController = ChewieController(
                  videoPlayerController: _videoPlayerController!,
                  aspectRatio: 16 / 9,
                  autoInitialize: true,
                  showOptions: true,
                  showControls: false,

                  overlay: MaterialDesktopControls(
                    showPlayButton: false,
                  ),

                  materialProgressColors: ChewieProgressColors(
                      playedColor: Colors.lightGreen,
                      backgroundColor: Colors.black,
                      handleColor: Colors.lightGreen),
                  // autoPlay: widget.autoplay,
                  // looping: widget.looping,
                  errorBuilder: (context, errorMessage) {
                    return Center(
                      child: Text(
                        errorMessage,
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  },
                );
              }
              Fluttertoast.showToast(
                  msg: "Offline playing....",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.white,
                  textColor: Colors.black,
                  fontSize: 16.0);
            });

            setState(() {});
          } else {
            _videoPlayerController =
                VideoPlayerController.network(_videoList[_index]);
            _chewieController = ChewieController(
              videoPlayerController: _videoPlayerController!,
              aspectRatio: 16 / 9,
              autoInitialize: true,
              showOptions: true,
              showControls: false,

              overlay: MaterialDesktopControls(
                showPlayButton: false,
              ),

              materialProgressColors: ChewieProgressColors(
                  playedColor: Colors.lightGreen,
                  backgroundColor: Colors.black,
                  handleColor: Colors.lightGreen),
              // autoPlay: widget.autoplay,
              // looping: widget.looping,
              errorBuilder: (context, errorMessage) {
                return Center(
                  child: Text(
                    errorMessage,
                    style: TextStyle(color: Colors.white),
                  ),
                );
              },
            );
            setState(() {});
          }
        } else {
          _videoPlayerController =
              VideoPlayerController.network(_videoList[_index]);
          _chewieController = ChewieController(
            videoPlayerController: _videoPlayerController!,
            aspectRatio: 16 / 9,
            autoInitialize: true,
            showOptions: true,
            showControls: false,

            overlay: MaterialDesktopControls(
              showPlayButton: false,
            ),

            materialProgressColors: ChewieProgressColors(
                playedColor: Colors.lightGreen,
                backgroundColor: Colors.black,
                handleColor: Colors.lightGreen),
            // autoPlay: widget.autoplay,
            // looping: widget.looping,
            errorBuilder: (context, errorMessage) {
              return Center(
                child: Text(
                  errorMessage,
                  style: TextStyle(color: Colors.white),
                ),
              );
            },
          );
          setState(() {});
        }
      }

      print("index is $_index");
      print("length is ${_videoList.length}");
    });
  }

  videoDownload() async {
    try {


      if (downloadedVideoPath.isNotEmpty) {
        print("-------------------------");
        String onlinrVideoId =
            _videoList[_index].toString().split("id=").last.toString();

        var isvideoAlreadyDownloaded = downloadedVideoPath.contains(
            "/data/user/0/com.example.video_player_lilac/app_flutter/${onlinrVideoId}video.mp4");

        if (isvideoAlreadyDownloaded) {
          downloadedVideoPath.forEach((element) async {
            if (element.split("app_flutter/").last.split("video.mp4").first ==
                onlinrVideoId) {
              ///--------------------- loading downloaded video
              final file1 = File(element);
              print("path -----------$file1");
              _loadNextVideo(video: file1, network: false);

              Fluttertoast.showToast(
                  msg: "video already downloaded",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.white,
                  textColor: Colors.black,
                  fontSize: 16.0);
            }
          });
        } else {
          final response = await http.get(Uri.parse(_videoList[_index]));
          if (response.statusCode == 200) {
            Fluttertoast.showToast(
                msg: "video downloading...!!!",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.white,
                textColor: Colors.black,
                fontSize: 16.0);
            final directory = await getApplicationDocumentsDirectory();

            final videoName = _videoList[_index].toString().split("id=").last;
            print(" video name${videoName}");

            final path = directory.path + '/${videoName}video.mp4';

            print("path  $path");

            final file = File(path);
            File video = await file.writeAsBytes(response.bodyBytes);

            ///--------------------- loading downloaded video
            _loadNextVideo(video: video, network: false);

            ///----------------- video path add to sharedpref

            downloadedVideoPath.add(video.path);
            setState(() {});

            DarkThemePreference().setDownloadedVideoPath(downloadedVideoPath);
            getDownloadedVideoPath();

            ///--------------------------- showing toast
            Fluttertoast.showToast(
                msg: "video downloaded...!!!",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.white,
                textColor: Colors.black,
                fontSize: 16.0);
          }
        }
      } else {
        final response = await http.get(Uri.parse(_videoList[_index]));
        if (response.statusCode == 200) {
          Fluttertoast.showToast(
              msg: "video downloading...!!!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.white,
              textColor: Colors.black,
              fontSize: 16.0);
          final directory = await getApplicationDocumentsDirectory();

          final videoName = _videoList[_index].toString().split("id=").last;
          print(" video name${videoName}");

          final path = directory.path + '/${videoName}video.mp4';

          print("path  $path");

          final file = File(path);
          File video = await file.writeAsBytes(response.bodyBytes);

          ///--------------------- loading downloaded video
          _loadNextVideo(video: video, network: false);

          ///----------------- video path add to sharedpref

          downloadedVideoPath.add(video.path);
          setState(() {});

          DarkThemePreference().setDownloadedVideoPath(downloadedVideoPath);
          getDownloadedVideoPath();

          ///--------------------------- showing toast
          Fluttertoast.showToast(
              msg: "video downloaded...!!!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.white,
              textColor: Colors.black,
              fontSize: 16.0);
        }
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Somthing went wrong, please try again",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0);
    }
  }

  VideoPlayerController? _videoPlayerController;
  bool? looping;
  bool? autoplay;
  ChewieController? _chewieController;
  bool isLoadeding = false;

  @override
  void dispose() {
    super.dispose();
    _chewieController!.dispose();
    _videoPlayerController!.dispose();
  }

  @override
  void initState() {
    isLoadeding = true;
    // TODO: implement initState
    super.initState();
    getDownloadedVideoPath();

    Future.delayed(Duration(seconds: 2)).then((value) {
      setState(() {
        isLoadeding = false;
      });
    });
    _videoPlayerController = VideoPlayerController.network(_videoList[_index]);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController!,
      aspectRatio: 16 / 9,
      autoInitialize: true,
      showOptions: true,
      showControls: false,

      overlay: MaterialDesktopControls(
        showPlayButton: false,
      ),

      materialProgressColors: ChewieProgressColors(
          playedColor: Colors.lightGreen,
          backgroundColor: Colors.black,
          handleColor: Colors.lightGreen),
      // autoPlay: widget.autoplay,
      // looping: widget.looping,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var _mediaQuery = MediaQuery.of(context).size;
    return Column(
      children: [
        _chewieController != null
            ? SizedBox(
                height: _mediaQuery.height * 0.25,
                child: isLoadeding == false
                    ? Chewie(controller: _chewieController!)
                    : Container(
                        color: Colors.black,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Colors.red,
                          ),
                        ),
                      ))
            : Container(
                color: Colors.black,
                height: _mediaQuery.height * 0.25,
              ),
        SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: () {
                _chewieController!.pause();
                _loadNextVideo(network: true, nextvideo: false);
              },
              child: Container(
                height: _mediaQuery.height * 0.06,
                width: _mediaQuery.width * 0.14,
                decoration: BoxDecoration(
                    color: Provider.of<DarkThemeProvider>(context).darkTheme ==
                            false
                        ? Colors.white
                        : Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(14)),
                child: Center(
                  child: Icon(Icons.arrow_back_ios_new),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                videoDownload();
              },
              child: Container(
                height: _mediaQuery.height * 0.06,
                width: _mediaQuery.width * 0.43,
                decoration: BoxDecoration(
                    color: Provider.of<DarkThemeProvider>(context).darkTheme ==
                            false
                        ? Colors.white
                        : Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(14)),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Icon(
                          Icons.arrow_drop_down_sharp,
                          size: 36,
                          color: Colors.lightGreen,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: Text(
                          "Download",
                          style: TextStyle(fontSize: 19),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                _chewieController!.pause();

                _loadNextVideo(network: true, nextvideo: true);
              },
              child: Container(
                height: _mediaQuery.height * 0.06,
                width: _mediaQuery.width * 0.14,
                decoration: BoxDecoration(
                    color: Provider.of<DarkThemeProvider>(context).darkTheme ==
                            false
                        ? Colors.white
                        : Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(14)),
                child: Center(
                  child: Icon(Icons.arrow_forward_ios),
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}
