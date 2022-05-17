import 'package:flutter/material.dart';
import 'package:rocketbot/models/coin.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' show get;

class PictureCacheWidget extends StatefulWidget {
  final Coin? coin;

  const PictureCacheWidget({Key? key, this.coin}) : super(key: key);

  @override
  State<PictureCacheWidget> createState() => _PictureCacheWidgetState();
}

class _PictureCacheWidgetState extends State<PictureCacheWidget> {
  String? fileName;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    if (widget.coin != null) {
      _handleFile();
    }
  }

  _handleFile() async {
    var documentDirectory = await getApplicationDocumentsDirectory();
    var firstPath = "${documentDirectory.path}/images";
    var filePathAndName = '${documentDirectory.path}/images/${widget.coin!.cryptoId!}';
    if (await File(filePathAndName).exists()) {
      setState(() {
        _imageFile = File.fromUri(Uri.parse(filePathAndName));
      });
    } else {
      var response = await get(Uri.parse('https://app.rocketbot.pro/Image?imageId=${widget.coin!.imageSmallid!}'));
      await Directory(firstPath).create(recursive: true);
      File file2 = File(filePathAndName);
      file2.writeAsBytesSync(response.bodyBytes);
      setState(() {
        _imageFile = File.fromUri(Uri.parse(filePathAndName));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _imageFile != null ? Image.file(_imageFile!) : Container();
  }
}
