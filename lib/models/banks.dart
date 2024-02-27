class BanksModel {
  int id;
  String bankName;
  String accountName;
  String accountNumber;
  String iban;

  BanksModel({
    required this.id,
    required this.bankName,
    required this.accountName,
    required this.accountNumber,
    required this.iban,
  });

  factory BanksModel.fromJson(Map<String, dynamic> json){
    return BanksModel(
      id: json['id'] as int,
      bankName: json['bank_name'],
      accountName: json['account_name'],
      accountNumber: json['account_number'],
      iban: json['iban'],
    );
  }
}