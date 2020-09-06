import 'package:firebaseappcourse/app/sign_in/platform_alert_dialogue.dart';
import 'package:firebaseappcourse/app/sign_in/platform_exception_alert_dialog.dart';
import 'package:firebaseappcourse/model/job.dart';
import 'package:firebaseappcourse/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class AddJobPage extends StatefulWidget {
  const AddJobPage({Key key, this.database, this.job}) : super(key: key);
  final Database database;
  final Job job;

  static Future<void> show(BuildContext context, {Job job}) async {
    final database = Provider.of<Database>(context);
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => AddJobPage(database: database, job: job),
      fullscreenDialog: true,
    ));
  }

  @override
  _AddJobPageState createState() => _AddJobPageState();
}

class _AddJobPageState extends State<AddJobPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text('Add Job'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Save',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            onPressed: () => _submit(),
          ),
        ],
      ),
      body: _buildContents(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
                child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildForm(),
            ))));
  }

  void _submit() async {
    if (_validateAndSaveForm()) {
      try {
        final jobs = await widget.database.jobsStream().first;
        final allNames = jobs.map((job) => job.name).toList();
        if (allNames.contains(_name)) {
          PlatformAlertDialogue(
            title: 'Name already used',
            content: 'Use a different name',
            defaultActionText: 'OK',
          ).show(context);
        } else {
          final job = Job(name: _name, ratePerHour: _ratePerHour);
          await widget.database.createJob(job);
          Navigator.of(context).pop();
        }
      } on PlatformException catch (e) {
        PlatformExceptionAlertDialog(
          title: 'Saving job failed',
          exception: e,
        ).show(context);
      }
    } else {
      return null;
    }
  }

  final _formKey = GlobalKey<FormState>();

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Widget _buildForm() {
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _buildFormChildren(),
        ));
  }

  String _name;
  int _ratePerHour;

//  final FocusNode _nameFocusNode = FocusNode();
//  final FocusNode _ratePerHourFocusNode = FocusNode();
//
//  void changeTextFormField() {
//    FocusScope.of(context).requestFocus(_ratePerHourFocusNode);
//  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        decoration: InputDecoration(labelText: 'Job name'),
        onSaved: (value) => _name = value,
        validator: (value) => value.isNotEmpty ? null : 'Form can\'t be empty',
//        focusNode: _nameFocusNode,
//        onEditingComplete: changeTextFormField,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Rate per hour'),
        onSaved: (value) => _ratePerHour = int.tryParse(value) ?? 0,
        validator: (value) => value.isNotEmpty ? null : 'Form can\'t be empty',
//        focusNode: _ratePerHourFocusNode,
        keyboardType:
            TextInputType.numberWithOptions(decimal: false, signed: false),
//        onEditingComplete: _submit, //<- not sure bout this, but could work
      ),
    ];
  }
}
