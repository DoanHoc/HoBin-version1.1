import 'package:flutter/material.dart';

import '../../../../../constants/color.dart';
import '../../../../../constants/icon.dart';
import 'widget/cardphanphoihang_widget.dart';

class DonePhanPhoiScreen extends StatefulWidget {
  final dynamic updatehanghoaSi;
  final dynamic updatehanghoaLe;
  final int chuyendoiLe;
  const DonePhanPhoiScreen(
      {super.key,
      this.updatehanghoaSi,
      this.updatehanghoaLe,
      required this.chuyendoiLe});

  @override
  State<DonePhanPhoiScreen> createState() => _DonePhanPhoiScreenState();
}

class _DonePhanPhoiScreenState extends State<DonePhanPhoiScreen> {
  late dynamic doneUpdatehanghoaSi;
  late dynamic doneUpdatehanghoaLe;
  late int chuyendoiLeTang;
  @override
  void initState() {
    doneUpdatehanghoaSi = widget.updatehanghoaSi;
    doneUpdatehanghoaLe = widget.updatehanghoaLe;
    chuyendoiLeTang = widget.chuyendoiLe;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('buildddđ done');
    print(chuyendoiLeTang);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 30, color: darkColor),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: const Text("Phân phối hàng hóa",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w900, color: darkColor)),
        backgroundColor: backGroundColor,
        centerTitle: true,
      ),
      backgroundColor: backGroundDefaultFigma,
      body: SizedBox(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(color: Colors.white),
              child: const Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage(successIcon),
                      height: 35,
                    ),
                    Padding(padding: EdgeInsets.only(right: 10)),
                    Text(
                      'Phân phối hàng hóa thành công!',
                      textAlign: TextAlign.justify,
                    )
                  ],
                ),
              ),
            ),
            Column(
              children: [
                CardPhanPhoiHang(
                    slchuyendoi: 0,
                    imageProduct: doneUpdatehanghoaSi['photoGood'].isEmpty
                        ? distributeGoodIcon
                        : doneUpdatehanghoaSi['photoGood'],
                    donViProduct: doneUpdatehanghoaSi['donvi'],
                    updatehanghoa: doneUpdatehanghoaSi),
                const Icon(
                  Icons.arrow_downward_outlined,
                ),
                CardPhanPhoiHang(
                    slchuyendoi: chuyendoiLeTang,
                    imageProduct: doneUpdatehanghoaLe['photoGood'].isEmpty
                        ? distributeGoodIcon
                        : doneUpdatehanghoaLe['photoGood'],
                    donViProduct: doneUpdatehanghoaLe['donvi'],
                    updatehanghoa: doneUpdatehanghoaLe),
              ],
            )
          ],
        ),
      ),
    );
  }
}
