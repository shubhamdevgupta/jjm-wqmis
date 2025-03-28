class LoginResponse {
  final String? token;
  final String? loginid;
  final String? password;
  final String? adpassword;
  final int? regId;
  final int? roleId;
  final String? mobileNumber;
  final String? name;
  final String? emailId;
  final String? sha512;
  final String? txtSaltedHash;
  final String? stateName;
  final int? stateId;
  final int? districtId;
  final int? blockId;
  final int? gramPanchayatId;
  final int? villageId;
  final int? pincode;
  final String? isChngPwd;
  final int? status;
  final String? msg;
  final String? lang;
  final int? agencyId;
  final bool? isUpdateProfile;
  final dynamic agencyListData;

  LoginResponse({
    this.token,
    this.loginid,
    this.password,
    this.adpassword,
    this.regId,
    this.roleId,
    this.mobileNumber,
    this.name,
    this.emailId,
    this.sha512,
    this.txtSaltedHash,
    this.stateName,
    this.stateId,
    this.districtId,
    this.blockId,
    this.gramPanchayatId,
    this.villageId,
    this.pincode,
    this.isChngPwd,
    this.status,
    this.msg,
    this.lang,
    this.agencyId,
    this.isUpdateProfile,
    this.agencyListData,
  });

  /// Factory method to create an instance from JSON
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['Token'],
      loginid: json['loginid'],
      password: json['password'],
      adpassword: json['adpassword'],
      regId: json['reg_id'],
      roleId: json['role_id'],
      mobileNumber: json['MobileNumber'],
      name: json['Name'],
      emailId: json['EmailId'],
      sha512: json['Sha512'],
      txtSaltedHash: json['txtSaltedHash'],
      stateName: json['StateName'],
      stateId: json['StateId'],
      districtId: json['DistrictId'],
      blockId: json['BlockId'],
      gramPanchayatId: json['GramPanchayatId'],
      villageId: json['VillageId'],
      pincode: json['Pincode'],
      isChngPwd: json['isChngPwd'],
      status: json['status'],
      msg: json['msg'],
      lang: json['lang'],
      agencyId: json['AgencyId'],
      isUpdateProfile: json['isupdateprofile'],
      agencyListData: json['AgencyListData'],
    );
  }

  /// Method to convert the model instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'Token': token,
      'loginid': loginid,
      'password': password,
      'adpassword': adpassword,
      'reg_id': regId,
      'role_id': roleId,
      'MobileNumber': mobileNumber,
      'Name': name,
      'EmailId': emailId,
      'Sha512': sha512,
      'txtSaltedHash': txtSaltedHash,
      'StateName': stateName,
      'StateId': stateId,
      'DistrictId': districtId,
      'BlockId': blockId,
      'GramPanchayatId': gramPanchayatId,
      'VillageId': villageId,
      'Pincode': pincode,
      'isChngPwd': isChngPwd,
      'status': status,
      'msg': msg,
      'lang': lang,
      'AgencyId': agencyId,
      'isupdateprofile': isUpdateProfile,
      'AgencyListData': agencyListData,
    };
  }
}
