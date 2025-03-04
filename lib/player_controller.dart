import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class PlayerContrtoller extends GetxController {
  final aq = OnAudioQuery();
  final ap = AudioPlayer();
  RxList<SongModel> songs = <SongModel>[].obs;
  var songType = 0.obs;
  var curr_uri = "".obs;
  var isplaying = false.obs, cardshow = false.obs;
  var position = "".obs;
  var duration = "".obs;
  var max = 0.0.obs;
  var value = 0.0.obs;
  var replay = false.obs;
  @override
  void onInit() {
    super.onInit();
    checkPermission();
    listenToPlayerState();
  }

  changeDurationSeconds(sec) {
    var d = Duration(seconds: sec);
    ap.seek(d);
  }

  void listenToPlayerState() {
    ap.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        isplaying(false);
        value(0.0);
        if (songType.value == 0) {
          if (replay.value) {
            playAudio(curr_uri.value.toString());
          } else {
            int currentIndex =
                songs.indexWhere((song) => song.uri == curr_uri.value);
            (currentIndex + 1 < songs.length)
                ? playAudio(songs[currentIndex + 1].uri)
                : playAudio(songs[0].uri);
          }
        } else {
          int currentIndex =
              songs.indexWhere((song) => song.uri == curr_uri.value);
          (currentIndex + 1 < songs.length)
              ? playAudio(songs[currentIndex + 1].uri)
              : playAudio(songs[0].uri);
        }
      }
    });
  }

  updatePosition() {
    ap.durationStream.listen(
      (d) {
        duration.value = d.toString().split(".")[0];
        max.value = d!.inSeconds.toDouble();
      },
    );
    ap.positionStream.listen(
      (d) {
        position.value = d.toString().split(".")[0];
        value.value = d!.inSeconds.toDouble();
      },
    );
  }

  playAudio(String? uri) async {
    try {
      ap.setAudioSource(AudioSource.uri(Uri.parse(uri!.toString())));
      ap.play();
      updatePosition();
      isplaying(true);
      cardshow(true);
      curr_uri(uri!);
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  pauseAudio() {
    try {
      if (isplaying.value) {
        ap.pause();
        isplaying(false);
      } else {
        ap.play();
        isplaying(true);
      }
      cardshow(true);
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  checkPermission() async {
    var p = await Permission.storage.request();
    if (p.isGranted) {
    } else {
      checkPermission();
    }
  }
}
