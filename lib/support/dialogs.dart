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
                  padding: const EdgeInsets.only(
                      top: 15, bottom: 10, left: 15.0, right: 15.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      child: Container(
                        color: Colors.black38,
                        padding: EdgeInsets.all(10.0),
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
                  )));
        });
  }

  static Future<void> open2FAbox(
      context, String key, Function(String k, String c) getToken) async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          final TextEditingController _codeControl = TextEditingController();
          return DialogBody(
            header: AppLocalizations.of(context)!.enter_code,
            buttonLabel: 'OK',
            oneButton: false,
            onTap: () {
              getToken(key, _codeControl.text);
              Navigator.of(context).pop(true);
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 25, bottom: 25, left: 15.0, right: 15.0),
              child: SizedBox(
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: Container(
                    color: Colors.black38,
                    padding: EdgeInsets.all(5.0),
                    child: TextField(
                        controller: _codeControl,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: Colors.white, fontSize: 18.0),
                        autocorrect: false,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          isDense: false,
                          contentPadding:
                              const EdgeInsets.only(left: 10.0, bottom: 5.0),
                          hintStyle: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(color: Colors.white54, fontSize: 14.0),
                          hintText:
                              AppLocalizations.of(context)!.enter_code_hint,
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                        )),
                  ),
                ),
              ),
            ),
          );
        });
  }

  static Future<void> openLogOutBox(
      context, VoidCallback acc) async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return DialogBody(
            header: AppLocalizations.of(context)!.log_out,
            buttonLabel: 'OK',
            oneButton: false,
            onTap: () {
              acc();
              Navigator.of(context).pop(true);
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 25, bottom: 25, left: 15.0, right: 15.0),
              child: SizedBox(
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: Container(
                    color: Colors.black38,
                    padding: EdgeInsets.all(15.0),
                    child: AutoSizeText(
                      AppLocalizations.of(context)!.dl_log_out,
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
              ),
            ),
          );
        });
  }
}
