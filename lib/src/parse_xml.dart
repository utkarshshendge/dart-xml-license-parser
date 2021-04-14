import 'package:license_xml_parser/license_xml_parser.dart';
import 'package:license_xml_parser/src/stack.dart';

// Takes in XML text and returns the text in it as string
String parseXml2MarkDown(String xmlString) {
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
        return '\n\n';
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

class StackClass {
  final String currentTag;
  final String parentTagg;

  StackClass(this.currentTag, this.parentTagg);
}
