import 'package:ansicolor/ansicolor.dart';
import 'package:license_xml_parser/license_xml_parser.dart';
import 'dart:io';

void main(List<String> arguments) async {
  var greenPen = AnsiPen()..green();
  var yellowPen = AnsiPen()..yellow();
  var parsedString = '';
  final gtRegex = RegExp(r'&gt;');
  final ltRegex = RegExp(r'&lt;');
  var magentaPen = AnsiPen()..magenta();

  print(greenPen(
      'Enter license identifier (MIT,0BSD,ADSL ..etc)   Note: Case Sensitive '));
  var licenseName = stdin.readLineSync();
  print('\nFetching xml file...\n\n');
  var linkString =
      'https://raw.githubusercontent.com/spdx/license-list-XML/master/src/' +
          licenseName +
          '.xml';
  final license = await getDataFromWeb(linkString);

  print(yellowPen('***** XML TAG TREE *****\n\n'.padLeft(50)));
  print(magentaPen(xmlTagTree(license)));
  print(yellowPen('***** XML Text *****\n\n'.padLeft(50)));
  parsedString = parseXml2MarkDown(license)
      .replaceAll(ltRegex, '<')
      .replaceAll(gtRegex, '>');

  print(parsedString);
}
