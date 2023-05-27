import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:minder/domain/entity/location/location.dart' as location;
import 'package:minder/domain/entity/stadium/stadium.dart';
import 'package:minder/presentation/bloc/location/data/locations/locations_cubit.dart';
import 'package:minder/presentation/bloc/stadium/data/stadiums/stadiums_cubit.dart';
import 'package:minder/presentation/widget/textfield/textfield_widget.dart';
import 'package:minder/util/constant/path/icon_path.dart';
import 'package:minder/util/constant/path/image_path.dart';
import 'package:minder/util/helper/location_helper.dart';
import 'package:minder/util/style/base_color.dart';
import 'package:minder/util/style/base_icon.dart';
import 'package:minder/util/style/base_text_style.dart';

class MapWidget extends StatefulWidget {
  final LatLng latLng;
  final Function(LatLng?) onChanged;
  final bool isEdit;
  final double radius;
  final Function(bool) isNearByStadium;

  const MapWidget({
    Key? key,
    required this.onChanged,
    required this.isEdit,
    required this.radius,
    required this.latLng,
    required this.isNearByStadium,
  }) : super(key: key);

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  final Completer<GoogleMapController> googleMapController = Completer();
  final TextEditingController searchController = TextEditingController();
  LatLng? latLng;
  final List<Stadium> stadiums = List.empty(growable: true);
  double ratio = 1;
  BitmapDescriptor? icon;
  String? _mapStyle;
  final List<Stadium> inRange = List.empty(growable: true);
  final List<location.Location> locations = List.empty(growable: true);
  Timer? searchOnStoppedTyping;

  @override
  void initState() {
    GetIt.instance.get<StadiumsCubit>().getData();
    GetIt.instance.get<StadiumsCubit>().stream.listen((event) {
      if (!mounted) return;
      if (event is StadiumsSuccess) {
        setState(() {
          stadiums.clear();
          stadiums.addAll(event.stadiums);
        });
      }
    });
    GetIt.instance.get<LocationsCubit>().clean();
    GetIt.instance.get<LocationsCubit>().stream.listen((event) {
      if (!mounted) return;
      if (event is LocationsSuccess) {
        setState(() {
          locations.clear();
          locations.addAll(event.locations);
        });
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      icon = BitmapDescriptor.fromBytes(
          await getBytesFromAsset(ImagePath.mark, 64));
    });

    rootBundle.loadString('assets/map_style/map_style.txt').then((string) {
      setState(() {
        _mapStyle = string;
      });
    });
    super.initState();
  }

  @override
  void didUpdateWidget(covariant MapWidget oldWidget) {
    final pageSize = MediaQuery.of(context).size;
    setState(() {
      ratio = sqrt((pageSize.width * getRatio(widget.radius) / widget.radius));
    });
    if (!widget.isEdit) {
      setState(() {
        latLng = null;
      });
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        (await googleMapController.future)
            .animateCamera(CameraUpdate.newLatLngZoom(widget.latLng, ratio));
      });
    } else {
      setState(() {
        inRange.clear();
        inRange.addAll(stadiums.where((e) {
          final distance = Geolocator.distanceBetween(
                  e.latitude!,
                  e.longitude!,
                  latLng?.latitude ?? widget.latLng.latitude,
                  latLng?.longitude ?? widget.latLng.longitude) /
              1000;
          return distance <= widget.radius;
        }).toList());
      });
      if (latLng != null) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
          (await googleMapController.future)
              .animateCamera(CameraUpdate.newLatLngZoom(latLng!, ratio));
        });
      } else {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
          (await googleMapController.future)
              .animateCamera(CameraUpdate.newLatLngZoom(widget.latLng, ratio));
        });
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final pageSize = MediaQuery.of(context).size;
    return Expanded(
      child: Stack(
        children: [
          GoogleMap(
            myLocationButtonEnabled: false,
            initialCameraPosition: CameraPosition(
                target: widget.latLng,
                zoom: sqrt((pageSize.width *
                    getRatio(widget.radius) /
                    widget.radius))),
            onMapCreated: (GoogleMapController controller) async {
              googleMapController.complete(controller);
              (await googleMapController.future).setMapStyle(_mapStyle);
            },
            markers: {
              if (latLng == null)
                Marker(
                  markerId: MarkerId(widget.latLng.latitude.toString()),
                  position: widget.latLng,
                ),
              if (latLng != null)
                Marker(
                  markerId: MarkerId(latLng!.latitude.toString()),
                  position: latLng!,
                ),
              ...stadiums.map((e) => Marker(
                  markerId: MarkerId(e.id!),
                  position: LatLng(e.latitude!, e.longitude!),
                  infoWindow: InfoWindow(title: e.name),
                  icon: icon ?? BitmapDescriptor.defaultMarker,
                  onTap: () => selectMarker(LatLng(e.latitude!, e.longitude!))))
            },
            circles: {
              if (latLng == null)
                Circle(
                    circleId: CircleId(widget.latLng.latitude.toString()),
                    center: widget.latLng,
                    radius: widget.radius * 1000,
                    strokeWidth: 0,
                    fillColor: BaseColor.green500.withOpacity(0.2)),
              if (latLng != null)
                Circle(
                    circleId: CircleId(latLng!.latitude.toString()),
                    center: latLng!,
                    radius: widget.radius * 1000,
                    strokeWidth: 0,
                    fillColor: inRange.isNotEmpty
                        ? BaseColor.green500.withOpacity(0.2)
                        : BaseColor.red500.withOpacity(0.2)),
            },
          ),
          if (widget.isEdit)
            Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 33.5),
                child: Stack(
                  children: [
                    if (locations.isNotEmpty)
                      Container(
                        width: double.infinity,
                        height: 300,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(40)),
                        child: ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 48),
                            shrinkWrap: true,
                            itemCount: locations.length,
                            itemBuilder: (context, index) {
                              final location = locations[index];
                              return ListTile(
                                style: ListTileStyle.list,
                                leading: BaseIcon.base(
                                  IconPath.locationLine,
                                ),
                                title: Text(
                                  location.description!,
                                  style: BaseTextStyle.body1(),
                                ),
                                onTap: () => selectLocation(location),
                              );
                            }),
                      ),
                    TextFieldWidget.searchWhite(
                      onSuffixIconTap: () async {
                        setState(() {
                          searchController.clear();
                          locations.clear();
                          latLng = null;
                        });
                        (await googleMapController.future).animateCamera(
                            CameraUpdate.newLatLngZoom(
                                widget.latLng,
                                widget.radius != 0
                                    ? sqrt((pageSize.width *
                                        getRatio(widget.radius) /
                                        widget.radius))
                                    : 18));
                      },
                      textEditingController: searchController,
                      onChanged: (value) => _onChangeHandler(value),
                    ),
                  ],
                ))
        ],
      ),
    );
  }

  double getRatio(double radius) {
    if (radius == 5) return 2;
    if (radius == 10) return 3.6;
    if (radius == 20) return 5.8;
    if (radius == 50) return 11;
    if (radius == 100) return 18;
    return 1;
  }

  void selectMarker(LatLng value) {
    if (widget.isEdit) {
      setState(() {
        latLng = value;
        inRange.clear();
        inRange.addAll(stadiums.where((e) {
          final distance = Geolocator.distanceBetween(
                  e.latitude!,
                  e.longitude!,
                  latLng?.latitude ?? widget.latLng.latitude,
                  latLng?.longitude ?? widget.latLng.longitude) /
              1000;
          return distance <= widget.radius;
        }).toList());
        widget.isNearByStadium(inRange.isNotEmpty);
      });
    }
  }

  void selectLocation(location.Location location) async {
    final pageSize = MediaQuery.of(context).size;
    setState(() {
      FocusScope.of(context).unfocus();
      locations.clear();
      searchController.text = location.description!;
      latLng = LatLng(location.latLng!.latitude, location.latLng!.longitude);
      inRange.clear();
      inRange.addAll(stadiums.where((e) {
        return LocationHelper.distance(
                LatLng(
                  e.latitude!,
                  e.longitude!,
                ),
                LatLng(latLng?.latitude ?? widget.latLng.latitude,
                    latLng?.longitude ?? widget.latLng.longitude)) <=
            widget.radius;
      }).toList());
      widget.isNearByStadium(inRange.isNotEmpty);
      widget.onChanged(latLng);
    });
    (await googleMapController.future).animateCamera(CameraUpdate.newLatLngZoom(
        latLng!,
        widget.radius != 0
            ? sqrt((pageSize.width * getRatio(widget.radius) / widget.radius))
            : 18));
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  _onChangeHandler(value) {
    const duration = Duration(milliseconds: 800);
    if (searchOnStoppedTyping != null) {
      setState(() => searchOnStoppedTyping!.cancel());
    }
    setState(() => searchOnStoppedTyping = Timer(duration, () {
          if (value.isNotEmpty) {
            GetIt.instance.get<LocationsCubit>().getData(value);
          } else {
            setState(() {
              locations.clear();
            });
          }
        }));
  }
}
