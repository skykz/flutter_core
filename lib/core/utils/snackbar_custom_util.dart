import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

/// show custom snackbar when it needed
void showCustomSnackBar(BuildContext? context, String? text) {
  final _size = MediaQuery.of(context!).size;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        width: (kIsWeb) ? _size.width * 0.3 : _size.width * 0.9,
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
                          fontSize: 16))),
            ),
          ],
        ),
      ),
    );
}
