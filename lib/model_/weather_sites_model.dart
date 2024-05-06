class WeatherSitesModel {
  String? refId;
  String? sunriseTimeLocal;
  String? sunsetTimeLocal;
  String? wxPhraseLong;
  String? narrative;
  int? precipChance;
  String? temperature;
  String? uvDescription;
  String? address;
  String? state;
  String? geoLat;
  String? geoLong;

  WeatherSitesModel(
      {refId,
      sunriseTimeLocal,
      sunsetTimeLocal,
      wxPhraseLong,
      narrative,
      precipChance,
      temperature,
      uvDescription,
      address,
      state,
      geoLat,
      geoLong});

  WeatherSitesModel.fromJson(Map<String, dynamic> json) {
    refId = json['refId'];
    sunriseTimeLocal = json['sunriseTimeLocal'];
    sunsetTimeLocal = json['sunsetTimeLocal'];
    wxPhraseLong = json['wxPhraseLong'];
    narrative = json['narrative'];
    precipChance = json['precipChance'];
    temperature = json['temperature'];
    uvDescription = json['uvDescription'];
    address = json['address'];
    state = json['state'];
    geoLat = json['geoLat'];
    geoLong = json['geoLong'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['refId'] = refId;
    data['sunriseTimeLocal'] = sunriseTimeLocal;
    data['sunsetTimeLocal'] = sunsetTimeLocal;
    data['wxPhraseLong'] = wxPhraseLong;
    data['narrative'] = narrative;
    data['precipChance'] = precipChance;
    data['temperature'] = temperature;
    data['uvDescription'] = uvDescription;
    data['address'] = address;
    data['state'] = state;
    data['geoLat'] = geoLat;
    data['geoLong'] = geoLong;
    return data;
  }
}
