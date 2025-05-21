class LoginResponse {
  final String? token;
  final String? loginId;
  final String? password;
  final String? adPassword;
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
  final String? isChangePwd;
  final int? status;
  final String? msg;
  final String? lang;
  final int? agencyId;
  final bool? isUpdateProfile;
  final dynamic agencyListData;
  final String? districtName;
  final String? blockName;
  final String? panchayatName;
  final String? villageName;

  LoginResponse({
    required this.token,
    required this.loginId,
    required this.password,
    required this.adPassword,
    required this.regId,
    required this.roleId,
    required this.mobileNumber,
    required this.name,
    required this.emailId,
    this.sha512,
    this.txtSaltedHash,
    required this.stateName,
    required this.stateId,
    required this.districtId,
    required this.blockId,
    required this.gramPanchayatId,
    required this.villageId,
    required this.pincode,
    required this.isChangePwd,
    required this.status,
    this.msg,
    this.lang,
    required this.agencyId,
    required this.isUpdateProfile,
    this.agencyListData,
    required this.districtName,
    required this.blockName,
    required this.panchayatName,
    required this.villageName,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['Token'],
      loginId: json['loginid'],
      password: json['password'],
      adPassword: json['adpassword'],
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
      isChangePwd: json['isChngPwd'],
      status: json['status'],
      msg: json['msg'],
      lang: json['lang'],
      agencyId: json['AgencyId'],
      isUpdateProfile: json['isupdateprofile'],
      agencyListData: json['AgencyListData'],
      districtName: json['DistrictName'],
      blockName: json['BlockName'],
      panchayatName: json['PanchayatName'],
      villageName: json['VillageName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Token': token,
      'loginid': loginId,
      'password': password,
      'adpassword': adPassword,
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
      'isChngPwd': isChangePwd,
      'status': status,
      'msg': msg,
      'lang': lang,
      'AgencyId': agencyId,
      'isupdateprofile': isUpdateProfile,
      'AgencyListData': agencyListData,
      'DistrictName': districtName,
      'BlockName': blockName,
      'PanchayatName': panchayatName,
      'VillageName': villageName,
    };
  }
}
