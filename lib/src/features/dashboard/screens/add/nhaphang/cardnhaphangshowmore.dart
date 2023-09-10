import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hobin_warehouse/src/repository/goods_repository/good_repository.dart';
import 'package:intl/intl.dart';
import '../../../../../constants/color.dart';
import '../../../../../constants/icon.dart';
import '../../../../../utils/utils.dart';
import 'widget/add_location.dart';
import 'widget/add_quantity.dart';

class CardNhapHangShowMore extends StatefulWidget {
  final int phanBietNhapXuat;
  final dynamic hanghoa;
  final Function(int) callbackSL;
  final Function(Map<String, dynamic>) callbackNameLocation;
  const CardNhapHangShowMore({
    super.key,
    this.hanghoa,
    required this.callbackSL,
    required this.callbackNameLocation,
    required this.phanBietNhapXuat,
  });

  @override
  State<CardNhapHangShowMore> createState() => _CardNhapHangShowMoreState();
}

class _CardNhapHangShowMoreState extends State<CardNhapHangShowMore> {
  bool isExpanded = false;
  final conntroller = Get.put(GoodRepository());
  List<Map<String, dynamic>> dataMapList = [];
  late List<int> soLuongTable = [];

  @override
  void initState() {
    super.initState();
    soLuongTable.clear();
    conntroller
        .getAllLocation(widget.hanghoa["macode"])
        .listen((QuerySnapshot snapshot) {
      setState(() {
        List<Map<String, dynamic>> tempList =
            List.from(dataMapList); // Tạo danh sách tạm thời
        for (var doc in snapshot.docs) {
          soLuongTable.add(
              doc['soluong'] as int); // Thêm giá trị vào danh sách soLuongTable
          String location = doc['location'];
          String expiration = doc['exp'];
          Map<String, dynamic> dataMap = {
            'tensp': widget.hanghoa["tensanpham"],
            'location': location,
            'exp': expiration,
            'soluong': 0,
          };

          tempList.add(dataMap);
        }

        dataMapList = tempList; // Cập nhật dataMapList thành danh sách tạm thời
      });
    });
  }

  Future<void> updateExpirationDate(int index, String newDate) async {
    setState(() {
      dataMapList[index]["exp"] = newDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<void> addLocation() async {
      await showModalBottomSheet<num>(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        builder: (BuildContext context) {
          return AddLocation(
            phanBietNhapXuat: widget.phanBietNhapXuat,
            hanghoa: widget.hanghoa,
          );
        },
      );
    }

    Future<void> addQuantity(String location) async {
      final result = await showModalBottomSheet<String>(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        builder: (BuildContext context) {
          return AddQuantity(
            hanghoa: widget.hanghoa,
            location: location,
          );
        },
      );
      if (result != null) {
        setState(() {
          int locationIndex = dataMapList
              .indexWhere((element) => element['location'] == location);
          // có giá trị trả về từ Bottom sheet
          soLuongTable[locationIndex] += int.parse(result);
          int sum = 0;
          for (int value in soLuongTable) {
            sum += value;
          }
          widget.callbackSL(sum);
          widget.callbackNameLocation({location: soLuongTable[locationIndex]});
        });
      } else {
        // Xử lý khi không nhận được giá trị trả về
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(12), // Đặt bán kính bo góc tại đây
          color: whiteColor,
        ),
        child: ExpansionTile(
          onExpansionChanged: (value) {
            setState(() {
              isExpanded = value;
            });
          },
          leading: widget.hanghoa["photoGood"].isEmpty
              ? const Image(
                  image: AssetImage(hanghoaIcon),
                  height: 35,
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    height: 40,
                    width: 40,
                    imageUrl: widget.hanghoa["photoGood"].toString(),
                    fit: BoxFit.fill,
                  ),
                ),
          title: Text(
            widget.hanghoa["tensanpham"],
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            textAlign: TextAlign.start,
          ),
          trailing: SizedBox(
            width: 65,
            height: 25,
            child: ElevatedButton(
              onPressed: () {
                addLocation();
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                backgroundColor:
                    widget.phanBietNhapXuat == 1 ? blueColor : mainColor,
                side: BorderSide(
                    color:
                        widget.phanBietNhapXuat == 1 ? blueColor : mainColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      10), // giá trị này xác định bán kính bo tròn
                ),
              ),
              child: const Text(
                'Nhập',
                style: TextStyle(fontSize: 13),
              ),
            ),
          ),
          subtitle: Text(
            "Kho: ${widget.hanghoa["tonkho"]} ${widget.hanghoa["donvi"]} - ${formatCurrency(widget.hanghoa["giaban"])}",
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w100),
            textAlign: TextAlign.start,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: StreamBuilder<QuerySnapshot>(
                  stream: conntroller.getAllLocation(widget.hanghoa["macode"]),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text("Không có dữ liệu"));
                    } else {
                      return Table(
                        border: TableBorder.all(),
                        columnWidths: const {
                          0: FixedColumnWidth(120), // Location column width
                          1: FixedColumnWidth(100), // SL column width
                          2: FixedColumnWidth(120), // Exp column width
                        },
                        children: [
                          const TableRow(
                            children: [
                              TableCell(
                                child: Padding(
                                  padding: EdgeInsets.all(4.0), // Padding cho ô
                                  child: Text(
                                    'Location',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: EdgeInsets.all(4.0), // Padding cho ô
                                  child: Text('SL',
                                      style: TextStyle(fontSize: 16)),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: EdgeInsets.all(4.0), // Padding cho ô
                                  child: Text('Exp',
                                      style: TextStyle(fontSize: 16)),
                                ),
                              ),
                            ],
                          ),
                          ...List.generate(snapshot.data!.docs.length, (index) {
                            var document = snapshot.data!.docs[index];
                            var location = document['location'];
                            int locationIndex = dataMapList.indexWhere(
                                (element) => element['location'] == location);

                            return TableRow(
                              children: [
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(
                                        4.0), // Padding cho ô
                                    child: Text(location,
                                        style: const TextStyle(fontSize: 16)),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(
                                        4.0), // Padding cho ô
                                    child: Text(
                                        soLuongTable[locationIndex].toString(),
                                        style: const TextStyle(fontSize: 16)),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(
                                        4.0), // Padding cho ô
                                    child: Text(
                                      dataMapList[index]["exp"],
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ],
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
