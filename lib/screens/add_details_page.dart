import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projectinsta/commonFiles/app_fonts.dart';
import 'package:projectinsta/commonFiles/app_varibles.dart';
import 'package:projectinsta/commonFiles/custom_offline_widget.dart';
import 'package:projectinsta/commonFiles/transperent_loading.dart';
import 'package:projectinsta/screens/add_image_page.dart';

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

  final _formKey = GlobalKey<FormState>();
  bool isLoading =  false;
  bool contetIDCheck = true;

  String _contestCode;
  String _instaID;

  final databaseReference = Firestore.instance;

  final FocusNode _contestCodeFocusNode = FocusNode();
  final FocusNode _instaIDFocusNode = FocusNode();

  String backgroundImageURL;
  int contestantCount;

  void getData(String contestCode) async{
    var document = await databaseReference.collection('contests').document(_contestCode).snapshots();
    document.listen((data) async{


      if(data == null){
        setState(() {
          contetIDCheck = false;
        });
      }

      if(data.data.length != 0) {
        final ref = FirebaseStorage.instance.ref().child('backgrounds/${data['background_image_title']}');
        var url = await ref.getDownloadURL();

        setState(() {
          backgroundImageURL = url;
          contestantCount = data['contestant_count'] + 1;
        });

        await databaseReference.collection("contests")
            .document(contestCode)
            .updateData({
          'contestant_count': contestantCount,
        });
      }
    });
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    setState(() {
      isLoading = true;
    });

    if (_validateAndSaveForm()) {


      await getData(_contestCode);

      GoToPage(context, AddImage(backgroundImageURL: backgroundImageURL, contestantNumber: contestantCount.toString(), instaID: _instaID,));

    }
    setState(() {
      isLoading = false;
    });
  }


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
        child:  Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                onChanged: (value) => _contestCode = value,
                textInputAction: TextInputAction.next,
                autocorrect: true,
                obscureText: false,
                keyboardType: TextInputType.number,
                keyboardAppearance: Brightness.dark,
                focusNode: _contestCodeFocusNode,
                onFieldSubmitted: (value) => value == ''
                    ? null
                    : FocusScope.of(context)
                    .requestFocus(_instaIDFocusNode),
                autofocus: true,
                cursorColor: Colors.black,
                style: mediumTextStyle,
                decoration: InputDecoration(
                  counterStyle: TextStyle(
                    color: Colors.white,
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  hintText: 'Add contest code',
                  hintStyle: mediumTextStyle,
                  enabledBorder: const OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Colors.transparent, width: 0.0),
                  ),
                ),
                validator: (value) {
                  print(value);
                  if (value.isEmpty) {
                    return 'Please enter contest code';
                  }
                  return null;
                },
              ),
              TextFormField(
                onChanged: (value) => _instaID = value,
                textInputAction: TextInputAction.done,
                autocorrect: true,
                obscureText: false,
                keyboardType: TextInputType.number,
                keyboardAppearance: Brightness.dark,
                focusNode: _instaIDFocusNode,
                onEditingComplete: _submit,
                autofocus: true,
                cursorColor: Colors.black,
                style: mediumTextStyle,
                decoration: InputDecoration(
                  counterStyle: TextStyle(
                    color: Colors.white,
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  hintText: 'Add instagram ID',
                  hintStyle: mediumTextStyle,
                  enabledBorder: const OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Colors.transparent, width: 0.0),
                  ),
                ),
                validator: (value) {
                  print(value);
                  if (value.isEmpty) {
                    return 'Please enter instagram ID';
                  }
                  return null;
                },
              ),

              GestureDetector(
                  onTap: (){
                    _submit();
                  },
                  child: Text('Next')),

              contetIDCheck == true ? Container(height: 0, width: 0,):Text('Please enter correct contest ID', style: mediumTextStyle,)
            ],
          ),
        ),
    );
  }
}

