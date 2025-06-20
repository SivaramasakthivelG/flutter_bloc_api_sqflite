

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

mixin ToastMixin<T extends StatefulWidget> on State<T> {
  void showToast(String message){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message))
    );
  }
}