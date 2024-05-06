
class CreateSessionRequest{
   String? startDate, startTime, endTime, endDate,batteryStatus, longitude, latitude,timezone,locationTitle;
  int? highRisk, batteryLevel,orgID,clientID,siteID;
  bool? isBookOn, charging;

  CreateSessionRequest(
      {
        this.startDate,
        this.startTime,
        this.endDate,
        this.endTime,
        this.batteryStatus,
        this.longitude,
        this.latitude,
        this.locationTitle,
        this.highRisk,
        this.batteryLevel,
        this.isBookOn,
        this.charging,
        this.orgID,
        this.clientID,
        this.siteID,
        this.timezone
      });

}

class EndSessionRequest{

  // {
  // "jobId" : "552",
  // "bookType" : "2",
  // "pin" : "1234",
  // "lng":"65.222",
  // "lat":"65.11",
  // "organisation_id": "1"
  // }

  String? jobId;
  String? lng;
  String? lat;
  String? organisationId;
  String? bookType = "2";
  String? pin = "1234";

  EndSessionRequest(
  {   this.jobId,
      this.bookType,
      this.pin,
      this.lng,
      this.lat,
      this.organisationId,

  });
}

class LocationModal{
  final String? localArea;
  final double? lat;
  final double? long;

  LocationModal(
    {
      this.localArea,
      this.lat,
      this.long
    }
  );
}