import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebaseappcourse/model/job.dart';
import 'package:firebaseappcourse/services/APIPath.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:firebaseappcourse/services/FirestoreService.dart';

abstract class Database {
  Future<void> createJob(Job job);
  Stream<List<Job>> jobsStream();
}

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

  final _service = FirestoreService.instance;

  String documentIdForCurrentTime() => DateTime.now().toIso8601String();

  Future<void> createJob(Job job) async => await _service.setData(
        path: APIPath.job(uid, documentIdForCurrentTime()),
        data: job.toMap(),
      );

  Stream<List<Job>> jobsStream() => _service.collectionStream(
        path: APIPath.jobs(uid),
        builder: (data) => Job.fromMap(data),
      );
}
