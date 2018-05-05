import 'dart:async';
import 'dart:convert';

import 'package:bing_daily_image/ImageModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FetchRemoteWidget extends StatefulWidget {
  @override
  _FetchRemoteState createState() => new _FetchRemoteState();
}

Future<List<ImageModel>> fetchImages(String url) async {
  final response = await http.get(url);
  return compute(parseImages, response.body);
}

List<ImageModel> parseImages(String response) {
  final responseJson = json.decode(response);
  return (responseJson['images'] as List)
      .map((f) => new ImageModel.fromJson(f))
      .toList();
}

ListView buildImageListView(List<ImageModel> imageList) {
  return new ListView.builder(
    itemCount: imageList.length,
    padding: new EdgeInsets.all(8.0),
    itemBuilder: (BuildContext context, int index) {
      ImageModel model = imageList[index];
      return buildImageColumn(model.url, model.copyright);
    }
  );
}

Column buildImageColumn(String url, String description) {
  String imageUrl = "http://bing.com" + url;
  return new Column(
    children: <Widget>[
      new Container(
        margin: const EdgeInsets.all(8.0),
        child: new Image.network(imageUrl, fit: BoxFit.cover),
      ),
      new Container(
        margin: const EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
        child: new Text(
          description,
          style: new TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    ],
  );
}

class _FetchRemoteState extends State<FetchRemoteWidget> {

  static const BING_IMAGE_URL = 'https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=365&mkt=en-US';

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<List<ImageModel>>(
        future: fetchImages(BING_IMAGE_URL),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return buildImageListView(snapshot.data);
          } else if (snapshot.hasError) {
            return new Text("${snapshot.error}");
          }

          // By default, show a loading spinner
          return new CircularProgressIndicator();
        });
  }
}
