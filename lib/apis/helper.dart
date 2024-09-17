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
  service.setHeader(bodyApi.toString());
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
                body: jsonEncode(bodyApi), //{'key':'value'}
                headers: settings.headers,
              );
        print(response.body);
        responseJson = json.decode(response.body);
      } catch (e) {
        print("Url is :" + url.toString());
        print("exception handld is :" + e.toString());
      }
    } else {}
  });

  Map data = {'data': responseJson, 'res': response};
  return data;
}
