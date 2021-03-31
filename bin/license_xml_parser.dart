import 'dart:collection';
import 'dart:io';
import 'package:http/http.dart' as http;

void main() async {
  print('Enter license identifier (MIT,0BSD,ADSL ..etc)');
  var licenseName = stdin.readLineSync();
  print('\nFetching xml file...\n\n');
  var linkString =
      'https://raw.githubusercontent.com/spdx/license-list-XML/master/src/' +
          licenseName +
          '.xml';
  var license = await _getDataFromWeb(linkString);
  if (license != null) {
    print('***** XML TAG TREE *****\n\n'.padLeft(50));
    print(_xmlTagTree(license));
    print('***** XML Text *****\n\n'.padLeft(50));
    print(_parseXml2MarkDown(license));
  }
}

Future<String> _getDataFromWeb(String linkString) async {
  final response = await http.get(linkString);
  if (response.statusCode == 200) {
    var linkElem = response.body;
    linkElem = linkElem
        .replaceRange(0, 38, '')
        .replaceAll('\n', '')
        .replaceAll('  ', '')
        .replaceAll(RegExp(r'>\s+?<'), '><');
    return linkElem;
  } else {
    print(
        "OPPS!! couldn't get data, make sure the license identifier you entered is correct and is prensent in the SPDX license-list-xml");
    return null;
  }
}

String _xmlTagTree(String xmlString) {
  final myStack = MyStack<Spacing>();
  var stackIndex = 0;
  var finalString = '';
  myStack.push(Spacing('Dummy', stackIndex));
  var tag = '';
  var gap = '-';
  var tempStartIndex = 0;
  var startIndex = 0;
  var endexIndex = 0;
  for (var i = 0; i < xmlString.length; i++) {
    if (xmlString[i] == '<' && xmlString[i + 1] != '/') {
      startIndex = i + 1;

      tempStartIndex = startIndex;
    }

    if ((xmlString[i] == '>' || xmlString[i] == ' ') &&
        (startIndex == tempStartIndex)) {
      endexIndex = i;
      tag = xmlString.substring(startIndex, endexIndex);
      tempStartIndex = -1;

      if (tag == myStack.peak().tag) {
        myStack.pop();
      } else {
        var padValue = myStack.peak().stackIndex;
        padValue = padValue + 1;

        var parent = myStack.peak().tag;
        myStack.push(Spacing(tag, padValue));

        var dist = gap * padValue;
        var printString = myStack.peak().tag;

        finalString = finalString +
            (dist + '>' + printString).padRight(50) +
            'is child of ' +
            parent +
            '\n';
      }
    }
    if (xmlString[i] == '<' && xmlString[i + 1] == '/') {
      startIndex = i + 2;

      tempStartIndex = startIndex;
    }
  }
  myStack.clearStack();
  return finalString;
}

String _parseXml2MarkDown(String xmlString) {
  final myStack = MyStack<StackClass>();

  var finalString = '';
  myStack.push(StackClass('Dart is Awesome', ''));
  var inTagStartIndex = 0, inTagEndIndex = 0;
  var tag = '';
  var contentString = '';
  var tempIterator = 0;
  var tempStartIndex = 0;
  var startIndex = 0;
  var endIndex = 0;
  for (var i = 0; i < xmlString.length - 1; i++) {
    if (xmlString[i] == '<' && xmlString[i + 1] != '/') {
      startIndex = i + 1;

      tempStartIndex = startIndex;
    }

    if ((xmlString[i] == '>' || xmlString[i] == ' ') &&
        (startIndex == tempStartIndex)) {
      endIndex = i;
      tag = xmlString.substring(startIndex, endIndex);
      tempStartIndex = -1;

      if (tag == myStack.peak().currentTag) {
        myStack.pop();
      } else {
        var parent = myStack.peak().currentTag;

        myStack.push(StackClass(tag, parent));

        tag = myStack.peak().currentTag;

        if (xmlString[i] == ' ') {
          tempIterator = i;

          startIndex = endIndex;

          while (xmlString[i] != '>') {
            endIndex = endIndex + 1;

            i = i + 1;
          }

          // contentString = xmlString.substring(startIndex + 1, endIndex);
          //  finalString = finalString + tag + ': ' + contentString + '\n';
          i = tempIterator;
        }

        if (xmlString[i] == '>') {
          tempIterator = i;

          startIndex = endIndex;
          while (xmlString[i] != '<') {
            endIndex = endIndex + 1;

            i = i + 1;
          }

          contentString = xmlString.substring(startIndex + 1, endIndex);

          finalString = finalString + simpleDummyRules(tag) + contentString;

          i = tempIterator;
        }
      }
    }
    if ((xmlString[i] == '<' && xmlString[i + 1] == '/')) {
      inTagEndIndex = i + 1;
      inTagStartIndex = xmlString.indexOf('>', inTagEndIndex);
      inTagEndIndex = xmlString.indexOf('<', inTagEndIndex);
      if (inTagEndIndex > inTagStartIndex + 1) {
        var newcontentString =
            xmlString.substring(inTagStartIndex + 1, inTagEndIndex).trim();
        finalString = finalString + newcontentString + '\n';
      }

      startIndex = i + 2;

      tempStartIndex = startIndex;
    }
  }
  myStack.clearStack();
  return finalString;
}

String simpleDummyRules(String tag) {
  switch (tag) {
    case 'p':
      {
        return '\n\n\n';
      }
      break;
    case 'bullet':
      {
        return '\n   •';
      }
      break;

    default:
      {
        return '';
      }
      break;
  }
}

class Spacing {
  final String tag;
  final int stackIndex;

  Spacing(this.tag, this.stackIndex);
}

class MyStack<T> {
  final _stack = Queue<T>();

  int get length => _stack.length;

  bool canPop() => _stack.isNotEmpty;

  void clearStack() {
    while (_stack.isNotEmpty) {
      _stack.removeLast();
    }
  }

  void push(T element) {
    _stack.addLast(element);
  }

  T pop() {
    if (canPop()) {
      var lastElement = _stack.last;
      _stack.removeLast();
      return lastElement;
    } else {
      print('Nothing left to pop');
      return null;
    }
  }

  T peak() => _stack.last;
}

class StackClass {
  final String currentTag;
  final String parentTagg;

  StackClass(this.currentTag, this.parentTagg);
}
