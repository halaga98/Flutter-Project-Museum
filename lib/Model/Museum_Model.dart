// To parse this JSON data, do
//
//     final museumModel = museumModelFromJson(jsonString);

import 'dart:convert';

MuseumModel museumModelFromJson(String str) =>
    MuseumModel.fromJson(json.decode(str));

String museumModelToJson(MuseumModel data) => json.encode(data.toJson());

class MuseumModel {
  MuseumModel({
    required this.id,
    required this.data,
  });

  Id id;
  List<Datum> data;

  factory MuseumModel.fromJson(Map<String, dynamic> json) => MuseumModel(
        id: Id.fromJson(json["_id"]),
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id.toJson(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    required this.muzeAd,
    required this.muzeAciklama,
    required this.calismaSaatleri,
    required this.girisDetay,
    required this.latitude,
    required this.longitude,
    required this.muzeAdres,
    required this.muzeMail,
    required this.muzeTel,
    required this.muzeWebSite,
    required this.sehir,
    required this.ilce,
    required this.muzekart,
    required this.bresim,
  });

  String muzeAd;
  String muzeAciklama;
  String calismaSaatleri;
  String girisDetay;
  Itude latitude;
  Itude longitude;
  String muzeAdres;
  String muzeMail;
  String muzeTel;
  String muzeWebSite;
  String sehir;
  String ilce;
  String muzekart;
  String bresim;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        muzeAd: json["muzeAd"],
        muzeAciklama: json["muzeAciklama"],
        calismaSaatleri: json["calismaSaatleri"],
        girisDetay: json["girisDetay"],
        latitude: Itude.fromJson(json["latitude"]),
        longitude: Itude.fromJson(json["longitude"]),
        muzeAdres: json["muzeAdres"],
        muzeMail: json["muzeMail"],
        muzeTel: json["muzeTel"],
        muzeWebSite: json["muzeWebSite"],
        sehir: utf8.decode(utf8.encode(json["sehir"])),
        ilce: json["ilce"],
        muzekart: json["muzekart"],
        bresim: json["bresim"],
      );

  Map<String, dynamic> toJson() => {
        "muzeAd": muzeAd,
        "muzeAciklama": muzeAciklama,
        "calismaSaatleri": calismaSaatleri,
        "girisDetay": girisDetay,
        "latitude": latitude.toJson(),
        "longitude": longitude.toJson(),
        "muzeAdres": muzeAdres,
        "muzeMail": muzeMail,
        "muzeTel": muzeTel,
        "muzeWebSite": muzeWebSite,
        "sehir": sehir,
        "ilce": ilce,
        "muzekart": muzekart,
        "bresim": bresim,
      };
}

class Itude {
  Itude({
    required this.numberDouble,
  });

  String numberDouble;

  factory Itude.fromJson(Map<String, dynamic> json) => Itude(
        numberDouble: json["\u0024numberDouble"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "\u0024numberDouble": numberDouble,
      };
}

class Id {
  Id({
    required this.oid,
  });

  String oid;

  factory Id.fromJson(Map<String, dynamic> json) => Id(
        oid: json["\u0024oid"],
      );

  Map<String, dynamic> toJson() => {
        "\u0024oid": oid,
      };
}
