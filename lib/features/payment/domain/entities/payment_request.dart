class PaymentRequest {
  final int amount;
  final String productName;
  final String productId;
  final String buyerName;
  final String buyerEmail;
  final String buyerPhone;
  final String orderId;
  final String fullName;
  final String phoneNo;
  final String phoneModel;
  final String sellerId;
  final int price;
  final String location;
  final String date;
  final String time;
  final String oid;
  final String refId;
  final Map<String, dynamic>? metadata;
  final String flow;

  PaymentRequest({
    required this.amount,
    required this.productName,
    required this.productId,
    required this.buyerName,
    required this.buyerEmail,
    required this.buyerPhone,
    required this.orderId,
    required this.fullName,
    required this.phoneNo,
    required this.phoneModel,
    required this.sellerId,
    required this.price,
    required this.location,
    required this.date,
    required this.time,
    required this.oid,
    required this.refId,
    this.metadata,
    this.flow = 'payment_intent',
  });

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'productName': productName,
      'productId': productId,
      'buyerName': buyerName,
      'buyerEmail': buyerEmail,
      'buyerPhone': buyerPhone,
      'orderId': orderId,
      'fullName': fullName,
      'phoneNo': phoneNo,
      'phoneModel': phoneModel,
      'sellerId': sellerId,
      'price': price,
      'location': location,
      'date': date,
      'time': time,
      'oid': oid,
      'refId': refId,
      'metadata': metadata ?? {'notes': 'App booking'},
      'flow': flow,
    };
  }
}
