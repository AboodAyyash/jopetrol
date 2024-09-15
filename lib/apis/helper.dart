import 'dart:convert';
import 'package:flutter_jo/services/check-internet.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_jo/services/service.dart' as service;
import 'package:flutter_jo/shared/settings.dart' as settings;

enum ApiMethod {
  get,
  post,
}

enum WithBaseURL {
  yes,
  no,
}

enum ShowConnectionPage {
  yes,
  no,
}

Future callApi(
    {url,
    body,
    required method,
    withBaseURL = WithBaseURL.yes,
    showConnectionPage = ShowConnectionPage.yes}) async {
  var responseJson;
  var response;
  var bodyApi = body;
  service.setHeader();
  await checkInternet(showConnectionPage).then((value) async {
    if (value) {
      try {
        print('${settings.baseURL}$url');
        response = method == ApiMethod.get
            ? await http.get(
                Uri.parse(withBaseURL == WithBaseURL.yes
                    ? '${settings.baseURL}$url'
                    : '$url'),
                headers: settings.headers,
              )
            : await http.post(
                Uri.parse(withBaseURL == WithBaseURL.yes
                    ? '${settings.baseURL}$url'
                    : '$url'),
                body: bodyApi, //{'key':'value'}
                headers: settings.headers,
              );
        responseJson = json.decode(response.body);

        if (response.statusCode == 200 || response.statusCode == 201) {
        } else if (response.statusCode == 401) {
          //  serviceAuth.signOut();
          print("responseJson" + responseJson.toString());
          print("response.statusCode ${response.statusCode}");
        } else {
          print("responseJson" + responseJson.toString());
          print("response.statusCode ${response.statusCode}");
        }
      } catch (e) {
        print("${response.statusCode}");
        print('${settings.baseURL}$url');
        print("Url is :" + url.toString());
        print("exception handld is :" + e.toString());
      }
    } else {}
  });

  Map data = {'data': responseJson, 'res': response};
  return data;
}
