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