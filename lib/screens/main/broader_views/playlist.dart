import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:zedmusic/screens/main/broader_views/songs_by_playlist.dart';
import '../../../components/kBackground.dart';
import '../../../components/kText.dart';
import '../../../components/loading.dart';
import '../../../components/searchbox.dart';
import '../../../constants/colors.dart';

enum Operation { create, edit }

class PlayListView extends StatefulWidget {
  static const routeName = '/playlists';

  const PlayListView({Key? key}) : super(key: key);

  @override
  State<PlayListView> createState() => _PlayListViewState();
}

class _PlayListViewState extends State<PlayListView> {
  final OnAudioQuery audioQuery = OnAudioQuery();
  final playlistNameController = TextEditingController();

  message(String message) {
    return ScaffoldMessenger(
      child: SnackBar(
        backgroundColor: primaryColor,
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // add and rename playlist
  _addAndEditPlaylist(Operation operation, int playlistId) {
    if (playlistNameController.text.isEmpty) {
      message('Input is empty');
      return;
    } else {
      switch (operation) {
        case Operation.create:
          audioQuery.createPlaylist(playlistNameController.text);
          break;

        case Operation.edit:
          audioQuery.renamePlaylist(playlistId, playlistNameController.text);
          break;
      }
      playlistNameController.text = "";
      Navigator.of(context).pop();
    }
  }

  // show modal for playlist creation and renaming
  _showModal(Operation operation, int playlistId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Wrap(
          children: const [
            Icon(
              Icons.music_note,
              size: 30,
              color: primaryColor,
            ),
            SizedBox(width: 5),
            Text(
              'ZedMusic',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: TextField(
          autofocus: true,
          controller: playlistNameController,
          decoration: const InputDecoration(
            hintText: 'New Playlist Name',
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: btnBg,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(5),
            ),
            onPressed: () {
              switch (operation) {
                case Operation.create:
                  _addAndEditPlaylist(Operation.create, 0);
                  break;

                case Operation.edit:
                  _addAndEditPlaylist(Operation.edit, playlistId);
                  break;
              }
            },
            child: Text(
              operation == Operation.create
                  ? 'Add Playlist'
                  : 'Rename Playlist',
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: btnBg,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(5),
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Delete Request Modal
  _deleteRequestModal(String playlist, int playlistId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Wrap(
          children: const [
            Icon(
              Icons.music_note,
              size: 30,
              color: primaryColor,
            ),
            SizedBox(width: 5),
            Text(
              'ZedMusic',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Text('Do you want to delete $playlist playlist?'),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: btnBg,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(5),
            ),
            onPressed: () => {
              setState(() {
                audioQuery.removePlaylist(playlistId);
              }),
              Navigator.of(context).pop(),
            },
            child: const Text(
              'Yes',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: btnBg,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(5),
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'No',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    var data =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    int playlistlength = data['length'];

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: primaryColor,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () => _showModal(Operation.create, 0),
        child: const Icon(
          Icons.add,
          color: primaryColor,
        ),
      ),
      body: KBackground(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 18.0,
            right: 18.0,
            top: 45.0,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Builder(
                      builder: (context) => GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          height: 25,
                          width: 30,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.chevron_left,
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 50),
                    Image.asset('assets/images/small_logo.png'),
                  ],
                ),
                const SizedBox(height: 25),
                const SearchBox(),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const KText(
                      firstText: 'All',
                      secondText: ' Playlists',
                    ),
                    Text(
                      '$playlistlength playlists',
                      style: const TextStyle(
                        color: searchBoxBg,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                FutureBuilder<List<PlaylistModel>>(
                  future: audioQuery.queryPlaylists(
                    orderType: OrderType.ASC_OR_SMALLER,
                    uriType: UriType.EXTERNAL,
                    sortType: null,
                    ignoreCase: true,
                  ),
                  builder: (context, item) {
                    var playlists = item.data;
                    if (playlists == null) {
                      return const Center(
                        child: Loading(),
                      );
                    }
                    if (playlists.isEmpty) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/empty.png',
                            width: 90,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Playlists are empty!',
                            style: TextStyle(
                              color: searchBoxBg,
                            ),
                          ),
                        ],
                      );
                    }
                    return SizedBox(
                        height: size.height / 1.3,
                        child: GridView.builder(
                          padding: const EdgeInsets.only(top: 10),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                orientation == Orientation.portrait ? 2 : 3,
                            mainAxisSpacing: 7,
                            crossAxisSpacing: 10,
                          ),
                          itemCount: playlists.length,
                          itemBuilder: (context, index) => GestureDetector(
                            onTap: () => Navigator.of(context).pushNamed(
                              PlayListSongs.routeName,
                              arguments: {
                                'playlist': playlists[index],
                              },
                            ),
                            child: Column(
                              children: [
                                Text(
                                  playlists[index].playlist,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    'assets/images/playlist1.png',
                                    height: 90,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${playlists[index].numOfSongs} songs',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        _showModal(
                                          Operation.edit,
                                          playlists[index].id,
                                        );
                                        setState(() {
                                          playlistNameController.text =
                                              playlists[index].playlist;
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.edit_note,
                                        color: pColor,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () => _deleteRequestModal(
                                        playlists[index].playlist,
                                        playlists[index].id,
                                      ),
                                      icon: const Icon(
                                        Icons.delete_forever,
                                        color: ambientBg,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
