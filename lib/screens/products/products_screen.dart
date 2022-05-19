import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fly_ads_demo1/models/item_model.dart';
import 'package:fly_ads_demo1/screens/city_model.dart';
import 'package:fly_ads_demo1/utils/responsive.dart';
import 'package:latlng/latlng.dart';
import 'package:map/map.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  static const String sampleShortText =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus viverra ante et arcu hendrerit suscipit. Phasellus posuere erat a purus mollis eleifend. Morbi ac vestibulum nisi, ut faucibus libero. Ut id feugiat lacus. Nam blandit dui ante.';

  static const String testImage =
      'https://image.shutterstock.com/shutterstock/photos/749994316/display_1500/stock-photo-gateway-of-india-mumbai-beautiful-landscape-birds-flying-over-cityscape-famous-landmark-749994316.jpg';

  final controller =
      MapController(location: LatLng(19.0411261, 72.8592133), zoom: 14);

  final data = [
    CityModel(
      name: 'Mumbai',
      description: 'Mumbai City',
      image: testImage,
      items: [
        ItemModel(
            name: 'Test 1',
            description: 'Test 1 Description ' + sampleShortText,
            image: testImage,
            latLng: LatLng(19.0411261, 72.8592133),
            activeFrom: DateTime.now(),
            isActive: true),
        ItemModel(
            name: 'Test 2',
            description: 'Test 2 Description ' + sampleShortText,
            image: testImage,
            latLng: LatLng(19.0435702, 72.860769),
            activeFrom: DateTime.now(),
            isActive: true),
        ItemModel(
            name: 'Test 3',
            description: 'Test 3 Description ' + sampleShortText,
            image: testImage,
            latLng: LatLng(19.0408015, 72.8642666),
            activeFrom: DateTime.now(),
            isActive: true),
        ItemModel(
            name: 'Test 4',
            description: 'Test 4 Description ' + sampleShortText,
            image: testImage,
            latLng: LatLng(19.0408624, 72.8619921),
            activeFrom: DateTime.now(),
            isActive: true),
        ItemModel(
            name: 'Test 5',
            description: 'Test 5 Description ' + sampleShortText,
            image: testImage,
            latLng: LatLng(19.0404161, 72.8613913),
            activeFrom: DateTime.now(),
            isActive: true),
        ItemModel(
            name: 'Test 6',
            description: 'Test 6 Description ' + sampleShortText,
            image: testImage,
            latLng: LatLng(19.0406088, 72.8592991),
            activeFrom: DateTime.now(),
            isActive: true),
      ],
    ),
  ];

  void _gotoDefault() {
    controller.center = LatLng(19.0411261, 72.8592133);
    setState(() {});
  }

  Offset? _dragStart;
  double _scaleStart = 1.0;

  void _onScaleStart(ScaleStartDetails details) {
    _dragStart = details.focalPoint;
    _scaleStart = 1.0;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    final scaleDiff = details.scale - _scaleStart;
    _scaleStart = details.scale;

    if (scaleDiff > 0) {
      controller.zoom += 0.02;
      setState(() {});
    } else if (scaleDiff < 0) {
      controller.zoom -= 0.02;
      setState(() {});
    } else {
      final now = details.focalPoint;
      final diff = now - _dragStart!;
      _dragStart = now;
      controller.drag(diff.dx, diff.dy);
      setState(() {});
    }
  }

  List<int> _selectedItem = [0, 0];

  Widget _buildMarkerWidget(Offset pos, Color color, List<int> selected) {
    return Positioned(
      left: pos.dx - 16,
      top: pos.dy - 16,
      // width: 24,
      // height: 24,
      child: InkWell(
          onTap: () {
            _selectedItem = selected;
            // buildDetailWidget(pos: pos);
            log('HEY');
            controller.center = data[selected[0]].items![selected[1]].latLng;
            controller.zoom = 16;
            setState(() {});

            if(!Responsive.isDesktop(context)) {
              showDetailDialog();
            }
          },
          child: Icon(
            Icons.bike_scooter_rounded,
            color: color,
            size: 32,
          )),
    );
  }

  void showDetailDialog() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => AlertDialog(
              content: detailCard(context),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Dismiss'))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Responsive(
        desktop: Row(
          children: [
            Expanded(
              child: detailCard(context),
            ),
            Expanded(
              flex: 2,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                child: mapWidget(),
              ),
            )
          ],
        ),
        mobile: mapWidget(),
      ),
    );
  }

  Widget mapWidget() {
    return MapLayoutBuilder(
      controller: controller,
      builder: (context, transformer) {
        List<Offset> markerPositions = [];

        var markerWidgets = [];

        for (int i = 0; i < data[0].items!.length; i++) {
          final item = data[0].items![i];

          final pos = transformer.fromLatLngToXYCoords(item.latLng);
          markerPositions.add(pos);
          markerWidgets.add(_buildMarkerWidget(pos, Colors.red, [0, i]));
        }

        // final markerWidgets = markerPositions.map(
        //       (pos) =>
        //       _buildMarkerWidget(pos, Colors.red,
        //           ),
        // );

        // final homeLocation =
        //     transformer.fromLatLngToXYCoords(markers[0]);
        //
        // final homeMarkerWidget =
        //     _buildMarkerWidget(homeLocation, Colors.black);

        // final centerLocation = Offset(
        //     transformer.constraints.biggest.width / 2,
        //     transformer.constraints.biggest.height / 2);
        //
        // final centerMarkerWidget =
        //     _buildMarkerWidget(centerLocation, Colors.purple);

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          // onDoubleTap: _onDoubleTap,
          onScaleStart: _onScaleStart,
          onScaleUpdate: _onScaleUpdate,
          onTapUp: (details) {
            // detailWidget = null;
            // setState(() {
            //
            // });
            // final location =
            //     transformer.fromXYCoordsToLatLng(details.localPosition);
            //
            // final clicked = transformer.fromLatLngToXYCoords(location);

            // print('${location.longitude}, ${location.latitude}');
            // print('${clicked.dx}, ${clicked.dy}');
            // print(
            //     '${details.localPosition.dx}, ${details.localPosition.dy}');
          },
          child: Listener(
            behavior: HitTestBehavior.opaque,
            onPointerSignal: (event) {
              if (event is PointerScrollEvent) {
                final delta = event.scrollDelta;

                controller.zoom -= delta.dy / 1000.0;
                setState(() {});
              }
            },
            child: Stack(
              children: [
                Map(
                  controller: controller,
                  builder: (context, x, y, z) {
                    //Legal notice: This url is only used for demo and educational purposes. You need a license key for production use.

                    //Google Maps
                    final url =
                        'https://www.google.com/maps/vt/pb=!1m4!1m3!1i$z!2i$x!3i$y!2m3!1e0!2sm!3i420120488!3m7!2sen!5e1105!12m4!1e68!2m2!1sset!2sRoadmap!4e0!5m1!1e0!23i4111425';

                    // final darkUrl =
                    //     'https://maps.googleapis.com/maps/vt?pb=!1m5!1m4!1i$z!2i$x!3i$y!4i256!2m3!1e0!2sm!3i556279080!3m17!2sen-US!3sUS!5e18!12m4!1e68!2m2!1sset!2sRoadmap!12m3!1e37!2m1!1ssmartmaps!12m4!1e26!2m2!1sstyles!2zcC52Om9uLHMuZTpsfHAudjpvZmZ8cC5zOi0xMDAscy5lOmwudC5mfHAuczozNnxwLmM6I2ZmMDAwMDAwfHAubDo0MHxwLnY6b2ZmLHMuZTpsLnQuc3xwLnY6b2ZmfHAuYzojZmYwMDAwMDB8cC5sOjE2LHMuZTpsLml8cC52Om9mZixzLnQ6MXxzLmU6Zy5mfHAuYzojZmYwMDAwMDB8cC5sOjIwLHMudDoxfHMuZTpnLnN8cC5jOiNmZjAwMDAwMHxwLmw6MTd8cC53OjEuMixzLnQ6NXxzLmU6Z3xwLmM6I2ZmMDAwMDAwfHAubDoyMCxzLnQ6NXxzLmU6Zy5mfHAuYzojZmY0ZDYwNTkscy50OjV8cy5lOmcuc3xwLmM6I2ZmNGQ2MDU5LHMudDo4MnxzLmU6Zy5mfHAuYzojZmY0ZDYwNTkscy50OjJ8cy5lOmd8cC5sOjIxLHMudDoyfHMuZTpnLmZ8cC5jOiNmZjRkNjA1OSxzLnQ6MnxzLmU6Zy5zfHAuYzojZmY0ZDYwNTkscy50OjN8cy5lOmd8cC52Om9ufHAuYzojZmY3ZjhkODkscy50OjN8cy5lOmcuZnxwLmM6I2ZmN2Y4ZDg5LHMudDo0OXxzLmU6Zy5mfHAuYzojZmY3ZjhkODl8cC5sOjE3LHMudDo0OXxzLmU6Zy5zfHAuYzojZmY3ZjhkODl8cC5sOjI5fHAudzowLjIscy50OjUwfHMuZTpnfHAuYzojZmYwMDAwMDB8cC5sOjE4LHMudDo1MHxzLmU6Zy5mfHAuYzojZmY3ZjhkODkscy50OjUwfHMuZTpnLnN8cC5jOiNmZjdmOGQ4OSxzLnQ6NTF8cy5lOmd8cC5jOiNmZjAwMDAwMHxwLmw6MTYscy50OjUxfHMuZTpnLmZ8cC5jOiNmZjdmOGQ4OSxzLnQ6NTF8cy5lOmcuc3xwLmM6I2ZmN2Y4ZDg5LHMudDo0fHMuZTpnfHAuYzojZmYwMDAwMDB8cC5sOjE5LHMudDo2fHAuYzojZmYyYjM2Mzh8cC52Om9uLHMudDo2fHMuZTpnfHAuYzojZmYyYjM2Mzh8cC5sOjE3LHMudDo2fHMuZTpnLmZ8cC5jOiNmZjI0MjgyYixzLnQ6NnxzLmU6Zy5zfHAuYzojZmYyNDI4MmIscy50OjZ8cy5lOmx8cC52Om9mZixzLnQ6NnxzLmU6bC50fHAudjpvZmYscy50OjZ8cy5lOmwudC5mfHAudjpvZmYscy50OjZ8cy5lOmwudC5zfHAudjpvZmYscy50OjZ8cy5lOmwuaXxwLnY6b2Zm!4e0&key=AIzaSyAOqYYyBbtXQEtcHG7hwAwyCPQSYidG8yU&token=31440';
                    //Mapbox Streets
                    // final url =
                    //     'https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/$z/$x/$y?access_token=AIzaSyDJp4Fu_iSKxCXvUtSHLB3TCj7vdSJ2XIs';

                    return CachedNetworkImage(
                      imageUrl: url,
                      fit: BoxFit.cover,
                    );
                  },
                ),
                // homeMarkerWidget,
                ...markerWidgets,
                // centerMarkerWidget,
              ],
            ),
          ),
        );
      },
    );
  }

  Widget detailCard(BuildContext context) {
    final item = data[_selectedItem[0]].items![_selectedItem[1]];

    return SingleChildScrollView(
      physics: Responsive.isMobile(context)
          ? const BouncingScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: Responsive.isDesktop(context)
                ? MediaQuery.of(context).size.height / 3
                : MediaQuery.of(context).size.height / 4.5,
            width: double.infinity,
            child: CircleAvatar(
              radius: 100,
              backgroundImage: NetworkImage(
                item.image,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
              item.name,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              item.description,
              style: Theme.of(context)
                  .textTheme
                  .subtitle2!
                  .copyWith(fontWeight: FontWeight.w500, height: 1.5),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Active from ' + item.activeFrom.toString(),
              style: Theme.of(context)
                  .textTheme
                  .caption!
                  .copyWith(fontWeight: FontWeight.w500, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
