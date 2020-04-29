import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';

class CustomOfflineWidget extends StatelessWidget {

  CustomOfflineWidget({this.onlineChild});
  final Widget onlineChild;

  @override
  Widget build(BuildContext context) {
    return OfflineBuilder(
      debounceDuration: Duration.zero,
      connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
          ) {
        if (connectivity == ConnectivityResult.none) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: OfflinePage(text: 'No internet connection'),
          );
        }
        return child;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: onlineChild,
      ),
    );
  }
}

class OfflinePage extends CustomOfflinePage{
  OfflinePage({
    @required String text,
  }) : assert(text != null),
        super(
        text: text,
      );
}

class CustomOfflinePage extends StatelessWidget {

  CustomOfflinePage({this.text});

  final text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Image(
              image: AssetImage(
                'images/no_internet.png',
              ),
              height: 300.0,
              width: 300.0,
            ),
            SizedBox(height: 30.0,),
            Text('No Internet connection.\nPlease check connection!!!', style: TextStyle(
                color: Color(0xFF1F4B6E),
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w700,
                fontSize: 23.0),)
          ],
        ),
      ),
    );
  }
}