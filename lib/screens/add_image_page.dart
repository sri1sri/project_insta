import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projectinsta/commonFiles/custom_offline_widget.dart';
import 'package:projectinsta/commonFiles/transperent_loading.dart';

class AddImage extends StatelessWidget {
  AddImage({@required this.backgroundImage, @required this.contestantNumber, @required this.instaID});
  Image backgroundImage;
  String contestantNumber;
  String instaID;

  @override
  Widget build(BuildContext context) {
    return F_AddImage(backgroundImage:backgroundImage, contestantNumber: contestantNumber, instaID: instaID,);
  }
}

class F_AddImage extends StatefulWidget {
  F_AddImage({@required this.backgroundImage, @required this.contestantNumber, @required this.instaID});
  Image backgroundImage;
  String contestantNumber;
  String instaID;


  @override
  _F_AddImageState createState() => _F_AddImageState();
}

class _F_AddImageState extends State<F_AddImage> {

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

