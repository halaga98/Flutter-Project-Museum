import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Model/Museum_Model.dart';
import 'city_museums.dart';
import 'custom_cached_network_image.dart';

class CityCard extends StatelessWidget {
  final MuseumModel model;
  const CityCard({required this.model});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => CityMusems(
              model: model,
            ));
      },
      child: Container(
        height: 250,
        margin: EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(.2),
              blurRadius: 1.0,
              spreadRadius: 0.1,
              offset: const Offset(
                0.0,
                0.0,
              ),
            )
          ],
        ),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 5,
              ),
              Text(
                model.data[0].sehir,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 2.5, right: 2.5, bottom: 2.5),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(.7),
                          blurRadius: 1.0,
                          spreadRadius: 2.5,
                          offset: const Offset(
                            0.0,
                            0.0,
                          ),
                        )
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: model.data[0].bresim != ''
                          ? Container(
                              child: Hero(
                                tag: model.data[0].bresim,
                                child: CustomCachedNetworkImage(
                                  url: model.data[0].bresim,
                                  boxFit: BoxFit.fill,
                                ),
                              ),
                            )
                          : Container(
                              width: 50,
                              height: 50,
                              child: Container(
                                margin: EdgeInsets.all(8),
                                child: Image.asset('images/256px.png'),
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.7),
                                    spreadRadius: 1,
                                    blurRadius: 1,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
