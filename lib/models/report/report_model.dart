class ReportModel {
  String? status;
  String? message;
  List<Data>? data;

  ReportModel({this.status, this.message, this.data});

  ReportModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? driverId;
  int? totalTours;
  Driver? driver;

  Data({this.driverId, this.totalTours, this.driver});

  Data.fromJson(Map<String, dynamic> json) {
    driverId = json['driver_id'];
    totalTours = json['total_tours'];
    driver =
    json['driver'] != null ? new Driver.fromJson(json['driver']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['driver_id'] = this.driverId;
    data['total_tours'] = this.totalTours;
    if (this.driver != null) {
      data['driver'] = this.driver!.toJson();
    }
    return data;
  }
}

class Driver {
  int? id;
  int? userId;
  String? plateNumber;
  String? createdAt;
  String? updatedAt;

  Driver(
      {this.id, this.userId, this.plateNumber, this.createdAt, this.updatedAt});

  Driver.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    plateNumber = json['plate_number'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['plate_number'] = this.plateNumber;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
