import 'package:firebaseappcourse/model/job.dart';
import 'package:flutter/material.dart';

class JobsListTile extends StatelessWidget {
  const JobsListTile({Key key, this.job, this.onTap}) : super(key: key);
  final Job job;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(job.name),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
