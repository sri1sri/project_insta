import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projectinsta/commonFiles/app_fonts.dart';
import 'package:projectinsta/commonFiles/custom_offline_widget.dart';
import 'package:projectinsta/commonFiles/platform_alert/platform_alert_dialog.dart';
import 'package:projectinsta/commonFiles/transperent_loading.dart';
import 'package:projectinsta/firebase/admobs.dart';
import 'package:screenshot/screenshot.dart';

class AddImage extends StatelessWidget {
  AddImage({@required this.backgroundImage, @required this.contestantNumber, @required this.instaID, @required this.contestCode});
  Image backgroundImage;
  String contestantNumber;
  String instaID;
  String contestCode;

  @override
  Widget build(BuildContext context) {
    return F_AddImage(backgroundImage:backgroundImage, contestantNumber: contestantNumber, instaID: instaID, contestCode:contestCode);
  }
}

class F_AddImage extends StatefulWidget {
  F_AddImage({@required this.backgroundImage, @required this.contestantNumber, @required this.instaID, @required this.contestCode});
  Image backgroundImage;
  String contestantNumber;
  String instaID;
  String contestCode;



  @override
  _F_AddImageState createState() => _F_AddImageState();
}

class _F_AddImageState extends State<F_AddImage> {
  bool isLoading =false;
  Future<File> ImageFile;
  String logotext = '';
  File _imageFile;
  ScreenshotController screenshotController = ScreenshotController();



  pickImageFromGallery(ImageSource source) {
    setState(() {
      ImageFile = ImagePicker.pickImage(source: source);
    });
  }

  Widget showImage() {
    return FutureBuilder<File>(
      future: ImageFile,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          return Image.file(
            snapshot.data,
          );
        }else {
          return const Text(
            ' ',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }


  void _submit() async{
    if(ImageFile != null){

//      var status = await Permission.storage.status;
//      if (status.isUndetermined) {
//        Permission.storage.request();
//      }
      Ads.showRewardedVideoAd();
      setState(() {
        isLoading = true;
      });

      screenshotController
          .capture(delay: Duration(milliseconds: 10),pixelRatio: 5)
          .then((File image) async {
        setState(() {
          _imageFile = image;
        });
        await ImageGallerySaver.saveImage(image.readAsBytesSync());
        setState(() {
          isLoading = false;
        });

        await PlatformAlertDialog(title: 'Success', content: "Your image has been successfully saved to galary.", defaultActionText: 'ok').show(context);

        Navigator.of(context).pop(true);

      }).catchError((onError) {
        print(onError);
      });
    }else{
      PlatformAlertDialog(title: 'Oops', content: "Please select the image.", defaultActionText: 'ok').show(context);
    }
  }

  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return CustomOfflineWidget(
      onlineChild: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Scaffold(
          appBar: AppBar(
            title: Text('Add Image', style: mediumTextStyle
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
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Screenshot(
                controller: screenshotController,
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.width,
                      width: MediaQuery.of(context).size.width,
                      child: widget.backgroundImage,
//                      Image.network(getBackgroundImage(contestData.backgroundURL)),
                    ),
                    Positioned(
                      top: 55,
                      right: 0,
                      left: 0,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                        child: Container(
                            color: Colors.transparent,
                            height: 270,
                            width: MediaQuery.of(context).size.width,
//                      width: 200,
                            child: showImage()
                        ),
                      ),
                    ),


                    Positioned(
                      top: 10,
                      right: 10,
                      child: Row(
                        children: <Widget>[
//                          Image(image: AssetImage('images/instagramlogo.png'),
//                            height: 30,
//                            width: 30,
//                          ),
                          SizedBox(width: 3,),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                            ),
                            child: Text("IG @${widget.instaID}",
                              style: TextStyle(
                                  fontFamily: 'BalooBhaina2',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17
                              ),),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 30,
                      right: 10,
                      child: Row(
                        children: <Widget>[
//                          Image(image: AssetImage('images/instagramlogo.png'),
//                            height: 30,
//                            width: 30,
//                          ),
                          SizedBox(width: 3,),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                            ),
                            child: Text('Contestant no :${widget.contestantNumber}',
                              style: TextStyle(
                                  fontFamily: 'BalooBhaina2',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12
                              ),),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 10,),

              Container(
                child: FlatButton(
                  child: Container(
                    width: 160,
                    decoration: BoxDecoration(
                      borderRadius: new BorderRadius.all(Radius.circular(10)),
                      color: Colors.black87,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Center(child: Text('Select Image',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                        ),)),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      isLoading = true;
                    });
                    pickImageFromGallery(ImageSource.gallery);
                    setState(() {
                      isLoading = false;
                    });
                  },
                ),
              ),
              SizedBox(height: 10,),
              Container(
                child: FlatButton(
                  onPressed: () async{
                    _submit();
                  },
                  child: Container(
                    width: 250,
                    decoration: BoxDecoration(
                      borderRadius: new BorderRadius.all(Radius.circular(10)),
                      color: Colors.black87,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Center(
                        child: Text('Save Image to gallery',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),),
                      )
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

