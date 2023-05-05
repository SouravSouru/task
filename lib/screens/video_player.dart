import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../controllers/darkThemeProviderController.dart';
import 'package:http/http.dart' as http;

class Video_Player extends StatefulWidget {
  const Video_Player({Key? key}) : super(key: key);

  @override
  State<Video_Player> createState() => _Video_PlayerState();
}

class _Video_PlayerState extends State<Video_Player> {
  int _index =0;
  List _videoList=[
    "https://drive.google.com/uc?export=download&id=1iTBQwnXSQpqkLD4-f-IiAYapxYHGFazT",
    "https://drive.google.com/uc?export=download&id=1eaAuXa8ijH66JpQNW5kp9wu_0dWGt95o",
  ];
  _loadNextVideo([File? video = null, bool network= true, bool nextvideo = false]) {
    setState(() {

      if(_index < _videoList.length-1 && -1 <_index){
        print("next  $nextvideo");
        nextvideo == false ? _index-- : _index++;
        _videoPlayerController =network == false ? VideoPlayerController.file(video!): VideoPlayerController.network(_videoList[_index]);
        print("12345678");
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

      print("index is $_index");
      print("length is ${_videoList.length}");




    });
  }



  videoDownload() async {
    try {
      final response = await http.get(Uri.parse(
          "https://drive.google.com/uc?export=download&id=1iTBQwnXSQpqkLD4-f-IiAYapxYHGFazT"));
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: "video downloading...!!!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            fontSize: 16.0);
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("video downloading...!!!")));
        final directory = await getApplicationDocumentsDirectory();
        final path = directory.path + '/video.mp4';

        print("path  $path");

        final file = File(path);
        File video = await file.writeAsBytes(response.bodyBytes);

        ///--------------------- loading downloaded video
        _loadNextVideo(video, false);

        ///--------------------------- showing toast
        Fluttertoast.showToast(
            msg: "video downloaded...!!!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            fontSize: 16.0);
        //
        // print("last ${video.path}");
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

  @override
  void dispose() {
    super.dispose();
    _chewieController!.dispose();
    _videoPlayerController!.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _videoPlayerController = VideoPlayerController.network(
        _videoList[_index]);
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
        SizedBox(
            height: _mediaQuery.height * 0.25,
            child: Chewie(controller: _chewieController!)),
        SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell
              (
              onTap: (){
                // if(_index < _videoList.length-1){
                //   _index--;
                // }
                _loadNextVideo(null ,true,false);
              },
              child: Container(
                height: _mediaQuery.height * 0.06,
                width: _mediaQuery.width * 0.14,
                decoration: BoxDecoration(
                    color:
                        Provider.of<DarkThemeProvider>(context).darkTheme == false
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
            InkWell
              (
              onTap: (){

                _loadNextVideo(null ,true,true);
              },
              child: Container(
                height: _mediaQuery.height * 0.06,
                width: _mediaQuery.width * 0.14,
                decoration: BoxDecoration(
                    color:
                        Provider.of<DarkThemeProvider>(context).darkTheme == false
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
