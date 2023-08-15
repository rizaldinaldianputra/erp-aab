import 'package:component/component.dart';
import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:l10n/generated/l10n.dart';
import 'package:preferences/preferences.dart';
import 'package:profile/src/presentation/pages/index/sections/pengajuan_lembur.dart';

class AddLembur extends StatefulWidget {
  const AddLembur({Key? key}) : super(key: key);

  @override
  State<AddLembur> createState() => _AddLemburState();
}

class _AddLemburState extends State<AddLembur> {
  TextEditingController alasan = TextEditingController();
  TextEditingController jam_masuk = TextEditingController();
  TextEditingController jam_keluar = TextEditingController();
  bool IsLoading = false;
  DateTime _leaveFrom = DateTime.now();
  var data = [];
  void _onSubmit() async {
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
      setState(() {
        IsLoading = true;
      });

      var response = await dio.post(
          'https://' + _defaultUrl! + '/api/v1/employee/lemburs/add',
          data: {
            "id_employee": id_user,
            "tanggal": _leaveFrom.toString(),
            "waktu_masuk": jam_masuk.text,
            "waktu_keluar": jam_keluar.text,
            "keterangan": alasan.text
          });
      print(response.data);
      if (response.data == "success") {
        setState(() {
          IsLoading = false;
        });

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => PengajuanLembur()),
            ModalRoute.withName(
                '/') // Replace this with your root screen's route name (usually '/')
            );
      } else if (response.data == "belum absen") {
        showDialog(
          context: context,
          builder: (_) => AppAlertDialog(
            body: Text("Kamu Belum Melakukan Absen Hari Ini"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    IsLoading = false;
                  });
                },
                child: Text("OK"),
              ),
            ],
          ),
        );
      }
    } on DioError catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pengajuan Lembur"),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              SizedBox(
                height: 20,
              ),
              DateInput(
                  isRequired: true,
                  label: "Tentukan Tanggal Lembur",
                  value: _leaveFrom,
                  startDate: DateTime.now(),
                  endDate: DateTime(3000),
                  onChange: (val) {
                    if (val != null) {
                      setState(() {
                        _leaveFrom = val;
                      });
                    }
                  }),
              SizedBox(
                height: 20,
              ),
              RegularTextInput(
                isRequired: true,
                hintText: "Jam Masuk",
                label: "Jam Masuk",
                controller: jam_masuk,
                readOnly: true,
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    initialTime: TimeOfDay.now(),
                    context: context,
                  );

                  if (pickedTime != null) {
                    print(pickedTime.format(context)); //output 10:51 PM
                    DateTime parsedTime = DateFormat.jm()
                        .parse(pickedTime.format(context).toString());
                    //converting to DateTime so that we can further format on different pattern.
                    print(parsedTime); //output 1970-01-01 22:53:00.000
                    String formattedTime =
                        DateFormat('HH:mm:ss').format(parsedTime);
                    print(formattedTime); //output 14:59:00
                    //DateFormat() is from intl package, you can format the time on any pattern you need.

                    setState(() {
                      jam_masuk.text =
                          formattedTime; //set the value of text field.
                    });
                  } else {
                    print("Time is not selected");
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              RegularTextInput(
                isRequired: true,
                hintText: "Jam Keluar",
                label: "Jam Keluar",
                controller: jam_keluar,
                readOnly: true,
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    initialTime: TimeOfDay.now(),
                    context: context,
                  );

                  if (pickedTime != null) {
                    print(pickedTime.format(context)); //output 10:51 PM
                    DateTime parsedTime = DateFormat.jm()
                        .parse(pickedTime.format(context).toString());
                    //converting to DateTime so that we can further format on different pattern.
                    print(parsedTime); //output 1970-01-01 22:53:00.000
                    String formattedTime =
                        DateFormat('HH:mm:ss').format(parsedTime);
                    print(formattedTime); //output 14:59:00
                    //DateFormat() is from intl package, you can format the time on any pattern you need.

                    setState(() {
                      jam_keluar.text =
                          formattedTime; //set the value of text field.
                    });
                  } else {
                    print("Time is not selected");
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextAreaInput(
                isRequired: true,
                controller: alasan,
                label: 'Alasan',
                onChange: (val) {},
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 80,
          padding: EdgeInsets.all(Dimens.dp16),
          child: PrimaryButton(
            onPressed: IsLoading
                ? null
                : () {
                    if (!IsLoading) {
                      _onSubmit();
                    }
                  },
            child: Text("Tambah Pengajuan Lembur"),
          ),
        ),
      ),
    );
  }
}
