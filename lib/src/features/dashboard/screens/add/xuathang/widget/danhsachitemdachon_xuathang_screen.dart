import 'package:flutter/material.dart';

import '../../../../../../common_widgets/dotline/dotline.dart';
import '../../../../../../constants/color.dart';
import '../../../../../../constants/icon.dart';
import '../../../../../../utils/utils.dart';
import '../../nhaphang/widget/delete_item.dart';

class DanhSachItemDaChonXuatHangScreen extends StatefulWidget {
  final List<Map<String, dynamic>> selectedItems;
  final bool blockOnPress;
  final Function reLoad;
  const DanhSachItemDaChonXuatHangScreen(
      {super.key,
      required this.selectedItems,
      required this.blockOnPress,
      required this.reLoad});

  @override
  State<DanhSachItemDaChonXuatHangScreen> createState() =>
      _DanhSachItemDaChonXuatHangScreenState();
}

class _DanhSachItemDaChonXuatHangScreenState
    extends State<DanhSachItemDaChonXuatHangScreen> {
  void _deleteItem(int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return DeleteItemsScreen(
          thongTinItemNhapHienTai: widget.selectedItems[index],
          onDelete: () {
            widget.selectedItems.removeAt(index);
            widget.reLoad(widget.selectedItems);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    num totalPrice = widget.selectedItems
        .map<num>((item) => item['soluong'] * item['gia'])
        .reduce((value, element) => value + element);

    num totalQuantity = widget.selectedItems
        .map<num>((item) => item['soluong'])
        .reduce((value, element) => value + element);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: Image(image: AssetImage(tongtienxuatkhoIcon)),
                  ),
                  SizedBox(width: 7),
                  Text("Ước tính chi phí",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.only(left: 22),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Tổng tiền:", style: TextStyle(fontSize: 17)),
                    Text(formatCurrency(totalPrice),
                        style: const TextStyle(fontSize: 17)),
                  ],
                ),
              ),
              const SizedBox(height: 7),
              Padding(
                padding: const EdgeInsets.only(left: 22),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Text("Tổng số lượng:", style: TextStyle(fontSize: 17)),
                      ],
                    ),
                    Text(totalQuantity.toString(),
                        style: const TextStyle(fontSize: 17)),
                  ],
                ),
              ),
            ],
          ),
        ),
        PhanCachWidget.space(),
        Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(15, 10, 15, 7),
              child: Row(
                children: [
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: Image(image: AssetImage(tongsoluongxuatkhoIcon)),
                  ),
                  SizedBox(width: 7),
                  Text(
                    "Danh sách đã chọn",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.selectedItems.length,
              itemBuilder: (context, index) {
                final docdata = widget.selectedItems[index];
                print(docdata);
                return Column(
                  children: [
                    InkWell(
                      onLongPress: widget.blockOnPress == false
                          ? () {
                              _deleteItem(index);
                            }
                          : null,
                      child: ListTile(
                          leading: CircleAvatar(
                            // radius: 17,
                            backgroundColor: backGroundColor,
                            foregroundColor: mainColor,
                            child: Text(
                              (index + 1).toString(),
                              style: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w700),
                            ),
                          ),
                          title: Text("${docdata['tensanpham']} ",
                              style: const TextStyle(fontSize: 17)),
                          subtitle: Column(
                            children: [
                              const SizedBox(height: 3),
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: docdata["locationAndexp"].length,
                                itemBuilder: (context, index) {
                                  final listLocation =
                                      docdata["locationAndexp"][index];
                                  return Row(
                                    children: [
                                      Text(
                                          "HSD: ${listLocation["exp"]} - ${listLocation["location"]} - SL: ${listLocation["soluong"]} ",
                                          style: const TextStyle(fontSize: 14))
                                    ],
                                  );
                                },
                              ),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${formatCurrency(docdata['gia'])} x ${docdata["soluong"]}",
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    Text(
                                      formatCurrency(
                                          docdata['gia'] * docdata["soluong"]),
                                      style: const TextStyle(fontSize: 14),
                                    )
                                  ]),
                            ],
                          )
                          // Các thuộc tính khác của CheckboxListTile
                          // ...
                          ),
                    ),
                    index != widget.selectedItems.length - 1
                        ? PhanCachWidget.dotLine(context)
                        : const SizedBox()
                  ],
                );
              },
            ),
          ],
        )
      ],
    );
  }
}
