import 'dart:ffi';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'data.dart';
import 'globals.dart';
import 'main.dart';
import 'globals.dart' as globals;

String restaurantScreen = '/restaurant';

class QrCodeArea extends StatefulWidget {
  QrCodeArea({Key? key, required this.active}) : super(key: key);

  bool active = false;

  @override
  State<QrCodeArea> createState() => _QrCodeAreaState();
}

class _QrCodeAreaState extends State<QrCodeArea> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  Restaurant? restaurant;
  bool nowIsFindingProcess = false;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: (widget.active) && acceptQrScanning ? QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ) : Text('Dont work'),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        if (!nowIsFindingProcess && globals.thisTableId != null && globals.thisTableId!.isNotEmpty && globals.thisRestaurant != null) {
          globals.acceptQrScanning = false;
          Navigator.pushNamed(context, restaurantScreen,
              arguments: ScreenArguments(globals.thisRestaurant!, globals.thisTableId!));
        }
        if (!nowIsFindingProcess && result!.format == BarcodeFormat.qrcode && result!.code!.isNotEmpty) {
          if (result != null && result!.code != null) {
            String code = result!.code ?? '';
            setRestaurantAndTableByQrCode(code);
          }
        }
        result!.code;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void setRestaurantAndTableByQrCode(qrCode) async{
    nowIsFindingProcess = true;
    var splitted = qrCode.toString().split('://');
    if (splitted.length != 2) {
      nowIsFindingProcess = false;
      return;
    }
    splitted = splitted[1].toString().split('/');
    if (splitted.length != 3) {
      nowIsFindingProcess = false;
      return;
    } else {
      String restaurantId = splitted[1] ?? '';
      QueryBuilder<ParseObject> queryRestaurant =
      QueryBuilder<ParseObject>(ParseObject('Restaurant'))
        ..whereEqualTo('objectId', restaurantId);

      final ParseResponse apiRestaurantResponse = await queryRestaurant.query();
      if (apiRestaurantResponse.success && apiRestaurantResponse.results != null) {
        final restaurant = (apiRestaurantResponse.results!.first) as ParseObject;
        globals.thisRestaurant = Restaurant(
          objectId: restaurant.get("objectId"),
          title: restaurant.get("title"),
          image: restaurant.get("images").isNotEmpty ? restaurant.get("images")[0]
              : "assets/loading.gif",
          images: List<String>.from(restaurant.get("images") as List),
        );
      }

      QueryBuilder<ParseObject> queryTable =
      QueryBuilder<ParseObject>(ParseObject('Table'))
        ..whereEqualTo('objectId', splitted[2] ?? '');

      final ParseResponse apiTableResponse = await queryTable.query();
      if (apiTableResponse.success && apiTableResponse.results != null) {
        final restaurant = (apiTableResponse.results!.first) as ParseObject;
        globals.thisTableId = restaurant.objectId;
      }
      nowIsFindingProcess = false;
    }
  }
}

