import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:music_player/player_controller.dart';
import 'package:music_player/riverpod/special_song_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SpecialSongs extends ConsumerStatefulWidget {
  const SpecialSongs({super.key});

  @override
  ConsumerState<SpecialSongs> createState() => _SpecialSongsState();
}

class _SpecialSongsState extends ConsumerState<SpecialSongs> {
  var controller = Get.put(PlayerContrtoller());
  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    List<SongModel> specialSongs = ref.watch(specialSongNotifierProvider);
    return Container(
        margin: EdgeInsets.fromLTRB(1, mq.height * 0.13, 1, 5),
        color: Colors.transparent,
        child: Container(
          color: Colors.transparent,
          child: (specialSongs.isEmpty)
              ? Center(
                  child: Container(
                  height: mq.height * 0.5,
                  width: mq.width * 0.5,
                  child: Text(
                    "PLEASE SELECT SONGS FROM THE PLAYLIST BY CLICKING ON  '+'",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ))
              : ListView.builder(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.only(left: 40, top: 50),
                  itemCount: specialSongs.length,
                  itemBuilder: (context, index) {
                    return Obx(
                      () => ListTile(
                        title: InkWell(
                          onTap: () {
                            controller.playAudio(specialSongs[index].uri);
                            controller.songs(specialSongs);
                            controller.songType(-1);
                          },
                          child: Text(specialSongs[index].title.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                overflow: TextOverflow.ellipsis,
                              )),
                        ),
                        subtitle: InkWell(
                          onTap: () {
                            controller.playAudio(specialSongs[index].uri);
                            controller.songs(specialSongs);
                            controller.songType(-1);
                          },
                          child: Text(
                            specialSongs[index].artist.toString(),
                            style:
                                TextStyle(color: Colors.white60, fontSize: 12),
                          ),
                        ),
                        trailing: InkWell(
                            onTap: () {
                              ref
                                  .read(specialSongNotifierProvider.notifier)
                                  .removeSongs(specialSongs[index]);
                              // controller.songs(specialSongs);
                            },
                            child: Icon(Icons.delete, color: Colors.redAccent)),
                        leading: (controller.curr_uri.value ==
                                specialSongs[index].uri)
                            ? (controller.isplaying.value)
                                ? InkWell(
                                    onTap: () {
                                      controller.pauseAudio();
                                    },
                                    child: Icon(
                                      Icons.pause,
                                      color: Colors.white,
                                    ),
                                  )
                                : InkWell(
                                    onTap: () {
                                      controller.pauseAudio();
                                    },
                                    child: Icon(Icons.play_arrow,
                                        color: Colors.white))
                            : null,
                      ),
                    );
                  },
                ),
        ));
  }
}
