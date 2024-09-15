import 'package:flutter_jo/apis/helper.dart';

class LoginController {
  Future loginApi() async {
    var body = {
      'token': "Cf6NNPsEWmRd43L8+GnJt3a90OojMj9mBzUqRANTduE=",
      "data": {
        "EMPID": "90013234",
        "PWD": "1",
        "deviceName": "LD90013234",
      }
    };
    callApi(method: ApiMethod.post, url: "CheckUserLogin", body: body)
        .then((onValue) {
      print(onValue);
      return onValue;
    });
  }
}
