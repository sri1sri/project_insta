import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void GoToPage(BuildContext context, Widget page) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => page),
  );
}
