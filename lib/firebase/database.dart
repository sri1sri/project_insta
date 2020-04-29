import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:projectinsta/database_model/contest_details.dart';
import 'api_path.dart';
import 'firestore_service.dart';

abstract class Database {

  Stream<ContestDetails> getContestDetails(String contestID);
  Future<void> updateContestDetails(ContestDetails contestDetails, String contestID);
}

Database DBreference;


class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

  final _service = FirestoreService.instance;



  @override
  Stream<ContestDetails> getContestDetails(String contestID) => _service.documentStream(
        path: APIPath.contestDetails(contestID),
        builder: (data, documentId) => ContestDetails.fromMap(data, documentId),
      );

  @override
  Future<void> updateContestDetails(ContestDetails contestDetails, String contestID) async =>
      await _service.updateData(
        path: APIPath.contestDetails(contestID),
        data: contestDetails.toMap(),
      );


}
