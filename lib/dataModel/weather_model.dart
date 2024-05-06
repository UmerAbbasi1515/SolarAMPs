import 'package:json_annotation/json_annotation.dart';

//part 'weather_model.g.dart';

//done this file

@JsonSerializable()
class WeatherModel {

  @JsonKey(name: 'temp')
  final String? temp;

  @JsonKey(name: 'temp_min')
  final String? tempMin;

  @JsonKey(name: 'temp_max')
  final String? tempMax;

  @JsonKey(name: 'humidity')
  final String? humidity;

  @JsonKey(name: 'description')
  final String? description;

  @JsonKey(name: 'dt_txt')
  final String? dtTxt;


  WeatherModel({this.temp='', this.tempMin='', this.tempMax='', this.humidity='', this.description='', this.dtTxt=''});

/*  factory WeatherModel.fromJson(Map<String, dynamic> json) =>
      _$WeatherModelFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherModelToJson(this);*/

}