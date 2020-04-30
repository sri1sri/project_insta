
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:projectinsta/commonFiles/platform_alert/platform_alert_dialog.dart';

class PlatformExceptionAlertDialog extends PlatformAlertDialog{

  PlatformExceptionAlertDialog({
    @required String title,
    @required String content,
  }) : super(
    title : title,
    content: content,
    defaultActionText: 'Ok',
  );
}