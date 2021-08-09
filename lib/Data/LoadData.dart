import 'dart:convert';

LoadData loadDataFromJson(String str) => LoadData.fromJson(json.decode(str));

String loadDataToJson(LoadData data) => json.encode(data.toJson());

class LoadData {
  LoadData({
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
  });

  String muzeAd;
  String muzeAciklama;
  String calismaSaatleri;
  String girisDetay;
  double latitude;
  double longitude;
  String muzeAdres;
  String muzeMail;
  String muzeTel;
  String muzeWebSite;
  String sehir;
  String ilce;

  factory LoadData.fromJson(Map<String, dynamic> json) => LoadData(
        muzeAd: json["muzeAd"],
        muzeAciklama: json["muzeAciklama"],
        calismaSaatleri: json["calismaSaatleri"],
        girisDetay: json["girisDetay"],
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        muzeAdres: json["muzeAdres"],
        muzeMail: json["muzeMail"],
        muzeTel: json["muzeTel"],
        muzeWebSite: json["muzeWebSite"],
        sehir: json["sehir"],
        ilce: json["ilce"],
      );

  Map<String, dynamic> toJson() => {
        "muzeAd": muzeAd,
        "muzeAciklama": muzeAciklama,
        "calismaSaatleri": calismaSaatleri,
        "girisDetay": girisDetay,
        "latitude": latitude,
        "longitude": longitude,
        "muzeAdres": muzeAdres,
        "muzeMail": muzeMail,
        "muzeTel": muzeTel,
        "muzeWebSite": muzeWebSite,
        "sehir": sehir,
        "ilce": ilce,
      };
}
