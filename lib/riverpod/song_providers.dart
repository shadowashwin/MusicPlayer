import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../player_controller.dart';

class defaultSongNotifier extends Notifier<Future<List<SongModel>>> {
  var controller = Get.put(PlayerContrtoller());
  List<SongModel> songs = [];
  List<SongModel> favourite = [];

  @override
  Future<List<SongModel>> build() async {
    favourite = await loadFavorites();
    return songsList();
  }

  Future<List<SongModel>> songsList({String? search}) async {
    songs = await controller.aq.querySongs(
        ignoreCase: true,
        orderType: OrderType.ASC_OR_SMALLER,
        sortType: null,
        uriType: UriType.EXTERNAL);
    if (search != null) {
      songs = songs
          .where((item) => item.title
              .toLowerCase()
              .split(' ')
              .any((word) => word.contains(search.toLowerCase())))
          .toList();
    }
    songs.sort((a, b) => b.dateAdded!.compareTo(a.dateAdded!));
    return songs;
  }

  void searchUpdate(String search) {
    state = songsList(search: search);
  }

  void favouriteSongs() {
    state = Future.value(favourite);
  }

  void defaultSongs() {
    state = songsList();
  }

  void addFavourite(SongModel song) {
    favourite.add(song);
    saveFavorites(favourite);
    print(favourite.length);
  }

  void removeFavourite(SongModel song) {
    favourite.removeAt(favourite.indexWhere((s) => s.id == song.id));
    saveFavorites(favourite);
    print(favourite.length);
  }

  Future<void> saveFavorites(List<SongModel> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    final songsJson = favorites.map((song) => song.getMap).toList();
    await prefs.setString('favorites', jsonEncode(songsJson));
  }

  Future<List<SongModel>> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getString('favorites');
    if (favoritesJson != null) {
      final List<dynamic> decoded = jsonDecode(favoritesJson);
      return decoded.map((songJson) => SongModel(songJson)).toList();
    }
    return [];
  }

  // final songsProvider = Provider(
  //       (ref) {
  //     return songsList();
  //   },
  // );
  //
  // final searchSongsProvider = Provider((ref) {
  //   return songsList();
  // });
}

final defaultSongNotifierProvider =
    NotifierProvider<defaultSongNotifier, Future<List<SongModel>>>(() {
  return defaultSongNotifier();
});
