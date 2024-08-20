import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toystory/widget/reusable_dialog.dart';

class Product {
  final int productNo;
  final String productName;
  final String productImageUrl;
  final double price;
  final String orderNo;
  final String orderDate;
  final String deliveryAddress;
  final String manufacturer;
  final String estimatedCompletionDate;
  final String status;

  Product({
    required this.productNo,
    required this.productName,
    required this.productImageUrl,
    required this.price,
    required this.orderNo,
    required this.orderDate,
    required this.deliveryAddress,
    required this.manufacturer,
    required this.estimatedCompletionDate,
    required this.status,
  });
}

void showProductionDialog(BuildContext context) {
  // 예시 데이터 리스트
  List<Product> productList = [
    Product(
      productNo: 1,
      productName: "엑스칼리버",
      productImageUrl: "https://via.placeholder.com/150",
      price: 100000,
      orderNo: "22222",
      orderDate: "2024.6.10",
      deliveryAddress: "서울시 관악구 보라매로5길 1",
      manufacturer: "skt",
      estimatedCompletionDate: "2024.6.10",
      status: "제작중",
    ),
  ];

  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now();

  showCupertinoDialog(
    context: context,
    builder: (context) {
      return ReusableDialog(
        title: '제작 현황 확인',
        content: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CupertinoButton(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: CupertinoColors.systemGrey5,
                  onPressed: () {
                    showCupertinoModalPopup(
                      context: context,
                      builder: (context) {
                        return Container(
                          height: 250,
                          color: Colors.white,
                          child: CupertinoDatePicker(
                            mode: CupertinoDatePickerMode.date,
                            initialDateTime: selectedStartDate,
                            onDateTimeChanged: (DateTime newDate) {
                              selectedStartDate = newDate;
                            },
                          ),
                        );
                      },
                    );
                  },
                  child: Text(
                    "${selectedStartDate.month} ${selectedStartDate.day}, ${selectedStartDate.year}",
                    style: TextStyle(color: CupertinoColors.activeBlue),
                  ),
                ),
                Text(' ~ '),
                CupertinoButton(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: CupertinoColors.systemGrey5,
                  onPressed: () {
                    showCupertinoModalPopup(
                      context: context,
                      builder: (context) {
                        return Container(
                          height: 250,
                          color: Colors.white,
                          child: CupertinoDatePicker(
                            mode: CupertinoDatePickerMode.date,
                            initialDateTime: selectedEndDate,
                            onDateTimeChanged: (DateTime newDate) {
                              selectedEndDate = newDate;
                            },
                          ),
                        );
                      },
                    );
                  },
                  child: Text(
                    "${selectedEndDate.month} ${selectedEndDate.day}, ${selectedEndDate.year}",
                    style: TextStyle(color: CupertinoColors.activeBlue),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 300,
              width: double.maxFinite,
              child: ListView.builder(
                itemCount: productList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        Row(
                          children: [
                            Image.network(
                              productList[index].productImageUrl,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    productList[index].orderDate,
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                  Text(
                                    productList[index].productName,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    "주문 번호: ${productList[index].orderNo}",
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                  Text(
                                    productList[index].status,
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                  Text(
                                    "배송지: ${productList[index].deliveryAddress}",
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                  Text(
                                    "제작 업체 정보: ${productList[index].manufacturer}",
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                  Text(
                                    "예상 제작 완료일: ${productList[index].estimatedCompletionDate}",
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              // 주문 수정하기 버튼 눌렀을 때 처리할 로직
                            },
                            child: const Text(
                              "주문 수정하기",
                              style: TextStyle(
                                color: CupertinoColors.activeBlue,
                                fontSize: 14,
                              ),
                            ),
                          ),
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
