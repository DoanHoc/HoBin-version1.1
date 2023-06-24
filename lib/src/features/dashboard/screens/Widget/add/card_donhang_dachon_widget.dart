import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/constants/color.dart';
import '../../../../../common_widgets/dialog/dialog.dart';
import '../../../../../utils/utils.dart';

class CardItemBanHangDaChon extends StatelessWidget {
  final int phanbietNhapXuat;
  const CardItemBanHangDaChon({
    super.key,
    required this.allHangHoa,
    required this.controllerSoluong,
    required this.sumItem,
    required this.onUpdateSumItem,
    required this.phanbietNhapXuat,
  });

  final List<dynamic> allHangHoa;
  final List<TextEditingController> controllerSoluong;
  final int sumItem;
  final void Function(int newSumItem) onUpdateSumItem;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: allHangHoa.length,
            itemBuilder: (context, index) {
              var hanghoa = allHangHoa[index];
              if (hanghoa["soluong"] > 0) {
                return Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              flex: 1,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                                child: SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: Icon(
                                    Icons.inventory_2,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                                flex: 4,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      hanghoa["tensanpham"],
                                      style: const TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.w900),
                                      textAlign: TextAlign.start,
                                    ),
                                    const SizedBox(height: 5),
                                    //chia giá nhập xuất cho 2 trang
                                    Text(
                                      phanbietNhapXuat == 0
                                          ? formatCurrency(hanghoa["giaban"])
                                          : formatCurrency(hanghoa["gianhap"]),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                )),
                            Expanded(
                              flex: 3,
                              child: StatefulBuilder(
                                builder: (BuildContext context,
                                    StateSetter setState) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "Tồn kho: ${hanghoa["tonkho"]}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall,
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: backGroundColor,
                                              ),
                                              child: InkWell(
                                                onTap: () {
                                                  if (hanghoa['soluong'] - 1 ==
                                                      0) {
                                                    MyDialog.showAlertDialog(
                                                        context,
                                                        "Xác nhận",
                                                        'Bạn muốn xóa hàng hóa này khỏi danh sách',
                                                        () {
                                                      hanghoa["soluong"]--;
                                                      controllerSoluong[index]
                                                              .text =
                                                          hanghoa["soluong"]
                                                              .toString();
                                                      int newSumItem =
                                                          sumItem - 1;
                                                      onUpdateSumItem(
                                                          newSumItem);
                                                      Navigator.of(context)
                                                          .pop();
                                                    });
                                                  } else {
                                                    if (hanghoa["soluong"] >
                                                        0) {
                                                      setState(() {
                                                        hanghoa["soluong"]--;
                                                        controllerSoluong[index]
                                                                .text =
                                                            hanghoa["soluong"]
                                                                .toString();
                                                        int newSumItem =
                                                            sumItem - 1;
                                                        onUpdateSumItem(
                                                            newSumItem);
                                                      });
                                                    }
                                                  }
                                                },
                                                child: const Icon(Icons.remove),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 35,
                                              height: 25,
                                              child: TextFormField(
                                                textAlign: TextAlign.center,
                                                controller:
                                                    controllerSoluong[index],
                                                decoration:
                                                    const InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.all(4),
                                                  isDense: true,
                                                  border: InputBorder.none,
                                                ),
                                                scrollPadding: EdgeInsets.zero,
                                                keyboardType:
                                                    TextInputType.number,
                                                onFieldSubmitted: (value) {
                                                  int? soluong =
                                                      int.tryParse(value);
                                                  if (soluong != null) {
                                                    setState(() {
                                                      if (phanbietNhapXuat ==
                                                          0) {
                                                        hanghoa["soluong"] =
                                                            soluong.clamp(
                                                                0,
                                                                hanghoa[
                                                                    "tonkho"]);
                                                      } else if (phanbietNhapXuat ==
                                                          1) {
                                                        hanghoa["soluong"] =
                                                            soluong;
                                                      }
                                                      controllerSoluong[index]
                                                              .text =
                                                          hanghoa["soluong"]
                                                              .toString();
                                                      int newSumItem =
                                                          sumItem + soluong;
                                                      onUpdateSumItem(
                                                          newSumItem);
                                                    });
                                                  }
                                                },
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: backGroundColor),
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    //truong hop ban hang
                                                    if (phanbietNhapXuat == 0 &&
                                                        hanghoa["soluong"] <
                                                            hanghoa["tonkho"]) {
                                                      hanghoa["soluong"]++;
                                                      //truong hop nhap hang, khong gioi han so luong
                                                    } else if (phanbietNhapXuat !=
                                                        0) {
                                                      hanghoa["soluong"]++;
                                                    }
                                                    controllerSoluong[index]
                                                            .text =
                                                        hanghoa["soluong"]
                                                            .toString();
                                                    int newSumItem =
                                                        sumItem + 1;
                                                    onUpdateSumItem(newSumItem);
                                                  });
                                                },
                                                child: const Icon(Icons.add),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ],
      ),
    );
  }
}
