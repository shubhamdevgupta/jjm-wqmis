class Updateresponse {
  final String version;
  final String apkUrl;
  final String whatsNew;

  Updateresponse({
    required this.version,
    required this.apkUrl,
    required this.whatsNew,
  });

  factory Updateresponse.fromJson(Map<String, dynamic> json) {
    return Updateresponse(
      version: json['version'],
      apkUrl: json['apk_url'],
      whatsNew: json['whats_new'],
    );
  }
}
