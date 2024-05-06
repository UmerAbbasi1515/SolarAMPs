class WeatherForeCastModel {
  String? time;
  String? temperature;
  String? forecast;
  String? tempDegree;

  WeatherForeCastModel(
      {time, temperature, forecast, tempDegree});

  WeatherForeCastModel.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    temperature = json['temperature'];
    forecast = json['forecast'];
    tempDegree = json['tempDegree'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['time'] = time;
    data['temperature'] = temperature;
    data['forecast'] = forecast;
    data['tempDegree'] = tempDegree;
    return data;
  }
}
