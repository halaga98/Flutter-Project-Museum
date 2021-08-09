import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Model/Museum_Model.dart';
import 'custom_cached_network_image.dart';

class MuseumDetailScreen extends StatelessWidget {
  final Datum data;
  const MuseumDetailScreen({required this.data});

  Widget _showImage() {
    Widget widget;

    if (data.bresim != '') {
      widget = Hero(
        tag: data.bresim,
        child: CustomCachedNetworkImage(
          url: data.bresim,
        ),
      );
    } else {
      widget = Container(
        margin: EdgeInsets.all(40),
        child: Image.asset(
          'images/1024px.png',
          color: Colors.red,
        ),
      );
    }
    return widget;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              actions: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () async {
                      final availableMaps = await MapLauncher.installedMaps;
                      await availableMaps.first.showMarker(
                        coords: Coords(double.parse(data.latitude.numberDouble),
                            double.parse(data.longitude.numberDouble)),
                        title: data.muzeAd,
                      );
                    },
                    child: Icon(
                      Icons.location_on,
                      size: 26.0,
                    ),
                  ),
                ),
              ],
              pinned: true,
              title: Text(data.muzeAd),
              expandedHeight: 350,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  color: Colors.red,
                  child: _showImage(),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  data.muzeAd,
                                  style: TextStyle(
                                    fontSize: 30,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                data.girisDetay,
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          color: Colors.black,
                          height: 15,
                          thickness: 1,
                        ),
                        Text(
                          data.muzeAciklama,
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: "Times New Roman",
                              letterSpacing: 1.5,
                              wordSpacing: 4,
                              fontWeight: FontWeight.w400),
                        ),
                        Divider(
                          color: Colors.black,
                          height: 15,
                          thickness: 1,
                        ),
                        ListTile(
                          title: Text("Çalışma Saatleri :"),
                          subtitle: Text(data.calismaSaatleri),
                          leading: Icon(Icons.info),
                        ),
                        ListTile(
                          title: Text("Adres : "),
                          subtitle: Text(data.muzeAdres),
                          leading: Icon(Icons.info),
                        ),
                        ListTile(
                          onTap: () async {
                            launch('tel://${data.muzeTel}');
                          },
                          title: Text("Telefon : "),
                          subtitle: Text(
                            data.muzeTel,
                          ),
                          leading: Icon(Icons.info),
                        ),
                        ListTile(
                          title: Text("E-Posta : "),
                          subtitle: Text(data.muzeMail),
                          leading: Icon(Icons.info),
                        )
                      ],
                    ),
                  );
                },
                childCount: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
