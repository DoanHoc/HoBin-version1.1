import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../../../../constants/color.dart';
import '../../../../../../repository/history_repository/history_repository.dart';
import '../card_history.dart';
import 'chitiet_thang.dart';

class StreamList extends StatelessWidget {
  const StreamList({
    super.key,
    required this.controller,
    required List<List<DocumentSnapshot<Object?>>> docsByMonth,
    required this.snapshotCollection,
  }) : _docsByMonth = docsByMonth;
  final String snapshotCollection;
  final HistoryRepository controller;
  final List<List<DocumentSnapshot<Object?>>> _docsByMonth;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      color: whiteColor,
      height: size.height - kToolbarHeight - 140,
      child: StreamBuilder<QuerySnapshot>(
          stream: controller.getAllDonBanHangHoacNhapHang(snapshotCollection),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("Không có dữ liệu"));
            } else {
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: _docsByMonth.length,
                itemBuilder: ((BuildContext context, int index) {
                  final docs = _docsByMonth[index];
                  final month = docs.first['ngaytao'].split('/')[1];
                  final year = docs.first['ngaytao'].split('/')[2];
                  // Tính tổng tongthanhtoan theo tháng
                  final doanhThuMonthlyTotal = docs.fold<num>(
                      0, (prev, curr) => prev + curr['tongthanhtoan']);
                  final soluongMonthlyTotal =
                      docs.fold<num>(0, (prev, curr) => prev + curr['tongsl']);
                  final soLuongDonHangMonthlyTotal = docs.length;
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    color: whiteColor,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 15, 8, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Tháng $month" "/" "$year",
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                        ChitietThang(
                          doanhThuMonthlyTotal: doanhThuMonthlyTotal,
                          soluongMonthlyTotal: soluongMonthlyTotal,
                          soLuongDonHangMonthlyTotal:
                              soLuongDonHangMonthlyTotal,
                          phanbietNhapHangBanHang: snapshotCollection,
                        ),
                        CardHistory(
                          docs: docs,
                        )
                      ],
                    ),
                  );
                }),
              );
            }
          }),
    );
  }
}
