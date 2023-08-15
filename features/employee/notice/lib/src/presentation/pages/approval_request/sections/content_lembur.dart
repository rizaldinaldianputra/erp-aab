import 'package:component/component.dart';
import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:l10n/l10n.dart';
import 'package:notice/src/presentation/pages/approval_request/sections/detaillembur.dart';
import 'package:preferences/preferences.dart';

import '../../../../../notice.dart';
import 'all_approval_item_skeleton_section.dart';
import 'content_loading_section.dart';

class ContentLembur extends StatefulWidget {
  final ApprovalRequestType? statusLabel;
  final String status;
  final String sortBy;
  final String startTime;
  final String endTime;

  const ContentLembur(
      {Key? key,
      this.statusLabel,
      required this.status,
      required this.sortBy,
      required this.startTime,
      required this.endTime})
      : super(key: key);

  @override
  State<ContentLembur> createState() => _ContentLemburState();
}

class _ContentLemburState extends State<ContentLembur> {
  final _scrollController = ScrollController();
  int _currentPage = 1;
  void _onScroll() {
    if (_isBottom) fetchData(_currentPage + 1);
  }

  var data = [];
  var isLoading = false;
  Future<void> fetchData(int page) async {
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
    var start = widget.startTime == '' ? 'no' : widget.startTime;
    var end = widget.endTime == '' ? 'no' : widget.endTime;
// Set the headers in Dio options
    dio.options.headers = headers;
    try {
      var response = await dio.get('https://' +
          _defaultUrl! +
          '/api/v1/employee/lemburs/manager/' +
          id_user! +
          '/' +
          widget.status +
          '/' +
          page.toString() +
          "/" +
          start +
          "/" +
          end +
          "/asc");

      setState(() {
        isLoading = false;
        print(response.data);
        data = response.data;
      });
    } on DioError catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e);
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.startTime);
    fetchData(1);
  }

  @override
  Widget build(BuildContext context) {
    return !isLoading
        ? data[0]['count'] == 0
            ? Center(child: Text("Seems like no request at this moment "))
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, i) {
                  var item = data[i];
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: InkWell(
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  RequestLemburDetail(data: item)),
                        ).then((value) => {fetchData(1)});
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: const NetworkImage(
                                    "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2d/Great_mosque_in_Medan_cropped.jpg/1200px-Great_mosque_in_Medan_cropped.jpg"),
                                backgroundColor:
                                    Theme.of(context).disabledColor,
                                onBackgroundImageError: (_, __) {},
                                radius: 24,
                              ),
                              const SizedBox(width: Dimens.dp8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          child: RegularText(
                                            item['created_by'],
                                            maxLine: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: Dimens.dp2,
                                              horizontal: Dimens.dp8),
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(Dimens.dp2),
                                            ),
                                            color: Color.fromARGB(
                                                155, 253, 223, 177),
                                          ),
                                          child: RegularText(
                                            item['branch'],
                                            style: const TextStyle(
                                                color: Colors.orange,
                                                fontSize: Dimens.dp12),
                                          ),
                                        ),
                                      ],
                                    ),
                                    RegularText(
                                      item['created_at'],
                                      style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: Dimens.dp12),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: Dimens.dp8),
                              if (widget.status == "awaiting") ...[
                                _buildApprovalStatusInfo(Colors.orange,
                                    widget.status, Icons.access_time)
                              ] else if (widget.status == "approved") ...[
                                _buildApprovalStatusInfo(
                                    Colors.green, widget.status, Icons.check)
                              ] else if (widget.status == "rejected") ...[
                                _buildApprovalStatusInfo(
                                    Colors.red, widget.status, Icons.close)
                              ] else ...[
                                _buildApprovalStatusInfo(Colors.purple,
                                    widget.status, Icons.block_sharp)
                              ]
                            ],
                          ),
                          const SizedBox(height: Dimens.dp16),
                          _buildTimeOffDurationInfo(context, item),
                          Divider(
                            height: 1,
                          ),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: data.length,
              )
        : Container();
  }

  Widget _buildApprovalStatusInfo(
      Color color, String approvalStatus, IconData icon) {
    return Container(
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
            style: const TextStyle(color: Colors.white, fontSize: Dimens.dp12),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeOffDurationInfo(BuildContext context, var item) {
    return Container(
      padding: const EdgeInsets.all(Dimens.dp16),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(Dimens.dp4)),
        color: Color.fromARGB(145, 241, 241, 241),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const RegularText(
                  "Time Off Duration :",
                  style: TextStyle(color: Colors.grey, fontSize: Dimens.dp12),
                ),
                const SizedBox(height: Dimens.dp6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child: RegularText(
                        item['jam_masuk'],
                        style: const TextStyle(fontSize: Dimens.dp12),
                      ),
                    ),
                    const SizedBox(width: Dimens.dp12),
                    const Icon(
                      Icons.arrow_forward,
                      color: Colors.grey,
                      size: Dimens.dp12,
                    ),
                    const SizedBox(width: Dimens.dp12),
                    Expanded(
                      child: RegularText(
                        item['jam_keluar'],
                        style: const TextStyle(fontSize: Dimens.dp12),
                      ),
                    ),
                    const SizedBox(width: Dimens.dp20),
                  ],
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: RegularText(
              item['between'].toString() + " hours",
              style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context).primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  String formateDate(String dateTime) {
    var inputFormat = DateFormat('y-MM-dd');
    var inputDate = inputFormat.parse(dateTime.toString());
    var outputFormat = DateFormat('dd MMM yyyy');
    var outputDate = outputFormat.format(inputDate);

    return outputDate;
  }
}
