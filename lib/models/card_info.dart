class CardInfo {
  int? id;
  String? cardNumber;
  String? cardHolderName;
  String? expiryDate;
  String? cvv;

  CardInfo(
      {this.id,
      this.cardNumber,
      this.cardHolderName,
      this.expiryDate,
      this.cvv});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cardNumber': cardNumber,
      'cardHolderName': cardHolderName,
      'expiryDate': expiryDate,
      'cvv': cvv,
    };
  }
}
