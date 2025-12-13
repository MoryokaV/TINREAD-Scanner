import 'package:url_launcher/url_launcher.dart';

String apiUrl = "https://demo.tinread.ro";
String imageUrl = "$apiUrl/covers.svc?h=190&t=m&w=135&rid=";
String getCoverUrl(String baseUrl, int id) => "$baseUrl/covers.svc?h=190&t=m&w=135&rid=${id.toString()}";

void openBrowserURL(Uri url) async {
  if (await canLaunchUrl(url)) {
    launchUrl(url, mode: LaunchMode.externalApplication);
  } else {
    throw "Could not launch $url";
  }
}

void openTel(String phone) async {
  Uri url = Uri.parse("tel:$phone");

  if (await canLaunchUrl(url)) {
    launchUrl(url);
  }
}

void openEmail(String email) async {
  Uri url = Uri.parse("mailto:$email");

  try {
    await launchUrl(url);
  } catch (_) {
    return;
  }
}
