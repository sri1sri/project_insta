import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:projectinsta/commonFiles/custom_offline_widget.dart';
import 'package:projectinsta/commonFiles/transperent_loading.dart';
import 'package:screenshot/screenshot.dart';

class AddImage extends StatelessWidget {
  AddImage({@required this.backgroundImageURL, @required this.contestantNumber, @required this.instaID, @required this.contestCode});
  String backgroundImageURL;
  String contestantNumber;
  String instaID;
  String contestCode;

  @override
  Widget build(BuildContext context) {
    return F_AddImage(backgroundImageURL:backgroundImageURL, contestantNumber: contestantNumber, instaID: instaID, contestCode:contestCode);
  }
}

class F_AddImage extends StatefulWidget {
  F_AddImage({@required this.backgroundImageURL, @required this.contestantNumber, @required this.instaID, @required this.contestCode});
  String backgroundImageURL;
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
  double watermarkHeight = 50;
  double watermarkWidth = 50;
  ScreenshotController screenshotController = ScreenshotController();
  bool _progressBarActive = true;
//  Ads adclass = Ads();



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
//            width: 300,
//            height: 300,
//            fit: BoxFit.fill,
          );
        } else if (snapshot.error != null) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'No Image selected',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }


  Widget circularProgressBar(BuildContext context) {
    return new Scaffold(
        appBar:new AppBar(
          title: new Text("Circular progressbar demo"),
          backgroundColor: Colors.blue,
        ),
        body: _progressBarActive == true?const CircularProgressIndicator():new Container());
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
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 90),
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
                      child: Image.network(widget.backgroundImageURL),
//                      Image.network(getBackgroundImage(contestData.backgroundURL)),
                    ),
                    Positioned(
                      top: 55,
                      right: 0,
                      left: 0,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                        child: Container(
                            color: Colors.green,
                            height: 290,
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
                          Image(image: AssetImage('images/instagramlogo.png'),
                            height: 30,
                            width: 30,
                          ),
                          SizedBox(width: 3,),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                            ),
                            child: Text("IG @${widget.instaID}",
                              style: TextStyle(
                                  fontFamily: 'BalooBhaina2',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16
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
                          Image(image: AssetImage('images/instagramlogo.png'),
                            height: 30,
                            width: 30,
                          ),
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
                      color: Colors.blue,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Center(child: Text('Upload Image',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                        ),)),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      isLoading = true;
//                      logotext = 'Logo';
                    });
                    pickImageFromGallery(ImageSource.gallery);
                    setState(() {
                      isLoading = false;
//                      logotext = 'Logo';
                    });
                  },
                ),
              ),
              SizedBox(height: 10,),
              Container(
                child: FlatButton(
                  onPressed: () async{
                    var status = await Permission.storage.status;
                    if (status.isUndetermined) {
                      Permission.storage.request();
                    }
//                      setState(() async{
//
//                      });
                    // _imageFile = null;
                    setState(() {
                      isLoading = true;
//                      logotext = 'Logo';
                    });
                    screenshotController
                        .capture(delay: Duration(milliseconds: 10),pixelRatio: 5)
                        .then((File image) async {
                      print("Capture Done");
                      setState(() {
                        _imageFile = image;
                        print(_imageFile);
                      });
                      await ImageGallerySaver.saveImage(image.readAsBytesSync());

                      setState(() {
                        isLoading = false;
//                      logotext = 'Logo';
                      });
//                    print(result);
                      print("File Saved to Gallery");
                      circularProgressBar(context);

                    }).catchError((onError) {
                      print(onError);
                    });
                   // Ads.showRewardedVideoAd();
                  },
//                tooltip: 'Increment',
                  child: Container(
                    width: 160,
                    decoration: BoxDecoration(
                      borderRadius: new BorderRadius.all(Radius.circular(10)),
                      color: Colors.blue,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Center(child: Text('Save Image',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                        ),)),
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

