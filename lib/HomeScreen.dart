import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:music_player/color.dart';
import 'package:music_player/custom_clippath.dart';
import 'package:music_player/default_songs.dart';
import 'package:music_player/draw_animation.dart';
import 'package:music_player/player_controller.dart';
import 'package:music_player/riverpod/song_providers.dart';
import 'package:music_player/special_songs.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:url_launcher/url_launcher.dart';

final GlobalKey<MyDrawerState> _drawerKey = GlobalKey<MyDrawerState>();

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  var controller = Get.put(PlayerContrtoller());

  addSpecialSongs(SongModel song) {
    Fluttertoast.showToast(
        msg: "song is added to the playlist",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.white,
        textColor: lblue);
  }

  removeSpecialSong(SongModel song) {
    Fluttertoast.showToast(
        msg: "Song Removed from playlist",
        backgroundColor: Colors.white,
        textColor: Colors.lightBlue,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM);
  }

  Future<void> launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  bool home = true;
  bool profile = false;

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 0.7],
              colors: [dblue, lblue],
            )),
          ),
          ClipPath(
            clipper: clippath2(),
            child: Container(
              decoration: BoxDecoration(color: Colors.white10),
              height: mq.height * 0.11,
            ),
          ),
          ClipPath(
            clipper: clippath1(),
            child: Container(
              decoration: BoxDecoration(color: Colors.white24),
              height: mq.height * 0.11,
            ),
          ),
          Container(
            decoration: const BoxDecoration(color: Colors.white12),
          ),
          // music list
          (!profile)
              ? MyDrawer(
                  key: _drawerKey,
                  drawer: SpecialSongs(),
                  child: DefaultSongs(),
                )
              : SizedBox(),
          // search bar
          (!profile)
              ? Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                      top: mq.height * 0.12,
                      left: mq.width * 0.05,
                      right: mq.width * 0.05),
                  height: mq.height * 0.05,
                  width: mq.width * 0.9,
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [b1, b2, b3]),
                      boxShadow: [
                        const BoxShadow(
                          color: b1,
                          spreadRadius: 0.2,
                          blurRadius: 5,
                          offset: Offset(0, 1),
                        ).scale(3)
                      ],
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(children: [
                    Padding(
                      padding: EdgeInsets.only(left: 5, bottom: 2),
                      child: Container(
                        height: mq.height * 0.05,
                        width: mq.width * 0.75,
                        child: TextFormField(
                          onChanged: (value) {
                            if (value.toString() != "") {
                              ref
                                  .read(defaultSongNotifierProvider.notifier)
                                  .searchUpdate(value.toString());
                            } else {
                              ref
                                  .read(defaultSongNotifierProvider.notifier)
                                  .defaultSongs();
                            }
                          },
                          style: const TextStyle(color: Colors.white),
                          cursorColor: Colors.white,
                          cursorHeight: mq.height * 0.03,
                          decoration: const InputDecoration(
                            fillColor: Colors.white,
                            hintText: 'Search the music',
                            hintStyle: TextStyle(color: Colors.white70),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.search_rounded,
                          color: Colors.white,
                          size: mq.width * 0.08,
                        ))
                  ]),
                )
              : SizedBox(),
          // bottom navigation
          (!profile)
              ? Center(
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(
                        top: mq.height * 0.91,
                        left: mq.width * 0.05,
                        right: mq.width * 0.05),
                    height: mq.height * 0.06,
                    width: mq.width * 0.6,
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [b1, b2, b3]),
                        boxShadow: [
                          const BoxShadow(
                            color: b1,
                            spreadRadius: 0.2,
                            blurRadius: 5,
                            offset: Offset(0, 1),
                          ).scale(3)
                        ],
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            InkWell(
                              child: Icon(
                                  (home) ? Icons.home : Icons.home_outlined,
                                  color: Colors.white,
                                  size: (!home) ? 40 : 29),
                              onTap: () {
                                if (!home) {
                                  ref
                                      .read(
                                          defaultSongNotifierProvider.notifier)
                                      .defaultSongs();
                                }
                                setState(() {
                                  home = true;
                                });
                              },
                            ),
                            (home)
                                ? Text(
                                    "HOME",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  )
                                : SizedBox()
                          ],
                        ),
                        Column(
                          children: [
                            InkWell(
                              child: Icon(
                                (!home) ? Icons.star : Icons.star_border,
                                color: Colors.white,
                                size: (home) ? 40 : 29,
                              ),
                              onTap: () {
                                if (home) {
                                  ref
                                      .read(
                                          defaultSongNotifierProvider.notifier)
                                      .favouriteSongs();
                                }
                                setState(() {
                                  home = false;
                                });
                              },
                            ),
                            (!home)
                                ? Text(
                                    "FAVOURITE",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  )
                                : SizedBox()
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              : SizedBox(),
          // profile
          (profile)
              ? Center(
                  child: Container(
                    height: mq.height * 0.7,
                    width: mq.width * 0.9,
                    color: Colors.white24,
                    child: Column(
                      children: [
                        Container(
                          height: mq.height * 0.2,
                          width: mq.height * 0.2,
                          margin: EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage('assets/ashwin.jpg')),
                              borderRadius: BorderRadius.circular(200)),
                        ),
                        SizedBox(
                          width: mq.width * 0.85,
                          height: mq.height * 0.3,
                          child: Center(
                              child: Text(
                            "Hey there 👋🏻, I'm Ashwin 😁\n"
                            "— a 4th-year B.Tech CSE student who excels in multiple fields, including "
                            "Android 📱, Web 🌐, Computer Vision 🤖, and    Docker 🐳 !",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          )),
                        ),
                        InkWell(
                          onTap: () {
                            launchURL(
                                "https://drive.google.com/file/d/1Gfl_4HGTEjDd1Eg-xI7TFVKfCQHS_qht/view?usp=sharing");
                          },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: CupertinoColors.activeBlue,
                                borderRadius: BorderRadius.circular(5)),
                            child: Text(" Resume 📄 ",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20)),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            launchURL(
                                "https://shadowashwin-portfolio.netlify.app/");
                          },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                                color: CupertinoColors.activeBlue,
                                borderRadius: BorderRadius.circular(5)),
                            child: Text(" Portfolio 🔗 ",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20)),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            launchURL("https://ashwin-projects.netlify.app/");
                          },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                                color: CupertinoColors.activeBlue,
                                borderRadius: BorderRadius.circular(5)),
                            child: Text(" Projects 🛠️ ",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20)),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : SizedBox(),
          // tab bar
          Container(
            height: mq.height * 0.1,
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            alignment: Alignment.bottomLeft,
            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  child: const Icon(
                    Icons.sort_rounded,
                    color: Colors.white,
                  ),
                  onTap: () {
                    _drawerKey.currentState?.toggleDrawer();
                  },
                ),
                const Text("Shadow Beats",
                    style: TextStyle(
                        color: Colors.white, fontFamily: "logo", fontSize: 20)),
                InkWell(
                  child: const Icon(
                    Icons.account_circle,
                    color: Colors.white,
                    size: 30,
                  ),
                  onTap: () {
                    setState(() {
                      profile = !profile;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
