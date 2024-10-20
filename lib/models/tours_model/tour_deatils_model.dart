class TourDetailsModel {
  String? status;
  String? message;
  Data? data;

  TourDetailsModel({this.status, this.message, this.data});

  TourDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  int? guideId;
  int? driverId;
  int? programId;
  String? price;
  int? number;
  String? startDate;
  String? endDate;
  String? createdAt;
  String? updatedAt;
  Program? program;

  Data(
      {this.id,
        this.guideId,
        this.driverId,
        this.programId,
        this.price,
        this.number,
        this.startDate,
        this.endDate,
        this.createdAt,
        this.updatedAt,
        this.program});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    guideId = json['guide_id'];
    driverId = json['driver_id'];
    programId = json['program_id'];
    price = json['price'];
    number = json['number'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    program =
    json['program'] != null ? new Program.fromJson(json['program']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['guide_id'] = this.guideId;
    data['driver_id'] = this.driverId;
    data['program_id'] = this.programId;
    data['price'] = this.price;
    data['number'] = this.number;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.program != null) {
      data['program'] = this.program!.toJson();
    }
    return data;
  }
}

class Program {
  int? id;
  String? name;

  Program({this.id, this.name});

  Program.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
