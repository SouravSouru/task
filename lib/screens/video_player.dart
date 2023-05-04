import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Video_Player extends StatefulWidget {
  const Video_Player({Key? key}) : super(key: key);

  @override
  State<Video_Player> createState() => _Video_PlayerState();
}

class _Video_PlayerState extends State<Video_Player> {
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
        "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4");
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
    return Chewie(controller: _chewieController!);
  }
}
