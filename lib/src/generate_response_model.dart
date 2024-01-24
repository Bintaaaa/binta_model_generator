import 'dart:convert';
import 'dart:io';

List pendingValueMap = [];
List pendingKeyMap = [];

void writeSomething(Map<String, dynamic> jsonAfterDecode, String className) {
  final StringBuffer buffer = StringBuffer();

  buffer.writeln('import \'package:dependencies/equatable/equatable.dart\';');
  buffer.writeln();
  buffer.writeln();

  ///build class
  buffer.writeln('class $className extends Equatable{');

  ///build final
  jsonAfterDecode.forEach((key, value) {
    if (value is Map) {
      buffer.writeln('  final ${pascalCase(key)}? ${camelCase(key)};');
      pendingValueMap.add(json.encode(value));
      pendingKeyMap.add(key);
    } else if (value is List) {
      buffer.writeln('  final List<${pascalCase(key)}>? ${camelCase(key)};');
      pendingValueMap.add(json.encode(value[0]));
      pendingKeyMap.add(key);
    } else {
      buffer.writeln('  final ${value.runtimeType}? ${camelCase(key)};');
    }
  });

  buffer.writeln();

  ///constructor
  buffer.writeln('const $className({');
  jsonAfterDecode.forEach((key, value) {
    buffer.writeln("this.${camelCase(key)},");
  });
  buffer.writeln('});');

  ///factory
  buffer.writeln('factory $className.fromJson(Map<String, dynamic> json) =>');
  buffer.writeln(' $className(');
  jsonAfterDecode.forEach((key, value) {
    if (value is Map) {
      buffer.writeln(
        '${camelCase(key)}: ${pascalCase(key)} != null ? ${pascalCase(key)}.fromJson(json[\'$key\']) : null,',
      );
    } else if (value is List && value.isNotEmpty && value.first is Map) {
      buffer.writeln(
        '${camelCase(key)}: json[\'$key\'] != null ? List<${pascalCase(key)}>.fromJson(json[\'$key)\']!.map((x) => ${pascalCase(key)}.fromJson(x),),) : [],',
      );
    } else {
      buffer.writeln('   ${camelCase(key)} : json[\'$key\'],');
    }
  });
  buffer.writeln(');');

  buffer.writeln('''
  @override
  List<Object?> get props =>[
  ''');
  jsonAfterDecode.forEach((key, value) {
    buffer.writeln("${camelCase(key)},");
  });
  buffer.writeln("];");

  buffer.writeln('}');

  final file = File("${pascalCaseToSnakeCase(className)}_response_model.dart");
  file.writeAsStringSync(buffer.toString());
  var lines = file.readAsLinesSync();
  for (var element in pendingKeyMap) {
    lines.insert(2, "import '${element}_response_model.dart'");
  }
}

String pascalCaseToSnakeCase(String word) {
  String result = '';
  for (int i = 0; i < word.length; i++) {
    if (i > 0 && word[i].toUpperCase() == word[i]) {
      result += '_';
    }
    result += word[i].toLowerCase();
  }
  return result;
}

String pascalCase(String word) {
  List<String> splitWords = word.split("_");
  String result = "";

  for (String part in splitWords) {
    result += part[0].toUpperCase() + part.substring(1);
  }
  return result;
}

String camelCase(String word) {
  List<String> splitWords = word.split("_");
  String result = "";
  for (int index = 0; index < splitWords.length; index++) {
    if (index == 0) {
      result += splitWords[0];
    } else {
      result += splitWords[index][0].toUpperCase() + splitWords[index].substring(1);
    }
  }
  return result;
}

class BintaModelGenerator {
  static void generateResponseModel({required String parentModelName, required Map<String,dynamic> yourJson}) {
    print("======== Starting... Generate Model.... =========");
    const jsonString = '''{
    $yourJson
  ''';
    writeSomething(json.decode(jsonString), parentModelName);
    if (pendingKeyMap.isNotEmpty) {
      for (int index = 0; index < pendingKeyMap.length; index++) {
        writeSomething(json.decode(pendingValueMap[index]), "${pascalCase(pendingKeyMap[index])}ResponseModel");
      }
    }
    print("======== Finish... Generate Model.... =========");
    print("======== File Name $parentModelName =========");
  }
}
