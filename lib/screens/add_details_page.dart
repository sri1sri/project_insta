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


  final FocusNode _contestCodeFocusNode = FocusNode();
  final FocusNode _instaIDFocusNode = FocusNode();

  String backgroundImageURL;
  int contestantCount;

  Future<void> getData(String contestCode) async{

    if (_validateAndSaveForm()) {
      var document = await Firestore.instance.collection('contests').document(_contestCode).snapshots();
      await document.listen((data) async{
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
          GoToPage(context, AddImage(backgroundImageURL: backgroundImageURL, contestantNumber: contestantCount.toString(), instaID: _instaID,));

        }
      });
    }
  }

  Future<void> updateContestantNumber() async{
    await Firestore.instance.collection("contests")
        .document(_contestCode)
        .updateData({
      'contestant_count': contestantCount
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

    await getData(_contestCode);
//    await updateContestantNumber();

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
            backgroundColor: Colors.blue,
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
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
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
              decoration: new InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide:
                  BorderSide(color: Colors.blue, width: 5.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 5.0),
                ),
                hintText: 'Contestant Number',
              ),
                  validator: (value) {
                    print(value);
                    if (value.isEmpty) {
                      return 'Please enter contest code';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  onChanged: (value) => _instaID = value,
                  maxLength: 30,
                  textInputAction: TextInputAction.done,
                  autocorrect: true,
                  obscureText: false,
//                  keyboardType: TextInputType.number,
                  keyboardAppearance: Brightness.dark,
                  focusNode: _instaIDFocusNode,
                  onEditingComplete: _submit,
                  autofocus: true,
                  cursorColor: Colors.black,
                  style: mediumTextStyle,
                  decoration: new InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Colors.blue, width: 5.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 5.0),
                    ),
                    hintText: 'Instagram ID',
                  ),
                  validator: (value) {
                    print(value);
                    if (value.isEmpty) {
                      return 'Please enter instagram ID';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 30,
                ),

                GestureDetector(
                    onTap: (){
                      _submit();
                    },
                    child: Container(
                      height: 50,
                        width: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: Colors.blue,
                        ),
                        child: Center(child: Text('Next',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'BalooBhaina2',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),)))),

                contetIDCheck == true ? Container(height: 0, width: 0,):Text('Please enter correct contest ID', style: mediumTextStyle,)
              ],
            ),
          ),
        ),
    );
  }
}

