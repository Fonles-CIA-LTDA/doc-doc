
import 'package:flutter/material.dart';

getLoadingModal(context) {
  showDialog(
    barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(),
              )
            ],
          ),
        );
      });
}
