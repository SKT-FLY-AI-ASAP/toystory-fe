import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toystory/widget/reusable_dialog.dart';

void showDeliveryDialog(BuildContext context) {
  List<Map<String, dynamic>> products = [
    {
      'productName': '엑스칼리버',
      'productImageUrl': 'https://via.placeholder.com/100',
      'price': 600000,
      'quantity': 2,
      'orderDate': '2023-11-24',
      'orderNo': '20231114-123456123',
      'paymentStatus': '결제 대기',
      'deliveryStatus': '배송 대기',
    },
    {
      'productName': '곰돌이',
      'productImageUrl': 'https://via.placeholder.com/100',
      'price': 50000,
      'quantity': 1,
      'orderDate': '2023-11-24',
      'orderNo': '20231114-141020312',
      'paymentStatus': '결제 완료',
      'deliveryStatus': '배송 중',
    },
  ];

  showCupertinoDialog(
    context: context,
    builder: (context) {
      return ReusableDialog(
        title: '배송 상태 확인',
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 날짜 선택 Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // 첫 번째 날짜 선택 버튼의 동작
                  },
                  child: Text('시작 날짜 선택'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    '~',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // 두 번째 날짜 선택 버튼의 동작
                  },
                  child: Text('종료 날짜 선택'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
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
                        Text(
                          "주문날짜: ${product['orderDate']}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(
                              product['productImageUrl'],
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product['productName'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    "가격: ${product['price']}원",
                                    style: const TextStyle(
                                      color: Colors.black,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    "수량: ${product['quantity']}",
                                    style: const TextStyle(
                                      color: Colors.black,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    "합계: ${product['price'] * product['quantity']}원",
                                    style: const TextStyle(
                                      color: Colors.black,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    "결제 상태: ${product['paymentStatus']} / 배송 상태: ${product['deliveryStatus']}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
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
          ],
        ),
      );
    },
  );
}