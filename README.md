<h2 align="center">
  Easy Generate Model Class
</h2>

<p align="center">
  <br/>
  <a href="https://github.com/Bintaaaa/binta_model_generator">
    <img src="https://img.shields.io/github/stars/Bintaaaa/binta_model_generator.svg?style=flat&logo=github&colorB=deeppink&label=stars" alt="Star on GitHub">
  </a>

  <a href="https://opensource.org/licenses/MIT">
    <img alt="MIT License" src="https://img.shields.io/badge/License-MIT-blue.svg">
  </a>
</p>

---


## Overview
binta_model_generator is a library that functions as a generator for creating response models in the Dart language.

Developers can be easly generating models  without open any tools.

Only config first, and run anything you wants.

## Usage

First, we need to do add `binta_model_generator` to the dependencies of the `pubspec.yaml`

for now `binta_model_generator` it's still comingsoon on `pub.dev`

```yaml
dependencies:
  binta_model_generator: ^0.1.1
```

Next, we need to create new dart file and


if you have http services using `Dio` or any package you can use code below:

```dart
import 'package:binta_model_generator/binta_model_generator.dart';
import 'package:dio/dio.dart';

main() async {
  final response = await hitService();
  BintaModelGenerator.generateResponseModel(
    parentModelName: "YourParentClassNameOfModel",
    yourJson: response,
    outputFile: "example/",
  );
}

Future<dynamic> hitService() async {
  final Dio dio = Dio();
  try {
    final response = await dio.get("https://your_services.example/example");
    return response;
  } on DioException catch (e) {
    throw Exception(
      e.error,
    );
  }
}
```

we have example json/response APIs
```json
{
  "status": 200,
  "data": {
    "person": [
      {
        "name": "binta",
        "age": 22
      },
      {
        "name": "reza",
        "age": 24
      }
    ],
    "info": {
      "code": "EXAMPLE_CODE_001",
      "message": "success to show data person"
    }
  }
}
```

don't forget to run your file dart

```shell
dart run your_dart_file.dart
```

and Finally we have files are generated on output file

```text
   📦example/
 ┣ 📜data_model.dart
 ┣ 📜info_model.dart
 ┣ 📜person_model.dart
 ┗ 📜person_model_model.dart
```

```dart
//in example/person_model_model.dart
import 'package:equatable/equatable.dart';
import 'data_model.dart';


class PersonModelModel extends Equatable {
  final int? status;
  final DataModel? data;

  const PersonModelModel({
    this.status,
    this.data,
  });

  factory PersonModelModel.fromJson(Map<String, dynamic> json) =>
      PersonModelModel(
        status : json['status'],
        data: json['data'] != null ? DataModel.fromJson(json['data']) : null,
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['status'] = status;
    if(json['data'] != null) {
      json['data'] = data!.toJson();
    }
    return json;
  }

  @override
  List<Object?> get props =>[
    status,
    data,
  ];
}
```

```dart
//in example/person_model.dart
class PersonModel extends Equatable {
  final String? name;
  final int? age;

  const PersonModel({
    this.name,
    this.age,
  });

  factory PersonModel.fromJson(Map<String, dynamic> json) =>
      PersonModel(
        name : json['name'],
        age : json['age'],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['name'] = name;
    json['age'] = age;
    return json;
  }

  @override
  List<Object?> get props =>[
    name,
    age,
  ];
}
```


```dart
//in example/data_model.dart
import 'package:equatable/equatable.dart';
import 'info_model.dart';
import 'person_model.dart';


class DataModel extends Equatable {
  final List<PersonModel>? person;
  final InfoModel? info;

  const DataModel({
    this.person,
    this.info,
  });

  factory DataModel.fromJson(Map<String, dynamic> json) =>
      DataModel(
        person: json['person'] != null ? List<PersonModel>.from(json['person']?.map((x) => PersonModel.fromJson(x),),) : [],
        info: json['info'] != null ? InfoModel.fromJson(json['info']) : null,
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    if (person != null) {
      json['person'] = person!.map((v) => v.toJson()).toList();
    }
    if(json['info'] != null) {
      json['info'] = info!.toJson();
    }
    return json;
  }

  @override
  List<Object?> get props =>[
    person,
    info,
  ];
}
```

```dart
//in example/info_model.dart
import 'package:equatable/equatable.dart';

class InfoModel extends Equatable {
  final String? code;
  final String? message;

  const InfoModel({
    this.code,
    this.message,
  });

  factory InfoModel.fromJson(Map<String, dynamic> json) => InfoModel(
    code: json['code'],
    message: json['message'],
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['code'] = code;
    json['message'] = message;
    return json;
  }

  @override
  List<Object?> get props => [
    code,
    message,
  ];
}
```


## Creator

<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="https://github.com/bintaaaa"><img src="https://avatars.githubusercontent.com/u/79687063?s=200&v=4" width="100px;" alt=""/><br /><sub><b>Bijantyum</b></sub></a><br /><a href="https://github.com/bintaaaa/binta_model_generator/commits?author=bintaaaa" title="Code">💻</a> <a href="https://github.com/bintaaaa/binta_model_generator/commits?author=bintaaaa" title="Documentation">📖</a> <a href="https://github.com/bintaaaa/gampah/commits?author=bintaaaa" title="Author">⚠️</a></td>
    <td align="center"><a href="https://github.com/rezarffahlevi"><img src="https://avatars.githubusercontent.com/u/28903520?s=200&v=4" width="100px;" alt=""/><br /><sub><b>Reza Fahlevi</b></sub></a><br /><a href="https://github.com/rezarffahlevi/binta_model_generator/commits?author=rezarffahlevi" title="Documentation">📖</a> <a href="https://github.com/rezarffahlevi/rezarffahlevi/commits?author=rezarffahlevi" title="Code">💻</a></td>
  </tr>
</table>
<!-- markdownlint-restore -->