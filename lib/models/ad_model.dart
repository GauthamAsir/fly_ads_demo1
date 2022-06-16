import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class AdModel {
  String? id, fileUrl;
  String campaignName;
  List<dynamic> areaIDs;
  ADStatus? adStatus;
  List<dynamic>? screens;
  Timestamp startDate, endDate;
  double price;
  Timestamp? createdOn, lastModifiedOn;
  PaymentStatus? paymentStatus;
  int screenCount;
  String? userId;
  String? mimeType;

  AdModel(
      {required this.campaignName,
      required this.areaIDs,
      required this.startDate,
      required this.endDate,
      required this.price,
      required this.screenCount,
      this.mimeType,
      this.paymentStatus,
      this.fileUrl,
      this.id,
      this.adStatus,
      this.screens,
      this.createdOn,
      this.lastModifiedOn,
      this.userId});

  static AdModel fromSnap(QueryDocumentSnapshot data) {
    return fromMap(data: data.data()! as Map<String, dynamic>, uid: data.id);
  }

  static AdModel fromMap(
      {required Map<String, dynamic> data, required String uid}) {
    return AdModel(
        id: uid,
        userId: data['user_id'],
        paymentStatus: _getPaymentStatus(data['payment_status'] as int),
        campaignName: data['campaign_name'],
        areaIDs: data['area_ids'],
        startDate: data['start_date'],
        endDate: data['end_date'],
        price: data['price'],
        adStatus: _getAdStatus(data['ad_status'] as int),
        createdOn: data['created_on'],
        lastModifiedOn: data['last_modified_on'],
        screens: data['screens'],
        fileUrl: data['file_url'],
        mimeType: data['mimeType'],
        screenCount: data['screen_count'] ?? 0);
  }

  static ADStatus? _getAdStatus(int s) {
    ADStatus? status;

    for (ADStatus adStatus in ADStatus.values) {
      if (adStatus.index == s) {
        status = adStatus;
        break;
      }
    }

    return status;
  }

  static PaymentStatus? _getPaymentStatus(int s) {
    PaymentStatus? status;

    for (PaymentStatus pS in PaymentStatus.values) {
      if (pS.index == s) {
        status = pS;
        break;
      }
    }

    return status;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': '',
      'user_id': userId ?? '',
      'screen_count': screenCount,
      'campaign_name': campaignName,
      'area_ids': areaIDs,
      'start_date': startDate,
      'end_date': endDate,
      'price': price,
      'ad_status': (adStatus ?? ADStatus.Created).index,
      'screens': screens ?? [],
      'created_on': Timestamp.now(),
      'last_modified_on': Timestamp.now(),
      'file_url': fileUrl ?? '',
      'payment_status': (paymentStatus ?? PaymentStatus.Pending).index,
      'mimeType': mimeType ?? 'video/mp4'
    };
  }

  String toJson() {
    return jsonEncode(<String, dynamic>{
      'id': id ?? '',
      'user_id': userId ?? '',
      'screen_count': screenCount,
      'campaign_name': campaignName,
      'area_ids': areaIDs,
      'start_date_m': startDate.millisecondsSinceEpoch,
      'end_date_m': endDate.millisecondsSinceEpoch,
      'price': price,
      'ad_status': (adStatus ?? ADStatus.Created).index,
      'screens': screens ?? [],
      'created_on_m': createdOn!.millisecondsSinceEpoch,
      'last_modified_on_m': lastModifiedOn!.millisecondsSinceEpoch,
      'file_url': fileUrl ?? '',
      'payment_status': (paymentStatus ?? PaymentStatus.Pending).index,
      'mimeType': mimeType ?? 'video/mp4'
    });
  }

  static AdModel fromJson(String object) {
    Map<String, dynamic> data = jsonDecode(object);

    return AdModel(
        id: data['id'],
        userId: data['user_id'],
        screenCount: data['screen_count'] ?? 0,
        paymentStatus: _getPaymentStatus(data['payment_status'] as int),
        campaignName: data['campaign_name'],
        areaIDs: data['area_ids'],
        startDate:
            Timestamp.fromMillisecondsSinceEpoch(data['start_date_m'] ?? 000),
        endDate:
            Timestamp.fromMillisecondsSinceEpoch(data['end_date_m'] ?? 000),
        price: data['price'],
        adStatus: data['ad_status'],
        createdOn:
            Timestamp.fromMillisecondsSinceEpoch(data['createdOn'] ?? 000),
        lastModifiedOn: Timestamp.fromMillisecondsSinceEpoch(
            data['last_modified_on_m'] ?? 000),
        screens: data['screens'],
        mimeType: data['mimeType'],
        fileUrl: data['file_url']);
  }
}

// ignore: constant_identifier_names
enum ADStatus { Created, Active, Hold, Disabled, Deleted }

// ignore: constant_identifier_names
enum PaymentStatus { Success, Pending, Failed }
