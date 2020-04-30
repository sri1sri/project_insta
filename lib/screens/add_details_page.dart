import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projectinsta/commonFiles/app_fonts.dart';
import 'package:projectinsta/commonFiles/app_varibles.dart';
import 'package:projectinsta/commonFiles/custom_offline_widget.dart';
import 'package:projectinsta/commonFiles/platform_alert/platform_alert_dialog.dart';
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

  Image backgroundImage;
  int contestantCount;

  Future<void> getData(String contestCode) async{

    if (_validateAndSaveForm()) {
      var document = Firestore.instance.collection('contests').document(_contestCode);
      document.get().then((data) async{
        if(data == null){
          setState(() {
            contetIDCheck = false;
          });
        }
        if(data.data == null) {
          PlatformAlertDialog(title: 'Oops', content: 'The contest code you entered is incorrect. Please check the code you entered.', defaultActionText: 'ok').show(context);
        }else if(data.data.length != 0) {
          final ref = FirebaseStorage.instance.ref().child('backgrounds/${data['background_image_title']}');
          var url = await ref.getDownloadURL();

          setState(() {
            backgroundImage = Image.network(url);
            contestantCount = data['contestant_count'] + 1;
          });

          updateContestantNumber();

          GoToPage(context, AddImage(backgroundImage: backgroundImage, contestantNumber: contestantCount.toString(), instaID: _instaID,));

        }
      });
    }
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
    setState(() {
      isLoading = false;
    });
  }

  void updateContestantNumber(){
    print('called');
    Firestore.instance.collection("contests")
        .document(_contestCode)
        .updateData({
      'contestant_count': contestantCount,
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomOfflineWidget(
      onlineChild: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Scaffold(
          appBar: AppBar(
            title: Text('Welcome to InstaGraphy', style: mediumTextStyle
              , ),
            backgroundColor: Colors.black45,
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
        child:  SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Enter Contest code', style: mediumTextStyle,),
                  ),
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
                    borderSide: BorderSide(color: Colors.black, width: 5.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 5.0),
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Enter instagram ID',  style: mediumTextStyle,),
                  ),
                  TextFormField(
                    maxLength: 30,
                    onChanged: (value) => _instaID = value,
                    textInputAction: TextInputAction.done,
                    autocorrect: true,
                    obscureText: false,
                    keyboardType: TextInputType.text,
                    keyboardAppearance: Brightness.dark,
                    focusNode: _instaIDFocusNode,
                    onEditingComplete: _submit,
                    autofocus: true,
                    cursorColor: Colors.black,
                    style: mediumTextStyle,
                    decoration: new InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.black, width: 5.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 5.0),
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
                            color: Colors.black87,
                          ),
                          child: Center(child: Text('Next',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'BalooBhaina2',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),)))),

                  contetIDCheck == true ? Container(height: 0, width: 0,):Text('Please enter correct contest ID', style: mediumTextStyle,)
                ],
              ),
            ),
          ),
        ),
    );
  }
}

