class StakeData {
  final DateTime date;
  final double amount;

  StakeData({required this.date, required this.amount});

  factory StakeData.fromJson(Map<String, dynamic> json) {
    return StakeData(
      date: json['date'],
      amount: json['amount'].toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'amount': amount,
    };
  }
}