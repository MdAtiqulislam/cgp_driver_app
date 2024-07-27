
extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

extension PassworrdValidator on String{
  bool isValidPassword() {
    return RegExp((r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$')).hasMatch(this);
  }
}

/*extension CheckUser on UserDataModel {
  Future<bool> userStatus() async {
    bool userStatus = false;

    if (status == 1) {
      userStatus = true;
    } else {
      var endPoint = APIEndPoints.getUserData;
      var userInfoModel = UserInfoModel();
      await RemoteServices.getRequest(endPoint: endPoint).then((value) async {
        if (value != null) {
          userInfoModel = UserInfoModel.fromJson(value);
          if (userInfoModel.data?.status == 1) {
            await LocalServices()
                .storeUser(userInfoModel.data ?? UserDataModel());
            userStatus = true;
          } else {
            userStatus = false;
          }
        }
      });
    }

    return userStatus;
  }
}*/
