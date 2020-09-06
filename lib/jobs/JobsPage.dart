import 'package:firebaseappcourse/FirebasePage.dart';
import 'package:firebaseappcourse/app/sign_in/platform_alert_dialogue.dart';
import 'package:firebaseappcourse/app/sign_in/platform_exception_alert_dialog.dart';
import 'package:firebaseappcourse/jobs/edit_job_page.dart';
import 'package:firebaseappcourse/jobs/job_list_tile.dart';
import 'package:firebaseappcourse/model/job.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebaseappcourse/services/database.dart';

class JobsPage extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await PlatformAlertDialogue(
      title: 'SignOut',
      content: 'Are you sure you wish to sign out?',
      cancelActionText: 'Cancel',
      defaultActionText: 'Signout',
    ).show(context);
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    //TODO: delete soon
    final database = Provider.of<Database>(context);
    database.jobsStream();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Jobs',
        ),
        actions: <Widget>[
          FlatButton(
              child: Text(
                'Log Out',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              ),
              onPressed: () {
                confirmSignOut(context);
              }),
        ],
      ),
      body: _buildContents(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => AddJobPage.show(context),
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context);
    return StreamBuilder<List<Job>>(
        stream: database.jobsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final jobs = snapshot.data;
            final children = jobs
                .map((job) => JobsListTile(job: job, onTap: () {}))
                .toList();
            return ListView(children: children);
          }
          if (snapshot.hasError) {
            return Center(child: Text('An error has occured'));
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}
