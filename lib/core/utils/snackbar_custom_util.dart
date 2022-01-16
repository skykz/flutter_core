import 'package:flutter/material.dart';

void showCustomSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 6),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        action: SnackBarAction(
            label: 'OK', textColor: Colors.white, onPressed: () {}),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.white),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text("$text",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Nunito',
                        fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
}
