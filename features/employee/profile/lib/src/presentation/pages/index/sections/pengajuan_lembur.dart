import 'package:component/component.dart';
import 'package:core/core.dart';
import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:preferences/preferences.dart';
import 'package:profile/src/presentation/pages/index/sections/add_pengajuan.dart';
import 'package:profile/src/presentation/pages/index/sections/detail_lembur.dart';

class LeaveUtils {
  static Widget getLeaveBadge(String status) {
    switch (status) {
      case 'approved':
        return Badge.success(text: status.toUpperCase());
      case 'awaiting':
        return Badge.warning(text: status.toUpperCase());
      case 'rejected':
        return Badge.error(text: status.toUpperCase());

      default:
        return const SizedBox();
    }
  }
}

class PengajuanLembur extends StatefulWidget {
  const PengajuanLembur({Key? key}) : super(key: key);

  @override
  State<PengajuanLembur> createState() => _PengajuanLemburState();
}

class _PengajuanLemburState extends State<PengajuanLembur> {
  var data = [];
  var data2 = [];
  var attendance = [];
  var attendance2 = [];
  var working = [];
  var isLoading = false;
  var working2 = [];
  void fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var _defaultUrl = prefs.getString('host');
    var auth = prefs.getString('ath');
    var deviceId = prefs.getString('dvc');
    var lg = prefs.getString('lg');
    var id_user = prefs.getString("id_user");
    Dio dio = Dio();

// Define your headers
    Map<String, dynamic> headers = {
      'Authorization': auth,
      'user-device': deviceId,
      'Accept-Language': lg,
    };

// Set the headers in Dio options
    dio.options.headers = headers;
    try {
      var response = await dio.get('https://' +
          _defaultUrl! +
          '/api/v1/employee/lembursbyid/' +
          id_user! +
          '/awaiting');

      setState(() {
        isLoading = false;
        data = response.data['lembur'];
        attendance.add(response.data['attendance']);
        working = response.data['between'];
      });

      var response2 = await dio.get('https://' +
          _defaultUrl +
          '/api/v1/employee/lembursbyid/' +
          id_user +
          '/approved');

      setState(() {
        data2 = response2.data['lembur'];
        attendance2.add(response2.data['attendance']);
        working2 = response2.data['between'];
      });
    } on DioError catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      isLoading = false;
    });
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
            child: Center(
              child: Icon(Icons.add, color: Colors.white),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddLembur()),
              );
            }),
        body: NestedScrollView(
            physics: const BouncingScrollPhysics(),
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  title: Text("Pengajuan Lembur"),
                  pinned: true,
                  snap: true,
                  floating: true,
                  expandedHeight: 120.0,
                  bottom: TabBar(
                    indicatorColor: Colors.red,
                    tabs: [
                      Tab(text: "InProccess"),
                      Tab(text: "Completed"),
                    ],
                  ),
                ),
              ];
            },
            body: TabBarView(
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : data.length < 1
                        ? Center(child: Text("Belum Ada Data Pengajuan Lembur"))
                        : ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              var item = data[index];
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DetailLembur(
                                              lembur: item,
                                              attendance: {},
                                              working_hours: working[index],
                                            )),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(Dimens.dp16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SubTitle2Text(
                                                    "Approval Lembur"),
                                                const SizedBox(
                                                    height: Dimens.dp8),
                                                Row(
                                                  children: [
                                                    Text(
                                                        "${item['tanggal']}  •  "),
                                                    SmallText(
                                                        item['jam_masuk']),
                                                    SmallText(
                                                        item['jam_keluar']),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          LeaveUtils.getLeaveBadge(
                                              item['status']),
                                        ],
                                      ),
                                      const SizedBox(height: Dimens.dp12),
                                      SubTitle2Text(
                                        item['created_by'] ?? '',
                                        style: TextStyle(color: Colors.orange),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                //tab complete
                isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : data2.length < 1
                        ? Center(child: Text("Belum Ada Data Pengajuan Lembur"))
                        : ListView.builder(
                            itemCount: data2.length,
                            itemBuilder: (context, index) {
                              var item = data2[index];
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DetailLembur(
                                              lembur: item,
                                              attendance: {},
                                              working_hours: working2[index],
                                            )),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(Dimens.dp16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SubTitle2Text(
                                                    "Approval Lembur"),
                                                const SizedBox(
                                                    height: Dimens.dp8),
                                                Row(
                                                  children: [
                                                    Text(
                                                        "${item['tanggal']}  •  "),
                                                    SmallText(
                                                        item['jam_masuk']),
                                                    SmallText(
                                                        item['jam_keluar']),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          LeaveUtils.getLeaveBadge(
                                              item['status']),
                                        ],
                                      ),
                                      const SizedBox(height: Dimens.dp12),
                                      SubTitle2Text(
                                        item['created_by'] ?? '',
                                        style: TextStyle(color: Colors.orange),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
              ],
            )),
      ),
    );
  }
}

// class InProccess extends StatefulWidget {
//   const InProccess({Key? key}) : super(key: key);

//   @override
//   State<InProccess> createState() => _InProccessState();
// }

// class _InProccessState extends State<InProccess> {
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(itemBuilder: itemBuilder)
//   }
// }
