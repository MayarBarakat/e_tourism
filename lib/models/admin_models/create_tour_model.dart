class CreateTourModel {
  String? status;
  String? message;
  Data? data;

  CreateTourModel({this.status, this.message, this.data});

  CreateTourModel.fromJson(Map<String, dynamic> json) {
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
  String? guideId;
  String? driverId;
  String? programId;
  String? price;
  String? startDate;
  String? endDate;
  String? updatedAt;
  String? createdAt;
  int? id;

  Data(
      {this.guideId,
        this.driverId,
        this.programId,
        this.price,
        this.startDate,
        this.endDate,
        this.updatedAt,
        this.createdAt,
        this.id});

  Data.fromJson(Map<String, dynamic> json) {
    guideId = json['guide_id'];
    driverId = json['driver_id'];
    programId = json['program_id'];
    price = json['price'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['guide_id'] = this.guideId;
    data['driver_id'] = this.driverId;
    data['program_id'] = this.programId;
    data['price'] = this.price;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}
