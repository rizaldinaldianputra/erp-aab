// ignore_for_file: prefer_const_constructors

import 'package:component/component.dart';
import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:preferences/preferences.dart';
import 'package:profile/src/presentation/pages/index/sections/pengajuan_lembur.dart';

class DetailLembur extends StatefulWidget {
  final Map lembur;
  final Map attendance;
  final int working_hours;

  const DetailLembur(
      {Key? key,
      required this.lembur,
      required this.attendance,
      required this.working_hours})
      : super(key: key);

  @override
  State<DetailLembur> createState() => _DetailLemburState();
}

class _DetailLemburState extends State<DetailLembur> {
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

  String deletesecond(var value) {
    return value;
  }

  String todate(var value) {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(now);
    return formatted;
  }

  var loading = "false";

  var data = '';

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
      var response = await dio.post(
          'https://' + _defaultUrl! + '/api/v1/employee/lemburs/cancel',
          data: {"id": widget.lembur['id'].toString()});
      print(response.data);
      data = response.data;

      if (data == 'success') {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => PengajuanLembur()),
            ModalRoute.withName(
                '/') // Replace this with your root screen's route name (usually '/')
            );
      }
    } on DioError catch (e) {
      print(e);
    }
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (_) => AppAlertDialog(
        body: Text("Apakah Kamu Membatalkan Pengajuan Lembur"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Cancel"),
          ),
          loading == "false"
              ? TextButton(
                  onPressed: () {
                    if (loading == "false") {
                      setState(() {
                        loading = "true";
                      });
                      fetchData();
                      Navigator.of(context).pop();
                    }
                  },
                  child: loading == "false"
                      ? Text("OK")
                      : CircularProgressIndicator(),
                )
              : Container()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var device_width = MediaQuery.of(context).size.width;
    var device_height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("Detail"),
      ),
      body: Container(
        height: device_height,
        width: device_width,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              Row(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Text(
                    "Status",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Expanded(child: Container()),
                  getLeaveBadge(widget.lembur['status'])
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Type",
                style: TextStyle(fontSize: 15),
              ),
              Text(
                widget.lembur['type'],
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Created By",
                style: TextStyle(fontSize: 15),
              ),
              Text(
                widget.lembur['created_by'],
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                color: Color.fromARGB(255, 100, 155, 250),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        "Attendance & Overtime Request",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      Expanded(child: Container()),
                      Text(
                        "( " + todate(widget.lembur['tanggal']) + ")",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              // Container(
              //   color: Colors.blueAccent,
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Row(
              //       children: [
              //         Column(
              //           children: [
              //             Text(
              //               "Clock in",
              //               style: TextStyle(color: Colors.white, fontSize: 15),
              //             ),
              //             Text(
              //               deletesecond(widget.attendance['clock_in']),
              //               style: TextStyle(
              //                   color: Colors.white,
              //                   fontWeight: FontWeight.bold,
              //                   fontSize: 20),
              //             ),
              //           ],
              //         ),
              //         Expanded(child: Container()),
              //         Column(
              //           children: [
              //             Text(
              //               "Clock out",
              //               style: TextStyle(color: Colors.white, fontSize: 15),
              //             ),
              //             Text(
              //               deletesecond(widget.attendance['clock_out']),
              //               style: TextStyle(
              //                   color: Colors.white,
              //                   fontWeight: FontWeight.bold,
              //                   fontSize: 20),
              //             ),
              //           ],
              //         ),
              //       ],
              //     ),
              //   ),
              // ),

              SizedBox(
                height: 15,
              ),
              Text(
                "Clock submission",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Text(
                          "Clock in",
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          deletesecond(widget.lembur['jam_masuk']),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ],
                    ),
                    Expanded(child: Container()),
                    Column(
                      children: [
                        Text(
                          "Clock out",
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          deletesecond(widget.lembur['jam_keluar']),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Working Hours",
                style: TextStyle(fontSize: 15),
              ),
              Text(
                widget.working_hours.toString() + " Jam",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Reason",
                style: TextStyle(fontSize: 15),
              ),
              Text(
                widget.lembur['keterangan'],
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 80,
          width: double.infinity,
          padding: const EdgeInsets.all(Dimens.dp16),
          child: PrimaryButton(
            onPressed: loading == "true"
                ? null
                : () {
                    _showDialog();
                  },
            color: StaticColors.red,
            child: Text("Cancel Submission"),
          ),
        ),
      ),
    );
  }
}
