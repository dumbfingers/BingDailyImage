class ImageModel {
  String url;
  String urlbase;
  String copyright;
  String copyrightlink;

  ImageModel({this.url, this.urlbase, this.copyright, this.copyrightlink});

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return new ImageModel(
      url: json['url'],
      urlbase: json['urlbase'],
      copyright: json['copyright'],
      copyrightlink: json['copyrightlink']
    );
  }
}