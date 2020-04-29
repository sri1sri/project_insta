import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projectinsta/commonFiles/custom_offline_widget.dart';
import 'package:projectinsta/commonFiles/transperent_loading.dart';

class AddDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return F_AddDetails();
  }
}

class F_AddDetails extends StatefulWidget {
  @override
  _F_AddDetailsState createState() => _F_AddDetailsState();
}

class _F_AddDetailsState extends State<F_AddDetails> {
  bool isLoading =  false;

  @override
  Widget build(BuildContext context) {
    return CustomOfflineWidget(
      onlineChild: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Scaffold(
          appBar: AppBar(
            title: Text('Template Creation'),
          ),
          body: _buildContent(context),
        ),
      ),
    );
  }

  @override
  Widget _buildContent(BuildContext context) {
    return  TransparentLoading(
        loading: isLoading,
        child:Container(),
    );
  }
}

