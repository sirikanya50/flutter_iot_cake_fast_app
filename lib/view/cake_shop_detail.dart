
import 'package:flutter/material.dart';
import 'package:flutter_iot_cake_fast_app/models/cake_shop.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class CakeShopDetail extends StatefulWidget {
  //สร้างตัวแปรรับข้อมูลร้านเค้กที่ส่งมาจากหน้า CakeShopListUi
  CakeShop? cakeShopDetail;
  // เอาตัวแปรที่สร้างไว้มารับข้อมูลที่ส่งมาจากหน้า CakeShopListUi
  CakeShopDetail({super.key, this.cakeShopDetail});

  @override
  State<CakeShopDetail> createState() => _CakeShopDetailState();
}

class _CakeShopDetailState extends State<CakeShopDetail> {
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    await launchUrl(launchUri);
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  MapController? _mapController;

  @override
  void initState() {
    _mapController = MapController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 85, 6, 32),
        title: Text(
          widget.cakeShopDetail!.name!,
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(45.0),
          child: Center(
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/images/${widget.cakeShopDetail!.image1!}',
                    width: 130,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/images/${widget.cakeShopDetail!.image2!}',
                        width: 130,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 20),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/images/${widget.cakeShopDetail!.image3!}',
                        width: 130,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(FontAwesomeIcons.shop),
                          title: Text(widget.cakeShopDetail!.name!),
                        ),
                        ListTile(
                          leading: Icon(FontAwesomeIcons.locationPin),
                          title: Text(widget.cakeShopDetail!.address!),
                        ),
                        ListTile(
                          onTap: () {
                            _makePhoneCall(widget.cakeShopDetail!.phone!);
                          },
                          leading: Icon(
                            FontAwesomeIcons.phone,
                            color: const Color.fromARGB(255, 78, 77, 77),
                          ),
                          title: Text(widget.cakeShopDetail!.phone!),
                        ),
                        ListTile(
                          onTap: () {
                            _launchInBrowser(
                              Uri.parse(widget.cakeShopDetail!.website!),
                            );
                          },
                          leading: Icon(
                            FontAwesomeIcons.globe,
                            color: const Color.fromARGB(255, 78, 77, 77),
                          ),
                          title: Text(widget.cakeShopDetail!.website!),
                        ),
                        ListTile(
                          onTap: () {
                            _launchInBrowser(
                              Uri.parse(widget.cakeShopDetail!.facebook!),
                            );
                          },
                          leading: Icon(
                            FontAwesomeIcons.facebook,
                            color: const Color.fromARGB(255, 78, 77, 77),
                          ),
                          title: Text(widget.cakeShopDetail!.facebook!),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  height: 300,
                  child: FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: LatLng(
                        double.parse(widget.cakeShopDetail!.latitude!),
                        double.parse(widget.cakeShopDetail!.longitude!),
                      ),
                      initialZoom: 15,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.app',
                      ),
                      RichAttributionWidget(
                        attributions: [
                          TextSourceAttribution(
                            'OpenStreetMap contributors',
                            onTap: () {
                              launchUrl(
                                Uri.parse('https://www.openstreetmap.org/'),
                              );
                            },
                          ),
                        ],
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: LatLng(
                              double.parse(widget.cakeShopDetail!.latitude!),
                              double.parse(widget.cakeShopDetail!.longitude!),
                            ),
                            child: InkWell(
                              onTap: () {
                                String googleMapsUrl =
                                    'https://www.google.com/maps/search/?api=1&query=${widget.cakeShopDetail!.latitude},${widget.cakeShopDetail!.longitude}';
                                _launchInBrowser(Uri.parse(googleMapsUrl));
                              },
                              child: Icon(
                                Icons.location_on,
                                color: Colors.red,
                                size: 40,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
