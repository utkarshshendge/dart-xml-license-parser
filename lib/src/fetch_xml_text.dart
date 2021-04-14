import 'package:http/http.dart' as http;

//Fetch License Xml Text
Future<String> getDataFromWeb(String linkString) async {
  final response = await http.get(linkString);
  if (response.statusCode == 200) {
    var linkElem = response.body;

    // series of regex to do minimal normalization
    linkElem = linkElem
        .replaceRange(0, 38, '')
        .replaceAll('\n', '')
        .replaceAll('  ', '')
        .replaceAll(RegExp(r'>\s+?<'), '><');
    return linkElem;
  } else {
    print(
        "OPPS!! couldn't get data, make sure the license identifier you entered is correct and is prensent in the SPDX license-list-xml");
    return Future.error('Error: ${response.body}\n');
  }
}
