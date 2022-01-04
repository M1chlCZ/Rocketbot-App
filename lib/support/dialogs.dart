import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:rocketbot/support/dialog_body.dart';

class Dialogs {
  static Future<void> openAlertBox(
      context, String header, String message) async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return DialogBody(
            header: AppLocalizations.of(context)!.error,
            buttonLabel: 'OK',
            oneButton: true,
            onTap: () {
              Navigator.of(context).pop(true);
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 25, bottom: 25, left: 15.0, right: 15.0),
              child: SizedBox(
                width: 390,
                child: AutoSizeText(
                  message,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 8,
                  minFontSize: 8.0,
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(fontSize: 16.0, color: Colors.white70),
                ),
              ),
            ),
          );
        });
  }
}