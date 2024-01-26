import 'dart:convert';
import 'dart:io';

void writeSomething(Map<String, dynamic> jsonAfterDecode, String className) {
  List pendingValueMap = [];
  List pendingKeyMap = [];
  print("======== Starting... Generate $className.... =========");
  final StringBuffer buffer = StringBuffer();

  buffer.writeln('import \'package:dependencies/equatable/equatable.dart\';');
  buffer.writeln();
  buffer.writeln();

  ///build class
  buffer.writeln('class $className extends Equatable {');

  ///build final
  jsonAfterDecode.forEach((key, value) {
    if (value is Map) {
      buffer.writeln('  final ${pascalCase(key)}Model? ${camelCase(key)};');
      pendingValueMap.add(json.encode(value));
      pendingKeyMap.add(key);
    } else if (value is List) {
      buffer.writeln('  final List<${pascalCase(key)}Model>? ${camelCase(key)};');
      pendingValueMap.add(json.encode(value[0]));
      pendingKeyMap.add(key);
    } else {
      buffer.writeln('  final ${value.runtimeType}? ${camelCase(key)};');
    }
  });

  buffer.writeln();

  ///constructor
  buffer.writeln('  const $className({');
  jsonAfterDecode.forEach((key, value) {
    buffer.writeln("    this.${camelCase(key)},");
  });
  buffer.writeln('  });');

  buffer.writeln();

  ///factory
  buffer.writeln('  factory $className.fromJson(Map<String, dynamic> json) =>');
  buffer.writeln('    $className(');
  jsonAfterDecode.forEach((key, value) {
    if (value is Map) {
      buffer.writeln(
        '    ${camelCase(key)}: json[\'$key\'] != null ? ${pascalCase(key)}Model.fromJson(json[\'$key\']) : null,',
      );
    } else if (value is List && value.isNotEmpty && value.first is Map) {
      buffer.writeln(
          '    ${camelCase(key)}: json[\'$key\'] != null ? List<${pascalCase(key)}Model>.from(json[\'$key\']?.map((x) => ${pascalCase(key)}Model.fromJson(x),),) : [],');
    } else {
      buffer.writeln('    ${camelCase(key)} : json[\'$key\'],');
    }
  });
  buffer.writeln('  );');

  buffer.writeln();

  /// to json
  buffer.writeln('''  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};''');

  jsonAfterDecode.forEach((key, value) {
    if (value is Map) {
      buffer.writeln('    if(json[\'$key\'] != null) {');
      buffer.writeln('       json[\'$key\'] = ${key}!.toJson();');
      buffer.writeln('    }');
    } else if (value is List && value.isNotEmpty && value.first is Map) {
      buffer.writeln('    if ($key != null) {');
      buffer.writeln('       json[\'$key\'] = $key!.map((v) => v.toJson()).toList();');
      buffer.writeln('    }');
    } else {
      buffer.writeln('    json[\'$key\'] = ${camelCase(key)};');
    }
  });
  buffer.writeln('    return json;');
  buffer.writeln('  }');

  buffer.writeln();

  buffer.writeln('''
  @override
  List<Object?> get props =>[''');
  jsonAfterDecode.forEach((key, value) {
    buffer.writeln("    ${camelCase(key)},");
  });
  buffer.writeln("  ];");

  buffer.writeln('}');
  final file = File("${pascalCaseToSnakeCase(className)}.dart");
  file.writeAsStringSync(buffer.toString());

  var lines = file.readAsLinesSync();
  for (var element in pendingKeyMap) {
    lines.insert(1, "import '${element}_model.dart';");
  }
  file.writeAsStringSync(lines.join('\n'));

  if (pendingKeyMap.isNotEmpty) {
    for (int index = 0; index < pendingKeyMap.length; index++) {
      writeSomething(json.decode(pendingValueMap[index]), "${pascalCase(pendingKeyMap[index])}Model");
    }
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
  static void generateResponseModel({required String parentModelName, required dynamic yourJson}) {
    String jsonString = '''
    $yourJson
  ''';
    writeSomething(json.decode(jsonString), '${parentModelName}Model');
    print("======== Finish... Generate All Model.... =========");
    // print("======== File Name $parentModelName =========");
  }
}
