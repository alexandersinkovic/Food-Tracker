import 'package:flutter/material.dart';
import 'package:food_tracker/picture_card.dart';
import 'package:camera/camera.dart';
import 'service/dio_upload_service.dart';
import 'service/http_upload_service.dart';
import 'take_photo.dart';

class InsertFood extends StatefulWidget {
  const InsertFood({super.key});

  @override
  State<InsertFood> createState() => _InsertFoodState();
}

class _InsertFoodState extends State<InsertFood> {
  final HttpUploadService _httpUploadService = HttpUploadService();
  final DioUploadService _dioUploadService = DioUploadService();
  late CameraDescription _cameraDescription;
  String _image = '';

  @override
  void initState() {
    super.initState();
    availableCameras().then((cameras) {
      final camera = cameras
          .where((camera) => camera.lensDirection == CameraLensDirection.back)
          .toList()
          .first;
      setState(() {
        _cameraDescription = camera;
      });
    }).catchError((err) {
      print(err);
    });
  }

  Future<void> presentAlert(BuildContext context,
      {String title = '', String message = '', Function()? ok}) {
    return showDialog(
        context: context,
        builder: (c) {
          return AlertDialog(
            title: Text(title),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(message),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: ok ?? Navigator.of(context).pop,
                child: Text(
                  'OK',
                  // style: greenText,
                ),
              ),
            ],
          );
        });
  }

  void presentLoader(BuildContext context,
      {String text = 'Loading...',
      bool barrierDismissible = false,
      bool willPop = true}) {
    showDialog(
        barrierDismissible: barrierDismissible,
        context: context,
        builder: (c) {
          return WillPopScope(
            onWillPop: () async {
              return willPop;
            },
            child: AlertDialog(
              content: Row(
                children: <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(
                    width: 20.0,
                  ),
                  Text(
                    text,
                    style: TextStyle(fontSize: 18.0),
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[600],
        title: Text(
          'Neuer Eintrag',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ),
      backgroundColor: Color(0xff16213e),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 15.0,
              ),
              Text(
                'Name',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Material(
                elevation: 3.0,
                color: Colors.transparent,
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        borderSide: BorderSide.none),
                    hintText: 'Name',
                    fillColor: Color(0xffeef0e1),
                    filled: true,
                    contentPadding: EdgeInsets.all(8.0),
                  ),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Text(
                'Bewertung',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Material(
                elevation: 3.0,
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        borderSide: BorderSide.none),
                    hintText: '0.00 - 5.00',
                    fillColor: Color(0xffeef0e1),
                    filled: true,
                    contentPadding: EdgeInsets.all(8.0),
                  ),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Text(
                'Beschreibung',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Material(
                elevation: 3.0,
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        borderSide: BorderSide.none),
                    hintText: 'Beschreibung',
                    fillColor: Color(0xffeef0e1),
                    filled: true,
                    contentPadding: EdgeInsets.all(8.0),
                  ),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Text(
                'Bild hochladen',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              SizedBox(
                height: 200,
                child: _image == ''
                    ? CardPicture(
                        onTap: () async {
                          final String? imagePath = await Navigator.of(context)
                              .push(MaterialPageRoute(
                                  builder: (_) => TakePhoto(
                                        camera: _cameraDescription,
                                      )));

                          print('imagepath: $imagePath');
                          if (imagePath != null) {
                            setState(() {
                              _image = imagePath;
                            });
                          }
                        },
                      )
                    : CardPicture(
                        imagePath: _image,
                      ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.indigo[600],
                                /*gradient: LinearGradient(colors: [
                                  Colors.indigo,
                                  Colors.indigo.shade800
                                ]),*/
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4.0))),
                            child: RawMaterialButton(
                              padding: EdgeInsets.symmetric(vertical: 12.0),
                              onPressed: () async {
                                // show loader
                                presentLoader(context, text: 'Wait...');

                                // calling with dio
                                var responseDataDio = await _dioUploadService
                                    .uploadPhotos(_image);

                                // calling with http
                                var responseDataHttp = await _httpUploadService
                                    .uploadPhotos(_image);

                                // hide loader
                                Navigator.of(context).pop();

                                // showing alert dialogs
                                await presentAlert(context,
                                    title: 'Success Dio',
                                    message: responseDataDio.toString());
                                await presentAlert(context,
                                    title: 'Success HTTP',
                                    message: responseDataHttp);
                              },
                              child: Center(
                                  child: Text(
                                'SEND',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold),
                              )),
                            )),
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
