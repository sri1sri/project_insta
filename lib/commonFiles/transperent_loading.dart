import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class TransparentLoading extends StatelessWidget {
  final Widget child;
  final bool loading;

  const TransparentLoading(
      {Key key, @required this.child, @required this.loading})
      : super(key: key);
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Stack(
          children: <Widget>[
            child,
            loading ? Center(
                child: Container(
                  height: 100,
                  width: 100,
                  child: CircularProgressIndicator(
                    strokeWidth: 20,
                    backgroundColor: Colors.grey,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                )) : Container()
          ],
        ));
  }
}
