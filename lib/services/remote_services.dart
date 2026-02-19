import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../common_widgets/custom_snackbar.dart';
import '../constraints/app_strings.dart';

import '../utils/utils.dart';
import 'api_endpoints.dart';
import 'local_services.dart';

class RemoteServices {
  static final http.Client client = http.Client();
  static const String baseURL = APIEndPoints.baseUrl;
  static String token = "";

  static Future<dynamic> postRequest({
    required String endPoint,
    Map<dynamic, dynamic>? body,
  }) async {
    token = await LocalServices.getToken() ?? "";
    AppStrings.httpErrorMSG.value = "";
    final Uri uri = Uri.parse(baseURL + endPoint);
    final Map<String, String> requestHeader = {
      "Authorization": "Bearer $token",
    };

    if (kDebugMode) {
      print("POST Request URL: $uri");
      print("Request Body: $body");
    }

    try {
      final http.Response response = await http.post(
        uri,
        body: body,
        headers: requestHeader,
      );

      return handleResponse(response);
    } on Exception catch (e) {
      AppStrings.httpErrorMSG.value = AppStrings.generalHttpErrorMSG;
      if (kDebugMode) {
        print("Error in POST request: $e");
      }
      return null;
    }
  }


  static Future<dynamic> putRequest({
    required String endPoint,
    Map<dynamic, dynamic>? body,
    Map<String, dynamic>? parameters,
  }) async {
    token = await LocalServices.getToken() ?? "";
    AppStrings.httpErrorMSG.value = "";
    final Uri uri = Uri.parse(baseURL + endPoint).replace(
        queryParameters: parameters,);
    final Map<String, String> requestHeader = {
      "Authorization": "Bearer $token",
    };

    if (kDebugMode) {
      print("PUT Request URL: $uri");
      print("Request Body: $body");
    }

    try {
      final http.Response response = await http.put(
        uri,
        body: body,
        headers: requestHeader,
      );

      return handleResponse(response);
    } on Exception catch (e) {
      AppStrings.httpErrorMSG.value = AppStrings.generalHttpErrorMSG;
      if (kDebugMode) {
        print("Error in PUT request: $e");
      }
      return null;
    }
  }

  static Future<dynamic> putRequestWithJson({
    required String endPoint,
    Map<dynamic, dynamic>? body,
    Map<String, dynamic>? parameters,
  }) async {
    token = await LocalServices.getToken() ?? "";
    AppStrings.httpErrorMSG.value = "";
    final Uri uri = Uri.parse(baseURL + endPoint).replace(
      queryParameters: parameters,);
    final Map<String, String> requestHeader = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": "*",
    };

    if (kDebugMode) {
      print("PUT Request URL: $uri");
      print("Request Body: $body");
    }

    try {
      final http.Response response = await http.put(
        uri,
        //body: body,
        // headers: requestHeader,

        body: json.encode(body),
        headers: requestHeader,
        encoding: Encoding.getByName("utf-8"),
      );

      return handleResponse(response);
    } on Exception catch (e) {
      AppStrings.httpErrorMSG.value = AppStrings.generalHttpErrorMSG;
      if (kDebugMode) {
        print("Error in PUT request: $e");
      }
      return null;
    }
  }

  static Future<dynamic> postRequestWithJsonData({
    required String endPoint,
    Map<dynamic, dynamic>? body,
  }) async {
    token = await LocalServices.getToken() ?? "";

    final Uri uri = Uri.parse(baseURL + endPoint);
    final Map<String, String> requestHeader = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": "*",
    };

    if (kDebugMode) {
      print("POST Request URL: $uri");
      print("Request Body: $body");
    }

    try {
      final http.Response response = await http.post(
        uri,
        body: json.encode(body),
        headers: requestHeader,
        encoding: Encoding.getByName("utf-8"),
      );

      return handleResponse(response);
    } on Exception catch (e) {
      AppStrings.httpErrorMSG.value = AppStrings.generalHttpErrorMSG;
      if (kDebugMode) {
        print("Error in POST request with JSON data: $e");
      }
      return null;
    }
  }

  static Future<dynamic> postRequestWithFullLink({
    required String url,
  }) async {
    token = await LocalServices.getToken() ?? "";
    final Map<String, String> requestHeader = {
      "Authorization": "Bearer $token",
    };

    if (kDebugMode) {
      print("POST Request URL: $url");
    }

    try {
      final Uri uri = Uri.parse(url);
      final http.Response response =
          await http.post(uri, headers: requestHeader);

      return handleResponse(response);
    } on Exception catch (e) {
      AppStrings.httpErrorMSG.value = AppStrings.generalHttpErrorMSG;
      if (kDebugMode) {
        print("Error in POST request with full link: $e");
      }
      return null;
    }
  }

  static Future<dynamic> patchRequest({
    required String endPoint,
    Map<dynamic, dynamic>? body,
  }) async {
    token = await LocalServices.getToken() ?? "";

    AppStrings.httpErrorMSG.value = "";

    final Uri uri = Uri.parse(baseURL + endPoint);
    final Map<String, String> requestHeader = {
      "Authorization": "Bearer $token",
    };

    if (kDebugMode) {
      print("Patch Request URL: $uri");
      //print("Body: $body");
    }

    try {
      final http.Response response = await http.patch(
        uri,
        body: body,
        headers: requestHeader,
      );
      return handleResponse(response);
    } on Exception catch (e) {
      AppStrings.httpErrorMSG.value = AppStrings.generalHttpErrorMSG;
      if (kDebugMode) {
        print("Error in POST request: $e");
      }
      return null;
    }
  }



  static Future<dynamic> patchRequestWithJson({
    required String endPoint,
    Map<dynamic, dynamic>? body,
    Map<String, dynamic>? parameters,
  }) async {
    token = await LocalServices.getToken() ?? "";
    AppStrings.httpErrorMSG.value = "";
    final Uri uri = Uri.parse(baseURL + endPoint).replace(
      queryParameters: parameters,);
    final Map<String, String> requestHeader = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": "*",
    };

    if (kDebugMode) {
      print("PATCH Request URL: $uri");
      print("Request Body: $body");
    }

    try {
      final http.Response response = await http.patch(
        uri,
        //body: body,
        // headers: requestHeader,

        body: json.encode(body),
        headers: requestHeader,
        encoding: Encoding.getByName("utf-8"),
      );

      return handleResponse(response);
    } on Exception catch (e) {
      AppStrings.httpErrorMSG.value = AppStrings.generalHttpErrorMSG;
      if (kDebugMode) {
        print("Error in PUT request: $e");
      }
      return null;
    }
  }

// messaging app link

  static Future<dynamic> chatPostRequest({
    required String url,
    Map<dynamic, dynamic>? body,
  }) async {
    token = await LocalServices.getToken() ?? "";

    final Uri uri = Uri.parse(url);
    final Map<String, String> requestHeader = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": "*",
    };

    if (kDebugMode) {
      print("POST Request URL: $uri");
      print("Request Body: $body");
    }

    try {
      final http.Response response = await http.post(
        uri,
        body: json.encode(body),
        headers: requestHeader,
        encoding: Encoding.getByName("utf-8"),
      );

      if (kDebugMode) {
        print(response.body);
      }

      return handleResponse(response);
    } on Exception catch (e) {
      AppStrings.httpErrorMSG.value = AppStrings.generalHttpErrorMSG;
      if (kDebugMode) {
        print("Error in POST request with JSON data: $e");
      }
      return null;
    }
  }


// messaging app link

  static Future<dynamic> chatGetRequest({
    required String link,
    Map<String, dynamic>? body,
    Map<String, dynamic>? parameters,
  }) async {
    token = await LocalServices.getToken() ?? "";

    final Map<String, String> headers = {
      "Authorization": "Bearer $token",
    };

    try {
      final Uri uri = Uri.parse(link).replace(
        queryParameters: parameters,
      );
      if (kDebugMode) {
        print("GET Request URL: $uri");
        print("Token: $token");
      }

      final http.Response response = await client.get(uri, headers: headers);

      print(response.body);

      return handleResponse(response);
    } on Exception catch (e) {
      AppStrings.httpErrorMSG.value = AppStrings.generalHttpErrorMSG;
      if (kDebugMode) {
        print("Error in GET request: $e");
      }
      return null;
    }
  }






  static Future<dynamic> deleteRequest({
    required String endPoint,
    Map<dynamic, dynamic>? body,
  }) async {
    token = await LocalServices.getToken() ?? "";

    AppStrings.httpErrorMSG.value = "";

    final Uri uri = Uri.parse(baseURL + endPoint);
    final Map<String, String> requestHeader = {
      "Authorization": "Bearer $token",
    };

    if (kDebugMode) {
      print("Delete Request URL: $uri");
      //print("Body: $body");
    }

    try {
      final http.Response response = await http.delete(
        uri,
        body: body,
        headers: requestHeader,
      );
      return handleResponse(response);
    } on Exception catch (e) {
      AppStrings.httpErrorMSG.value = AppStrings.generalHttpErrorMSG;
      if (kDebugMode) {
        print("Error in POST request: $e");
      }
      return null;
    }
  }

  static Future<dynamic> getRequestForResponseBody({
    required String endPoint,
    Map<String, dynamic>? body,
    Map<String, dynamic>? parameters,
  }) async {
    token = await LocalServices.getToken() ?? "";

    final Map<String, String> headers = {
      "Authorization": "Bearer $token",
    };


    try {
      final Uri uri = Uri.parse(baseURL + endPoint).replace(
        queryParameters: parameters,
      );
      if (kDebugMode) {
        print("GET Request URL: $uri");
        print("Token: $token");
      }

      final http.Response response = await client.get(uri, headers: headers);
      if(isHttpStatusSuccess(response.statusCode)) {
        return json.decode(response.body);
      } else {
        return null;
      }


      return response.body;
    } on Exception catch (e) {
      AppStrings.httpErrorMSG.value = AppStrings.generalHttpErrorMSG;
      if (kDebugMode) {
        print("Error in GET request: $e");
      }
      return null;
    }
  }



  static Future<dynamic> getRequest({
    required String endPoint,
    Map<String, dynamic>? body,
    Map<String, dynamic>? parameters,
  }) async {
    token = await LocalServices.getToken() ?? "";

    final Map<String, String> headers = {
      "Authorization": "Bearer $token",
    };

    try {
      final Uri uri = Uri.parse(baseURL + endPoint).replace(
        queryParameters: parameters,
      );
      if (kDebugMode) {
        print("GET Request URL: $uri");
        print("Token: $token");
      }

      final http.Response response = await client.get(uri, headers: headers);


      return handleResponse(response);
    } on Exception catch (e) {
      AppStrings.httpErrorMSG.value = AppStrings.generalHttpErrorMSG;
      if (kDebugMode) {
        print("Error in GET request: $e");
      }
      return null;
    }
  }

  static Future<dynamic> getRequestLoadMore({
    required String url,
    Map<String, dynamic>? body,
    Map<String, dynamic>? parameters,
  }) async {
    token = await LocalServices.getToken() ?? "";

    final Map<String, String> headers = {
      "Authorization": "Bearer $token",
    };

    if (kDebugMode) {
      print("GET Request URL: $url");
    }

    try {
      final Uri uri = Uri.parse(url).replace(
        queryParameters: parameters,
      );

      final http.Response response = await client.get(uri, headers: headers);

      return handleResponse(response);
    } on Exception catch (e) {
      AppStrings.httpErrorMSG.value = AppStrings.generalHttpErrorMSG;
      if (kDebugMode) {
        print("Error in GET request for loading more: $e");
      }
      return null;
    }
  }

  static void customLogOut() {
    CustomSnackBar(
      msg: "Login Required!",
      isWarning: true,
      buttonText: "Go To Login".toUpperCase(),
    ).showSnackBar();
  }

  static Future<dynamic> uploadImages({
    required List<File> images,
    required endPoint,
    String? id,
    String? key,
    Map<String, String>? body,
  }) async {
    final Uri uri = Uri.parse(baseURL + endPoint);

    try {
      final http.MultipartRequest request = http.MultipartRequest('POST', uri);

      request.fields.addAll(body ?? {});

      for (final image in images) {
        final http.ByteStream stream = http.ByteStream(image.openRead());
        final int length = await image.length();
        final http.MultipartFile multipartFile = http.MultipartFile(
            'file[]', stream, length,
            filename: image.path.split('/').last);
        request.files.add(multipartFile);
      }

      final http.Response response =
          await http.Response.fromStream(await request.send());

      return handleResponse(response);
    } on Exception catch (e) {
      AppStrings.httpErrorMSG.value = AppStrings.generalHttpErrorMSG;
      if (kDebugMode) {
        print("Error in uploading images: $e");
      }
      return null;
    }
  }


  static Future<dynamic> uploadDeliveryProofImages({
    required List<File> images,
    required endPoint,
    required String id,
  }) async {
    final Uri uri = Uri.parse(APIEndPoints.baseUrlMessaging + endPoint);

    try {
      final http.MultipartRequest request = http.MultipartRequest('POST', uri);

     // request.fields.addAll(body ?? {});
      request.fields['id'] = id;

      print(images);
      print(">>>>>>>>>>${request.fields}");

      for (final image in images) {
        final http.ByteStream stream = http.ByteStream(image.openRead());
        final int length = await image.length();
        final http.MultipartFile multipartFile = http.MultipartFile(
            'attachments[]', stream, length,
            filename: image.path.split('/').last);
        request.files.add(multipartFile);
      }

      final http.Response response =
          await http.Response.fromStream(await request.send());

      return handleResponse(response);
    } on Exception catch (e) {
      AppStrings.httpErrorMSG.value = AppStrings.generalHttpErrorMSG;
      if (kDebugMode) {
        print("Error in uploading images: $e");
      }
      return null;
    }
  }



/*  static Future<dynamic> uploadDeliveryProofImages({
    required List<Map<String, dynamic>> selectedDocument, // List of file details
    required String url,
    required String deliveryId, // Lead ID to be sent
  }) async {
    final Uri uri = Uri.parse(url);
    final Map<String, String> headers = {
      "Authorization": "Bearer $token",
    };

    if (kDebugMode) {
      print(uri);
      print(selectedDocument);
      print(deliveryId);
    }

    try {
      final http.MultipartRequest request = http.MultipartRequest("POST", uri);

      request.headers.addAll(headers);

      request.fields['id'] = deliveryId;

      for (int i = 0; i < selectedDocument.length; i++) {
        final doc = selectedDocument[i];
        final filePath = doc['path'];
        final fileName = doc['name'];

        if (filePath != null && filePath.isNotEmpty) {
          // Add file name to the body with indexed key
          request.fields['file_name[$i]'] = fileName ?? 'unknown';

          // Attach the file to the request with indexed key
          request.files.add(
            await http.MultipartFile.fromPath(
              'attachments[$i]', // Indexed field name for file
              filePath, // Path of the file
              filename: fileName, // Explicitly set the file name
            ),
          );
        }
      }

      if (kDebugMode) {
        print(request.fields); // To debug the final fields being sent
      }

      final response = await http.Response.fromStream(await request.send());


      var r = json.decode(response.body);
      return handleResponse(response);
    } on Exception catch (e) {
      AppStrings.httpErrorMSG.value = AppStrings.generalHttpErrorMSG;
      if (kDebugMode) {
        print("Error in uploading images: $e");
      }
      return null;
    }
  }*/




  static Future<dynamic> multipartRequest({
    required String filePath,
    required String fieldName,
    required String endPoint,
    required String requestType,
    Map<String, String>? body,
  }) async {
    final Uri uri = Uri.parse(baseURL + endPoint);
    final Map<String, String> headers = {
      "Authorization": "Bearer $token",
    };

    if (kDebugMode) {
      print(uri);
      print(body);
      print(filePath);
      print(fieldName);
    }

    try {
      final http.MultipartRequest request = http.MultipartRequest(requestType, uri);

      request.headers.addAll(headers);
      request.fields.addAll(body ?? {});
      if (filePath.isNotEmpty) {
        request.files.add(
          await http.MultipartFile.fromPath(
            fieldName, // field name in the request
            filePath, // Adjust as needed
          ),
        );
      }

      final response = await http.Response.fromStream(await request.send());
      return handleResponse(response);
    } on Exception catch (e) {
      AppStrings.httpErrorMSG.value = AppStrings.generalHttpErrorMSG;
      if (kDebugMode) {
        print("Error in uploading images: $e");
      }
      return null;
    }
  }

  static dynamic handleResponse(http.Response response) {
    if (isHttpStatusSuccess(response.statusCode)) {
      var responseData = json.decode(response.body);
      if (responseData["status"] == "success") {
        return json.decode(response.body);
      } else {
        AppStrings.httpErrorMSG.value = responseData.toString().contains("msg")
            ? responseData["msg"]
            : AppStrings.generalHttpErrorMSG;
        return null;
      }
      // return json.decode(response.body);
    } else {
      if (kDebugMode) {
        print(generateHttpErrorMessage(response.statusCode));
      }

      try {
        final dynamic responseData = json.decode(response.body);
        AppStrings.httpErrorMSG.value = responseData.toString().contains("msg")
            ? responseData["msg"]
            : responseData.toString().contains("message")
                ? responseData["message"]
                : AppStrings.generalHttpErrorMSG;
      } on Exception {
        AppStrings.httpErrorMSG.value = AppStrings.generalHttpErrorMSG;
      }
      return null;
    }
  }


  static Future<dynamic> multipartRequestAddOrUpdateVehicle({
    required List<String> filePaths,
    required List<String> fieldNames,
    required String endPoint,
    required String requestType,
    Map<String, String>? body,
  }) async
  {
    final Uri uri = Uri.parse(baseURL + endPoint);
    final Map<String, String> headers = {
      "Authorization": "Bearer $token",
    };

    if (kDebugMode) {
      print(uri);
      print(body);
      print(filePaths);
      print(fieldNames);
    }

    try {
      final http.MultipartRequest request = http.MultipartRequest(requestType, uri);

      request.headers.addAll(headers);
      request.fields.addAll(body ?? {});

      // Add files to the request
      for (int i = 0; i < filePaths.length; i++) {
        var filePath = filePaths[i];
        var fieldName = fieldNames[i];
        if (filePath.isNotEmpty) {
          request.files.add(
            await http.MultipartFile.fromPath(
              fieldName, // field name in the request
              filePath, // path of the file
            ),
          );
        }
      }

      final response = await http.Response.fromStream(await request.send());

      print("Response: ${response.body}");
      return handleResponse(response);
    } on Exception catch (e) {
      AppStrings.httpErrorMSG.value = AppStrings.generalHttpErrorMSG;
      if (kDebugMode) {
        print("Error in uploading images: $e");
      }
      return null;
    }
  }


}
