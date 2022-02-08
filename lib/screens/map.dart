import 'package:diplom/models/location.dart';
import 'package:diplom/models/post.dart';
import 'package:diplom/utils/utils.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:url_launcher/url_launcher.dart';

class MapPage extends StatefulWidget {
  const MapPage({
    required this.posts,
    Key? key,
  }) : super(key: key);

  final List<Post> posts;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late PageController _pageViewController;
  late MapTileLayerController _mapController;

  late MapZoomPanBehavior _zoomPanBehavior;

  final List<_WonderDetails> _worldWonders = [];

  late int _currentSelectedIndex = 0;
  late int _previousSelectedIndex;
  late int _tappedMarkerIndex;

  late double _cardHeight;

  late bool _canUpdateFocalLatLng;
  late bool _canUpdateZoomLevel;
  late bool _isDesktop;

  bool isLoad = false;

  Future<bool> getPlacemarks() async {
    if (!isLoad) {
      for (var i in widget.posts) {
        if (i.isLocation) {
          if (i.location.isAddress)
          // print('==${_worldWonders.length}/${widget.posts.length}==');
          // final placemarks = kIsWeb
          //     ? []
          //     : await placemarkFromCoordinates(
          //         i.location.lat!,
          //         i.location.lng!,
          //         localeIdentifier: 'ru_RU',
          //       ).timeout(const Duration(seconds: 1), onTimeout: () => []);
          {
            _worldWonders.add(_WonderDetails(
              place: i.location,
              latitude: i.location.lat!,
              longitude: i.location.lng!,
              link: i.link,
              date: DateFormat('dd MMMM yyyy / hh:mm').format(i.getTime),
            ));
          }
        }
      }
      // _worldWonders.add(_WonderDetails(
      //   place: (await placemarkFromCoordinates(
      //     55.782097,
      //     37.724802,
      //     localeIdentifier: 'ru_RU',
      //   ))
      //       .first,
      //   latitude: 55.782097,
      //   longitude: 37.724802,
      //   link: widget.posts[0].link,
      //   date: DateFormat('dd MMMM yyyy / hh:mm')
      //       .format(DateTime(2022, 01, 15, 21, 30)),
      // ));

      MapLatLng? mapLatLng;
      try {
        mapLatLng = MapLatLng(
          _worldWonders[0].latitude,
          _worldWonders[0].longitude,
        );
      } catch (e) {}
      _zoomPanBehavior.focalLatLng = mapLatLng;
      isLoad = true;
    }
    return _worldWonders.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    _canUpdateFocalLatLng = true;
    _canUpdateZoomLevel = true;
    _mapController = MapTileLayerController();

    _zoomPanBehavior = MapZoomPanBehavior(
      minZoomLevel: 3,
      maxZoomLevel: 16,
      enableDoubleTapZooming: true,
    );
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    _mapController.dispose();
    _worldWonders.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    _isDesktop = kIsWeb ||
        themeData.platform == TargetPlatform.macOS ||
        themeData.platform == TargetPlatform.windows ||
        themeData.platform == TargetPlatform.linux;
    if (_canUpdateZoomLevel) {
      _zoomPanBehavior.zoomLevel = _isDesktop ? 12 : 11;
      _canUpdateZoomLevel = false;
    }
    _cardHeight = (MediaQuery.of(context).orientation == Orientation.landscape)
        ? (_isDesktop ? 120 : 90)
        : 110;
    _pageViewController = PageController(
        initialPage: _currentSelectedIndex,
        viewportFraction:
            (MediaQuery.of(context).orientation == Orientation.landscape)
                ? (_isDesktop ? 0.5 : 0.7)
                : 0.8);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Местоположение пользователя из записей'),
      ),
      body: FutureBuilder(
          future: getPlacemarks(),
          builder: (context, state) {
            if (!state.hasData) {
              return LoadingWidgets.loadingCenter();
            }
            return Stack(
              children: <Widget>[
                SfMaps(
                  layers: <MapLayer>[
                    MapTileLayer(
                      /// URL to request the tiles from the providers.
                      ///
                      /// The [urlTemplate] accepts the URL in WMTS format i.e. {z} —
                      /// zoom level, {x} and {y} — tile coordinates.
                      ///
                      /// We will replace the {z}, {x}, {y} internally based on the
                      /// current center point and the zoom level.
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      zoomPanBehavior: _zoomPanBehavior,
                      controller: _mapController,
                      initialMarkersCount: _worldWonders.length,
                      tooltipSettings: const MapTooltipSettings(
                        color: Colors.transparent,
                        hideDelay: double.infinity,
                      ),
                      markerTooltipBuilder: (context, index) {
                        if (_isDesktop) {
                          return ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, top: 5.0, bottom: 5.0),
                                  width: 150,
                                  color: Colors.white,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        _worldWonders[index].date,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                      markerBuilder: (context, index) {
                        final _markerSize =
                            _currentSelectedIndex == index ? 40.0 : 25.0;
                        return MapMarker(
                          latitude: _worldWonders[index].latitude,
                          longitude: _worldWonders[index].longitude,
                          alignment: Alignment.bottomCenter,
                          child: GestureDetector(
                            onTap: () {
                              if (_currentSelectedIndex != index) {
                                _canUpdateFocalLatLng = false;
                                _tappedMarkerIndex = index;
                                _pageViewController.animateToPage(
                                  index,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                );
                              }
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              height: _markerSize,
                              width: _markerSize,
                              child: FittedBox(
                                child: Icon(
                                  Icons.location_on,
                                  color: _currentSelectedIndex == index
                                      ? Colors.blue
                                      : Colors.red,
                                  size: _markerSize,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: _cardHeight,
                    padding: const EdgeInsets.only(bottom: 10),

                    /// PageView which shows the world wonder details at the bottom.
                    child: PageView.builder(
                      itemCount: _worldWonders.length,
                      onPageChanged: _handlePageChange,
                      controller: _pageViewController,
                      itemBuilder: (context, index) {
                        final item = _worldWonders[index];
                        return _Card(
                          currentSelectedIndex: _currentSelectedIndex,
                          item: item,
                          index: index,
                          isDesktop: _isDesktop,
                          pageViewController: _pageViewController,
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }

  void _handlePageChange(int index) {
    /// While updating the page viewer through interaction, selected position's
    /// marker should be moved to the center of the maps. However, when the
    /// marker is directly clicked, only the respective card should be moved to
    /// center and the marker itself should not move to the center of the maps.
    if (!_canUpdateFocalLatLng) {
      if (_tappedMarkerIndex == index) {
        _updateSelectedCard(index);
      }
    } else if (_canUpdateFocalLatLng) {
      _updateSelectedCard(index);
    }
  }

  void _updateSelectedCard(int index) {
    setState(() {
      _previousSelectedIndex = _currentSelectedIndex;
      _currentSelectedIndex = index;
    });

    /// While updating the page viewer through interaction, selected position's
    /// marker should be moved to the center of the maps. However, when the
    /// marker is directly clicked, only the respective card should be moved to
    /// center and the marker itself should not move to the center of the maps.
    if (_canUpdateFocalLatLng) {
      _zoomPanBehavior.focalLatLng = MapLatLng(
          _worldWonders[_currentSelectedIndex].latitude,
          _worldWonders[_currentSelectedIndex].longitude);
    }

    /// Updating the design of the selected marker. Please check the
    /// `markerBuilder` section in the build method to know how this is done.
    _mapController
        .updateMarkers(<int>[_currentSelectedIndex, _previousSelectedIndex]);
    _canUpdateFocalLatLng = true;
  }
}

class _Card extends StatelessWidget {
  const _Card({
    required this.index,
    required this.pageViewController,
    required currentSelectedIndex,
    required this.item,
    required bool isDesktop,
    Key? key,
  })  : _currentSelectedIndex = currentSelectedIndex,
        _isDesktop = isDesktop,
        super(key: key);

  final int _currentSelectedIndex;
  final int index;
  final _WonderDetails item;
  final bool _isDesktop;
  final PageController pageViewController;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: index == _currentSelectedIndex ? 1 : 0.85,
      child: Stack(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.light
                  ? const Color.fromRGBO(255, 255, 255, 1)
                  : const Color.fromRGBO(66, 66, 66, 1),
              border: Border.all(
                color: const Color.fromRGBO(153, 153, 153, 1),
                width: 0.5,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5.0, right: 5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('${item.date}'),
                        const SizedBox(height: 5),
                        Expanded(
                          child: Text(
                            item.place != null
                                ? '${item.place?.name}, ${item.place?.city}'
                                : '',
                          ),
                        ),
                        const SizedBox(height: 5),
                        Linkify(
                          onOpen: _onOpen,
                          text: item.link,
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                          softWrap: false,
                        ),
                      ],
                    ),
                  ),
                ),
                // Adding Image for card.
              ],
            ),
          ),
          // Adding splash to card while tapping.
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: const BorderRadius.all(Radius.elliptical(10, 10)),
              onTap: () {
                if (_currentSelectedIndex != index) {
                  pageViewController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onOpen(LinkableElement link) async {
    if (await canLaunch(link.url)) {
      await launch(link.url);
    } else {
      throw 'Could not launch $link';
    }
  }
}

class _WonderDetails {
  const _WonderDetails({
    required this.place,
    required this.latitude,
    required this.longitude,
    this.link = '',
    this.date = '',
  });

  final CustomLocation? place;
  final double latitude;
  final double longitude;
  final String link;
  final String date;
}
