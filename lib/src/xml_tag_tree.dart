import 'package:license_xml_parser/src/stack.dart';

// Takes in XML text and and a tag tree as string
String xmlTagTree(String xmlString) {
  final myStack = MyStack<Spacing>();
  var stackIndex = 0;
  var finalString = '';
  myStack.push(Spacing('Batman', stackIndex));
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

class Spacing {
  final String tag;
  final int stackIndex;

  Spacing(this.tag, this.stackIndex);
}
