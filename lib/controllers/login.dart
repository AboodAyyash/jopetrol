import 'package:flutter_jo/apis/helper.dart';
import 'package:flutter_jo/models/user.dart';

class LoginController {
  LoginController();
  Future loginApi() async {
    var body = {
      'token': "Cf6NNPsEWmRd43L8+GnJt3a90OojMj9mBzUqRANTduE=",
      "data": {
        "EMPID": "90013234",
        "PWD": "1",
        "deviceName": "LD90013234",
      }
    };
    var allData;
    await callApi(method: ApiMethod.post, endPoint: "CheckUserLogin", body: body)
        .then((onValue) {
      print("onValuess $onValue");
      allData = onValue;
      return onValue;
    });
    return allData;
  }

  Future getLoadsApi() async {
    var body = {
      "Request": [
        "Cf6NNPsEWmRd43L8+GnJt3a90OojMj9mBzUqRANTduE=",
        "{'Depot':'2001','CurrentUserArea':'A','CurrentUserLoadRoleID':'09','CurrentUserLoadingDepot':'2001', 'loadStateFromCalling':'',  'deviceName':'LD90013234'}"
      ]
    };
    var allData;
    await callApi(
      method: ApiMethod.post,
      endPoint: "GetLoads",
      body: body,
    ).then((onValue) {
      print("onValuess $onValue");
      allData = onValue;
      return onValue;
    });
    return allData;
  }

  Future getAllData() async {
    List<UserModel> users = [];
    await callApi(
      method: ApiMethod.get,
      withBaseURL: WithBaseURL.no,
      endPoint: "https://dummyjson.com/users/search?q=",
    ).then((onValue) {
      for (var i = 0; i < onValue['data']['users'].length; i++) {
        UserModel userModelData = UserModel(
            id: onValue['data']['users'][i]['id'].toString(),
            name: onValue['data']['users'][i]['firstName']);
        users.add(userModelData);
      }
      print(users[0].name);
      return onValue;
    });
    return users;
  }
}
