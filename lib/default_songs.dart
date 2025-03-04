import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:music_player/player_controller.dart';
import 'package:music_player/riverpod/song_providers.dart';
import 'package:music_player/riverpod/special_song_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'color.dart';

class DefaultSongs extends ConsumerStatefulWidget {
  const DefaultSongs({super.key});

  @override
  ConsumerState<DefaultSongs> createState() => _DefaultSongsState();
}

class _DefaultSongsState extends ConsumerState<DefaultSongs> {
  var controller = Get.put(PlayerContrtoller());

  addSpecialSongs(SongModel song) {
    Fluttertoast.showToast(
        msg:
            "'${song.title.toString().length > 20 ? song.title.toString().substring(0, 20) : song.title.toString()}' is added to the playlist",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.white,
        textColor: lblue);
  }

  replayOrder() {
    if (controller.replay.value) {
      Fluttertoast.showToast(
          msg: "Loop mode",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.white,
          textColor: lblue);
    } else {
      Fluttertoast.showToast(
          msg: "Order mode",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.white,
          textColor: lblue);
    }
  }

  removeSpecialSong(id) {
    Fluttertoast.showToast(
        msg: "Song Removed from playlist",
        backgroundColor: Colors.white,
        textColor: Colors.lightBlue,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM);
  }

  @override
  Widget build(BuildContext context) {
    List<SongModel> specialSongs = ref.watch(specialSongNotifierProvider);
    List<SongModel> favouriteSongs =
        ref.read(defaultSongNotifierProvider.notifier).favourite;
    var mq = MediaQuery.of(context).size;
    return Row(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(0, mq.height * 0.13, 0, 5),
          width: MediaQuery.of(context).size.width * 0.009,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, mq.height * 0.13, 0, 5),
          width: MediaQuery.of(context).size.width * 0.99,
          child: FutureBuilder<List<SongModel>>(
            future: ref.watch(defaultSongNotifierProvider),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.data!.isEmpty) {
                return Center(
                    child: Text(
                  "no song found",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ));
              } else {
                return Container(
                  decoration: const BoxDecoration(color: Colors.transparent),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Obx(
                            () => Stack(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 4.25),
                                  height: (controller.isplaying.value == true ||
                                              controller.cardshow.value ==
                                                  true) &&
                                          controller.curr_uri.value ==
                                              snapshot.data[index].uri
                                      ? mq.height * 0.17
                                      : mq.height * 0.08,
                                  decoration: (controller.isplaying.value ==
                                                  true ||
                                              controller.cardshow.value ==
                                                  true) &&
                                          controller.curr_uri.value ==
                                              snapshot.data[index].uri
                                      ? const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          image: DecorationImage(
                                              opacity: 0.7,
                                              fit: BoxFit.cover,
                                              image: AssetImage(
                                                  'assets/card1.png')))
                                      : null,
                                ),
                                GlassmorphicContainer(
                                    margin: EdgeInsets.only(top: 3.5),
                                    height:
                                        (controller.isplaying.value == true ||
                                                    controller.cardshow.value ==
                                                        true) &&
                                                controller.curr_uri.value ==
                                                    snapshot.data[index].uri
                                            ? mq.height * 0.17
                                            : mq.height * 0.08,
                                    width:
                                        (controller.isplaying.value == true ||
                                                    controller.cardshow.value ==
                                                        true) &&
                                                controller.curr_uri.value ==
                                                    snapshot.data[index].uri
                                            ? mq.width * 1
                                            : 0,
                                    borderRadius: 5,
                                    blur: 0.1,
                                    alignment: Alignment.center,
                                    border: 5,
                                    linearGradient: LinearGradient(
                                        colors: [
                                          lblue.withOpacity(0.02),
                                          dblue.withOpacity(0.01)
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight),
                                    borderGradient: const LinearGradient(
                                        colors: [dblue, lblue])),
                                Container(
                                  margin: EdgeInsets.fromLTRB(0,
                                      mq.height * 0.005, 0, mq.height * 0.005),
                                  height: (controller.isplaying == true ||
                                              controller.cardshow == true) &&
                                          controller.curr_uri.value ==
                                              snapshot.data[index].uri
                                      ? mq.height * 0.17
                                      : mq.height * 0.08,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: (controller.isplaying == true ||
                                                controller.cardshow == true) &&
                                            controller.curr_uri.value ==
                                                snapshot.data[index].uri
                                        ? Colors.transparent
                                        : Colors.white12,
                                  ),
                                  child: ListTile(
                                    title: InkWell(
                                      onTap: () {
                                        controller.playAudio(
                                            snapshot.data![index].uri);
                                        controller.songs(snapshot.data);
                                        controller.songType(0);
                                      },
                                      child: Text(
                                        snapshot.data![index].title,
                                        style: TextStyle(
                                            color: Colors.white,
                                            overflow: TextOverflow.ellipsis,
                                            fontFamily: "body",
                                            fontSize: controller.curr_uri ==
                                                        snapshot
                                                            .data[index].uri &&
                                                    (controller.isplaying ==
                                                            true ||
                                                        controller.cardshow ==
                                                            true)
                                                ? 20
                                                : 18),
                                      ),
                                    ),
                                    subtitle: (controller.isplaying == true ||
                                                controller.cardshow == true) &&
                                            controller.curr_uri.value ==
                                                snapshot.data[index].uri
                                        ? Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${snapshot.data![index].artist}",
                                                style: TextStyle(
                                                    color: (controller.isplaying ==
                                                                    true ||
                                                                controller
                                                                        .cardshow ==
                                                                    true) &&
                                                            controller.curr_uri
                                                                    .value ==
                                                                snapshot
                                                                    .data[index]
                                                                    .uri
                                                        ? Colors.white
                                                        : Colors.white,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    fontSize: 11),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 5, 0, 0),
                                                child: SizedBox(
                                                  height: 20,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0, 15, 0, 0),
                                                    child: Slider(
                                                      min: const Duration(
                                                              seconds: 0)
                                                          .inSeconds
                                                          .toDouble(),
                                                      max: controller.max.value,
                                                      value: controller
                                                          .value.value,
                                                      onChanged: (newValue) {
                                                        controller
                                                            .changeDurationSeconds(
                                                                newValue
                                                                    .toInt());
                                                        if (newValue
                                                                .toDouble() ==
                                                            controller
                                                                .max.value) {
                                                          controller
                                                              .isplaying(false);
                                                        }
                                                      },
                                                      activeColor: Colors.white,
                                                      inactiveColor:
                                                          Colors.white30,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8),
                                                    child: InkWell(
                                                      onTap: () {
                                                        controller.replay(
                                                            !controller
                                                                .replay.value);
                                                        replayOrder();
                                                      },
                                                      child: Icon(
                                                        (controller
                                                                .replay.value)
                                                            ? Icons
                                                                .replay_circle_filled_sharp
                                                            : Icons.replay,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                  CircleAvatar(
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    child: Transform.scale(
                                                      scale: mq.width * 0.003,
                                                      child: IconButton(
                                                        onPressed: () {},
                                                        icon: (controller
                                                                .isplaying
                                                                .value)
                                                            ? InkWell(
                                                                onTap: () {
                                                                  controller
                                                                      .pauseAudio();
                                                                },
                                                                child: Icon(
                                                                  Icons.pause,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 30,
                                                                ),
                                                              )
                                                            : InkWell(
                                                                onTap: () {
                                                                  controller
                                                                      .pauseAudio();
                                                                },
                                                                child: Icon(
                                                                  Icons
                                                                      .play_arrow,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 30,
                                                                ),
                                                              ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8),
                                                    child: InkWell(
                                                      onTap: () {
                                                        controller.replay(
                                                            !controller
                                                                .replay.value);
                                                        replayOrder();
                                                      },
                                                      child: Icon(
                                                        (!controller
                                                                .replay.value)
                                                            ? Icons
                                                                .format_list_numbered_outlined
                                                            : Icons
                                                                .format_list_bulleted,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          )
                                        : Text(
                                            "${snapshot.data![index].artist}",
                                            style: TextStyle(
                                                color:
                                                    controller.isplaying == true
                                                        ? Colors.white
                                                        : Colors.white,
                                                overflow: TextOverflow.ellipsis,
                                                fontSize: 11),
                                          ),
                                    leading: (controller.isplaying == true ||
                                                controller.cardshow == true) &&
                                            controller.curr_uri.value ==
                                                snapshot.data[index].uri
                                        ? Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.music_note,
                                                color: Colors.white,
                                                size: 32,
                                              )
                                            ],
                                          )
                                        : Icon(
                                            Icons.music_note,
                                            color: Colors.white,
                                            size: 32,
                                          ),
                                    trailing: (controller.isplaying == true ||
                                                controller.cardshow == true) &&
                                            controller.curr_uri.value ==
                                                snapshot.data[index].uri
                                        ? Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              (!favouriteSongs.any((s) =>
                                                      s.id ==
                                                      snapshot.data[index].id))
                                                  ? InkWell(
                                                      onTap: () {
                                                        ref
                                                            .read(
                                                                defaultSongNotifierProvider
                                                                    .notifier)
                                                            .addFavourite(
                                                                snapshot.data[
                                                                    index]);
                                                        setState(() {
                                                          favouriteSongs = ref
                                                              .read(
                                                                  defaultSongNotifierProvider
                                                                      .notifier)
                                                              .favourite;
                                                        });
                                                        // addFavouriteSongs(
                                                        //     snapshot
                                                        //         .data[index]);
                                                      },
                                                      child: Icon(
                                                        Icons.star_border,
                                                        color: Colors.white,
                                                        size: 26,
                                                      ),
                                                    )
                                                  : InkWell(
                                                      onTap: () {
                                                        ref
                                                            .read(
                                                                defaultSongNotifierProvider
                                                                    .notifier)
                                                            .removeFavourite(
                                                                snapshot.data[
                                                                    index]);
                                                        setState(() {
                                                          favouriteSongs = ref
                                                              .read(
                                                                  defaultSongNotifierProvider
                                                                      .notifier)
                                                              .favourite;
                                                        });

                                                        // removeFavouriteSong(
                                                        //     snapshot.data[index]
                                                        //         .id);
                                                      },
                                                      child: Icon(
                                                        Icons.star,
                                                        color: Colors.white,
                                                        size: 26,
                                                      ),
                                                    ),
                                              (!specialSongs.any((s) =>
                                                      s.id ==
                                                      snapshot.data[index].id))
                                                  ? InkWell(
                                                      onTap: () {
                                                        ref
                                                            .read(
                                                                specialSongNotifierProvider
                                                                    .notifier)
                                                            .addSongs(snapshot
                                                                .data[index]);

                                                        addSpecialSongs(snapshot
                                                            .data[index]);
                                                      },
                                                      child: Icon(
                                                        Icons.add,
                                                        color: Colors.white,
                                                        size: 26,
                                                      ),
                                                    )
                                                  : InkWell(
                                                      onTap: () {
                                                        ref
                                                            .read(
                                                                specialSongNotifierProvider
                                                                    .notifier)
                                                            .removeSongs(
                                                                snapshot.data[
                                                                    index]);
                                                        removeSpecialSong(
                                                            snapshot
                                                                .data[index]);
                                                      },
                                                      child: Icon(
                                                        Icons.close,
                                                        color: Colors.white,
                                                        size: 26,
                                                      ),
                                                    ),
                                            ],
                                          )
                                        : (!specialSongs.any((s) =>
                                                s.id ==
                                                snapshot.data[index].id))
                                            ? InkWell(
                                                onTap: () {
                                                  ref
                                                      .read(
                                                          specialSongNotifierProvider
                                                              .notifier)
                                                      .addSongs(
                                                          snapshot.data[index]);

                                                  addSpecialSongs(
                                                      snapshot.data[index]);
                                                },
                                                child: Icon(
                                                  Icons.add,
                                                  color: Colors.white,
                                                  size: 26,
                                                ),
                                              )
                                            : InkWell(
                                                onTap: () {
                                                  ref
                                                      .read(
                                                          specialSongNotifierProvider
                                                              .notifier)
                                                      .removeSongs(
                                                          snapshot.data[index]);

                                                  removeSpecialSong(
                                                      snapshot.data[index]);
                                                },
                                                child: Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                  size: 26,
                                                ),
                                              ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
