import 'package:flutter/cupertino.dart';
import 'package:toystory/widget/reusable_dialog.dart';

void showDeliveryDialog(BuildContext context) {
  List<Map<String, dynamic>> products = [
    {
      'productName': '노트북(Laptop)',
      'productImageUrl': 'https://picsum.photos/id/1/300/300',
      'price': 600000,
      'quantity': 2,
      'orderDate': '2023-11-24',
      'orderNo': '20231114-123456123',
      'paymentStatus': 'completed',
      'deliveryStatus': 'delivering',
    },
    {
      'productName': '키보드(Keyboard)',
      'productImageUrl': 'https://picsum.photos/id/60/300/300',
      'price': 50000,
      'quantity': 3,
      'orderDate': '2023-11-24',
      'orderNo': '20231114-141020312',
      'paymentStatus': 'waiting',
      'deliveryStatus': 'waiting',
    },
  ];

  showCupertinoDialog(
    context: context,
    builder: (context) {
      return ReusableDialog(
        title: '배송 상태 확인',
        content: SizedBox(
          height: 400, // Dialog 내에서 ListView의 높이를 제한
          child: ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("주문날짜: ${product['orderDate']}"),
                    SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          product['productImageUrl'],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product['productName'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text("가격: ${product['price']}원"),
                              Text("수량: ${product['quantity']}"),
                              Text(
                                  "합계: ${product['price'] * product['quantity']}원"),
                              Text(
                                "결제 상태: ${product['paymentStatus']} / 배송 상태: ${product['deliveryStatus']}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    },
  );
}
