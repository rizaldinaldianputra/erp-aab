import 'package:component/component.dart';
import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:preferences/preferences.dart';

class RequestLemburDetail extends StatefulWidget {
  final Map data;

  const RequestLemburDetail({Key? key, required this.data}) : super(key: key);

  @override
  State<RequestLemburDetail> createState() => _RequestLemburDetailState();
}

class _RequestLemburDetailState extends State<RequestLemburDetail> {
  TextEditingController jam_masuk = TextEditingController();
  TextEditingController jam_keluar = TextEditingController();
  TextEditingController reason = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    jam_keluar.text = widget.data['jam_keluar'];
    jam_masuk.text = widget.data['jam_masuk'];
  }

  String data = '';
  var isLoading = false;
  Future<void> approvereject(var value) async {
    setState(() {
      isLoading = true;
    });

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
          'https://' + _defaultUrl! + '/api/v1/employee/lemburs/' + value,
          data: {
            "id": widget.data['id'],
            "waktu_masuk": jam_masuk.text,
            "waktu_keluar": jam_keluar.text,
            "reason": reason.text
          });

      setState(() {
        isLoading = false;
        print(response.data);
        data = response.data;
      });
      if (data == 'success') {
        Navigator.of(context).pop();
      }
    } on DioError catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Request Detail",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.data['created_by'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Text(
                          widget.data['created_at'],
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    Expanded(child: Container()),
                    if (widget.data['status'] == "awaiting") ...[
                      _buildApprovalStatusInfo(Colors.orange,
                          widget.data['status'], Icons.access_time)
                    ] else if (widget.data['status'] == "approved") ...[
                      _buildApprovalStatusInfo(
                          Colors.green, widget.data['status'], Icons.check)
                    ] else if (widget.data['status'] == "rejected") ...[
                      _buildApprovalStatusInfo(
                          Colors.red, widget.data['status'], Icons.close)
                    ] else ...[
                      _buildApprovalStatusInfo(Colors.purple,
                          widget.data['status'], Icons.block_sharp)
                    ],
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Request Information\n",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20)),
                        Row(
                          children: [
                            Container(
                              width: 200,
                              child:
                                  Text("Type", style: TextStyle(fontSize: 20)),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(':', style: TextStyle(fontSize: 20)),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 200,
                              child: Text(widget.data['type'],
                                  style: TextStyle(fontSize: 20)),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 200,
                              child: Text("Duration",
                                  style: TextStyle(fontSize: 20)),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(':', style: TextStyle(fontSize: 20)),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 200,
                              child: Text(
                                  widget.data['between'].toString() + "  Hours",
                                  style: TextStyle(fontSize: 20)),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 200,
                              child:
                                  Text("Date", style: TextStyle(fontSize: 20)),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(':', style: TextStyle(fontSize: 20)),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 200,
                              child: Text(widget.data['lembur'],
                                  style: TextStyle(fontSize: 20)),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 200,
                              child: Text("Reason",
                                  style: TextStyle(fontSize: 20)),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(':', style: TextStyle(fontSize: 20)),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 200,
                              child: Text(widget.data['keterangan'],
                                  style: TextStyle(fontSize: 20)),
                            ),
                          ],
                        ),
                        widget.data['status'] != 'rejected'
                            ? Container()
                            : Row(
                                children: [
                                  Container(
                                    width: 200,
                                    child: Text("Reason For Refusal",
                                        style: TextStyle(fontSize: 20)),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(':', style: TextStyle(fontSize: 20)),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    width: 200,
                                    child: Text(widget.data['reason'],
                                        style: TextStyle(fontSize: 20)),
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: widget.data['status'] != 'awaiting'
            ? Container(
                height: 1,
              )
            : Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimens.dp16, vertical: Dimens.dp16),
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: const Color.fromARGB(145, 241, 241, 241),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: PrimaryButton(
                        onPressed: () async {
                          await showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Aprove Overtime Request?",
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    ),
                                    const SizedBox(height: 16),
                                    TextFormField(
                                      controller: jam_masuk,
                                      decoration: InputDecoration(
                                        labelText: "Clock In",
                                        hintText: "Clock In",
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    TextFormField(
                                      controller: jam_keluar,
                                      decoration: InputDecoration(
                                        labelText: "Clock Out",
                                        hintText: "Clock Out",
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context, false);
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.grey),
                                          ),
                                          child: Text("No"),
                                        ),
                                        const SizedBox(width: 8),
                                        ElevatedButton(
                                          onPressed: () {
                                            approvereject('approve');
                                            Navigator.pop(context);
                                          },
                                          child: Text("Yes"),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        child: Text("Approve"),
                      ),
                    ),
                    const SizedBox(height: Dimens.dp8),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(Dimens.dp8),
                          ),
                        ),
                        onPressed: () async {
                          await showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Reject Overtime Request? ",
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    ),
                                    const SizedBox(height: 16),
                                    TextFormField(
                                      controller: reason,
                                      decoration: InputDecoration(
                                        hintText: 'Reason',
                                        hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12.0,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                      maxLines: 3,
                                      keyboardType: TextInputType.multiline,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter some text';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context, false);
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.grey),
                                          ),
                                          child: Text("No"),
                                        ),
                                        const SizedBox(width: 8),
                                        ElevatedButton(
                                          onPressed: () {
                                            approvereject('reject');
                                            Navigator.pop(context);
                                          },
                                          child: Text("Yes"),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: Dimens.dp14, horizontal: Dimens.dp32),
                          child: Text("Reject"),
                        ),
                      ),
                    ),
                  ],
                ),
              ));
  }

  Widget _buildApprovalStatusInfo(
      Color color, String approvalStatus, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: Dimens.dp16, vertical: Dimens.dp8),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(Dimens.dp16)),
          color: color,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: Dimens.dp16,
            ),
            const SizedBox(width: Dimens.dp8),
            RegularText(
              approvalStatus,
              style:
                  const TextStyle(color: Colors.white, fontSize: Dimens.dp12),
            ),
          ],
        ),
      ),
    );
  }
}
