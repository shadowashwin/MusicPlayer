import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:music_player/player_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';

class specialSongNotifier extends Notifier<List<SongModel>> {
  var controller;

  @override
  List<SongModel> build() {
    controller = Get.put(PlayerContrtoller());
    return [];
  }

  void addSongs(SongModel song) {
    if (!state.any((s) => s.id == song.id)) {
      state = [...state, song];
      controller.songs(state);
    }
  }

  void removeSongs(SongModel song) {
    state = state.where((s) => s.id != song.id).toList();
    controller.songs(state);
  }
}

final specialSongNotifierProvider =
    NotifierProvider<specialSongNotifier, List<SongModel>>(() {
  return specialSongNotifier();
});
